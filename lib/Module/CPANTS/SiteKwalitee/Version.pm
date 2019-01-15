package Module::CPANTS::SiteKwalitee::Version;
use warnings;
use strict;
use File::Spec::Functions qw(catdir catfile abs2rel splitdir);
use Parse::LocalDistribution;
use version;

sub order { 200 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class = shift;
    my $me = shift;
    my $distdir = $me->distdir;
    $distdir =~ s|\\|/|g if $^O eq 'MSWin32';

    my $provides = do {
        no warnings 'once';
        local $Parse::PMFile::ALLOW_DEV_VERSION = 1;
        local $SIG{__WARN__} = sub {};
        Parse::LocalDistribution->new($distdir)->parse;
    };
    my (%versions, %errors);
    for (keys %$provides) {
        my $package = $provides->{$_};
        delete $package->{parsed};
        delete $package->{filemtime};
        delete $package->{simile};
        ($package->{infile} //= '') =~ s!^$distdir/!!;
        if (defined $package->{version}) {
            $versions{$package->{infile}}{$_} = $package->{version};
        }
        if (my ($key) = grep /_error/, keys %$package) {
            $errors{$package->{infile}}{$_} = $package->{$key};
        }
    }

    $me->d->{versions} = \%versions;
    $me->d->{error}{no_invalid_versions} = \%errors if %errors;

    return;
}



##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
  return [
    {
        name => 'no_invalid_versions',
        error => qq{This distribution has .pm files with an invalid version.},
        remedy => q{Fix the version numbers so that version::is_lax($version) returns true.},
        is_extra => 1,
        code => sub {
            my $d = shift;
            return 0 if $d->{error}{no_invalid_versions};
            return 1;
        },
        details => sub {
            my $d = shift;
            return $d->{error}{no_invalid_versions};
        },
    },
    {
        name => 'consistent_version',
        error => qq{This distribution has .pm files with inconsistent versions.},
        remedy => q{Split the distribution, or fix the version numbers to make them consistent (use the highest version number to avoid version downgrade).},
        code => sub {
            my $d = shift;

            my %seen;
            for my $file (keys %{$d->{versions}}) {
                for my $package (keys %{$d->{versions}{$file}}) {
                    my $version = $d->{versions}{$file}{$package};
                    next if !defined $version;
                    next if $version eq 'undef';
                    next if $version eq '0'; # XXX
                    $seen{$version}++;
                }
            }
            my @versions = keys %seen;
            return 1 if !@versions; # This is bad, but not inconsistent.
            return 1 if @versions == 1;
            $d->{error}{consistent_version} = join ',', sort @versions;
            return 0;
        },
        details => sub {
            my $d = shift;
            return $d->{error}{consistent_version};
        },
        is_extra => 1,
    },
    {
        name => 'main_module_version_matches_dist_version',
        error => q{The version and/or name of the main module in this distribution doesn't match the distribution version and/or name.},
        remedy => q{Make sure that the main module name and version are the same of the distribution.},
        code => sub {
            my $d = shift;

            my $distv = $d->{version};
            return 0 unless defined $distv;
            $distv =~ s/\-TRIAL[0-9]*$//;
            my $distvv = eval { version->new($distv) };

            my $main_module = ($d->{dist} || '') =~ s/\-/::/gr;
            for my $file (keys %{$d->{versions}}) {
                for my $package (keys %{$d->{versions}{$file}}) {
                    next unless $package eq $main_module;
                    my $version = $d->{versions}{$file}{$package};
                    return 0 unless defined $version;
                    return 1 if $version eq $distv;
                    if ($distvv) {
                        no warnings; # to silence "numify is lossy"
                        my $packagev = eval { version->new($version."") } or return 0;
                        return 1 if eval $distvv->numify == eval $packagev->numify;
                    }
                    return 0;
                }
            }
            return 0;
        },
        details => sub {
            my $d = shift;
            my $main_module = ($d->{dist} || '') =~ s/\-/::/gr;
            return "The version and name of the main module ($main_module) in this distribution matches the distribution name and version.";
        },
    },
];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};


__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::Version - Check versions

=head1 SYNOPSIS

Look for packages and their versions by parsing a META file or parsing .pm files

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<200>.

=head3 analyse

C<MCK::Version> uses C<Pares::PMFile> to parse .pm files

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * no_invalid_versions

=item * consistent_version

=item * package_version_matches_dist_version

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2006, 2009 L<Thomas Klausner|https://metacpan.org/author/domm>

You may use and distribute this module according to the same terms
that Perl is distributed under.
