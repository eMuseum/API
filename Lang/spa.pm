#!/usr/bin/perl

package Lang::es;

$::language{'SPA'} = {
    'ERROR_JSON'        => 'Error en el formato JSON',
    'ERROR_HEADER'      => 'El paquete no tiene cabecera (Auth)',
    'ERROR_BODY'        => 'El paquete no tiene cuerpo (Call)',
    'ERROR_FUNCTION'    => 'La funci�n no existe',
    'ERROR_AUTH'        => 'No se puede autentificar',
    'ERROR_KEY'         => 'Llave p�blica no v�lida',
    'ERROR_PERMISSION'  => 'Permisos insuficientes',
    'ERROR_ARGUMENTS'   => 'Argumentos incorrectos',
    
    'USER_ERROR_LOGIN'  => 'Combinaci�n usuario/contrase�a no encontrada',
    'USER_ERROR_REGISTER_NAME'  => 'Nombre de usuari ya en uso',
    'USER_ERROR_REGISTER_EMAIL' => 'Email ya en uso',
    'USER_COMMENT_LENGTH_ERROR' => 'Comentario demasiado corto',
    'USER_COMMENT_TYPE_ERROR'   => 'Tipo de elemento no v�lido',
    'USER_COMMENT_NO_ELEMENT'   => 'No se ha encontrado ning�n elemento',
    'USER_RATE_ERROR'           => 'Valoraci�n inv�lida',
    
    'USER_RECOVER_ERROR'        => 'No hay ning�n usuario con este email',
    'USER_RECOVER_PASSWORD'     => 'eMuseum: Recuperar contrase�a',
    'USER_RECOVER_PASSWORD_MSG' => 'Este email le ha sido enviado para recuperar la contrase�a perdida.<br />
        Si no ha pedido un cambio de contrase�a, puede ignorar este mensaje. <br /><b />
        Sino, puede acceder al siguiente enlace:<br />
            <a href="%LINK%">Recuperar contrase�a</a><br />
        Si no ve el enlace, copie esta direcci�n en el campo URL de su navegador.<br />
        %LINK%
        <br /><br />
        All� podr� establecer una nueva contrase�a.'
};

print "\t[OK] Carregat castell�\n";

1

__END__
