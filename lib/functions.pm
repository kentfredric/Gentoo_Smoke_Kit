
package functions;
use strict;
use warnings;
use repo;

sub debug(@) {
	print {*STDERR} "[Debug] ", @_, "\n";
}
sub debugx(@){
	require Data::Dumper;
	debug Data::Dumper::Dumper( \@_ );
}

sub fetch_package($) {
    require LWP::Simple;
	debug 'fetch_package';
    my $url     = repo::expand_source_package( $ARGV[0] );
    my $outfile = repo::expand_stage_file( $ARGV[0] );

    print "Fetching $url \ninto $outfile\n";

    my $result = LWP::Simple::mirror( $url, $outfile );
    if ( LWP::Simple::is_success($result) ) {
        return 1;
    }
    else {
        $! = $result;
        return 0;
    }
}

sub ls_available() {
    require functions::http;
    require Data::Dumper;
    my ( @allsnapshots, @links );
	debug 'ls_available';
    @links = functions::http::ls_dir(repo::MIRROR);
	debugx @links;
    @links = grep { $_->{href} eq $_->{text} } @links;
    @links = map { $_->{href} } @links;
    for my $subdir (@links) {
        my (@dirlinks);
        @dirlinks = functions::http::ls_dir( repo::MIRROR . $subdir );
        @dirlinks = grep { $_->{href} =~ /.tar.bz2$/ } @dirlinks;
        @dirlinks = map { repo::MIRROR . $subdir . $_->{href} } @dirlinks;
        push @allsnapshots, @dirlinks;
    }

    print Data::Dumper::Dumper( \@allsnapshots );
}

1;
