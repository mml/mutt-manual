# Copyright (c) 2025, Matt Liggett
# Licensed under the BSD 2-Clause License. See LICENSE file in the project root
# for full license information.

DOCDIR = /usr/share/doc/mutt
MT = maketags.pl
BYTEWISE_SORT = LC_ALL=C sort

all: manual.txt tags

manual.txt: $(DOCDIR)/manual.txt.gz
	gzip -dc < $< > $@

tags: manual.txt $(MT)
	./$(MT) $< | $(BYTEWISE_SORT) > $@
