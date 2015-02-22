#!/usr/bin/perl

package Lang::ca;

$::language{'CAT'} = {
    'ERROR_JSON'        => 'Error en el format JSON',
    'ERROR_HEADER'      => 'El paquet no té capçalera (Auth)',
    'ERROR_BODY'        => 'El paquet no té cos (Call)',
    'ERROR_FUNCTION'    => 'La funció no existeix',
    'ERROR_AUTH'        => 'No es pot autentificar',
    'ERROR_KEY'         => 'Clau pública no vàlida',
    'ERROR_PERMISSION'  => 'Permissos insuficients',
    'ERROR_ARGUMENTS'   => 'Arguments incorrectes',
    
    'USER_ERROR_LOGIN'  => 'Convinació usuari/contrasenya no trobada',
    'USER_ERROR_REGISTER_NAME'  => 'Nom d\'usuari ja en ús',
    'USER_ERROR_REGISTER_EMAIL' => 'Email ja en ús',
    'USER_COMMENT_LENGTH_ERROR' => 'Comentari massa curt',
    'USER_COMMENT_TYPE_ERROR'   => 'Tipus d\'element invàlid',
    'USER_COMMENT_NO_ELEMENT'   => 'No s\'ha trobat cap element',
    'USER_RATE_ERROR'           => 'Valoració invàlida',
    
    'USER_RECOVER_ERROR'        => 'No hi ha cap usuari amb aquest email',
    'USER_RECOVER_PASSWORD'     => 'eMuseum: Recuperar contrasenya',
    'USER_RECOVER_PASSWORD_MSG' => 'Aquest email li ha estat enviat per recuperar la contrasenya perduda.<br />
        Si no ha demanat un canvi de contrasenya, pot ignorar aquest missatge. <br /><b />
        D\'altra banda pot accedir al següent enllaç:<br />
            <a href="%LINK%">Recuperar contrasenya</a><br />
        Si no veu l\'enllaç, copi aquesta direcció en la camp d\'URL del teu navegador.<br />
        %LINK%
        <br /><br />
        Allí podrà establir una nova contrasenya.'
};

print "\t[OK] Carregat català\n";

1

__END__
