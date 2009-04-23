#!/usr/bin/perl
use strict;
use lib './lib';
use LEOCHARRE::CLI2 ':all', 'This is a description.', '(leocharre)','[Alister]';
our $VERSION = sprintf "%d.%02d", q$Revision: 1.3 $ =~ /(\d+)/g;



my $ARGV_FILES_COUNT = argv_files_count();
my $ARGV_DIRS_COUNT  = argv_dirs_count();


debug('debug is on');

debug(" files count: $ARGV_FILES_COUNT, dirs count: $ARGV_DIRS_COUNT");




exit;










