#!/bin/bash

NITROGEN_CFG=$HOME/.config/nitrogen/bg-saved.cfg
wallpaper_path=$(sed -nr 's/file=(.+)/\1/p' $NITROGEN_CFG | head -n 1)
i3lock -i $wallpaper_path
