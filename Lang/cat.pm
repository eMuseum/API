#!/usr/bin/perl

package Lang::ca;

$::language{'CAT'} = {
    'ERROR_JSON'        => 'Error en el format JSON',
    'ERROR_HEADER'      => 'El paquet no t� cap�alera (Auth)',
    'ERROR_BODY'        => 'El paquet no t� cos (Call)',
    'ERROR_FUNCTION'    => 'La funci� no existeix',
    'ERROR_AUTH'        => 'No es pot autentificar',
    'ERROR_KEY'         => 'Clau p�blica no v�lida',
    'ERROR_PERMISSION'  => 'Permissos insuficients',
    'ERROR_ARGUMENTS'   => 'Arguments incorrectes',
    
    'USER_ERROR_LOGIN'  => 'Convinaci� usuari/contrasenya no trobada',
    'USER_ERROR_REGISTER_NAME'  => 'Nom d\'usuari ja en �s',
    'USER_ERROR_REGISTER_EMAIL' => 'Email ja en �s',
    'USER_COMMENT_LENGTH_ERROR' => 'Comentari massa curt',
    'USER_COMMENT_TYPE_ERROR'   => 'Tipus d\'element inv�lid',
    'USER_COMMENT_NO_ELEMENT'   => 'No s\'ha trobat cap element',
    'USER_RATE_ERROR'           => 'Valoraci� inv�lida',
    
    'USER_RECOVER_ERROR'        => 'No hi ha cap usuari amb aquest email',
    'USER_RECOVER_PASSWORD'     => 'eMuseum: Recuperar contrasenya',
    'USER_RECOVER_PASSWORD_MSG' => 'Aquest email li ha estat enviat per recuperar la contrasenya perduda.<br />
        Si no ha demanat un canvi de contrasenya, pot ignorar aquest missatge. <br /><b />
        D\'altra banda pot accedir al seg�ent enlla�:<br />
            <a href="%LINK%">Recuperar contrasenya</a><br />
        Si no veu l\'enlla�, copi aquesta direcci� en la camp d\'URL del teu navegador.<br />
        %LINK%
        <br /><br />
        All� podr� establir una nova contrasenya.'
};

print "\t[OK] Carregat catal�\n";

1

__END__
