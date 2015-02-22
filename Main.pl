#!/usr/bin/perl

no warnings;

use strict;
use utf8;
use warnings;
use open qw( :encoding(UTF-8) :std );
use feature qw< unicode_strings >;

use JSON;
use Time::HiRes qw(usleep);
use IO::Socket::INET;
use IO::Select;

use xLang;
use xUser;
use xSYS;
use xResponse;

$| = 1;
our $errno = 0;
our $errmsg = 0;

my $SERVER_DEBUG = 1;

{
    my $daemonStop = 0;

    my %callbacks = (
        'RequestKey' => {
            Permission => xUser::GUEST_MODE,
            Function => sub {
                my($client, %args) = @_;
                return xSYS::newRequestKey($client);
            }
        },
        
        'Login' => {
            Permission => xUser::GUEST_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'Username'} or !exists $args{'Password'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $username = $args{'Username'};
                my $password = $args{'Password'};
            
                return $client->login($username, $password);
            }
        },
        
        'Register' => {
            Permission => xUser::GUEST_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'Username'} or !exists $args{'Password'} or !exists $args{'Email'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $username = $args{'Username'};
                my $password = $args{'Password'};
                my $email = $args{'Email'};
                
                return $client->register($username, $password, $email);
            }
        },
        
        'CheckVersion' => {
            Permission => xUser::GUEST_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'Version'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $version = $args{'Version'};
                
                return xSYS::checkGlobalVersion($version);
            }
        },
        
        'GetDBURL' => {
            Permission => xUser::GUEST_MODE,
            Function => sub {
                my($client, %args) = @_;
                return xSYS::getDBURL();
            }
        },
        
        'Comment' => {
            Permission => xUser::USER_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'ID'} or !exists $args{'Type'} or !exists $args{'Comment'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $id = $args{'ID'};
                my $type = $args{'Type'};
                my $comment = $args{'Comment'};
                
                return $client->comment($id, $type, $comment);
            }
        },
        
        'GetComments' => {
            Permission => xUser::GUEST_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'ID'} or !exists $args{'Type'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                
                my $id = $args{'ID'};
                my $type = $args{'Type'};
                my $from = time;
                if (exists $args{'From'})
                {
                    $from = $args{'From'};
                }
                
                return xSYS::getComments($id, $type, $from);
            }
        },
        
        'EditComment' => {
            Permission => xUser::USER_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'ID'} or !exists $args{'Comment'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $id = $args{'ID'};
                my $comment = $args{'Comment'};
                
                return $client->editComment($id, $comment);
            }
        },
        
        'DeleteComment' => {
            Permission => xUser::USER_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'ID'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $id = $args{'ID'};
                
                return $client->deleteComment($id);
            }
        },
        
        'Rate' => {
            Permission => xUser::USER_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'ID'} or !exists $args{'Type'} or !exists $args{'Rating'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $id = $args{'ID'};
                my $type = $args{'Type'};
                my $rating = $args{'Rating'};
                
                return $client->rate($id, $type, $rating);
            }
        },
        
        'GetRating' => {
            Permission => xUser::GUEST_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'ID'} or !exists $args{'Type'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $id = $args{'ID'};
                my $type = $args{'Type'};
                
                return xSYS::getRating($id, $type);
            }
        },
        
        'NewVersion' => {
            Permission => xUser::ADMIN_MODE,
            Function => sub {
                my($client, %args) = @_;               
                return xSYS::generateNewVersion();
            }
        },
        
        'Recover' => {
            Permission => xUser::GUEST_MODE,
            Function => sub {
                my($client, %args) = @_;
                
                if (!exists $args{'Email'})
                {
                    $::errno = 1;
                    $::errmsg = xLang::get($client->getLang(), 'ERROR_ARGUMENTS');
                    return '-8';
                }
                
                my $email = $args{'Email'};
                
                return $client->recover($email);
            }
        },
    );
    
    my $socket = undef;

    local $SIG{PIPE} = 'sockconnect';

    print "---------------------------------------\n";
    print "--- SERVIDOR API D'EMUSEUM (PIS_12) ---\n";
    print "---------------------------------------\n\n";
    
    print "[*] Iniciant servidor\n";
    
    # Set the socket to listening
    {
        $socket = new IO::Socket::INET (
            LocalHost => '0.0.0.0',
            LocalPort => '8000',
            Proto => 'tcp',
            Listen => 5,
            Reuse => 1,
            ReuseAddr => 1
        )
        or die "\t[FAIL] No es pot crear el socket : $!\n";
    }
    
    print "\t[OK] Iniciat\n";
    
    my $select = IO::Select->new($socket) or die "\t[FAIL] No es pot crear el selector: $!";
    
    print "\n[*] Inicialitzant idiomes\n";
    if (!xLang::initialize())
    {
        print "\t[FAIL] Error inesperat\n";
    }
    xLang::setDefault('ENG');
    
    print "\n[*] Connectant a DB\n";
    if (xDB::initialize())
    {
        print "\t[OK] Connectat\n";
    }
    else
    {
        print "\t[FAIL] Error de connexio\n";
    }
    
    print "\n[*] Inicialitzant serveis critics\n";
    if (xSYS::initialize())
    {
        print "\t[OK] Iniciats\n";
    }
    else
    {
        print "\t[FAIL] Error inesperat\n";
    }
    
    print "\n\n> Servidor iniciat\n\n";
    while (!$daemonStop)
    {
        my @ready_clients = $select->can_read(0);
        foreach my $rc (@ready_clients)
        {
            if($rc == $socket)
            {
                my $new = $socket->accept();
                $select->add($new);
            }
            else
            {
                my $read = $rc->sysread(my $data, 1024);

                if ($read)
                {
                    parseRecv($data, $rc);
                }
                else
                {
                    closeSocket($select, $rc);
                }
            }
        }

        usleep(250000);
    }
    
    print "\n[*] Desconnectant de DB\n";
    if (xDB::deinitialize())
    {
        print "\t[OK] Desconnectat\n";
    }
    else
    {
        print "\t[FAIL] Error de desconnexio\n";
    }
    
    print "\n\n> Servidor desconnectat\n\n";
    
    exit 0;

    sub parseRecv
    {
        my($data, $socket) = @_;

        
        my $packet = undef;
        
        eval
        {
            $packet = JSON->new->utf8->decode($data);
        }
        or do
        {
            my $response = new xResponse('1', '-1', 'Incorrect JSON format');
            $response->send($socket);
            return closeSocket($select, $socket);
        };
        
        unless (exists $packet->{'Auth'})
        {
            my $response = new xResponse('1', '-2', 'Invalid packet header, no Auth');
            $response->send($socket);
            return closeSocket($select, $socket);
        }
        
        my $lang = '';
        if (exists $packet->{'Auth'}{'Language'})
        {
            $lang = $packet->{'Auth'}{'Language'};
        }
        $lang = xLang::isValid($lang);
        
        unless (exists $packet->{'Call'})
        {
            my $response = new xResponse('1', '-3', xLang::get($lang, 'ERROR_BODY'));
            $response->send($socket);
            return closeSocket($select, $socket);
        }
        
        my $function = $packet->{'Call'}{'Function'};
        unless (defined($callbacks{$function}))
        {
            my $response = new xResponse('1', '-4', xLang::get($lang, 'ERROR_FUNCTION'));
            $response->send($socket);
            return closeSocket($select, $socket);
        }
       
        my $client = 0;
        my $key = $packet->{'Auth'}{'PublicKey'};
        if($function =~ m/^RequestKey$/i)
        {
            $client = xUser::authentificate($key, $lang);
            if (!defined $client)
            {
                my $response = new xResponse('1', '-5', xLang::get($lang, 'ERROR_AUTH'));
                $response->send($socket);
                return closeSocket($select, $socket);
            }
        }
        else
        {
            $client = xSYS::useRequestKey($key);
            if (!defined $client)
            {
                my $response = new xResponse('1', '-6', xLang::get($lang, 'ERROR_KEY'));
                $response->send($socket);
                return closeSocket($select, $socket);
            }
            
            if (!$client->canCall($callbacks{$function}{Permission}))
            {
                my $response = new xResponse('1', '-7', xLang::get($lang, 'ERROR_PERMISSION'));
                $response->send($socket);
                return closeSocket($select, $socket);
            }
        }

        $::errno = 0;
        $::errmsg = '';
        
        my %args = ();
        if (exists $packet->{'Call'}{'Arguments'})
        {
            %args = %{+$packet->{'Call'}{'Arguments'}};
        }
        
        my $result = $callbacks{$function}{Function}->($client, %args);
        
        if (defined $SERVER_DEBUG && $::errno != 0)
        {
            print "[EXCEPTION] Found exception " .$::errno . " on packet:\n";
            print "\t" . $data . "\n";
            print "\tWith details:\n";
            print "\t\t" . $::errmsg . "\n";
            print "\t\tAnd response:\n";
            print "\t\t" . $result . "\n\n";
        }
        
        my $response = new xResponse(int($::errno != 0), $result, $::errmsg);
        $response->send($socket);
        closeSocket($select, $socket);
    }
}

sub closeSocket
{
    my($select, $socket) = @_;

    $select->remove($socket);
    $socket->close;
};


__END__
