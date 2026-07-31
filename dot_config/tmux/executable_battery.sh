#!/bin/sh
# Battery percentage for tmux's status-right.
#
# Deliberately uses ioreg, not pmset -- pmset produces zero output (not even
# an error) when invoked as a tmux background job on this machine, likely a
# macOS restriction on power-management queries from that execution context.
# ioreg doesn't hit the same restriction. Pulled into its own script rather
# than embedded inline in tmux.conf because the quoting required for the
# ioreg | grep | grep pipeline (nested single AND double quotes) doesn't
# survive tmux's own config-file quoting rules cleanly.
ioreg -rn AppleSmartBattery | grep -m1 '"CurrentCapacity"' | grep -oE '[0-9]+'
