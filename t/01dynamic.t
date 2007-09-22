#!/usr/bin/perl -- -*-cperl-*-

use strict;
use warnings;
use Data::Dumper;
use Test::More;

plan tests => 2; ## Oh, the irony

eval { require Test::Dynamic; };
$@ and BAIL_OUT qq{Could not load the Test::Dynamic module: $@};
pass("Test::Dynamic module loaded");

SKIP: {

	eval {
		require Perl::Critic;
	};

	if ($@) {
		skip 'Module Perl::Critic not available', 1;
	}

	## Gotta have a profile
	my $PROFILE = '.perlcriticrc';
	if (! -e $PROFILE) {
		skip qq{Perl::Critic profile "$PROFILE" not found\n}, 1;
	}

	## Gotta have our code
	my $CODE = './Dynamic.pm';
	if (! -e $CODE) {
		skip qq{Perl::Critic cannot find "$CODE" to test with\n}, 1;
	}

	my $critic = Perl::Critic->new(-profile => $PROFILE);
	my @problems = $critic->critique($CODE);
	is(@problems, 0, "Passed Perl::Critic run");

};


