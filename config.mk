# instantSHELL version

CMS_VERSION := $(shell git describe --abbrev=5 --dirty=-dev --always --tags 2>/dev/null || echo "unknown")
VERSION := "instantOS $(CMS_VERSION) - Build $(shell LANG=en_us_8859_1 date '+%a, %b %e %Y, %R:%S %z') on $(shell hostname 2>/dev/null || echo "unknown host")"

PREFIX = /usr/

