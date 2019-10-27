requires 'Module::CPANTS::Analyse' => '0.99';

requires 'Capture::Tiny' => 0;
requires 'File::chdir' => 0;
requires 'File::Spec' => 0;
requires 'Module::Signature' => '0.82'; # old signature
requires 'Parse::LocalDistribution' => '0.18'; # 0.17 was broken
requires 'Parse::PMFile' => '0.35';
requires 'Pod::Simple::Checker' => '3.40';
requires 'version' => '0.73';

on test => sub {
  requires 'Test::More' => '0.88',
  requires 'Test::UseAllModules' => '0.10',
  requires 'WorePAN' => '0.14',
};
