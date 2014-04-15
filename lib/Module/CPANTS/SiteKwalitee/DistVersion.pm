package Module::CPANTS::SiteKwalitee::DistVersion;
use warnings;
use strict;

sub order { 15 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class=shift;
    my $me=shift;

    # NOTE: necessary information is gathered while unpacking.

    return;
}


##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
    return [
        {
            name=>'has_version',
            error=>"The distribution filename (eg. Foo-Bar-1.42.tar.gz) does not include a version number (or something that looks like a reasonable version number to CPAN::DistnameInfo)",
            remedy=>q{Add a version number to the packed distribution. Or use a buildtool ('make dist' or 'Build dist')},
            code=>sub { defined shift->{version} ? 1 : 0 },
            details=>sub {
                my $d = shift;
                my $vname = $d->{vname};
                return "This seems not a valid distribution. (Haven't you run a Kwalitee test from a local directory?)" unless defined $vname;
                return "This distribution ($vname) doesn't have a version number.";
            },
        },
        {
            name=>'has_proper_version',
            error=>"The version number isn't a number. It probably contains letter besides a leading 'v', which it shouldn't",
            remedy=>q{Remove all letters from the version number. If you want to mark a release as a developer release, use the scheme 'Module-1.00_01'},
            code=>sub { my $v=shift->{version};
                 return 0 unless defined $v;
                 return 1 if ($v=~ /\A v? \d+ (?:\.\d+)* (?:_\d+)? (\-TRIAL)?\z/xi );
                 return 0;
            },
            details=>sub {
                my $d = shift;
                my $version = $d->{version};
                return "This distribution doesn't have a version number." unless defined $version;
                $version =~ s/\-TRIAL$//;
                return "The version ($version) doesn't look like a number.";
            },
        },
    ];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};


__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::DistVersion - Proper Dist Version

=head1 SYNOPSIS

Checks if a dist version is well-formed.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<15>.

=head3 analyse

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * has_version

=item * has_proper_version

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2006, 2009 L<Thomas Klausner|https://metacpan.org/author/domm>

You may use and distribute this module according to the same terms
that Perl is distributed under.
