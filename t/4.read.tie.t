#!/usr/bin/perl -W
use strict;
use Test::Simple tests => 24;

use Tie::PureDB;

ok(1);

my $final = 'fina.db';

my %db;
my $p = tie %db, 'Tie::PureDB::Read', $final;

die "Eeeeek $@" unless $p;

ok(2);

my %ha = (
    foo => 'bar',
    PodMaster => 'PodMaster',
    perlmonks => 'http://perlmonks.org',
    PerlMonks => 'http://www.perlmonks.org',
    vroom => 'vroom',
    diotalevi => 'diotalevi',
    tye => 'tye',
);

for my $k ( keys %ha ){
    ok( exists $db{$k}, "$k exists");
    ok( $db{$k} eq $ha{$k} , "read it, and it matches \$ha{\$k}" );
    ok( $p->FETCH($k) eq $ha{$k} , "method FETCH'd it, and it matches \$ha{\$k}" );
}


ok( !
    defined( undef($p)),
    "not defined \$p"
);
