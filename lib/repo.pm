package repo;

use strict;
use warnings;

sub ROOT() { '/media/SuperDisk/ShiftOff/TestGentoo' }; 
sub STAGES() { ROOT . '/Stages' };
sub CHECKOUTS(){ ROOT . '/Masters' }; 
sub STAGE_CHECKOUTS(){ CHECKOUTS . '/Stages' };
sub ARCH() { 'amd64'}; 
sub EXT() { '.tar.bz2' };
sub MIRROR() { 'http://mirror.datapipe.net/gentoo/releases/amd64/autobuilds/' };

sub EXPANDER_SOURCE_PACKAGE() { 
	MIRROR . '%s' . '/stage3-'. ARCH . '-' . '%s' . EXT ; 
}
sub EXPANDER_STAGE_FILE(){ 
	STAGES . '/stage-3-' . ARCH . '-%s' . EXT; 
}
sub EXPANDER_STAGE_DEST(){ 
	STAGES . "/%s" ;
}
sub DISK_FILE_EXTRACT(){ 
	'(?-xism:' . ARCH . '-([^\.]+)' . quotemeta(EXT) . ')';
}

sub expand_source_package($) { 
	my $version = shift; 
	return sprintf( EXPANDER_SOURCE_PACKAGE, $version , $version );
}
sub expand_stage_file($){ 
	my $version = shift; 
	return sprintf( EXPANDER_STAGE_FILE,  $version );
}
sub expand_stage_dest($){ 
	my $version = shift; 
	return sprintf(EXPANDER_STAGE_DEST, $version );
}
sub file_to_stamp($){
	my $file = shift; 
}
1;

