package Module::CPANTS::SiteKwalitee::Permissions;

use strict;
use warnings;

sub order { 100 }

sub analyse {}

sub kwalitee_indicators {
    return [
        {
            name=>'no_unauthorized_packages',
            error=>q{Apparently this distribution has unauthorized packages now.},
            remedy=>q{Ask the owner of the distribution (the one who released it first, or the one who is designated in x_authority) to give you a (co-)maintainer's permission.},
            code=>sub {
                my $d = shift;
                return $d->{error}{no_unauthorized_packages} ? 0 : 1;
            },
            details=>sub {
                my $d = shift;
                return "Apparently this distribution has unauthorized packages now: " . $d->{error}{no_unauthorized_packages};
            },
            needs_db=>1,
            is_extra=>1,
        },
    ]
}

1;

__END__

=head1 NAME

Module::CPANTS::SiteKwalitee::Permissions - metrics related to permissions

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Methods

=head3 order

=head3 analyse

=head3 kwalitee_indicators

=over

=item * no_unauthorized_packages

=back

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
