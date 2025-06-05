#!/bin/sh

if jj root >/dev/null 2>&1; then
  jjui
else
  lazygit
fi
