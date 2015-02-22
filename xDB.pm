use DBI;

package xDB;

my $db = undef;
my %statements = 
(
);

sub initialize
{
    eval
    {
        $db = DBI->connect('DBI:mysql:emuseum', 'emuseum_u', '123qwe', {mysql_enable_utf8 => 1})
            or die "Could not connect to database: $DBI::errstr";
    }
    or do
    {
        return 0;
    };
    
    xDB::doPreparedStatements();
    
    return 1;
}

sub doPreparedStatements
{
    $statements{'STMT_VERSION'} = $db->prepare('SELECT `name`,`version` FROM `e_version`');
    $statements{'STMT_RISE_VERSION'} = $db->prepare('UPDATE `e_version` SET `version`=? WHERE `name`=\'Global\'');
    $statements{'STMT_LOGIN'} = $db->prepare('SELECT `id` FROM `e_users` WHERE `username`=? and `password`=?');
    $statements{'STMT_IS_ADMIN'} = $db->prepare('SELECT `id` FROM `e_admins` WHERE `id`=?');
    $statements{'STMT_CHECK_USERNAME'} = $db->prepare('SELECT `id` FROM `e_users` WHERE `username`=?');
    $statements{'STMT_CHECK_EMAIL'} = $db->prepare('SELECT `id` FROM `e_users` WHERE `email`=? ');
    $statements{'STMT_REGISTER'} = $db->prepare('INSERT INTO `e_users` VALUES (NULL,?,?,?)');
    $statements{'STMT_CHECK_OBRA'} = $db->prepare('SELECT `id` FROM `e_obres` WHERE `id`=?');
    $statements{'STMT_CHECK_AUTOR'} = $db->prepare('SELECT `id` FROM `e_autors` WHERE `id`=?');
    $statements{'STMT_CHECK_MUSEU'} = $db->prepare('SELECT `id` FROM `e_museus` WHERE `id`=?');
    $statements{'STMT_COMMENT'} = $db->prepare('INSERT INTO `e_comments` VALUES (NULL,?,?,?,?,?)');
    $statements{'STMT_EDIT_COMMENT'} = $db->prepare('UPDATE `e_comments` SET `comment`=? WHERE `id`=? and `username`=?');
    $statements{'STMT_DELETE_COMMENT'} = $db->prepare('DELETE FROM `e_comments` WHERE `id`=? and `username`=?');
    $statements{'STMT_USER_LAST_COMMENT'} = $db->prepare('SELECT `id` FROM `e_comments` WHERE username=? ORDER BY `id` DESC LIMIT 1');
    $statements{'STMT_GET_COMMENTS'} = $db->prepare('SELECT `id`,`username`,`comment`,`date` FROM `e_comments` WHERE `eid`=? AND `type`=? AND `date`<? ORDER BY `date` DESC LIMIT 10');
    $statements{'STMT_RATE_OBRA'} = $db->prepare('UPDATE `e_obres` SET `valoracio`=(((`valoracio`*`num_valoracions`)+?)/(`num_valoracions` + 1)), `num_valoracions`=`num_valoracions`+1 WHERE `id`=?');
    $statements{'STMT_RATE_AUTOR'} = $db->prepare('UPDATE `e_autors` SET `valoracio`=(((`valoracio`*`num_valoracions`)+?)/(`num_valoracions` + 1)), `num_valoracions`=`num_valoracions`+1 WHERE `id`=?');
    $statements{'STMT_RATE_MUSEU'} = $db->prepare('UPDATE `e_museus` SET `valoracio`=(((`valoracio`*`num_valoracions`)+?)/(`num_valoracions` + 1)), `num_valoracions`=`num_valoracions`+1 WHERE `id`=?');
    $statements{'STMT_GET_RATING_OBRA'} = $db->prepare('SELECT `valoracio` FROM `e_obres` WHERE `id`=?');
    $statements{'STMT_GET_RATING_AUTOR'} = $db->prepare('SELECT `valoracio` FROM `e_autors` WHERE `id`=?');
    $statements{'STMT_GET_RATING_MUSEU'} = $db->prepare('SELECT `valoracio` FROM `e_museus` WHERE `id`=?');
    $statements{'STMT_SET_RECOVERY'} = $db->prepare('UPDATE `e_users` SET `reset_key`=?, `reset_time`=? WHERE `email`=?')
}

sub doQuery
{
    my($query, @parameters) = @_;
    
    if (!exists($statements{$query}))
    {
        return -1;
    }
    
    unless ($db->ping())
    {
        xDB::initialize();
    }
    
    my $sth = $statements{$query};    
    $sth->execute(@parameters);    
    return $sth;
}

sub queryWithReturn
{
    my $sth = xDB::doQuery(@_);
    if ($sth == -1)
    {
        return -1;
    }
    
    my $row = $sth->fetchrow_array();
    $sth->finish();
    return $row;
}

sub queryReturnAll
{
    my $sth = xDB::doQuery(@_);
    if ($sth == -1)
    {
        return -1;
    }
    
    my $rows = $sth->fetchall_arrayref();
    $sth->finish();
    return $rows;
}

sub queryNumber
{
    $sth = xDB::doQuery(@_);
    if ($sth == -1)
    {
        return -1;
    }
    
    my $rows = $sth->rows;
    $sth->finish();
    return $rows;
}

sub deinitialize
{
    if (!defined $db)
    {
        return 1;
    }
    
    eval
    {
        $db->disconnect();
    }
    or do
    {
        return 0;
    };
    
    return 1;
}


1

__END__