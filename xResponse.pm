use Encode;
use JSON;

package xResponse;
sub new
{
    my $class = shift;
    my $self = {
        HasErrors   => shift,
        Return      => shift,
        Message     => shift,
    };
    
    bless $self, $class;
    return $self;
}

sub TO_JSON { return { %{ shift() } }; }

sub set
{
    my($self, $errors, $return, $message) = @_;
    
    $self->{HasErrors} = $errors;
    $self->{Return} = $return;
    $self->{Message} = $message;
}


sub send
{
    my($self, $socket) = @_;
    
    my $JSON = JSON->new->utf8(0);
    $JSON->convert_blessed(1);

    my $json = $JSON->encode($self);
    
    return $socket->send($json) > 0;
}

1;

__END__

