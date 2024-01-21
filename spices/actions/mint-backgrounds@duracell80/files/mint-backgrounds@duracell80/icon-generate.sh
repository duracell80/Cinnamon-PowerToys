#!/bin/bash
# eg $1=Mint-Y/places/symbolic/folder-pictures-symbolic.svg

inkscape --export-width=128 --export-type=png --export-background-opacity=0 --export-filename=icon.png "/usr/share/icons/${1}"
