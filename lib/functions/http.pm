package functions::http;
use strict;
use warnings;

sub _extract_link($$) {

    my $t      = shift;
    my $parser = shift;

    my $link = {};
    $link->{href} = $t->get_attr('href');
    $link->{text} = '';
    my $deep = 0;
    while ( $t = $parser->get_token ) {
        $link->{text} .= $t->as_is() if $t->is_text();
        $deep++ if $t->is_start_tag();
        $deep-- if !$deep and $t->is_end_tag();
        last if !$deep and $t->is_end_tag('a');
    }
    return $link;

}

sub _grep_links($) {
    require HTML::TokeParser::Simple;
    my $content = shift;
    my @links;

    my $parser = HTML::TokeParser::Simple->new( \$content );
    while ( my $t = $parser->get_token ) { do {
        next unless $t->is_start_tag('a');
		push @links, _extract_link $t, $parser;
    }    }
    return @links;

}

sub ls_dir($) {
    my $url = shift;
    use LWP::Simple;
    my $content = LWP::Simple::get($url);
    if ($content) {
        return _grep_links $content;
    }
    else {
        die "$@ $!";
    }
}

1;
