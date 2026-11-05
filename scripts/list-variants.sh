#!/bin/sh
# Prints one markdown bullet per variant, using the '% VARIANT: ...' comment on line 1 of each file.
for f in variants/*.tex; do
  name=$(basename "$f" .tex)
  desc=$(sed -n '1s/^% VARIANT: *//p' "$f")
  echo "- **Aashish-Singhal-$name.pdf** — ${desc:-$name}"
done
