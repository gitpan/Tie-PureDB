use ExtUtils::MakeMaker;
use ExtUtils::Embed qw[ ccopts ldopts ];
use Config;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my $build= @ARGV;
my $LIBS="";
my $INC="";
my $cc = $Config{cc};
my $ccopts = ccopts();
my $ldopts = ldopts();

if( $^O =~ /mswin/i ) {
    $INC = ' -I./pure-db-2.1/windows ';
    $LIBS = '-L./pure-db-2.1/windows ';

    if($build){
        chdir 'pure-db-2.1/windows';
        system qw[build_cl.bat] if $cc =~ /cl/i;
        system qw[build_borland.bat] if $cc =~ /bcc/i;
        chdir '../..';
    }

} else {
####################### doesn't work so well ;(
    $INC = ' -I./pure-db-2.1/src ';
    $LIBS = '-L./pure-db-2.1/src/.libs ';

    if($build){
        chdir 'pure-db-2.1';
        system qq[./configure CFLAGS='$ccopts' LDFLAGS='$ldopts'];
        system qw[make];
        chdir '../..';
    }
}

print qq[

#
# If you get warnings similar to
#
#    Note (probably harmless): No library found for -llibpuredb_write.lib
#    Note (probably harmless): No library found for -llibpuredb_read.lib
#
# Try executing `perl Makefile.PL 1', and see if pure-db-2.1 gets built.
# I have only tested this on Win32 ActivePerl.
# If you cannot build pure-db-2.1, then you cannot build Tie::PureDB.
#
#

] unless $build;

WriteMakefile(
    'NAME'		=> 'Tie::PureDB',
    'VERSION_FROM'	=> 'PureDB.pm', # finds $VERSION
    'LIBS'		=> [ ## one of these should work
        "$LIBS -llibpuredb_write -llibpuredb_read",
        "$LIBS -llibpuredb_write$Config{_a} -llibpuredb_read$Config{_a}",
        "-L/usr/local/lib/ -llibpuredb_write -llibpuredb_read",
    ],
    'INC'		=> "-I/usr/local/include $INC",
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'PureDB.pm', # retrieve abstract from module
       AUTHOR     => 'D. H. <PodMaster@cpan.org>') : ()),

);

__END__

perl -MFile::Find -le" find(sub{ print $File::Find::name;},@ARGV) " pure-db-2.1
perl -MFile::Find -le" find(sub{ print $File::Find::name if -f $_;},@ARGV) " pure-db-2.1
perl -MFile::Find -le" find(sub{ print $File::Find::name if -f $_;},@ARGV) " pure-db-2.1 >MANIFEST