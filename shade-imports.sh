#!/bin/bash
set -e

echo "🔧 Starting shading process..."

# Source paths from cloned repos
PUSHY_SRC="external/pushy/src/main/java/com/eatthepath/pushy"
NETTY_SRC="external/netty/handler/src/main/java/io/netty"

# Target paths in your repo
TARGET_PUSHY="src/main/java/pushynetty/pushy"
TARGET_NETTY="src/main/java/pushynetty/netty"

# Create target directories
mkdir -p "$TARGET_PUSHY"
mkdir -p "$TARGET_NETTY"

# Shade Pushy
echo "📦 Shading Pushy..."
find "$PUSHY_SRC" -type f -name "*.java" | while read file; do
  relpath="${file#$PUSHY_SRC/}"
  target="$TARGET_PUSHY/$relpath"
  mkdir -p "$(dirname "$target")"
  sed -e 's/package com.eatthepath.pushy/package pushynetty.pushy/g' \
      -e 's/import com.eatthepath.pushy/import pushynetty.pushy/g' "$file" > "$target"
done

# Shade Netty
echo "📦 Shading Netty..."
find "$NETTY_SRC" -type f -name "*.java" | while read file; do
  relpath="${file#$NETTY_SRC/}"
  target="$TARGET_NETTY/$relpath"
  mkdir -p "$(dirname "$target")"
  sed -e 's/package io.netty/package pushynetty.netty/g' \
      -e 's/import io.netty/import pushynetty.netty/g' "$file" > "$target"
done

echo "✅ Shading complete."
