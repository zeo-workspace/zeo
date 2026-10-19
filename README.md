# Zeo

Zeo is a rebranded build of the [Zed](https://zed.dev) editor: Zed's engine, a
distinct visual identity, and a set of downstream refinements on top.

**Zeo is not a fork.** It is a *patch set* applied to the exact Zed source commit that
gets packaged, in the spirit of what Betterbird is to Thunderbird. There is no vendored
copy of Zed here and no rebased branch to keep alive — the patches live in
[`zeo-workspace/zed-patches`](https://github.com/zeo-workspace/zed-patches), each one written
against a named upstream commit and re-verified whenever that commit moves.

That choice is the whole design. A fork accumulates a merge debt that grows with every
upstream release; a patch series states exactly what it changes, and stops applying —
loudly — the moment upstream moves the ground under it.

## Not affiliated with Zed Industries

Zeo is an independent project. It is **not** affiliated with, endorsed by, or supported
by Zed Industries. "Zed" and the Zed logo are theirs; this project neither uses nor
claims them. The Zeo mark in [`brand/`](brand/) is original work, constructed rather
than traced — see [`brand/build-icon.py`](brand/build-icon.py), which generates it.

Zed is distributed under the GPL-3.0-or-later (with parts under Apache-2.0), and Zeo
inherits those terms. Report Zeo problems here, never to Zed Industries.

## What lives where

| | |
|---|---|
| [`brand/`](brand/) | the Zeo mark — SVG sources, the generator that builds it, the rendered icons, and their checksums |
| [`CHANGELOG.md`](CHANGELOG.md) | what each Zeo version changed, newest first |
| [`docs/RELEASING.md`](docs/RELEASING.md) | how Zeo is versioned, and how a version and a `zeo-bin` release are cut |
| [`docs/`](docs/) | the rebrand's touch-point inventory, the roadmap, and the Visual Extension API research |
| [`archive/`](archive/) | the first run (2026), kept as the record it is: story specifications, unpublished commits as patches, and the icon exploration renders |
| `zeo-workspace/zed-patches` | **the patches themselves**, including the rebrand series |
| the `bentoo` overlay | `app-editors/zeo`, which decides which patches apply |

## Voice input

The agent composer has a microphone button beside Send. It records you, turns the speech
into text on this machine with [whisper.cpp](https://github.com/ggml-org/whisper.cpp),
and puts the text in the composer unsent, so you can read and fix it before you send it.
`ctrl-alt-v` (`cmd-alt-v` on macOS) does the same from the keyboard. Tap it to start and
tap again to stop, or hold it to record until you let go. Escape cancels. The feature is
patch `0067-voice-input.patch` in `zed-patches`. Its header carries the reasoning, the
privacy model and the pinned checksums.

- **USE flag.** `voice` on `app-editors/zeo` is on by default and needs
  `claude-agent-acp-plus`. With it, the ebuild also pulls in
  `app-accessibility/whisper-models[base]`. `USE=-voice` builds Zeo without the patch:
  no button and no whisper.cpp. The ebuild builds whisper.cpp for the CPU your
  `CFLAGS` `-march` names (`GGML_NATIVE=OFF`, ggml's own x86 switches off). The
  prebuilt release targets x86-64-v3.
- **The model.** Zeo first looks in `/usr/share/whisper-models/ggml-<model>.bin`, which
  `app-accessibility/whisper-models` installs. Otherwise it uses
  `<data dir>/voice/models/`. A missing model is downloaded only after you click Download
  in the strip above the composer. It comes from Hugging Face,
  `ggerganov/whisper.cpp` at commit `5359861c739e955e79d9a303bcbc70fb988958b1`, and is
  kept only if its size and SHA-256 match the pinned ones: `tiny` 78 MB, `base` 148 MB
  (the default), `small` 488 MB.
- **Settings**, under `"voice_input"` in `settings.json`:

  ```json
  "voice_input": {
    "enabled": true,
    "model": "base",
    "language": "auto",
    "remote": { "enabled": false, "url": null, "model": "whisper-1", "api_key_env": "ZEO_VOICE_API_KEY" }
  }
  ```

  `"enabled": false` hides the button and unbinds the shortcut. `language` is `auto` or
  a lowercase two-letter code such as `en`. The remote service is off by default. Turned
  on, it sends each recording as a WAV to the OpenAI-compatible endpoint in `remote.url`
  (https, or plain http to a loopback host), with the API key read from the environment
  variable named by `remote.api_key_env`. The key is never written to settings or
  logged. In local mode Zeo opens no connection, apart from the model download you
  agreed to.
- **AltGr keyboard layouts on Windows** (Polish, German, …). There, `ctrl-alt-v` is the
  same chord as `AltGr+v`. Either the shortcut fires instead of the character `AltGr+v`
  types, or the character wins and the shortcut never fires. Rebind it in your keymap
  (`zed: open keymap`). The tap and the hold work on any key you bind:

  ```json
  [
    {
      "context": "AcpThread",
      "bindings": {
        "ctrl-alt-v": null,
        "alt-v": "voice_input::ToggleRecording"
      }
    }
  ]
  ```

- **Tests**, in a tree with the series applied:
  `cargo test -p voice_input`, `cargo test -p agent_ui voice` and
  `cargo test -p reqwest_client without_proxy`.

## Status

**Early.** The rebrand is fully specified in [`docs/REBRAND.md`](docs/REBRAND.md) — every
constant, every decision, with its rationale — and the mark is finished and reproducible.
What does not exist yet is an installable Zeo: the identity patches have to be written
against the currently packaged Zed commit, and the ebuild after them.

There is nothing to download here yet. When there is, it will say so.
