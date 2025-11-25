#!perl

use 5.10.1;
use utf8;
use common::sense;
use Test::More tests => 3;

use Algorithm::Bitonic::Sort;
	
my @sample = (1,5,8,4,4365,2,67,33,345);
my @up = (1,2,4,5,8,33,67,345,4365);
my @down = (4365,345,67,33,8,5,4,2,1);

my @result = bitonic_sort( 1 ,@sample);
is_deeply(\@result, \@up, 'Ascending');

my @result = bitonic_sort( 0 ,@sample);
is_deeply(\@result, \@down, 'Decreasing');

my @sample_odd = (5, 2, 8, 1, 9, -1, 0, 5, 2, 8, 1);
my @down_odd = (9, 8, 8, 5, 5, 2, 2, 1, 1, 0, -1);
my @result_odd = bitonic_sort(0, @sample_odd);
is_deeply(\@result_odd, \@down_odd, 'Decreasing odd');
