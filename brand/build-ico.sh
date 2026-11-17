#!/usr/bin/env bash
# Build the Windows icon, rendered/app-icon-zeo.ico, from zeo-icon.svg.
#
#     brand/build-ico.sh
#
# Each size is rasterised from the SVG on its own instead of shrinking the 1024 PNG,
# so the small sizes stay crisp. The sizes are upstream's app-icon.ico set (256, 128, 64,
# 32, 16) plus 48 and 24, which Explorer and the taskbar ask for at common scalings.
# PNG date/time chunks are left out so a rerun yields the same bytes.
#
# Consumers: patch 0127's Windows packaging (crates/windows_resources picks
# app-icon-zeo.ico for the zeo channel); the Windows build copies this file into
# crates/zed/resources/windows/ before building, as src_prepare does with the PNGs.
#
# Exit: 0 written · 2 a tool is missing.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
svg="${here}/zeo-icon.svg"
out="${here}/rendered/app-icon-zeo.ico"
sizes=(256 128 64 48 32 24 16)

for tool in rsvg-convert magick; do
	command -v "${tool}" >/dev/null || {
		echo "build-ico: ${tool} is not installed" >&2
		exit 2
	}
done

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

pngs=()
for size in "${sizes[@]}"; do
	rsvg-convert --width "${size}" --height "${size}" --output "${tmp}/${size}.png" "${svg}"
	pngs+=("${tmp}/${size}.png")
done

magick "${pngs[@]}" -define png:exclude-chunks=date,time "${out}"
echo "wrote ${out} (${sizes[*]})"
