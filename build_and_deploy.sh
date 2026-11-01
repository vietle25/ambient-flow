#!/bin/bash
set -e

echo "=== Building Floum Next.js Web App ==="
cd v2
npm install
npm run build
cd ..

echo "=== Outputting to build/web ==="
rm -rf build/web
mkdir -p build/web
cp -r v2/out/* build/web/

echo "=== Build Complete ==="
