#!/usr/bin/perl

use strict;
use warnings;

use lib '/opt/IAS/lib/perl5';

use FindBin qw($RealBin);
FindBin::again();

use lib "$RealBin/../lib/perl5";

use IAS::CGIApplication::Test;

my $cgi_app_test = new IAS::CGIApplication::Test;

$cgi_app_test->run();
