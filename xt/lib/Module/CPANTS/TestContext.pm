package #
  Module::CPANTS::TestContext;

use strict;
use warnings;

sub new {
  my ($class, $dir) = @_;
  bless {distdir => $dir}, $class;
}

sub dist    { shift->{dist} }
sub distdir { shift->{distdir} }
sub d       { shift->{d} ||= {} }

1;
