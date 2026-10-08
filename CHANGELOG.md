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

## [0.2.1] — 2026-10-08

### Fixed

- The About window names Zeo's version — "Zeo 0.2.1", with the package version, snapshot date included, under "Version" — instead of Zed's. Zed's version moves to a row of its own, "Zed", because extensions check their compatibility against it; "Copy" includes all three (patch 0047).

## [0.2.0] — 2026-10-07

The agent's tasks become easier to follow and to reach: progress on the card,
"Open at Task" from the panel, threads opening in their own project's window.
The message box remembers what was sent, a recommended slash command is one
click from a new thread, the default Claude agents use the system adapter, and
the last places that still said Zed — the application menu and Claude Code's
`/ide` — say Zeo.

### Added

- Every running task on the tasks card shows what it is doing — its last tool and how many tools it has used, beside the elapsed time — without watching it. The Agent Tasks panel's rows now open a task at the tool call that started it ("Open at Task"), where every command and edit it made is recorded; a task with nothing to jump to (one recorded before this change, or a nested subagent's step) opens its thread and says so. The history keeps that starting point across restarts; existing records are kept (patch 0041).
- Archived task records can be deleted from the Agent Tasks panel: an archived row has a Delete button, and with the Archived filter on, "Delete All Archived" clears the whole filter. Both ask first, and only the record goes — the thread, its conversation and every task that is not archived stay as they are (patch 0042).
- Up in the agent panel's message box brings back the messages already sent in that thread, newest first — mentions and images included — so resending or adjusting an earlier prompt is one key away; Down walks forward and finally restores whatever you were typing. Up and Down only do this on the box's first and last line with nothing selected; anywhere else they move the cursor as before, and with a message waiting in the queue, Up in an empty box still pulls that message back first (patch 0044).
- When the agent recommends a slash command in a code block — `/epic:epic stories run 014`, say — the block now has a button beside Copy that opens a new thread with the same agent and that command already in the message box, waiting for you to read it and press Enter; nothing is sent for you. Only a code block holding a single command gets it, and only in the agent's replies (patch 0045).

### Changed

- Claude Agent (Plus) and Claude Agent TUI run the adapter your package manager installed — `/usr/bin/claude-agent-acp-plus` and `/usr/bin/claude-agent-acp-tui` — when it is there, and are installed from npm only when it is not. It is checked each time an agent starts, so installing or removing the adapter takes effect on the next thread without rebuilding Zeo; the Flatpak, which cannot see the host's adapter, keeps using npm. An `agent_servers` entry of your own with the same id still wins (patch 0046).
- Claude Code's `/ide` names the editor it is connected to "Zeo" instead of "Zed" (patch 0002).

### Fixed

- Opening a task from the Agent Tasks panel opens its thread in the window that holds the thread's project, and raises that window, instead of loading it into the window the panel lives in; when no window holds the project, a new one opens for it. If the thread cannot be opened (its folders were removed, say), the task's row says why. Clicking a row no longer crashes Zeo when the Agent Tasks panel and the agent panel share a dock. The tray notification's link opens threads the same way (patch 0040).
- The application menu in the title bar is named "Zeo", with "About Zeo" and "Quit Zeo", and the About window's title says Zeo; they still said Zed. `f10` and any keybinding that opens the menu by its old name, `["app_menu::OpenApplicationMenu", "Zed"]`, keep working (patch 0025).

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
