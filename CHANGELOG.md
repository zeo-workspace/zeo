# Changelog

All notable changes to Zeo are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

A package is `app-editors/zeo-<X.Y.Z>_p<YYYYMMDD>[-rN]`: `X.Y.Z` is Zeo's own
version, the one this file records; `_pYYYYMMDD` names the Zed snapshot it is
built from, and moves on every snapshot bump without an entry here; `-rN` is a
packaging-only change. How a version is chosen and a release is cut:
[`docs/RELEASING.md`](docs/RELEASING.md).

A change that comes from a downstream patch names its number. The patch's
header — `zed-patches/patches/<PF>/NNNN-*.patch`, above the `---` — carries the
reasoning.

## [Unreleased]

## [0.1.1] — 2026-10-05

The agent's tasks become visible: a card over the agent panel, a history panel
that survives restarts, and a tray notification when a watched task ends out of
view. A reopened thread keeps its configuration, and both Claude adapters ship
as default agents.

### Added

- Claude Agent (Plus) and Claude Agent TUI are default agents: a fresh install, the Flatpak included, offers both with no `agent_servers` entry, installed from npm by Zeo's own Node runtime on first use (patch 0033).
- The agent's task feed: a thread holds the adapter's live tasks and can stop a task or send it to the background (patch 0034). Needs `claude-agent-acp-plus` >= 0.24.0.
- A floating tasks card over the agent panel lists the live tasks of every conversation, with Stop, Send to Background, Open at the tool call that started it, and Watch; `agent.tasks_card.{enabled,position}` (patch 0037).
- A watched or failed task that ends out of view notifies `zeo-systray` (>= 0.3.0) over `$XDG_RUNTIME_DIR/zeo-systray.sock`; without the daemon the send is a silent no-op (patch 0038).
- An Agent Tasks dock panel lists every task the agent ran, across threads and windows, kept across restarts, with Active/Finished/Failed/Archived filters and archiving; `agent_tasks_panel::ToggleFocus` on `ctrl-alt-shift-a` (patch 0035).
- A task can be renamed from the panel, and the name is kept (patch 0039).

### Changed

- A reopened ACP thread comes back in the mode, model, effort and options it was left in, instead of the entry's `default_config_options`; a new or forked thread still starts from the defaults (patch 0036).
- The Claude Code IDE server publishes its lock file and hands its port to the terminals only while its workspace has folders, so folderless windows no longer leave stray lock files (patch 0002).
- The in-app release notes point at `github.com/zeo-workspace/zeo/releases` (patch 0021).

### Fixed

- A `zeo://` link, such as `zeo://agent?session=<id>`, reopens the thread instead of opening nothing (patch 0022).
- Under Flatpak, the CLI's escape to the host recognises `dev.zeo.Zeo` and the `zeo` binaries, so the terminal, language servers and agents get the host's tools again (patch 0032).
- A multi-line task label — a Bash heredoc, say — renders as one line in the card and the panel instead of drawing over the rows below (patch 0039).

## [0.1.0] — 2026-10-01

The first release under the Zeo name: the Zed snapshot, the downstream patch
series that carries the Claude-agent integration, and the rebrand on top.

### Changed

- Zed is rebranded as Zeo: its own state directories, the `zeo` binary and `dev.zeo.Zeo` app id, a Zeo release channel, the `zeo://` scheme with `zed://` still accepted, and the product name in the strings a user reads (patches 0019–0023, 0025).
- The patched editor is packaged as `app-editors/zeo` (and prebuilt as `app-editors/zeo-bin`); `app-editors/zed` now builds upstream's releases unpatched, and only one of them can be installed at a time.
