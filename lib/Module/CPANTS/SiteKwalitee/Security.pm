package Module::CPANTS::SiteKwalitee::Security;

use strict;
use warnings;
use Regexp::Common qw(Email::Address URI);
use File::Spec::Functions qw(catfile);
use Email::Address;

sub order { 1000 } # after ::Kwalitee::Files

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class = shift;
    my $me = shift;
    my $distdir = $me->distdir;
    my @security_docs = grep m!^(docs?/)?SECURITY(?:.(?:pod|md))?$!i, keys %{$me->d->{files_hash}};
    if (@security_docs) {
        $me->d->{has_security_doc} = 1;
        $me->d->{file_security} = join ',', @security_docs;
        for my $doc (@security_docs) {
            my $file = catfile($distdir, $doc);
            next unless -f $file;
            my $content = do { open my $fh, '<', $file; local $/; <$fh> };
            # security document should have an email address to report, or a link to a reporting form
            my @contact;
            if (my @emails = $content =~ /($RE{Email}{Address})/g) {
                $me->d->{security_doc_contains_contact} += 1;
                for my $email (@emails) {
                    push @contact, map {$_->address} Email::Address->parse($email);
                }
            }
            if (my @links = $content =~ /($RE{URI}{HTTP}{-scheme => 'https'})/g) {
                $me->d->{security_doc_contains_contact} += 2;
                for my $link (@links) {
                    # remove typical trailing trashes (such as punctuation marks and parentheses)
                    $link =~ s![^a-zA-Z0-9_/]+$!!;
                    # ignore security.metacpan.org; it should not be a place to report issues.
                    next if $link =~ m!https://security\.metacpan\.org/!;
                    push @contact, $link;
                }
            }
            if (@contact) {
                my %seen;
                $me->d->{security_contact} = join ',', grep {!$seen{$_}++} @contact;
                last;
            }
        }
    }
    if (my @contributing_docs = grep m!^(?:docs?/)?CONTRIBUTING(?:.(?:pod|md))?$!i, keys %{$me->d->{files_hash}}) {
        $me->d->{has_contributing_doc} = 1;
        $me->d->{file_contributing} = join ',', @contributing_docs;
    }
}

sub map_filenames {
    my ($me, $special_files, $files) = @_;
    my %ret;
    foreach my $file (@$special_files){
        (my $db_file = $file) =~ s/\./_/g;
        $db_file = "file_" . lc($db_file);
        $me->d->{$db_file} = ((grep {$_ eq "$file"} @$files) ? 1 : 0);
        $ret{$db_file} = $file;
    }
    return %ret;
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
  return [
    {
        name => 'has_security_doc',
        error => q{This distribution has no documentation about security policy.},
        remedy => q{Add SECURITY(.pod|md). See Software::Security::Policy.},
        is_experimental => 1,
        code => sub { shift->{has_security_doc} ? 1 : 0 },
        details => sub {
            my $d = shift;
            return if $d->{has_security_doc};
            return "This distribution has no documentation about security policy.";
        },
    },
    {
        name => 'security_doc_contains_contact',
        error => q{This distribution has no documentation about security policy or the documentation has no contact.},
        remedy => q{Add SECURITY(.pod|md) and add a contact address. See Software::Security::Policy.},
        is_experimental => 1,
        code => sub { shift->{security_doc_contains_contact} ? 1 : 0 },
        details => sub {
            my $d = shift;
            return if $d->{security_doc_contains_contact};
            return "This distribution has no documentation about security policy or the documentation has no contact.";
        },
    },
    {
        name => 'has_contributing_doc',
        error => q{This distribution has no documentation about contribution.},
        remedy => q{Add CONTRIBUTING(.pod|md). See https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors.},
        is_experimental => 1,
        code => sub { shift->{has_contributing_doc} ? 1 : 0 },
        details => sub {
            my $d = shift;
            return if $d->{has_contributing_doc};
            return "This distribution has no documentation about contribution.";
        },
    },
  ];
}

1;

__END__

=head1 NAME

Module::CPANTS::SiteKwalitee::Serurity

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head3 order

Defines the order in which Kwalitee tests should be run.

=head3 analyse

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * has_security_doc

=item * security_doc_contains_contact

=item * has_contributing_doc

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2025 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
