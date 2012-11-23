package Algorithm::Bitonic::Sort;

use utf8;
use feature 'say';
use common::sense;
use Data::Dumper::Simple;
use constant DEBUG => $ENV{ALGORITHM_BITONIC_SORT};


our (@ISA, @EXPORT);
BEGIN {
	require Exporter;
	@ISA = qw(Exporter);
	@EXPORT = qw(bitonic_sort);  # symbols to export on request
}

# "A supercomputer is a device for turning compute-bound problems into I/O-bound problems."

=encoding utf8

=head1 NAME

Algorithm::Bitonic::Sort - Sorting numbers with Bitonic Sort

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Use L<Algorithm::Bitonic::Sort> with the following style.

	use Algorithm::Bitonic::Sort;
	
	my @sample = (1,4,8,4,4365,67,33,345);
	my @result_up	= bitonic_sort( 1 ,@sample);	# incremental
	my @result_down	= bitonic_sort( 0 ,@sample);	# decremental

=head1 DESCRIPTION

This is an Perl 5 implementation of Ken Batcher's Bitonic mergesort.


=head1 Limitation

The original Bitonic can only sort N numbers, which N is a power of 2.

Which means that you can sort a set of numbers (an array or list) which 
contains 2 (2**1) or 4 (2**2) or 8 (2**3) or any 2**M amount of members.


=head1 EXPORT

bitonic_sort


=head1 SUBROUTINES

=head2 bitonic_sort

Accepts the first param as the ascending/decreasing selector.
True (1 or any true value) means ascending (incremental),
False (0 or any false value) means decreasing.

All the rest params will treat as members/items to be sorted.

WARNING:
Giving any amount of members not equal to 2**N will have unexpected result and fail.

=cut

sub bitonic_sort {
	my $up = shift;
	say '#### Sort: '.Dumper(@_) if DEBUG;
	
	return @_ if int @_ <= 1;
	
	my @num = @_;
	my @first = bitonic_sort( 1, @num[0..(@num /2 -1)] );
        my @second = bitonic_sort( 0, @num[(@num /2)..(@num -1)] );
        
        return _bitonic_merge( $up, @first, @second );
}

sub _bitonic_merge {
	my $up = shift;
	say '#### Merge: '.Dumper(@_) if DEBUG;
	
	# assume input @num is bitonic, and sorted list is returned 
	return @_ if int @_ == 1;
	
	my @num = @_;
	@num = _bitonic_compare( $up, @num );
	
	my @first = _bitonic_merge( $up, @num[0..(@num /2 -1)]);
	my @second = _bitonic_merge( $up, @num[(@num /2)..(@num -1)]);
	
	say "#####\n# Merge Result\n#####\n".Dumper(@first, @second)  if DEBUG;
	
	return (@first, @second);
}

sub _bitonic_compare {
	my $up = shift;
	say '#### Compare: '.Dumper(@_) if DEBUG;
	my @num = @_;
	my $dist = int @num /2;
	
	for my $i (0..$dist-1) {
		if ( ($num[$i] > $num[$i+$dist]) == $up ) {
			($num[$i], $num[$i+$dist]) = ($num[$i+$dist], $num[$i]);	#swap
		}
	}
	
	return @num;
}


=head1 AUTHOR

BlueT - Matthew Lien - 練喆明, C<< <BlueT at BlueT.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-algorithm-bitonic-sort at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Algorithm-Bitonic-Sort>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Algorithm::Bitonic::Sort


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Algorithm-Bitonic-Sort>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Algorithm-Bitonic-Sort>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Algorithm-Bitonic-Sort>

=item * Search CPAN

L<http://search.cpan.org/dist/Algorithm-Bitonic-Sort/>

=item * Launchpad

L<https://launchpad.net/p5-algorithm-bitonic-sort>

=item * GitHub

L<https://github.com/BlueT/Algorithm-Bitonic-Sort>

=back


=head1 ACKNOWLEDGEMENTS

=head1 SEE ALSO

=over 4

=item * Batcher's web page at Kent State University

L<http://www.cs.kent.edu/~batcher/>

=item * Bitonic sorter on Wikipedia

L<http://en.wikipedia.org/wiki/Bitonic_sorter>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2012 BlueT - Matthew Lien - 練喆明.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Algorithm::Bitonic::Sort
