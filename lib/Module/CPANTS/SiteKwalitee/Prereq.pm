package Module::CPANTS::SiteKwalitee::Prereq;
use warnings;
use strict;
use File::Spec::Functions qw(catfile);

sub order { 100 }

##################################################################
# Analyse
##################################################################

sub analyse {
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators{
    return [
        {
            name => 'is_prereq',
            error => q{This distribution is not required by another distribution by another author.},
            remedy => q{Convince / force / bribe another CPAN author to use this distribution.},
            code => sub {
                # this metric can only be run from within 
                # Module::CPANTS::ProcessCPAN
                return 0;               
            },
            details => sub {
                my $d = shift;
                return "This distribution is not required by another distribution by another author.";
            },
            needs_db => 1,
            is_extra => 1,
            is_disabled => 1,
        },
        {
            name => 'prereq_matches_use',
            error => q{This distribution uses a module or a dist that's not listed as a prerequisite.},
            remedy => q{List all used modules in META.yml requires},
            code => sub {
                # this metric can only be run from within 
                # Module::CPANTS::ProcessCPAN
                return 0;               
            },
            needs_db => 1,
            details => sub {
                my $d = shift;
                return "This distribution uses a module or a dist that's not listed as a prerequisite.";
            },
        },
        {
            name => 'test_prereq_matches_use',
            error => q{This distribution uses a module or a dist in its test suite that's not listed as a test prerequisite.},
            remedy => q{List all modules used in the test suite in META.yml test_requires},
            code => sub {
                return 0;
            },
            details => sub {
                my $d = shift;
                return "This distribution uses a module or a dist in its test suite that's not listed as a test prerequisite.";
            },
            needs_db => 1,
            is_extra => 1,  # needs refactoring
        },
        {
            name => 'configure_prereq_matches_use',
            error => q{This distribution uses a module or a dist in its Makefile.PL/Build.PL that's not listed as a configure prerequisite.},
            remedy => q{List all modules used in the Makefile.PL/Build.PL in META.yml configure_requires},
            code => sub {
                return 0;
            },
            details => sub {
                my $d = shift;
                return "This distribution uses a module or a dist in its Makefile.PL/Build.PL that's not listed as a configure prerequisite.";
            },
            needs_db => 1,
            is_experimental => 1,  # needs refactoring
        },
        
    ];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};

__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::Prereq - Checks listed prerequistes

=head1 SYNOPSIS

Checks which other dists a dist declares as requirements.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<100>.

=head3 analyse

C<MCK::Prereq> checks C<META.yml>, C<Build.PL> or C<Makefile.PL> for prereq-listings. 

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * is_prereq

=item * prereq_matches_use

=item * build_prereq_matches_use

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2006, 2009 L<Thomas Klausner|https://metacpan.org/author/domm>

You may use and distribute this module according to the same terms
that Perl is distributed under.
