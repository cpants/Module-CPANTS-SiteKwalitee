use strict;
use warnings;
use ExtUtils::MakeMaker::CPANfile;

WriteMakefile(
    NAME          => 'Module::CPANTS::SiteKwalitee',
    AUTHOR        => 'Kenichi Ishigaki <ishigaki@cpan.org>',
    VERSION_FROM  => 'lib/Module/CPANTS/SiteKwalitee.pm',
    ABSTRACT_FROM => 'lib/Module/CPANTS/SiteKwalitee.pm',
    LICENSE       => 'perl',
    META_MERGE => {
        resources => {
            repository => 'https://github.com/cpants/Module-CPANTS-SiteKwalitee',
        },
    },
);
