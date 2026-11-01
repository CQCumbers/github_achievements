#!/bin/sh
# Builds public/index.html, a single page with all assets inlined
set -e
cd "$(dirname "$0")"

# Zola can't read binary files, so encode images as text for load_data
trap 'rm -f assets/images/*.b64' EXIT
for image in assets/images/*.png; do
  base64 < "$image" | tr -d '\r\n' > "$image.b64"
done

zola build
rm public/404.html
