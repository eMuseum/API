#!/usr/bin/perl

package Lang::en;

$::language{'ENG'} = {
    'ERROR_JSON'        => 'Incorrect JSON format',
    'ERROR_HEADER'      => 'Invalid packet header (Auth)',
    'ERROR_BODY'        => 'Invalid packet body (Call)',
    'ERROR_FUNCTION'    => 'Function does not exist',
    'ERROR_AUTH'        => 'Can not authenticate',
    'ERROR_KEY'         => 'Invalid public key',
    'ERROR_PERMISSION'  => 'Not enough permissions',
    'ERROR_ARGUMENTS'   => 'Incorrect arguments',
    
    'USER_ERROR_LOGIN'  => 'Username/password not found',
    'USER_ERROR_REGISTER_NAME'  => 'Username already used',
    'USER_ERROR_REGISTER_EMAIL' => 'Email already used',
    'USER_COMMENT_LENGTH_ERROR' => 'Comment is too short',
    'USER_COMMENT_TYPE_ERROR'   => 'Element type is not valid',
    'USER_COMMENT_NO_ELEMENT'   => 'No element has been found',
    'USER_RATE_ERROR'           => 'Invalid rating',
    
    'USER_RECOVER_ERROR'        => 'There is no user with this email',
    'USER_RECOVER_PASSWORD'     => 'eMuseum: Password recovery',
    'USER_RECOVER_PASSWORD_MSG' => 'This email has ben sent to recover a lost password. <br />
        If you haven\'t requested a password change this message can be discarted. <br /><b />
        Otherwise, you may follow this link to change your account\'s password:<br />
            <a href="%LINK%">Recover Password</a><br />
        If you can not see the link, copy this URL to your navigator URL field.<br />
        %LINK%<br /><br />        
        There you will be able to change your password.'
};

print "\t[OK] Carregat anglès\n";

1

__END__
