#!/bin/bash
set -e

echo "=== Building Flutter Web ==="
flutter build web --release

echo "=== Building Next.js v2 ==="
cd v2
npm install
npm run build
cd ..

echo "=== Merging v2 into build/web/v2 ==="
mkdir -p build/web/v2
cp -r v2/out/* build/web/v2/

echo "=== Build Complete ==="
