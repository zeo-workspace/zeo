<p align="center">
  <img src="brand/rendered/app-icon-zeo.png" width="128" height="128" alt="Zeo">
</p>

<h1 align="center">Zeo</h1>

<p align="center">
  <strong>The Zed editor, built for working with AI agents.</strong><br>
  Zed's speed and engine, with an agent panel that shows what your agents are doing,
  keeps your threads organized, and stays out of your way.
</p>

<p align="center">
  <a href="https://github.com/zeo-workspace/zeo/releases/latest"><img alt="Latest release" src="https://img.shields.io/github/v/release/zeo-workspace/zeo?label=release"></a>
  <img alt="Platform" src="https://img.shields.io/badge/platform-Linux%20%7C%20Windows%20x86--64-informational">
  <img alt="Stage" src="https://img.shields.io/badge/stage-alpha-orange">
  <img alt="License" src="https://img.shields.io/badge/license-GPL--3.0--or--later-blue">
</p>

<p align="center">
  <a href="#install">Install</a> ·
  <a href="#what-zeo-adds">Features</a> ·
  <a href="#auditable-by-design">How it is built</a> ·
  <a href="CHANGELOG.md">Changelog</a> ·
  <a href="SECURITY.md">Security</a>
</p>

---

## Why Zeo

Zed is a fast, modern editor. Zeo takes Zed as it is and adds what you need once an AI agent
works beside you all day:

- **You can see what the agent is doing.** Background tasks, subagents and shell output
  have a place on screen, and you can stop any one of them.
- **Your threads stay organized.** You can pin, tag, list, fork and rewind them.
- **Your environment stays under your control.** Voice is transcribed on your machine, an
  optional sandbox limits what the agent can touch, and nothing is sent without you.

