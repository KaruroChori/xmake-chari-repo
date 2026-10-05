#!/usr/bin/env sh
# Add or update an add_versions("vX.Y.Z", "<sha>") entry for a package.
#
# usage: tools/bump-version.sh <package> <version> <sha>
#
# <version> may be given with or without the leading "v". New versions are
# inserted before the existing add_versions lines, so the file stays ordered
# newest-first.

set -eu

usage() {
    echo "usage: $0 <package> <version> <sha>" >&2
    exit 2
}

[ "$#" -eq 3 ] || usage

pkg=$1
ver=$2
sha=$3

case "$ver" in
    v*) tag=$ver ;;
    *) tag=v$ver ;;
esac

case "$tag" in
    v[0-9]*.[0-9]*.[0-9]*) : ;;
    *) echo "error: '$ver' does not look like a vX.Y.Z version" >&2; exit 1 ;;
esac

case "$sha" in
    *[!0-9a-fA-F]*|'') echo "error: '$sha' is not a hex commit hash" >&2; exit 1 ;;
esac

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
first=$(printf '%s' "$pkg" | cut -c1)
file="$root/packages/$first/$pkg/xmake.lua"

if [ ! -f "$file" ]; then
    echo "error: package file not found: $file" >&2
    exit 1
fi

existing=$(grep -n "add_versions(\"$tag\"," "$file" | cut -d: -f1 || true)

if [ -n "$existing" ]; then
    tmp=$(mktemp)
    sed -E "s#(add_versions\(\"$tag\", \")[^\"]*(\"\))#\1$sha\2#" "$file" > "$tmp"
    if cmp -s "$file" "$tmp"; then
        rm -f "$tmp"
        echo "unchanged: $pkg $tag already points at $sha"
        exit 0
    fi
    mv "$tmp" "$file"
    echo "updated: $pkg $tag -> $sha"
else
    tmp=$(mktemp)
    awk -v line="    add_versions(\"$tag\", \"$sha\")" '
        !done && /^[[:space:]]*add_versions\(/ { print line; done = 1 }
        !done && /^[[:space:]]*on_install\(/  { print line; done = 1 }
        !done && /^[[:space:]]*on_load\(/     { print line; done = 1 }
        { print }
        END { if (!done) print line }
    ' "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "added: $pkg $tag -> $sha"
fi
