use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

xt::kwalitee::Test::run(
  # one directory, without dist version
  ['STEFANOS/Finance-Currency-Convert-ECB-0.3.tar.gz', 1],
  ['XINZHENG/BIE-Data-HDF5-Data-0.01.tar.gz', 1],
  # more than one directories (with a directory with prepending _)
  ['SUNNYP/Captcha-reCAPTCHA-0.98.tar.gz', 0],
  # no top directory
  ['SMS/Net-SMS-CSNetworks-0.08.tar.gz', 0],
  ['KEUVGRVL/Log-Basic-1.2.1.tar.gz', 0],
);
