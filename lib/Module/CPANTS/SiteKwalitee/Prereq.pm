package Module::CPANTS::SiteKwalitee::Prereq;
use warnings;
use strict;
use File::Spec::Functions qw(catfile);

sub order { 100 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class=shift;
    my $me=shift;
    
    my $files=$me->d->{files_array};
    my $distdir=$me->distdir;

    my $prereq;
    my $build;
    my $optional;
    my $yaml=$me->d->{meta_yml};
    if ($yaml) {
        if ($yaml->{requires}) {
            $prereq=$yaml->{requires};
        }
        if ($yaml->{build_requires}) {
            $build=$yaml->{build_requires};
        }
        if ($yaml->{recommends}) {
            $optional=$yaml->{recommends};
        }
        $me->d->{got_prereq_from}='META.yml';
    }
    elsif (grep {/^Build\.PL$/} @$files) {
        open(my $in, '<', catfile($distdir,'Build.PL')) || return 1;
        my $m=join '', <$in>;
        close $in;
        my($requires) = $m =~ /(?<!_)requires.*?=>.*?\{(.*?)\}/s;
        my($build_requires) = $m =~ /build_requires.*?=>.*?\{(.*?)\}/s;
        my($optional_requires) = $m =~ /recommends.*?=>.*?\{(.*?)\}/s;
        
        $me->d->{got_prereq_from}='Build.PL';

        ## no critic (ProhibitStringyEval)
        eval "{ no strict; \$prereq = { $requires \n} }" if $requires;
        ## no critic (ProhibitStringyEval)
        eval "{ no strict; \$build = { $build_requires \n} }" if $build_requires;
        ## no critic (ProhibitStringyEval)
        eval "{ no strict; \$optional = { $optional_requires \n} }" if $optional_requires;
    }
    else {
        open(my $in, '<', catfile($distdir,'Makefile.PL')) || return 1;
        my $m=join '', <$in>;
        close $in;
        
        $me->d->{got_prereq_from}='Makefile.PL';

        my($requires) = $m =~ /PREREQ_PM.*?=>.*?\{(.*?)\}/s;
        $requires||='';
        ## no critic (ProhibitStringyEval)
        eval "{ no strict; \$prereq = { $requires \n} }";
    }
    return unless $prereq || $build || $optional;
    
    my %all=(
        prereq              => $prereq,
        build_prereq        => $build,
        optional_prereq     => $optional
    );

    my @clean;
    while (my ($type,$data)=each %all) {
        next unless $data;
        if (!ref $data) {
            my $p={$data=>0};
            $data=$p;
        }
        elsif (ref $data ne ref {}) {
            next;  # ignore wrong format
        }

        # sanitize version
        while (my($requires,$version)=each %$data) {
            $version||=0;
            $version=0 unless $version=~/[\d\._]+/;
            push(@clean,{
                requires=>$requires,
                version=>$version,
                'is_'.$type=>1,
            });
        }
    }
    $me->d->{prereq}=\@clean;
    return;
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators{
    return [
        {
            name=>'is_prereq',
            error=>q{This distribution is not required by another distribution by another author.},
            remedy=>q{Convince / force / bribe another CPAN author to use this distribution.},
            code=>sub {
                # this metric can only be run from within 
                # Module::CPANTS::ProcessCPAN
                return 0;               
            },
            details=>sub {
                my $d = shift;
                return "This distribution is not required by another distribution by another author.";
            },
            needs_db=>1,
            is_extra=>1,
        },
        {
            name=>'prereq_matches_use',
            error=>q{This distribution uses a module or a dist that's not listed as a prerequisite.},
            remedy=>q{List all used modules in META.yml requires},
            code=>sub {
                # this metric can only be run from within 
                # Module::CPANTS::ProcessCPAN
                return 0;               
            },
            needs_db=>1,
            is_extra=>1,
            details=>sub {
                my $d = shift;
                return "This distribution uses a module or a dist that's not listed as a prerequisite.";
            },
        },
        {
            name=>'build_prereq_matches_use',
            error=>q{This distribution uses a module or a dist in it's test suite that's not listed as a build prerequisite.},
            remedy=>q{List all modules used in the test suite in META.yml build_requires},
            code=>sub {
                # this metric can only be run from within 
                # Module::CPANTS::ProcessCPAN
                return 0;               
            },
            details=>sub {
                my $d = shift;
                return "This distribution uses a module or a dist in it's test suite that's not listed as a build prerequisite.";
            },
            needs_db=>1,
            is_experimental=>1,
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

=item * is_prereq (currently deactived)

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2006, 2009 L<Thomas Klausner|https://metacpan.org/author/domm>

You may use and distribute this module according to the same terms
that Perl is distributed under.
