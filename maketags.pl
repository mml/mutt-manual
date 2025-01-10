#!/usr/bin/perl

# Copyright (c) 2025, Matt Liggett
# Licensed under the BSD 2-Clause License. See LICENSE file in the project root
# for full license information.

### maketags.pl reads a plaintext version of the mutt manual and creates
### a tags file based on a bunch of heuristics.  This can then be used
### when editing your .muttrc in vim.  See the README for a few more
### specifics.

require 5;
use warnings;
use strict;

use feature 'signatures';

binmode STDOUT, ':utf8';
print "!_TAG_FILE_ENCODING\tutf-8\t/UTF-8/\n";

my $NBSP = "\N{NO-BREAK SPACE}";

my $f = shift;

# The lines in the tags file must have one of these two formats:
# 
# 1.  {tagname} {TAB} {tagfile} {TAB} {tagaddress}
# 2.  {tagname} {TAB} {tagfile} {TAB} {tagaddress} {term} {field} ..

my %printed;

sub print_tag($name, $addr = $.) {
  unless (exists $printed{$name}) {
    printf "%s\t%s\t%s\n", $name, $f, $addr;
    $printed{$name} = $addr;
  }
}

sub print_section_tag($name, $num, $rest) {
  # These patterns are interpreted as if 'nomagic' is set.
  print_tag($name, "/^${num}.${NBSP}${rest}\$/");
}

# These links derived from http://www.mutt.org/doc/manual/#commands
print_section_tag('account-hook', 7, 'Managing Multiple Accounts');
print_section_tag($_, 5, '\.\*Using Aliases') for qw( alias unalias );
print_section_tag($_, 13, 'Alternative Addresses')
  for qw( alternates unalternates );
print_section_tag($_, 5, 'MIME\.\*Alternative')
  for qw(alternative_order unalternative_order);
print_section_tag($_, 6, 'Attachment Searching and Counting')
  for qw(attachments unattachments);
print_section_tag($_, 4, 'MIME Autoview') for qw(auto_view unauto_view);
print_section_tag('bind', 6, 'Changing the Default Key Bindings');
print_section_tag('cd', 7, 'Changing the current working directory');
print_section_tag($_, 11, 'Using Color and Mono Video Attributes')
  for qw(color uncolor mono unmono);
print_section_tag('echo', 17, 'Echoing text');
print_section_tag('exec', 26, 'Executing Functions');
print_section_tag('save-hook', 18, 'Specify Default Save Mailbox');
print_section_tag($_, 29, 'Setting and Querying Variables')
  for qw(set unset toggle reset);
print_section_tag('source', 30,
  'Reading Initialization Commands From Another File');
print_section_tag($_, 14, 'Mailing Lists')
  for qw(lists unlists subscribe unsubscribe);
print_section_tag($_, '12.2', 'Selecting Headers')
  for qw(ignore unignore);

open F, $f or die "$f: $!";
binmode F, ':utf8';
my $chapter;
my $section;
while (<F>) {
  if (/^Chapter\N{NO-BREAK SPACE}(\d+)/) {
    $chapter = $1;
    undef $section;
  }
  next unless defined $chapter;
  if (/^(\d+)\.\N{NO-BREAK SPACE}/) {
    $section = $1;
  }
  # Chapter 1. Introduction
  # Chapter 2. Getting Started
  # Chapter 3. Configuration
  if (3 == $chapter) {
    if (/^([a-z][a-z-]+-hook)\s/) {
      print_tag $1;
    }
  }
  # Chapter 4. Advanced Usage
  # Chapter 5. Mutt's MIME Support
  # Chapter 6. Optional Features
  # Chapter 7. Security Considerations
  # Chapter 8. Performance Tuning
  # Chapter 9. Reference
  if (9 == $chapter) {
    next unless defined $section;
    if (2 == $section) {
      if (/^\s*\N{BULLET}?\s*([a-z][a-z-_]*)/) {
        print_tag $1;
      }
    } elsif (3 == $section) {
      if (/^3\.\d+\.\N{NO-BREAK SPACE}(\S+)$/) {
        print_tag $1;
      }
    }
  }
  # Chapter 10. Miscellany
}
