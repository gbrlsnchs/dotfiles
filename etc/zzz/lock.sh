#!/bin/sh

sudo --preserve-env --user "$(id --user --name 1000)" waylock \
	-fork-on-lock \
	-init-color "0x${FG_COLOR}" \
	-input-color "0x${COLOR_4}" \
	-fail-color "0x${COLOR_1}"
