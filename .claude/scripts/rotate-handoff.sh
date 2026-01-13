#!/bin/bash

HANDOFF_DIR=".claude/memory/handoff"
TS=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$HANDOFF_DIR"

if [ -f "$HANDOFF_DIR/LATEST.md" ]; then
  mv "$HANDOFF_DIR/LATEST.md" "$HANDOFF_DIR/$TS.md"
  echo "Archived previous snapshot to $TS.md"
else
  echo "No previous snapshot to archive"
fi
