use Encode;
use JSON;

package xComment;
sub new
{
    my $class = shift;
    my $self = {
        ID          => shift,
        Username    => shift,
        Comment     => shift,
        Date        => shift,
    };
    
    bless $self, $class;
    return $self;
}

sub TO_JSON { return { %{ shift() } }; }

sub get
{
    my($self) = @_;
    
    my $JSON = JSON->new->utf8;
    $JSON->convert_blessed(1);

    my $json = $JSON->encode($self);
    
    return $json;
}

1;

__END__

