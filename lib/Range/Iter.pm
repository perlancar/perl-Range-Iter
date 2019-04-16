package Range::Iter;

# DATE
# VERSION

use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(range_iter);

my $re_num = qr/\A[+-]?[0-9]+(\.[0-9]+)?\z/;

sub range_iter($$;$) {
    my ($start, $end, $step) = @_;
    $step //= 1;

    my $value = $start;
    my $ended;

    if ($start =~ $re_num && $end =~ $re_num) {
        # numeric version
        $ended++ if $value > $end;
        sub {
            $ended++ if $value > $end;
            return undef if $ended;
            my $old = $value;
            $value+=$step;
            return $old;
        };
    } else {
        die "Cannot specify step != 1 for non-numeric range" if $step != 1;
        $ended++ if $value gt $end;
        sub {
            return undef if $ended;
            $ended++ if $value ge $end;
            $value++;
        };
    }
}

1;
#ABSTRACT: Generate a coderef iterator for range

=for Pod::Coverage .+

=head1 SYNOPSIS

  use Range::Iter qw(range_iter);

  my $iter = range_iter(1, 10);
  while (my $val = $iter->()) { ... } # 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

You can add step:

 my $iter = range_iter(1, 10, 2); # 1, 3, 5, 7, 9

Anything that can be incremented by Perl is game:

  $iter = range_iter("a", "e"); # a, b, c, d, e


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 range_iter($start, $end) => coderef


=head1 SEE ALSO

L<Array::Iter>

=cut
