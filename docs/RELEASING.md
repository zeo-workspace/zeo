# Versioning and releasing Zeo

Zeo has a version of its own. Until 2026-10-05 every package was `0.1.0_p<date>`: the
date named the Zed snapshot underneath, `-rN` moved with every patch change, and nothing
told a user what changed between two installs. Since then the version says what Zeo
changed, and [`../CHANGELOG.md`](../CHANGELOG.md) says how.

## The package version

```
app-editors/zeo-<X.Y.Z>_p<YYYYMMDD>[-rN]
                 │        │          └── packaging only: no Zeo behaviour changed
                 │        └───────────── the date of the packaged Zed snapshot
                 └────────────────────── Zeo's version (Semantic Versioning 2.0.0)
```

The snapshot stays in the version because Portage orders on it: `zeo-0.1.1_p20261004`
sorts above every `0.1.0_p…`, and a snapshot bump inside one Zeo version still sorts
above the one before it.

## Which part moves

| The change | Version | Changelog |
|---|---|---|
| A new user-visible capability — a patch added, or one that does something new | **minor**: `0.1.1` → `0.2.0` | an entry under `Added` or `Changed` |
| A fix to behaviour Zeo already had | **patch**: `0.1.1` → `0.1.2` | an entry under `Fixed` |
| A snapshot-only bump — the autoupdate moved `_pYYYYMMDD`, the series refreshed with no behaviour change | **none**: `X.Y.Z` stays, `-rN` resets | no entry |
| A packaging change — dependencies, `src_install`, a patch reformatted without changing what it does | **`-rN`** only | no entry |
| Breaking a setting, a keybinding or saved state a user relies on | **minor** while Zeo is `0.x`, **major** after `1.0.0` | an entry, saying what to do |

`-rN` is reserved for changes a user cannot observe. A patch that changes behaviour moves
`X.Y.Z` even when it is one line; that is what keeps the changelog complete.

Several changes can share one version: open the section under `## [Unreleased]` as they
land, and rename it to `## [X.Y.Z] — YYYY-MM-DD` when the package is cut.

## The changelog

[`CHANGELOG.md`](../CHANGELOG.md) follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/):
newest first, one `## [X.Y.Z] — YYYY-MM-DD` heading per version, its changes under
`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed` or `Security`. An entry is written
for a user — what they will see — and names the downstream patch it comes from
(`(patch 0036)`), whose header carries the reasoning.

**The heading is load-bearing.** `zed-patches/scripts/check-changelog.sh` looks for a
line starting `## [X.Y.Z] — ` (an em dash) for the packaged version, and
`zed-patches/scripts/check-sync.sh` runs it, so `bump.sh` and `status.sh` report a
version with no section as drift. A mention in prose, a code block or an `###` heading
does not count.

## Cutting a version

1. Write the section in `CHANGELOG.md` and commit it in this repository.
2. In `zed-patches`, move the series: `git mv patches/zeo-<old PF> patches/zeo-<new PF>`.
3. `bash scripts/check-sync.sh` — the changelog check must pass before anything else moves.
4. In the overlay, as the last edit: rename the ebuild, update the `["app-editors/zeo"]`
   entry's `version` in `.autoupdate/packages.toml`, run `scripts/sync-overlay.sh`, and
   commit with a pathspec. The overlay is committed and pushed by its autoupdate within
   the hour — see the workspace's `CLAUDE.md`.

`zeo --version` prints the package version (`RELEASE_VERSION` is the ebuild's `PV`). The
in-app About keeps Zed's upstream version: extensions check compatibility against it.

## Releasing `zeo-bin`

A `zeo-bin` release is a GitHub release of `zeo-workspace/zeo` tagged **`v<PVR>`** —
`v0.1.1_p20261004`, or `v0.1.1_p20261004-r1` — which is the name the `zeo-bin` ebuild's
`SRC_URI` expects. The build is `zed-patches/scripts/release-zeo-bin.sh <PF>` (and
`release-portable.sh <PF>` for the other distributions). Both refuse, before building, a
version whose changelog section is missing. Publishing is a human step each time.
