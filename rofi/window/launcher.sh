#!/usr/bin/env bash

dir="$HOME/.config/rofi/window/"
theme='style'

## Run
rofi \
    -show window \
    -theme ${dir}/${theme}.rasi