Zeo is built around **[Claude Code](https://www.anthropic.com/claude-code)** through
[Claude Agent (Plus)](https://github.com/zeo-workspace/claude-agent-acp-plus), an
[ACP](https://agentclientprotocol.com) adapter. Any ACP agent still works, and so does
Zed's own agent.

## What Zeo adds

### Agent tasks you can follow

- **Tasks card.** A card over the conversation lists every live task and subagent: what it
  is running, its last output line, how long it has run. Each one has Stop, Send to
  Background, Open, and a live preview of its output.
- **Agent Tasks panel.** A history of every task, across threads and windows, that survives
  restarts. It has filters, paging, selection and archiving, and **Follow Log** tails a
  running task in a tab.
- **Native subagents.** Subagents appear the moment the agent announces them, each one
  stoppable on its own. "Waiting for you" tells you when one needs an answer.
- **Task tags.** CI, Test, Build and Watch chips show at a glance what a background shell is
  for.
- **Tray notifications.** A task you watch can tell you when it ends out of view, through
  [zeo-systray](https://github.com/zeo-workspace/zeo-systray) (optional).

### Threads you can organize

- **Pins** that apply to one project or to all of them, **tags** with a `#tag` search
  filter, **lists** in a sidebar view of their own, and drag-to-reorder.
- **Fork from any turn**, **Rewind to Here** (the conversation only, or the files too), and
  **sub-threads** started from a selection, with **Send to Parent** to bring the answer back.
- A **description** per thread, **message times** with the duration of each turn, and the
  message you sent **pinned at the top** while the reply scrolls under it.

### A composer that keeps up

- **Voice input** (`ctrl-alt-v`, tap or hold) transcribed locally by
  [whisper.cpp](https://github.com/ggml-org/whisper.cpp). The text lands unsent, so you can
  fix it first.
- **`/btw`** asks a side question while a turn runs, without adding it to the conversation.
- **Steer** sends a queued message into the running turn without stopping it.
- **Composer history** (Up and Down), code blocks and quotes rendered as blocks, and a
  one-click **Run** for a slash command the agent recommends.
- The **context ring** shows context usage and your 5-hour and weekly limits. A click opens
  a full breakdown.

### Safer by default

- **Agent Sandbox** (optional). Run the agent inside
  [ai-jail](https://github.com/zeo-workspace/ai-jail): the project is writable, `.git` is
  read-only, your settings and credentials are out of reach, and only the hosts you allow
  can be reached. A lock icon shows the sandbox state for each thread.
- **Nothing leaves without you.** The speech model is downloaded only after you agree, and
  it is checksum-pinned. Elements picked in a browser wait in the composer until you send
  them.
- **Security fixes ahead of upstream** when a reachable advisory needs one. See the
  *Security* sections of the [changelog](CHANGELOG.md).

### Beyond the editor

- **[zeo-browser](https://github.com/zeo-workspace/zeo-browser).** A Chrome sidebar on the
  same agent thread. It can attach page elements, screenshots and console or network
  recordings.
- **[zeo-devtools](https://github.com/zeo-workspace/zeo-devtools).** A Vite and Astro
  plugin: click an element in your dev page, and its source lines land in the composer.
- **Claude Code in the terminal.** `claude` follows your editor selection, and "Mention
  Selection in Claude Code" sends lines to its prompt as `@file#L1-3`.

The full list, version by version, is in the [changelog](CHANGELOG.md).

## Install

Zeo runs on **Linux x86-64** and **Windows x86-64**. The prebuilt Linux packages need a CPU
with **x86-64-v3** (AVX2, on Intel Haswell or AMD Excavator and later) and **glibc 2.35** or
newer. On an older CPU, build from source.

### Prebuilt packages

Download from the **[latest release](https://github.com/zeo-workspace/zeo/releases/latest)**.
Below, `<version>` is `<X.Y.Z>_p<YYYYMMDD>` (for example `0.29.0_p20261125`); the `.deb` and
`.rpm` spell it `<X.Y.Z>.p<YYYYMMDD>-1`, as their package formats require.

| Format | Install |
|---|---|
| Debian / Ubuntu `.deb` | `sudo apt install ./zeo_<X.Y.Z>.p<YYYYMMDD>-1_amd64.deb` |
| Fedora / openSUSE `.rpm` | `sudo dnf install ./zeo-<X.Y.Z>.p<YYYYMMDD>-1.x86_64.rpm` |
| Flatpak | `flatpak install --user ./Zeo-<version>-x86_64.flatpak` |
| AppImage | `chmod +x Zeo-<version>-x86_64.AppImage && ./Zeo-<version>-x86_64.AppImage` |
| Portable tarball | extract `zeo-<version>-x86_64.tar.xz` and run `zeo-<version>/usr/bin/zeo` |
| Windows installer | run `Zeo-<version>-x86_64-setup.exe`: it installs per user, with no elevation. The build is unsigned, so SmartScreen asks once ("More info → Run anyway") |
| Windows portable | extract `zeo-<version>-windows-x86_64.zip` |

Check the download against the release's checksums before you install it. The Linux packages
(`.deb`, `.rpm`, Flatpak, AppImage, the tarball) are listed in `SHA256SUMS-portable-<version>`,
the Windows files in `SHA256SUMS-windows-<version>`, and zeo-bin's tarball in
`SHA256SUMS-<version>`:

```sh
sha256sum --check --ignore-missing SHA256SUMS-portable-<version>
```

### Gentoo

Zeo is packaged in the [`bentoo`](https://github.com/obentoo/bentoo) overlay:

```sh
eselect repository add bentoo git https://github.com/obentoo/bentoo.git
emaint sync --repo bentoo
emerge --ask app-editors/zeo       # from source, tuned to your CPU
emerge --ask app-editors/zeo-bin   # or the prebuilt release
```

Features are USE flags. Most are on by default, `ai-jail` included: it turns nothing on by
itself, because each project's lock does.

| USE | What it adds |
|---|---|
| `claude-agent-acp-plus` | Claude Agent (Plus), the agent panel refinements, and the base for the flags below |
| `claude-agent-acp-tui` | the Claude Code terminal UI inside the agent panel |
| `claude-code-ide` | the editor integration for `claude` running in a terminal |
| `voice` | local voice input, with the `whisper-models` package |
| `epic` | a read-only stories panel for projects planned with Epico |
| `devtools-bridge` · `devtools-panel` · `browser-extension` | zeo-devtools, its panel, and zeo-browser |
| `ai-jail` | the Agent Sandbox |

Only one of `zed`, `zed-bin`, `zeo` and `zeo-bin` can be installed at a time.

### Running it alongside Zed

Zeo has its own binary (`zeo`), app id (`dev.zeo.Zeo`), state directories and URL scheme
(`zeo://`, with `zed://` still accepted). Its settings and history never mix with a Zed
install's. Zed extensions and themes work unchanged.

## Auditable by design

**Zeo is not a fork.** It is a set of plain-text patches applied to one exact, named Zed
commit. Nothing is hidden in a private branch:

- **Every change is readable.** The patches live in
  [`zeo-patches`](https://github.com/zeo-workspace/zeo-patches). Each one has a header that
  says what it changes and why.
- **Every build is traceable.** Each release ships a `PROVENANCE` file with the Zed commit,
  the SHA-256 of the source tarball, the compiler and flags, and the SHA-256 of every patch
  in the order it was applied.
- **Every build is reproducible.** The recipe is a public ebuild. Fetch the same Zed source,
  apply the same patches, and compare.
- **It fails loudly.** When Zed moves, each patch is checked again against the new commit. A
  patch that no longer applies stops the build. Nothing drifts silently.

A fork collects merge debt with every upstream release. A patch series states exactly what
it changes, so you do not need to trust Zeo: you can read every line it adds. Changes that
are useful beyond Zeo are offered back to Zed.

## Configuration worth knowing

Everything goes in `settings.json` (`zed: open settings`):

```jsonc
{
  "agent": {
    "expand_terminal_card": false,              // start terminal output collapsed
    "expand_edit_card": false,                  // start edit diffs collapsed
    "tasks_card": { "start_minimized": true }   // start the tasks card as a pill
  },
  "voice_input": {
    "enabled": true,
    "model": "base",                            // tiny (78 MB) · base (148 MB) · small (488 MB)
    "language": "auto",                         // or a code such as "en"
    "remote": { "enabled": false }              // off: audio never leaves the machine
  },
  "feature_flags": { "acp-beta": "off" }        // fall back to ACP v1, with no subagents
}
```

`voice_input.remote` can send recordings to an OpenAI-compatible endpoint instead. The API
key is read from an environment variable and is never stored or logged. On Windows keyboard
layouts that use AltGr, `ctrl-alt-v` is the same chord as `AltGr+v`. Rebind
`voice_input::ToggleRecording` in your keymap if that conflicts.

## Status

Zeo is **alpha**. It is used every day by its maintainer and released often, sometimes
several times a week, and it has rough edges. Each release says which Zed version and
commit it is built on (also shown in Zeo's About window). Only the latest release is
supported.

## The Zeo family

| Project | What it is |
|---|---|
| **zeo** (this repository) | the product: brand, changelog, releases |
| [zeo-patches](https://github.com/zeo-workspace/zeo-patches) | the patch series and the tooling that verifies it |
| [claude-agent-acp-plus](https://github.com/zeo-workspace/claude-agent-acp-plus) | Claude Agent (Plus), the ACP adapter that powers the agent features |
| [claude-agent-tui](https://github.com/zeo-workspace/claude-agent-tui) | the Claude Code terminal UI over ACP |
| [zeo-systray](https://github.com/zeo-workspace/zeo-systray) | a tray indicator for agent sessions |
| [zeo-browser](https://github.com/zeo-workspace/zeo-browser) | the browser sidebar on the same thread |
| [zeo-devtools](https://github.com/zeo-workspace/zeo-devtools) | the element picker for Vite and Astro |
| [ai-jail](https://github.com/zeo-workspace/ai-jail) | the sandbox the agent can run in |
| [azukari](https://github.com/zeo-workspace/azukari) | a launcher that hands MCP servers their secrets from the keyring, never from a config file |

## Contributing and support

- **Bugs and ideas:** [open an issue](https://github.com/zeo-workspace/zeo/issues). Include
  the version from Zeo's About window, and use **Copy**: it gives the Zeo and Zed versions
  together.
- **Security issues:** report them privately, as [SECURITY.md](SECURITY.md) describes. Never
  in a public issue.
- **Code:** changes are patches against Zed. Start with
  [`zeo-patches`](https://github.com/zeo-workspace/zeo-patches) and
  [`docs/BUILD.md`](docs/BUILD.md).

Inside this repository:

| | |
|---|---|
| [`brand/`](brand/) | the Zeo mark: SVG sources, the script that generates it, rendered icons, checksums |
| [`CHANGELOG.md`](CHANGELOG.md) | what each version changed, newest first |
| [`docs/RELEASING.md`](docs/RELEASING.md) | how versions are numbered and releases are cut |
| [`docs/REBRAND.md`](docs/REBRAND.md) | every constant the rebrand touches, with its reason |
| [`archive/` at `a749fa4`](https://github.com/zeo-workspace/zeo/tree/a749fa4/archive) | the record of the first run (2026), as it stood when it left this repository |

## Not affiliated with Zed Industries

Zeo is an independent, community project. It is **not affiliated with, endorsed by,
sponsored by or supported by Zed Industries, Inc.**

- **All rights to Zed belong to Zed Industries, Inc. and its contributors.** That covers the
  source code, the name "Zed", the Zed logo and every other trademark of theirs. Zeo claims
  none of them.
- **The Zeo program is GPL-3.0-or-later**, with some parts under Apache-2.0, because it is
  Zed's source code under the licenses Zed chose; its patches, in
  [`zeo-patches`](https://github.com/zeo-workspace/zeo-patches), are GPL-3.0-or-later for the
  same reason. The license texts are in [Zed's repository](https://github.com/zed-industries/zed)
  (`LICENSE-GPL`, `LICENSE-APACHE`).
- **This repository's own material** — the brand sources, the documents and the scripts — is
  **Apache-2.0**, in [`LICENSE`](LICENSE). Apache-2.0 grants no right to the Zeo name or mark
  (its section 6).
- The Zeo name and mark are original work. The mark is generated by a script
  ([`brand/build-icon.py`](brand/build-icon.py)), not traced from anything.
- **Report Zeo problems here, never to Zed Industries.** A bug in Zeo may come from one of
  its patches.

Zeo and its companion projects are also unofficial with respect to **Anthropic**. "Claude"
and "Claude Code" are Anthropic's trademarks.

Zeo is provided **as is, without warranty of any kind**, as its licenses state. If you hold
rights to something used here and object to how it is used, open an issue or write to the
contact in [SECURITY.md](SECURITY.md). It will be addressed promptly.
