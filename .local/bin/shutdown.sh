#! /usr/bin/env bash
set -euo pipefail

sleep 1;

busctl call \
  org.freedesktop.login1 \
  /org/freedesktop/login1 \
  org.freedesktop.login1.Manager \
  PowerOff b false
