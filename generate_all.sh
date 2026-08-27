#!/usr/bin/env bash
set -e

echo "=== Compiling i18n localization dictionaries ==="
dart run tool/generate_i18n.dart

echo "=== Running build_runner code generation ==="
dart run build_runner build --delete-conflicting-outputs

echo "=== All generation complete ==="
