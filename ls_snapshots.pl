#!/usr/bin/perl 

use strict;
use warnings;
use repo; 
use File::Find::Rule;

my $rule = File::Find::Rule->new(); 
$rule->file;
$rule->name("*" . repo::EXT);
my $it = $rule->start(repo::STAGES); 
while( my $found = $it->match ){
	if ( $found =~ repo::DISK_FILE_EXTRACT() ){ 
		print $1 , ' => ', $found, "\n"; 
		my $xpanded = repo::expand_stage_dest $1;
		print "\t => $xpanded\n" if -e -d -r -x -w $xpanded; 
	}
}
