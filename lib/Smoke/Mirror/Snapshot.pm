
use strict;
use warnings;
use MooseX::Declare;

class Smoke::Mirror::Snapshot {

    # Imports
    use MooseX::Has::Sugar qw( :allattrs );
    use MooseX::Types::Moose qw( ArrayRef Str Any RegexpRef HashRef);
    use MooseX::ClassAttribute qw( class_has );
    use Moose::Autobox;

    # Depends
    require MooseX::AttributeHelpers;
    require Smoke::Mirror;
    require Smoke::Mirror::Snapshot::File;

    use namespace::autoclean -also => qr/^_ext_/;

    # Class Attributes

    class_has Section_Map => (
        isa => HashRef,
        rw,
        metaclass => 'Collection::Hash',
        providers => { get => 'Section_Map_Of', },
        default   => sub {
            {
                ''          => 'binary',
                '.CONTENTS' => 'toc',
                '.DIGESTS'  => 'digest'
            };
        },
    );

    # Instance Attributes

    has uri => ( isa => Any, rw, required );
    has parent => (
        isa => 'Smoke::Mirror',
        rw, weak_ref, required, handles => [qw( log _spider )],
    );
    has datestamp => ( isa => Str,      rw, required );
    has files     => ( isa => ArrayRef, rw, lazy_build );

    method compare_to( Smoke::Mirror::Snapshot $other ) {
        $self->datestamp <=> $other->datestamp;
    };

    method BUILD( Any $a ) {

        #    $self->files;
    };

    method _build_files {
        my @links;
        $self->log->debug( 'Fetching ' . $self->uri->url_abs );
        $self->_spider->get( $self->uri->url_abs );
        for ( $self->_spider->links() ) {
            next if $_->url =~ m{\?C=\w;O=\w};
            next if $_->url =~ m{/};

            push @links,
              Smoke::Mirror::Snapshot::File->from_string( $_->url, $_, $self );
        }
        \@links;
    };

    sub _ext_grep_ext {
        $_[0]->extension eq 'tar.bz2' and $_[0]->metatype eq 'file';
    }

    method snapshot_binary {
        $self->files->grep( \&_ext_grep_ext )->at(0);
    };

};

