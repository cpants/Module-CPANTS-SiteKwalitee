package Module::CPANTS::SiteKwalitee::Pod;
use warnings;
use strict;
use Pod::Simple::Checker;
use File::Spec::Functions qw(catfile);

sub order { 1000 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class = shift;
    my $me = shift;
    
    my $files = $me->d->{files_array};
    my $distdir = $me->distdir;

    my $pod_errors = 0;
    my @msgs;
    foreach my $file (@$files) {
        next unless $file =~ /\.p(m|od|l)$/;

        # ignore pod files for examples/tests
        next if $file =~ m!(?:^|/)(x?t|test|ex|eg|examples?|samples?|demos?|inc|local|perl5|fatlib)/!;

        # ignore if the file has binary data section
        next if $me->d->{files_hash}{$file}{has_binary_data};

        # Count the number of POD errors
        my $parser = Pod::Simple::Checker->new;
        my $errata;
        $parser->output_string(\$errata);
        my $fullpath = catfile($distdir, $file);
        $fullpath =~ s!\\!/!g if $^O eq 'MSWin32';
        eval { $parser->parse_file($fullpath) };
        if (my $error = $@) {
            $error =~ s/ at .+? line \d+\.$//;
            push(@msgs, $error);
        }
        else {
            my $errors =()= $errata =~ /Around line /g;
            $pod_errors += $errors;
            push(@msgs, $errata) if $errata =~ /\w/;
        }
    }
    if (@msgs) {
        # work around Pod::(Simple::)Checker returning strange data
        my $errors = join(" ", @msgs);
        $errors =~ s!\n! !g;
        $errors =~ s|POD *ERRORS *Hey! The above document had some coding errors, which are explained below:| |g;
        $me->d->{error}{no_pod_errors} = $errors;
    }
}


##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
    return [
        {
            name => 'no_pod_errors',
            error => q{The documentation for this distribution contains syntactic errors in its POD. Note that this metric tests all .pl, .pm and .pod files, even if they are in t/. See 'pod_message' in the dist error view for more info.},
            remedy => q{Remove the POD errors. You can check for POD errors automatically by including Test::Pod to your test suite.},
            code => sub { shift->{error}{no_pod_errors} ? 0 : 1 },
            details => sub {
                return "The following POD errors were found: " . (shift->{error}{no_pod_errors});
            },
        },
    ];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};

__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::Pod - Check Pod

=head1 SYNOPSIS

Check if the POD of a dist is syntactically correct.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<100>.

=head3 analyse

C<MCK::Pod> uses C<Pod::Checker> to check if there are any syntactic errors in the POD.

It checks all files matching C</\.p(m|od|l)$/>.

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * no_pod_errors

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2006, 2009 L<Thomas Klausner|https://metacpan.org/author/domm>

You may use and distribute this module according to the same terms
that Perl is distributed under.
