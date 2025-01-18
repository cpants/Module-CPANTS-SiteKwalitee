use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

Test::More::plan skip_all => "This test requires databases";

xt::kwalitee::Test::run(
    ['KAWABATA/Text-HikiDoc-1.023.tar.gz',                  0],    # Text::Highlight etc
    ['PVIGIER/XML-Compile-SOAP-Daemon-Dancer2-0.07.tar.gz', 0],    # Log::Report etc
    ['MICKEY/PONAPI-Server-0.003002.tar.gz',                0],    # URI::Escape
    ['TEAM/Net-Async-Pusher-0.004.tar.gz',                  0],    # Syntax::Keyword::Try
    ['DORNER/UI-Various-0.39.tar.gz',                       1],    # Curses::UI and Tk are declared as recommends
);
