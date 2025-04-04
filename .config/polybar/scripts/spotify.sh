#!/usr/bin/bash

set -euo pipefail

printf "%-50s" "$(spotifyctl status --format "%artist%: %title%" --trunc --max-length=50)"
