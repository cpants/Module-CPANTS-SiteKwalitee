use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

xt::kwalitee::Test::run(
    # email
    ['RRWO/Data-Enum-v0.6.0.tar.gz', 1],
    ['BRIANDFOY/Tie-Timely-1.026.tar.gz', 1],

    # link
    ['FASTLY/WebService-Fastly-7.00.tar.gz', 1],
    ['MSTEMLE/Net-AMQP-RabbitMQ-2.40014.tar.gz', 1],

    # SECURITY without contact
    ['FSG/Penguin-3.00.tar.gz', 0],
    ['THOMAS/Apache-DnsZone-0.1.tar.gz', 0],
);
