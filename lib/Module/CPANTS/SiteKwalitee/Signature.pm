package Module::CPANTS::SiteKwalitee::Signature;
use strict;
use warnings;
use File::chdir;
use Module::Signature qw(verify SIGNATURE_OK SIGNATURE_MISSING);
use Capture::Tiny qw/capture_stderr/;

sub order { 100 }

sub analyse {
    my ($class, $self) = @_;
    local $CWD = $self->distdir;

    # a shortcut to ignore the most common warning.
    # (the rest should be caught when necessary)
    return $self->d->{valid_signature} = SIGNATURE_MISSING
      unless -r $Module::Signature::SIGNATURE;

    # capture warnings from both Module::Signature and gpg itself
    my $err = capture_stderr {
        local $SIG{__WARN__};
        $self->d->{valid_signature} = verify;
    };
    if ($err) {
        $self->d->{error}{valid_signature} = $err;
    }
}

sub kwalitee_indicators {
    return [{
        name    => 'valid_signature',
        error   => q{This dist failed its Module::Signature verification and does not to install automatically through the CPAN client if Module::Signature is installed. Note: unsigned dists will automatically pass this kwalitee check.},
        remedy  => q{Sign the dist as the last step before creating the archive. Take care not to modify/regenerate dist meta files or the manifest.},
        code    => sub {
            my $v = shift->{valid_signature};
            return (!defined $v or SIGNATURE_OK == $v or SIGNATURE_MISSING == $v) ? 1 : 0;
        },
        details=>sub {
            my $d = shift;
            return $d->{error}{valid_signature};
        },
    }];
}

1;

__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::SiteKwalitee::Signature - dist has a valid signature

=head1 SYNOPSIS

Check if the cryptographic signature of a dist is valid.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<100>.

=head3 analyse

Uses C<Module::Signature> to verify the validity of the dist signature.

Dists without signature pass automatically.

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * valid_signature

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

Lars Dɪᴇᴄᴋᴏᴡ C<< <daxim@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright © 2012, Lars Dɪᴇᴄᴋᴏᴡ C<< <daxim@cpan.org> >>.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl 5.14.
