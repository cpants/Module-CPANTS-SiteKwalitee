package Module::CPANTS::SiteKwalitee::Files;

use strict;
use warnings;
use File::Spec::Functions qw(catdir catfile);

sub order { 16 } # after ::Kwalitee::Files

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class = shift;
    my $me = shift;
    my $distdir = $me->distdir;

    my @dot_underscore_files;
    foreach my $name (sort keys %{$me->d->{files_hash} || {}}) {
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

        # NOTE: [:^ascii:] became looser in Perl 5.18 and higher.
        if ($name =~ /[\*\?"<>\|:]/ or $name =~ /[^ -~]/) {
            push @{$me->d->{error}{portable_filenames} ||= []}, $name;
        }

        if ($name =~ m!(^|/)\._!) {
            push @dot_underscore_files, $name;
        }
    }
    $me->d->{error}{no_dot_underscore_files} = [sort @dot_underscore_files] if @dot_underscore_files;

    my @generated_files = qw(Build Makefile _build blib pm_to_blib); # files that should not...
    my %generated_db_files = map_filenames($me, \@generated_files, [keys %{$me->d->{files_hash} || {}}]);
    my @found_generated_files = map { $generated_db_files{$_} }
                                grep { $me->d->{$_} }
                                keys %generated_db_files;
    if (@found_generated_files) {
        $me->d->{error}{no_generated_files} = join ", ", sort @found_generated_files;
    }

    # Check permissions of Build.PL/Makefile.PL
    {
        my $build_exe = 0;

        $build_exe = 1 if ($me->d->{file_makefile_pl} && -x catfile($distdir, 'Makefile.PL'));
        $build_exe = 2 if ($me->d->{file_build_pl} && -x catfile($distdir, 'Build.PL'));
        $build_exe = -1 unless ($me->d->{file_makefile_pl} || $me->d->{file_build_pl});
        $me->d->{buildfile_executable} = $build_exe;
    }

    # no local directories (for local::lib, carton etc)
    # NOTE: Some dists use the 'local' directory to put author-only
    # configurations and tools. It may not be good, but we shouldn't
    # be too picky, especially when we tolerate 'xt' stuff.
    # Only local directories with modules (which will be ignored by
    # PAUSE) should be caught here.
    if (my @local_files = grep {m!^(?:local|perl5|fatlib)/.+?\.pm$!} keys %{$me->d->{files_hash} || {}}) {
        my %seen;
        my @local_root_dirs = grep {!$seen{$_}++} map {(split '/', $_, 2)[0]} @local_files;
        $me->d->{error}{no_local_dirs} = join ',', sort @local_root_dirs;
    }

    # no dot directories (most probably of VCS)
    if (my @dot_dirs = grep {m!^(?:\.[^/]+)\b!} @{$me->d->{dirs_array} || []}) {
        my %seen;
        my @dot_root_dirs = grep {!$seen{$_}++} map {(split '/', $_, 2)[0]} @dot_dirs;
        $me->d->{error}{no_dot_dirs} = join ',', @dot_root_dirs;
    }
}

sub map_filenames {
    my ($me, $special_files, $files) = @_;
    my %ret;
    foreach my $file (@$special_files){
        (my $db_file = $file) =~ s/\./_/g;
        $db_file = "file_" . lc($db_file);
        $me->d->{$db_file} = ((grep {$_ eq "$file"} @$files) ? 1 : 0);
        $ret{$db_file} = $file;
    }
    return %ret;
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
  return [
    {
        name => 'buildtool_not_executable',
        error => q{The build tool (Build.PL/Makefile.PL) is executable. This is bad because you should specify which perl you want to use while installing.},
        remedy => q{Change the permissions of Build.PL/Makefile.PL to not-executable.},
        code => sub {(shift->{buildfile_executable} || 0) > 0 ? 0 : 1},
        details => sub {
            my $d = shift;
            my %filetypes = (1 => 'Makefile.PL', 2 => 'Build.PL');
            return ($filetypes{$d->{buildfile_executable}} || '') . " is executable.";
        },
    },
    {
        name => 'no_generated_files',
        error => q{This distribution has files/directories that should be generated at build time, not distributed by the author.},
        remedy => q{Remove the offending files/directories!},
        code => sub {
            my $d = shift;
            return 0 if $d->{error}{no_generated_files};
            return 1;
        },
        details => sub {
            my $d = shift;
            return "The following files were found: " . $d->{error}{no_generated_files};
        },
    },
    {
        name => 'portable_filenames',
        error => qq{This distribution has at least one file with non-portable characters in its filename, which may cause problems under some environments.},
        remedy => q{Rename those files with alphanumerical characters, or maybe remove them because in many cases they are automatically generated for local installation.},
        code => sub {
            my $d = shift;
            return 0 if $d->{error}{portable_filenames};
            return 1;
        },
        details => sub {
            my $d = shift;
            return "The following files were found: " . (join ', ', @{$d->{error}{portable_filenames}});
        },
    },
    {
        name => 'no_dot_underscore_files',
        error => qq{This distribution has dot underscore files which may cause various problems.},
        remedy => q{If you use Mac OS X, set COPYFILE_DISABLE (for OS 10.5 and better) or COPY_EXTENDED_ATTRIBUTES_DISABLE (for OS 10.4) environmental variable to true to exclude dot underscore files from a distribution.},
        code => sub {
            my $d = shift;
            return 0 if $d->{error}{no_dot_underscore_files};
            return 1;
        },
        details => sub {
            my $d = shift;
            return "The following files were found: " . (join ', ', @{$d->{error}{no_dot_underscore_files}});
        },
        is_extra => 1,
    },
    {
        name => 'no_dot_dirs',
        error => qq{This distribution has a dot directory, which most probably derives from a version control system.},
        remedy => q{Fix MANIFEST (or MANIFEST.SKIP) to exclude dot directories from a distribution. Use an appropriate tool and avoid archiving your working directory by hand. If you switch your version control system, remove old VCS directories after you migrate.},
        code => sub {
            my $d = shift;
            return 0 if $d->{error}{no_dot_dirs};
            return 1;
        },
        details => sub {
            my $d = shift;
            return "The following directories were found: " . $d->{error}{no_dot_dirs};
        },
        is_extra => 1,
    },
    {
        name => 'no_local_dirs',
        is_extra => 1, # because it's so rare and PAUSE won't index modules in local dirs
        error => qq{This distribution contains a well-known directory for local use (i.e. not suitable for a public distribution).},
        remedy => q{Fix MANIFEST (or MANIFEST.SKIP) to exclude local directories from a distribution.},
        code => sub {
            my $d = shift;
            return 0 if $d->{error}{no_local_dirs};
            return 1;
        },
        details => sub {
            my $d = shift;
            return "The following directories were found: " . $d->{error}{no_local_dirs};
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

=head3 order

Defines the order in which Kwalitee tests should be run.

=head3 analyse

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * buildtool_not_executable

=item * no_dot_dirs

=item * no_dot_underscore_files

=item * no_generated_files

=item * no_local_dirs

=item * portable_filenames

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
