package Range::Iter;

# DATE
# VERSION

use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

use Exporter qw(import);
our @EXPORT_OK = qw(range_iter);

sub range_iter($$;$) {
    my ($start, $end, $step) = @_;
    $step //= 1;

    my $value = $start;
    my $ended;

    if (looks_like_number($start) && looks_like_number($end)) {
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

You can use alphanumeric strings too since C<++> has some extra builtin magic
(see L<perlop>):

 $iter = range_iter("zx", "aab"); # zx, zy, zz, aaa, aab

Infinite list:

 $iter = range_iter(1, Inf); # 1, 2, 3, ...


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 range_iter($start, $end) => coderef


=head1 SEE ALSO

L<Range::ArrayIter>, L<Range::Iterator>

L<Array::Iter>

=cut
