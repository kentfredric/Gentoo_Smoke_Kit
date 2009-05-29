
use strict;
use warnings;
use MooseX::Declare;

#
# install-amd64-minimal-20090430.iso.CONTENTS
# |       |     |       |        |   ^ MetaType
# |       |     |       |        ^ Extension
# |       |     |       ^ Date
# |       |     ^ Flavour
# |       ^ Platform
# ^ Media
#

class Smoke::Mirror::Snapshot::File {
	# Imports
    use MooseX::Has::Sugar qw( :allattrs );
    use MooseX::Types::Moose qw( ArrayRef Str Any RegexpRef HashRef);
    use MooseX::ClassAttribute qw( class_has );
	use Moose::Autobox;

	# Depends
    require MooseX::AttributeHelpers;
	require Smoke::Mirror;
	require Smoke::Mirror::Snapshot;
	
    use namespace::autoclean -also => qw/^_ext_/;


    has media    => ( isa => Str, rw, required );
    has platform => ( isa => Str, rw, required );
    has flavour => ( isa => 'Str | Undef', rw, default => '' );
    has date      => ( isa => Str, rw, required );
    has extension => ( isa => Str, rw, required );
    has metatype  => ( isa => Str, rw, default => 'file' );

    has url => ( isa => Any, rw, required );
    has parent => (
        isa => "Smoke::Mirror::Snapshot",
        rw, weak_ref, required,
        handles => [qw( log _spider )],
    );

	method BUILD ( Any $foo ){
		$self->metatype();
		$self->flavour();
	};

    sub _ext_tokenize {
        my $str = shift;
        $str =~ m{^(?<media>[^-]+)-(?<rest>[^.]+)[.](?<suffix>.*)$}x;
        return {%+};
    };

    sub _ext_tokenize_suffix {
        my $str = shift;
        $str =~ m{^[.]?(?<extension>iso|tar[.](bz2|gz))[.]?(?<metatype>.+)?$};
        return {%+};
    };

    sub _ext_tokenize_target {
        my $str    = shift;
        my $tokes  = [ split qr/-/, $str ];
        my $result = {
            platform => $tokes->at(0),
            date     => $tokes->at(-1),
        };
        if ( $tokes->length > 2 ) {
            $result->put( 'flavour',
                $tokes->slice( [ 1 .. ( $tokes->length - 2 ) ] ) );
        }
        return $result;
    };

#<<<
	method from_string ($class: Str $str, $url, $parent ) {
#>>>
            my $parts  = _ext_tokenize($str);
            my $suffix = _ext_tokenize_suffix( $parts->at('suffix') );
            my $target = _ext_tokenize_target( $parts->at('rest') );

            my %Opts = ();

            %Opts->put( 'media',     $parts->at('media') );
            %Opts->put( 'platform',  $target->at('platform') );
            %Opts->put( 'date',      $target->at('date') );
            %Opts->put( 'extension', $suffix->at('extension') );

            if( $target->exists('flavour') ){
             	%Opts->put( 'flavour', $target->at('flavour')->values->join(',') );
			}
			if (  $suffix->exists('metatype') ){
              	%Opts->put( 'metatype', $suffix->at('metatype') );
			}

            $parent->log->debug( "Found File " . %Opts->kv->flatten_deep(2)->join(',') );

            %Opts->put( 'url',    $url );
            %Opts->put( 'parent', $parent );

            return $class->new(
                %Opts,
                url    => $url,
                parent => $parent,
            );
   };

   method compare_to( Smoke::Mirror::Snapshot::File $other ){
		return $self->date <=> $other->date;
   }
}

1;

