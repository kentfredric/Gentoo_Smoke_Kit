#!/usr/bin/perl 
exit 0 
if 0;

use strict;
use warnings;

use FindBin;
use Path::Class qw( file );

my $rcfile = file("$FindBin::Bin/env.rc");

chdir( $rcfile->dir->parent->absolute->stringify );
local *ENV = *ENV;
$ENV{CHROOTING} = $rcfile->dir->parent->absolute->stringify;

system('bash', '--rcfile', $rcfile->absolute->stringify );



