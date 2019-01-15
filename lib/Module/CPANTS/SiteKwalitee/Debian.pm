package Module::CPANTS::SiteKwalitee::Debian;
use warnings;
use strict;

sub order { 900 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class = shift;
    my $me = shift;

    return;
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators{
    return [
         {
            name => 'easily_repackageable_by_debian',
            error => qq{It is easy to repackage this module by Debian.},
            remedy => q{Fix each one of the metrics this depends on.},
            aggregating => [qw(no_generated_files has_tests_in_t_dir no_stdin_for_prompting)],
            is_disabled => 1,
            is_experimental => 1,
            code => \&_aggregator,
            details => sub {
                my $d = shift;
                return "Fix the following metrics: ".$d->{easily_repackageable_by_debian};
            },
         },
    ];
}

sub _aggregator { 
    my $d = shift;
    my $metric = shift;

    my @errors = grep { !$d->{kwalitee}{$_} } @{ $metric->{aggregating} };
    if (@errors) {
        $d->{ $metric->{name} } = join ", ", @errors;
        return 0;
    }
    return 1;
}

q{Favourite record of the moment:
  Lili Allen - Allright, still};

__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::Debian - debian related metrics

=head1 SYNOPSIS

There are several agregate metrics in here.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

=head3 analyse

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * easily_repackageable_by_debian

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>
and L<Gábor Szabó|https://metacpan.org/author/szabgab>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2009 L<Thomas Klausner|https://metacpan.org/author/domm>

Copyright © 2006–2008 L<Gábor Szabó|https://metacpan.org/author/szabgab>

You may use and distribute this module according to the same terms
that Perl is distributed under.
