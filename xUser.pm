#!/usr/bin/perl

use xDB;
use xSYS;
use xLang;
use TIPUS_ELEMENT;

package xUser;

my %userCache = ();

use constant {
    GUEST_MODE      => 0,
    INACTIVE_MODE   => 1,
    USER_MODE       => 2,
    ADMIN_MODE      => 3,
};

sub new
{
    my $class = shift;
    my $self = {
        id          => 0,
        lang        => shift,
        username    => '',
        permissions => GUEST_MODE,
    };
    
    bless $self, $class;
    return $self;
}

# STATIC
sub authentificate
{
    my $public_key = shift;
    my $lang = shift;
    
    # Is it in cache?
    if (exists $userCache{$public_key})
    {
        return $userCache{$public_key};
    }
    else
    {
        # Is it an AppKey?
        my $version = xSYS::existsAppKey($public_key);
        if ($version > 0)
        {
            # We are in guest mode
            return new xUser($lang);
        }
    }
    
    return undef;
}

sub saveToCache
{
    my($self, $perm) = @_;
    
    my $key = xSYS::genKey();
    $self->{permissions} = $perm;
    $userCache{$key} = $self;
    return $key;
}

sub canCall
{
    my($self, $permission) = @_;
    
    return $self->{permissions} >= $permission;
}

sub getLang
{
    my $self = shift;
    return $self->{lang};
}

sub login
{
    my($self, $username, $password) = @_;
    
    my @user = xDB::queryWithReturn('STMT_LOGIN', $username, $password);
    if (! defined $user[0]) # No rows
    {
        $::errno = 1;
        $::errmsg = xLang::get($self->{lang}, 'USER_ERROR_LOGIN');
        return -1;
    }
    
    $self->{id} = $user[0];
    $self->{username} = $username;
    
    my $isAdmin = xDB::queryNumber('STMT_IS_ADMIN', $user[0]);
    if ($isAdmin > 0)
    {
        return $self->saveToCache(ADMIN_MODE);
    }
    
    return $self->saveToCache(USER_MODE);
}

sub register
{
    my($self, $username, $password, $email) = @_;
    
    my $existeix = xDB::queryNumber('STMT_CHECK_USERNAME', $username);
    if ($existeix > 0)
    {
        $::errno = 1;
        $::errmsg = xLang::get($self->{lang}, 'USER_ERROR_REGISTER_NAME');
        return -1;
    }
    
    $existeix = xDB::queryNumber('STMT_CHECK_EMAIL', $email);
    if ($existeix > 0)
    {
        $::errno = 1;
        $::errmsg = xLang::get($self->{lang}, 'USER_ERROR_REGISTER_EMAIL');
        return -1;
    }

    xDB::doQuery('STMT_REGISTER', $username, $password, $email);
    return $self->saveToCache(USER_MODE);
}

sub comment
{
    my($self, $id, $type, $comment) = @_;
    
    # Trim comment
    $comment =~ s/^\s+//;
    $comment =~ s/\s+$//;
    
    if (length($comment) < 3)
    {
        $::errno = 1;
        $::errmsg = xLang::get($self->{lang}, 'USER_COMMENT_LENGTH_ERROR');
        return 0;
    }
    
    my $existeix = 0;
    if ($type == TIPUS_ELEMENT::TIPUS_OBRA)
    {
        $existeix = xDB::queryNumber('STMT_CHECK_OBRA', $id);
    }
    elsif ($type == TIPUS_ELEMENT::TIPUS_AUTOR)
    {
        $existeix = xDB::queryNumber('STMT_CHECK_AUTOR', $id);
    }
    elsif ($type == TIPUS_ELEMENT::TIPUS_MUSEU)
    {
        $existeix = xDB::queryNumber('STMT_CHECK_MUSEU', $id);
    }
    else
    {
        $::errno = 2;
        $::errmsg = xLang::get($self->{lang}, 'USER_COMMENT_TYPE_ERROR');
        return 0;
    }
    
    if ($existeix <= 0)
    {
        $::errno = 3;
        $::errmsg = xLang::get($self->{lang}, 'USER_COMMENT_NO_ELEMENT');
        return 0;
    }    
    
    xDB::doQuery('STMT_COMMENT', $id, $type, $self->{username}, $comment, time);
    my @c = xDB::queryWithReturn('STMT_USER_LAST_COMMENT', $self->{username});
    
    return $c[0];
}

sub editComment
{
    my($self, $id, $comment) = @_;
    
    # Actualitzem per ID i usuari, per assegurar que ningú intenta borrar coses que no son seves
    xDB::doQuery('STMT_EDIT_COMMENT', $comment, $id, $self->{username});
    
    return 1;
}

sub deleteComment
{
    my($self, $id) = @_;
    
    # Eliminem per ID i usuari, per assegurar que ningú intenta borrar coses que no son seves
    xDB::doQuery('STMT_DELETE_COMMENT', $id, $self->{username});
    
    return 1;
}

sub rate
{
    my($self, $id, $type, $rating) = @_;
    
    if ($rating < 0 or $rating > 5)
    {
        $::errno = 1;
        $::errmsg = xLang::get($self->{lang}, 'USER_RATE_ERROR');
        return 0;
    }
    
    if ($type == TIPUS_ELEMENT::TIPUS_OBRA)
    {
        xDB::doQuery('STMT_RATE_OBRA', $rating, $id);
    }
    elsif ($type == TIPUS_ELEMENT::TIPUS_AUTOR)
    {
        xDB::doQuery('STMT_RATE_AUTOR', $rating, $id);
    }
    elsif ($type == TIPUS_ELEMENT::TIPUS_MUSEU)
    {
        xDB::doQuery('STMT_RATE_MUSEU', $rating, $id);
    }
    else
    {
        $::errno = 2;
        $::errmsg = xLang::get($self->{lang}, 'USER_COMMENT_TYPE_ERROR');
        return 0;
    }
    
    return xSYS::getRating($id, $type);
}

sub recover
{
    my ($self, $email) = @_;
    
    if (xDB::queryNumber('STMT_CHECK_EMAIL', $email) <= 0)
    {
        $::errno = 1;
        $::errmsg = xLang::get($self->{lang}, 'USER_RECOVER_ERROR');
        return 0;
    }
    
    my $key = xSYS::genKey();
    xDB::doQuery('STMT_SET_RECOVERY', $key, time, $email);
    
    $from = 'recovery@vps53673.ovh.net';
    $subject = xLang::get($self->{lang}, 'USER_RECOVER_PASSWORD');
    $link = xSYS::getWebsite() . "web/pass/recupass.php?codi=" . $key;
    $message = xLang::get($self->{lang}, 'USER_RECOVER_PASSWORD_MSG');
    $message =~ s/%LINK%/$link/g;
    
    open(my $mail, "|/usr/sbin/sendmail -t");
 
    # Email Header
    print $mail "To: $email\n";
    print $mail "From: eMuseum <$from>\n";
    print $mail "Subject: $subject\n";
    print $mail "Content-type: text/html\n\n";
    # Email Body
    print $mail $message;
    
    close($mail);
    
    return 1;
}

1

__END__
