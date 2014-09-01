package Module::CPANTS::SiteKwalitee::Distname;
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
            name=>'distname_matches_name_in_meta',
            error=>"The distribution name (eg. 'Foo-Bar' of Foo-Bar-1.42.tar.gz) does not match the 'name' field in META files.",
            remedy=>q{Use a proper tool to make a distribution. You might also need to fix META files if you keep them in the repository.},
            code=>sub {
                my $d = shift;
                return 1 if !$d->{meta_yml} || !%{$d->{meta_yml}};
                if (($d->{meta_yml}{name} || '') ne $d->{dist}) {
                    $d->{error}{distname_matches_name_in_meta} = $d->{meta_yml}{name} || '';
                    return 0;
                }
                return 1;
            },
            details=>sub {
                my $d = shift;
                return "The distribution name ($d->{dist}) doesn't match the name in META (".($d->{meta_yml}{name} || '').").";
            },
        },
    ];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};


__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::Distname - Proper Dist name

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

=item * distname_matches_name_in_meta

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Kenichi Ishigaki|https://metacpan.org/author/ishigaki>

=head1 COPYRIGHT AND LICENSE

Copyright © 2014 Kenichi Ishigaki

You may use and distribute this module according to the same terms
that Perl is distributed under.
