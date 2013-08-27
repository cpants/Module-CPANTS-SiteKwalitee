package Module::CPANTS::SiteKwalitee::Files;

use strict;
use warnings;
use File::Find::Rule;
use File::Spec::Functions qw(catdir catfile);

sub order { 16 } # after ::Kwalitee::Files

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class=shift;
    my $me=shift;
    my $distdir=$me->distdir;

    my @files = File::Find::Rule->file()->relative()->in($distdir);
    my @dirs  = File::Find::Rule->directory()->relative()->in($distdir);

    my @dot_underscore_files;
    foreach my $name (@files) {
        my $path = catfile($distdir, $name);

        # chmod if not readable
        if (-e $path && !-r _) {
            $me->d->{files_hash}{$name}{unreadable} = 1;
            my $perm = ((stat($path))[2] || 0) & 07777;
            chmod($perm | 0600, $path);
        }

        # Some characters are not allowed or have special meanings
        # under some environment thus should be avoided.
        # Filenames that are not allowed under *nix can't be trapped
        # here now as they are not extracted at all.
        if ($name =~ /[\*\?"<>\|:[:^ascii:]]/) {
            push @{$me->d->{error}{portable_filenames} ||= []}, $name;
        }

        if ($name =~ m!(^|/)\._!) {
            push @dot_underscore_files, $name;
        }
    }
    $me->d->{error}{no_dot_underscore_files} = \@dot_underscore_files if @dot_underscore_files;

    my @generated_files=qw(Build Makefile _build blib pm_to_blib); # files that should not...
    my %generated_db_files=map_filenames($me, \@generated_files, \@files);
    my @found_generated_files = map { $generated_db_files{$_} }
                                grep { $me->d->{$_} }
                                keys %generated_db_files;
    if (@found_generated_files) {
        $me->d->{error}{no_generated_files} = join ", ", @found_generated_files;
    }

    # Check permissions of Build.PL/Makefile.PL
    {
        my $build_exe=0;

        $build_exe=1 if ($me->d->{file_makefile_pl} && -x catfile($me->distdir,'Makefile.PL'));
        $build_exe=2 if ($me->d->{file_build_pl} && -x catfile($me->distdir,'Build.PL'));
        $build_exe=-1 unless ($me->d->{file_makefile_pl} || $me->d->{file_build_pl});
        $me->d->{buildfile_executable}=$build_exe;
    }
}

sub map_filenames {
    my ($me, $special_files, $files) = @_;
    my %ret;
    foreach my $file (@$special_files){
        (my $db_file=$file)=~s/\./_/g;
        $db_file="file_".lc($db_file);
        $me->d->{$db_file}=((grep {$_ eq "$file"} @$files)?1:0);
        $ret{$db_file}=$file;
    }
    return %ret;
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
  return [
    {
        name=>'buildtool_not_executable',
        error=>q{The build tool (Build.PL/Makefile.PL) is executable. This is bad because you should specify which perl you want to use while installing.},
        remedy=>q{Change the permissions of Build.PL/Makefile.PL to not-executable.},
        code=>sub {(shift->{buildfile_executable} || 0) > 0 ? 0 : 1},
        details=>sub {
            my $d = shift;
            my %filetypes = (1 => 'Makefile.PL', 2 => 'Build.PL');
            return ($filetypes{$d->{buildfile_executable}} || '') . " is executable.";
        },
    },
    {
        name=>'no_generated_files',
        error=>q{This distribution has files/directories that should be generated at build time, not distributed by the author.},
        remedy=>q{Remove the offending files/directories!},
        code=>sub {
            my $d=shift;
            return 0 if $d->{error}{no_generated_files};
            return 1;
        },
        details=>sub {
            my $d = shift;
            return "The following files were found: " . $d->{error}{no_generated_files};
        },
    },
    {
        name=>'portable_filenames',
        error=>qq{This distribution has at least one file with non-portable characters in its filename, which may cause problems under some environments.},
        remedy=>q{Rename those files with alphanumerical characters, or maybe remove them because in many cases they are automatically generated for local installation.},
        code=>sub {
            my $d=shift;
            return 0 if $d->{error}{portable_filenames};
            return 1;
        },
        details=>sub {
            my $d = shift;
            return "The following files were found: " . (join ', ', @{$d->{error}{portable_filenames}});
        },
    },
    {
        name=>'no_dot_underscore_files',
        error=>qq{This distribution has dot underscore files which may cause various problems.},
        remedy=>q{If you use Mac OS X, set COPYFILE_DISABLE (for OS 10.5 and better) or COPY_EXTENDED_ATTRIBUTES_DISABLE (for OS 10.4) environmental variable to true to exclude dot underscore files from a distribution.},
        code=>sub {
            my $d=shift;
            return 0 if $d->{error}{no_dot_underscore_files};
            return 1;
        },
        details=>sub {
            my $d = shift;
            return "The following files were found: " . (join ', ', @{$d->{error}{no_dot_underscore_files}});
        },
    },
  ];
}

1;

__END__

=head1 NAME

Module::CPANTS::SiteKwalitee::Files

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 new

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
