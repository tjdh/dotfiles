#!/usr/bin/env python3
"""Claude Code status line.

Shows (left to right):
  - box hostname
  - folder Claude was opened from (workspace.project_dir)
  - repo path + git branch (when inside a git repo)
  - model + effort level
  - month-to-date API spend as a fill bar against a $1500 limit
  - context-window usage as a fill bar

No external deps (jq is not installed on these boxes) -- pure python3.
The monthly-cost scan reads every transcript under ~/.claude/projects, so its
result is cached for 60s to keep each render fast.
"""
import json
import os
import sys
import glob
import time
import subprocess

HOME = os.path.expanduser("~")
PROJECTS_DIR = os.path.join(HOME, ".claude", "projects")
COST_CACHE = os.path.join(HOME, ".claude", ".statusline_cost_cache.json")
COST_TTL_SECONDS = 60
MONTHLY_LIMIT = 1500  # user-stated monthly usage limit, in USD

# Anthropic API list rates, USD per million tokens. Cache writes are split into
# 5-minute (1.25x base) and 1-hour (2x base) tiers; cache reads are 0.1x base.
# This is an API-list-rate ESTIMATE -- subscription/enterprise billing differs.
PRICING = {
    "fable":    {"in": 10.0, "out": 50.0, "cw5": 12.50, "cw1h": 20.0, "cr": 1.00},
    "opus-4":   {"in": 5.0,  "out": 25.0, "cw5": 6.25,  "cw1h": 10.0, "cr": 0.50},
    "sonnet-4": {"in": 3.0,  "out": 15.0, "cw5": 3.75,  "cw1h": 6.0,  "cr": 0.30},
    "haiku":    {"in": 1.0,  "out": 5.0,  "cw5": 1.25,  "cw1h": 2.0,  "cr": 0.10},
    "default":  {"in": 10.0, "out": 50.0, "cw5": 12.50, "cw1h": 20.0, "cr": 1.00},
}

# ANSI truecolor (Da Vinci brand palette)
RESET = "\033[0m"
PURPLE = "\033[38;2;138;139;255m"   # Bright Purple
LIME = "\033[38;2;214;244;0m"       # Lime
ORANGE = "\033[38;2;255;179;138m"   # pastel orange (softspectrum permission/warning #FFB38A)
MIST = "\033[38;2;177;214;239m"     # Misty Blue
DIM = "\033[38;2;150;150;150m"
AMBER = "\033[38;2;255;191;0m"
RED = "\033[38;2;255;90;90m"


def read_input():
    try:
        return json.loads(sys.stdin.read() or "{}")
    except Exception:
        return {}


def abbrev(path):
    if path and path.startswith(HOME):
        return "~" + path[len(HOME):]
    return path or ""


def pricing_for(model_id):
    m = (model_id or "").lower()
    for key in ("fable", "opus-4", "sonnet-4", "haiku"):
        if key in m:
            return PRICING[key]
    return PRICING["default"]


def compute_month_cost(month_prefix):
    """Sum API-rate cost across all transcripts for the given YYYY-MM.

    Each API response is logged as two records sharing one requestId, so we
    dedupe on requestId to avoid double-counting.
    """
    seen = set()
    total = 0.0
    for jsonl in glob.glob(os.path.join(PROJECTS_DIR, "**", "*.jsonl"), recursive=True):
        try:
            with open(jsonl) as f:
                for line in f:
                    try:
                        obj = json.loads(line)
                    except Exception:
                        continue
                    if obj.get("type") != "assistant":
                        continue
                    if not obj.get("timestamp", "").startswith(month_prefix):
                        continue
                    rid = obj.get("requestId")
                    if rid:
                        if rid in seen:
                            continue
                        seen.add(rid)
                    usage = obj.get("message", {}).get("usage")
                    if not usage:
                        continue
                    p = pricing_for(obj.get("message", {}).get("model"))
                    inp = usage.get("input_tokens", 0)
                    out = usage.get("output_tokens", 0)
                    cr = usage.get("cache_read_input_tokens", 0)
                    cc = usage.get("cache_creation") or {}
                    cw1h = cc.get("ephemeral_1h_input_tokens", 0)
                    cw5 = cc.get("ephemeral_5m_input_tokens", 0)
                    if not (cw1h or cw5):
                        cw5 = usage.get("cache_creation_input_tokens", 0)
                    total += (inp * p["in"] + out * p["out"]
                              + cw5 * p["cw5"] + cw1h * p["cw1h"]
                              + cr * p["cr"]) / 1_000_000
        except Exception:
            pass
    return total


