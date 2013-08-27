package Module::CPANTS::SiteKwalitee::MyMeta;
use warnings;
use strict;

sub order { 30 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class=shift;
    my $me=shift;

}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators{
    return [
    {
        name=>'no_mymeta_files',
        error=>q{This distribution contains MYMETA.* files which should be used only locally. This metric should be integrated into 'no_generated_files' eventually, but as MYMETA.* files are recent inventions, you might need to take special care if MANIFEST.SKIP exists in your distribution. Hence this metric.},
        remedy=>q{Update MANIFEST.SKIP to exclude MYMETA files. If you are lazy, add "#!install_default" in your MANIFEST.SKIP and update your ExtUtils::Manifest if necessary, then some of the most common files will be excluded.},
        code=>sub {
            my $d=shift;
            return 0 if $d->{file_mymeta_yml} || $d->{file_mymeta_json};
            return 1;
        },
        details=>sub {
            my $d = shift;
            my @found = grep /MYMETA/, @{$d->{files_array}};
            return "The following files were found: " . join ',', @found;
        },
    },
    ];
}

1;

__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::MyMeta - See if MYMETA.* files are not included

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<30>.

=head3 analyse

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * no_mymeta_files

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Kenichi Ishigaki|https://metacpan.org/author/ishigaki>

=head1 COPYRIGHT AND LICENSE

Copyright © 2013 L<Kenichi Ishigaki|https://metacpan.org/author/ishigaki>

You may use and distribute this module according to the same terms
that Perl is distributed under.
