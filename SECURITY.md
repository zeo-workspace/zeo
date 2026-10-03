# Security Policy

Zeo is the Zed editor with a downstream patch series and a rebrand applied, packaged
for Gentoo as `app-editors/zeo` (built from source) and `app-editors/zeo-bin`
(prebuilt). This repository holds the brand and the rebrand's reasoning; the patches
themselves live in [`zeo-workspace/zed-patches`](https://github.com/zeo-workspace/zed-patches).

## Supported versions

Only the version currently in the `bentoo` overlay is supported. Older snapshots
are not patched.

## Reporting a vulnerability

Report privately via GitHub **Private vulnerability reporting** (Security tab →
_Report a vulnerability_) or by email to the maintainer (`lucascs@proton.me`).
Please do not open a public issue for a security report. Include the Zeo version
(`zeo --version`, or the `PROVENANCE.txt` shipped with `zeo-bin`), a reproduction
and the impact. Expect an initial acknowledgement within a few days.

## Where a report belongs

- **Introduced by Zeo** — a downstream patch, the rebrand, or the `zeo-bin` build:
  report it here. Patches are listed per version in `zed-patches/patches/<PF>/series`.
- **Present in upstream Zed** as well: report it to Zed Industries through their own
  security policy. Zeo picks the fix up when the packaged Zed commit moves. Zeo is
  not affiliated with Zed Industries, so please do not send them Zeo-only issues.

## Integrity of what ships

- `app-editors/zeo` builds a named Zed commit (`EGIT_COMMIT` in the ebuild) with the
  series applied; every distfile is pinned by checksum in the overlay's Manifest.
- `zeo-bin` is built unprivileged from that same ebuild and series, for x86-64-v3.
  Its tarball carries `PROVENANCE.txt` — the Zed commit, each patch with its sha256,
  the USE set and the compiler flags — and the `zeo-bin` Manifest pins the tarball's
  checksum, so a package manager refuses bytes other than the ones published.
