#!/usr/bin/perl

use Data::UUID;
use xComment;
use TIPUS_ELEMENT;


package xSYS;


my $ug = new Data::UUID;
my %requestKeys = ();
my $publicIP = 0;
my $nginxSitePath = '';
my $APIVersion = 0;
my $globalVersion = 0;

my %applicationKeys = (
    'c740f63ca8184204a983dfee6dbd807f35118975d9e346aaa6032306cec0e254' => 001, #0.01
);

sub initialize
{
    # Obtenir variables
    $publicIP = `ip addr | awk '/inet / {sub(/\\/.*/, "", \$2); print \$2}' | tail -1`;
    $nginxSitePath = `cat /etc/nginx/sites-available/emuseum | awk '/root / { print \$2 }' | head -1`;
    
    # Borrat espais, salts de linia, el que sigui
    $publicIP =~ s/\s+$//;
    $nginxSitePath =~ s/;\s+$//;
    
    my $version = xDB::queryReturnAll('STMT_VERSION');
    if (scalar @{ $version } == 0) # No rows
    {
        return 0;
    }
    
    foreach my $row (@{ $version })
    {
        if ($row->[0] eq 'API')
        {
            $APIVersion = $row->[1];
        }
        elsif ($row->[0] eq 'Global')
        {
            $globalVersion = $row->[1];
        }
    }
    
    return $publicIP != 0 && $nginxSitePath ne '' && $APIVersion != 0 && $globalVersion != 0;
}

sub getWebsite
{
    return 'http://' . $publicIP . '/';
}

sub genKey
{
    return substr($ug->create_hex(), 2) . substr($ug->create_hex(), 2);
}

sub newRequestKey
{
    my $client = shift;
    my $key = xSYS::genKey();
    $requestKeys{$key} = $client;
    return $key;
}

sub useRequestKey
{
    my $key = shift;
    
    if (exists $requestKeys{$key})
    {
        my $client = $requestKeys{$key};
        delete $requestKeys{$key};
        return $client;
    }
    
    return undef;
}

sub existsAppKey
{
    my $key = shift;
    if (!exists $applicationKeys{$key})
    {
        return 0;
    }
    
    return $applicationKeys{$key};
}

sub checkGlobalVersion
{
    my $version = shift;
    if ($version != $globalVersion)
    {
        return 0;
    }
       
    return 1;
}

sub getDBURL()
{
     return 'http://' . $publicIP . '/data/emuseum-' . $globalVersion . '.db'
}

sub getComments
{
    my($id, $type, $from) = @_;
    
    my $comments = xDB::queryReturnAll('STMT_GET_COMMENTS', $id, $type, $from);
    if (scalar @{ $comments } == 0) # No rows
    {
        return '{}';
    }
    
    my $json = '';
    foreach my $comment (@{ $comments })
    {
        if (length($json) > 0)
        {
            $json .= ',';
        }
        my $comment = new xComment($comment->[0], $comment->[1], $comment->[2], $comment->[3]);
        $json .= $comment->get();
    }
    
    return '[' . $json . ']';
}

sub getRating
{
    my($id, $type) = @_;
    
    if ($type == TIPUS_ELEMENT::TIPUS_OBRA)
    {
        my @r = xDB::queryWithReturn('STMT_GET_RATING_OBRA', $id);
        return $r[0];
    }
    elsif ($type == TIPUS_ELEMENT::TIPUS_AUTOR)
    {
        my @r = xDB::queryWithReturn('STMT_GET_RATING_AUTOR', $id);
        return $r[0];
    }
    elsif ($type == TIPUS_ELEMENT::TIPUS_MUSEU)
    {
        my @r = xDB::queryWithReturn('STMT_GET_RATING_MUSEU', $id);
        return $r[0];
    }
    else
    {
        $::errno = 2;
        $::errmsg = xLang::get($self->{lang}, 'USER_COMMENT_TYPE_ERROR');
        return 0;
    }
    
    return 0;
}

sub generateNewVersion
{
    # Nova versió
    my $newVersion = $globalVersion + 1;
    my $dbName = 'emuseum-' . $newVersion . '.db';
    
    # Guardar en DB el número de la nova versió
    xDB::doQuery('STMT_RISE_VERSION', $newVersion);
    
    # Generar la nova db en sqlite
    `./mysql2sqlite.sh -u emuseum_u -p123qwe emuseum e_version e_museus e_autors e_obres | sed 's/ collate utf8_unicode_ci/ /gI' | sqlite3 $dbName`;
    
    # Moure a la carpeta corresponent
    `mv $dbName $nginxSitePath/data/`;
    
    # Agugmentar la versió
    $globalVersion++;
}

1

__END__
