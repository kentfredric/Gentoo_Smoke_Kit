#!/usr/bin/perl 

use strict;
use warnings;
use repo; 

unless ( defined $ARGV[0] ){ 
	die	"Enter Snapshot Timestamp" ; 
}

my $source = repo::expand_stage_file( $ARGV[0] );
my $dest =   repo::expand_stage_dest( $ARGV[0] );


print "Unpacking snapshot $source -> $dest ";



