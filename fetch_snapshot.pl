#!/usr/bin/perl 

use strict;
use warnings;
use repo;
use LWP::Simple;

unless ( defined $ARGV[0] ) {
    die "Enter Snapshot Timestamp";
}
if ( functions::fetch_package( $ARGV[0] ) ) {
    print "Success";
}
else {
    print "Fail $!";
}
