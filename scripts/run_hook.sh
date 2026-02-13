#!/bin/bash
# Created by Nelson Durrant, Jan 2026

R=$(pwd); while [[ "$R" != "/" && ! -d "$R/packages" ]]; do R=$(dirname "$R"); done
[[ -d "$R/packages" ]] || R=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
B="$R/packages"; [[ -d "$B" ]] || B="$R"; H=$1; shift

for a in "$@"; do
    [[ $a == -* ]] && ARGS+=("$a") || FILES+=("src/$(realpath --relative-to="$B" "$a")")
done

docker exec cougars-ct bash -c \
    "source /opt/ros/humble/setup.bash && cd ros2_ws && \$0 ${ARGS[*]} \"\$@\"" "$H" "${FILES[@]}"
