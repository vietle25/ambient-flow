#!/bin/bash
set -e

# Xác định đường dẫn flutter (Vercel clone vào ./flutter)
if [ -f "./flutter/bin/flutter" ]; then
  FLUTTER_CMD="./flutter/bin/flutter"
elif command -v flutter &> /dev/null; then
  FLUTTER_CMD="flutter"
else
  echo "Flutter not found, cloning flutter 3.24.5..."
  git clone -b 3.24.5 https://github.com/flutter/flutter.git
  FLUTTER_CMD="./flutter/bin/flutter"
fi

echo "=== Building Flutter Web ==="
$FLUTTER_CMD build web --release

echo "=== Building Next.js v2 ==="
cd v2
npm install
npm run build
cd ..

echo "=== Merging v2 into build/web/v2 ==="
mkdir -p build/web/v2
cp -r v2/out/* build/web/v2/

echo "=== Build Complete ==="
