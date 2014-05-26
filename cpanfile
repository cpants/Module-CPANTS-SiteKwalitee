requires 'Module::CPANTS::Analyse' => '0.92';

requires 'Capture::Tiny' => 0;
requires 'File::Basename' => 0;
requires 'File::chdir' => 0;
requires 'File::Find' => 0;
requires 'File::Spec' => 0;
requires 'File::stat' => 0;
requires 'List::Util' => 0;
requires 'Module::Signature' => '0.70';
requires 'Parse::LocalDistribution' => '0.10';
requires 'Parse::PMFile' => '0.19';
requires 'Pod::Simple::Checker' => '2.02';
requires 'version' => '0.73';

on test => sub {
  requires 'Test::More' => '0.88',
  requires 'Test::UseAllModules' => '0.10',
  requires 'WorePAN' => '0.09',
};