def month_cost_cached(month_prefix, now):
    """Return month-to-date cost, recomputing at most once per COST_TTL_SECONDS."""
    try:
        with open(COST_CACHE) as f:
            c = json.load(f)
        if c.get("month") == month_prefix and (now - c.get("ts", 0)) < COST_TTL_SECONDS:
            return c["cost"]
    except Exception:
        pass
    cost = compute_month_cost(month_prefix)
    try:
        with open(COST_CACHE, "w") as f:
            json.dump({"month": month_prefix, "ts": now, "cost": cost}, f)
    except Exception:
        pass
    return cost


def run_cmd(args):
    """subprocess.run wrapper compatible with python 3.6 (system python here)."""
    try:
        out = subprocess.run(
            args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            universal_newlines=True, timeout=1.0,
        )
        if out.returncode == 0:
            return out.stdout.strip()
    except Exception:
        pass
    return ""


def git(cwd, *args):
    return run_cmd(["git", "-C", cwd, "--no-optional-locks", *args])


def fill_bar(pct, color):
    pct = max(0.0, min(100.0, pct))
    filled = int(pct / 10 + 0.5)
    filled = max(0, min(10, filled))
    return f"{color}{'█' * filled}{DIM}{'░' * (10 - filled)}{RESET}"


def level_color(pct):
    if pct >= 90:
        return RED
    if pct >= 70:
        return AMBER
    return MIST


def main():
    data = read_input()
    now = int(time.time())
    parts = []

    # Box hostname
    host = run_cmd(["hostname", "-s"])
    if host:
        parts.append(f"{PURPLE}{host}{RESET}")

    workspace = data.get("workspace") or {}
    project_dir = workspace.get("project_dir") or workspace.get("current_dir") or data.get("cwd") or ""
    cwd = workspace.get("current_dir") or data.get("cwd") or project_dir

    # Repo path + branch. The separate "opened" folder is dropped to save width;
    # when the repo sits under the opened folder show the relative hop, else home-abbreviate.
    repo = git(cwd, "rev-parse", "--show-toplevel")
    branch = git(cwd, "branch", "--show-current")
    if not branch:
        sha = git(cwd, "rev-parse", "--short", "HEAD")
        branch = f"@{sha}" if sha else ""
    if repo:
        if project_dir and repo.startswith(project_dir.rstrip("/") + os.sep):
            parts.append(os.path.relpath(repo, project_dir))
        else:
            parts.append(abbrev(repo))
    if branch:
        parts.append(f"{ORANGE}[{branch}]{RESET}")

    # Model + effort
    model_id = (data.get("model") or {}).get("id") or ""
    model_disp = model_id.split("[")[0].replace("claude-", "")
    effort = (data.get("effort") or {}).get("level") or ""
    if model_disp:
        md = model_disp + (f"/{effort}" if effort else "")
        parts.append(f"{MIST}{md}{RESET}")
    elif effort:
        parts.append(f"{MIST}{effort}{RESET}")

    # Monthly cost fill bar (vs $1500 limit)
    month_prefix = time.strftime("%Y-%m", time.localtime(now))
    cost = month_cost_cached(month_prefix, now)
    cost_pct = cost * 100.0 / MONTHLY_LIMIT
    cbar = fill_bar(cost_pct, level_color(cost_pct))
    parts.append(f"{DIM}cost:{RESET}${round(cost)}/${MONTHLY_LIMIT} {cbar} {round(cost_pct)}%")

    # Context-window fill bar (always shown; 0% before first API call)
    cw = data.get("context_window") or {}
    used = cw.get("used_percentage") or 0.0
    ctx_bar = fill_bar(used, MIST if used < 70 else level_color(used))
    parts.append(f"{DIM}ctx:{RESET}{ctx_bar} {round(used)}%")

    sys.stdout.write("  ".join(parts))


if __name__ == "__main__":
    main()
