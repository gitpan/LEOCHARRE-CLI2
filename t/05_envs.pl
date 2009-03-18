#!/usr/bin/perl
use strict;
use vars qw($VERSION);
use Getopt::Std::Strict 'dhv';
use LEOCHARRE::Dir ':all';
use LEOCHARRE::DEBUG;
use Cwd;
use Carp;
$VERSION = sprintf "%d.%02d", q$Revision: 1.1 $ =~ /(\d+)/g;

printf "[%30s]: %s\n", $_, $ENV{$_} for sort keys %ENV;




exit;


