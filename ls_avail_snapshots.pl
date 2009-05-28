#!/usr/bin/perl 

use strict;
use warnings;
use Smoke::Mirror;
use Data::Dumper;
use Moose::Autobox;
use Log::Log4perl qw( :easy );
Log::Log4perl->easy_init($DEBUG);

my $i = Smoke::Mirror->new(
    base_path => 'http://ftp.citylink.co.nz/gentoo/releases/amd64/autobuilds/'

      #'ftp://ftp.citylink.co.nz/gentoo/releases/amd64/autobuilds/'
      #'http://mirror.datapipe.net'
      #      . '/gentoo/releases/amd64/autobuilds/'
);

local $Data::Dumper::Maxdepth = 2;

$i->latest_snapshot->snapshot_binary->dump->print;

#
#	print Dumper($_->files);
#
#}
