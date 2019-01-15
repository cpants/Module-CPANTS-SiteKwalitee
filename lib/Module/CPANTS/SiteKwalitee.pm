package Module::CPANTS::SiteKwalitee;

use strict;
use warnings;
use Module::CPANTS::Kwalitee qw(
  Module::CPANTS::SiteKwalitee
  Module::CPANTS::Kwalitee
);
use base 'Module::CPANTS::Kwalitee';

our $VERSION = '0.01';

1;

__END__

=head1 NAME

Module::CPANTS::SiteKwalitee - provides extra Kwalitee metrics that need extra effort to install or run

=head1 SYNOPSIS

  my $mck = Module::CPANTS::SiteKwalitee->new;
  my @generators = $mck->generators;

=head1 DESCRIPTION

Some of the Kwalitee metrics require databases to get extra information, or dependencies with portability issues, or simply too much dependencies for casual users (of L<Test::Kwalitee> for example), or a lot of time to analyse. Those useful but problematic Kwalitee metrics are now moved into this distribution so that casual users would not be annoyed.

=head1 METHODS

=head2 new
=head2 get_indicators
=head2 get_indicators_hash
=head2 core_indicator_names
=head2 optional_indicator_names
=head2 experimental_indicator_names
=head2 all_indicator_names
=head2 available_kwalitee
=head2 total_kwalitee

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
