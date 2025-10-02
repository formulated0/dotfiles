#!/usr/bin/env bash

dir="$HOME/.config/rofi/emoji/"
theme='style'

## Run
rofi \
    -modi emoji \
    -show emoji \
    -theme ${dir}/${theme}.rasi