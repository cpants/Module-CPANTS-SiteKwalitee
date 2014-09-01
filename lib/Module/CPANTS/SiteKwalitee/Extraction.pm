package Module::CPANTS::SiteKwalitee::Extraction;
use warnings;
use strict;
use Data::Dumper;

sub order { 5 }

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
        name=>'extractable',
        error=>q{This distribution doesn't extract well due to several reasons such as unsupported archive type (CPANTS only supports tar.gz, tgz and zip archives), file permissions, broken links, invalid filenames, and so on. Most of other kwalitee metrics should be ignored.},
        remedy=>q{Pack the distribution with a proper command such as "make dist" and "./Build dist", or use a distribution builder such as Dist::Zilla, Dist::Milla, Minilla. You might also need to set some options or environmental variables to ensure your archiver work portably.},
        code=>sub { shift->{extractable} ? 1 : -100 },
        details=>sub {
            my $d = shift;
            my $error = $d->{error}{extractable} || $d->{error}{cpants};
            return $error unless ref $error;
            return Dumper($error);
        }
    },
    {
        name=>'extracts_nicely',
        error=>q{This distribution doesn't create a directory and extracts its content into this directory. Instead, it creates more than one directories (some of which are probably system-specific hidden files/directories), or it spews its content into the current directory, making it really hard/annoying to remove the unpacked package.},
        remedy=>q{Pack the distribution with a proper command such as "make dist" and "./Build dist", or use a distribution builder such as Dist::Zilla, Dist::Milla, Minilla.},
        code=>sub { shift->{extracts_nicely} ? 1 : 0},
        details=>sub {
            my $d = shift;
            return "More than one files and/or directories were extracted into the current directory, or the directory where distribution is extracted into did not match the distribution name.";
        },
    },
    {
        name=>'no_pax_headers',
        error=>q{This distribution is archived with PAX extended headers, which may be useful under some environments, but may also make extraction fail under other environments (Archive::Tar ignores PAX information as well).},
        remedy=>q{If you use Mac OS X >= 10.6, use gnu tar (/usr/bin/gnutar) to avoid PAX headers. It's also important to rename (shorten) long file names (>= 100 characters) in the distribution.},
        code=>sub { shift->{no_pax_headers} ? 1 : 0 },
        details=>sub {
            my $d = shift;
            return "PAX extended headers were found: " . $d->{error}{no_pax_headers};
        }
    },
];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};


__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::Extraction - metrics related to archive extraction

=head1 SYNOPSIS

Find various files and directories that should be part of every self-respecting distribution.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<5>.

=head3 analyse

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * extractable

=item * extracts_nicely

=item * no_pax_headers

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2006, 2009 L<Thomas Klausner|https://metacpan.org/author/domm>

You may use and distribute this module according to the same terms
that Perl is distributed under.
