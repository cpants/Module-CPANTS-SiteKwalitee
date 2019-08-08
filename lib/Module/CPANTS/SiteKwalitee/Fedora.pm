package Module::CPANTS::SiteKwalitee::Fedora;
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
    my @fedora_licenses = qw(perl apache artistic_2 gpl lgpl mit mozilla);
    # based on: https://fedoraproject.org/wiki/Licensing?rd=Licensing
    my $fedora_licenses = "Acceptable licenses: (" . join(", ", @fedora_licenses) . ")";

    return [
        {
            name => 'easily_repackageable_by_fedora',
            error => qq{It is easy to repackage this module by Fedora.},
            remedy => q{Fix each one of the metrics this depends on.},
            aggregating => [qw(no_generated_files fits_fedora_license)],
            is_experimental => 1,
            is_disabled => 1,
            code => \&_aggregator,
            details => sub {
                my $d = shift;
                return "Fix the following metrics: ".$d->{easily_repackageable_by_fedora};
            },
        },
        {
            name => 'fits_fedora_license',
            error => qq{Fits the licensing requirements of Fedora ($fedora_licenses).},
            remedy => q{Replace the license or convince Fedora to accept this license as well.},
            is_experimental => 1,
            is_disabled => 1,
            code => sub { 
                my $d = shift;
                my $license = $d->{meta_yml}{license};
                return ((defined $license and grep {$license eq $_} @fedora_licenses) ? 1 : 0);

            },
            details => sub {
                my $d = shift;
                my $license = $d->{meta_yml}{license} || 'unknown';
                return "The license ($license) does not fit the licensing requirements of Fedora ($fedora_licenses).";
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

Module::CPANTS::SiteKwalitee::Fedora - metrics for fedora

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

=item * easily_repackageable_by_fedora

=item * fits_fedora_license

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
