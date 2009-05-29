
use strict;
use warnings;
use MooseX::Declare;

class Smoke::Mirror with MooseX::Log::Log4perl {
	# Imports
    use MooseX::Has::Sugar qw( :allattrs );
    use MooseX::Types::Moose qw( ArrayRef Str );
    use Moose::Autobox;

	# Depends
	require Smoke::Mirror::Snapshot;
	require WWW::Mechanize;

    use namespace::autoclean -also => qr/^_ext_/;


    has base_path => ( isa => Str,      rw, required, );
    has snapshots => ( isa => ArrayRef, rw, lazy_build, );
    has '_spider' => ( isa => 'WWW::Mechanize', is => 'rw', lazy_build => 1, );

    method BUILD( Any $a ) {

        #        $self->snapshots;
    };

    method _build__spider {
        WWW::Mechanize->new();
    };

    method _build_snapshots {

        $self->log->debug( 'Fetching ' . $self->base_path );
        $self->_spider->get( $self->base_path );
        $self->log->debug('Done');

        my @snapshots;
        for ( $self->_spider->links() ) {
            next unless ( $_->url =~ m{^(\d+)/$} );

            $self->log->debug("Found Link > $1");

            push @snapshots,
              Smoke::Mirror::Snapshot->new(
                datestamp => $1,
                uri       => $_,
                parent    => $self,
              );
        }
        \@snapshots;
    };

    sub _ext_sort_snapshot {
        shift->compare_to(shift);
    }

    method latest_snapshot {
        $self->snapshots->sort( \&_ext_sort_snapshot )->at(-1);
    };

};
