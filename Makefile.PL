use strict;
use warnings;
use ExtUtils::MakeMaker;

my %params = (
    NAME          => 'Module::CPANTS::SiteKwalitee',
    AUTHOR        => 'Kenichi Ishigaki <ishigaki@cpan.org>',
    VERSION_FROM  => 'lib/Module/CPANTS/SiteKwalitee.pm',
    ABSTRACT_FROM => 'lib/Module/CPANTS/SiteKwalitee.pm',
    LICENSE       => 'perl',
    PREREQ_PM     => {
        'Module::CPANTS::Analyse' => '0.87',

        # for ::Signature
        'File::chdir' => 0,
        'Module::Signature' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'          => '0.88',
        'Test::UseAllModules' => '0.10',
    },
    META_MERGE => {
        resources => {
            repository => 'https://github.com/cpants/Module-CPANTS-SiteKwalitee',
        },
    },
);

my $eumm = $ExtUtils::MakeMaker::VERSION;
delete $params{LICENSE}          if $eumm < 6.31;
delete $params{MIN_PERL_VERSION} if $eumm < 6.48;
delete $params{META_MERGE}       if $eumm < 6.46;

if ($eumm < 6.52 && $params{CONFIGURE_REQUIRES}) {
    $params{PREREQ_PM} = {
        %{ $params{PREREQ_PM}          || {} },
        %{ $params{CONFIGURE_REQUIRES} },
    };
    delete $params{CONFIGURE_REQUIRES};
}
if ($eumm < 6.5503 && $params{BUILD_REQUIRES}) {
    $params{PREREQ_PM} = {
        %{ $params{PREREQ_PM}      || {} },
        %{ $params{BUILD_REQUIRES} },
    };
    delete $params{BUILD_REQUIRES};
}

WriteMakefile(%params);
