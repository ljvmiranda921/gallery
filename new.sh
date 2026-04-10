#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 <name> [path/to/photo]"
    exit 1
fi

name="$1"
photo="${2:-}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest_dir="$script_dir/content/$name"

if [ -e "$dest_dir" ]; then
    echo "Error: $dest_dir already exists"
    exit 1
fi

mkdir -p "$dest_dir"

image_field="$name.png"
if [ -n "$photo" ]; then
    if [ ! -f "$photo" ]; then
        echo "Error: photo not found: $photo"
        rmdir "$dest_dir"
        exit 1
    fi
    ext="${photo##*.}"
    image_field="$name.$ext"
    cp "$photo" "$dest_dir/$image_field"
fi

date="$(date +%Y-%m-%d)"

cat > "$dest_dir/index.md" <<EOF
+++
image = "$image_field"
date = "$date"
title = "$name"
type = "gallery"
+++

EOF

echo "Created $dest_dir/index.md"
