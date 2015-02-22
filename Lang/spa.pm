#!/usr/bin/perl

package Lang::es;

$::language{'SPA'} = {
    'ERROR_JSON'        => 'Error en el formato JSON',
    'ERROR_HEADER'      => 'El paquete no tiene cabecera (Auth)',
    'ERROR_BODY'        => 'El paquete no tiene cuerpo (Call)',
    'ERROR_FUNCTION'    => 'La función no existe',
    'ERROR_AUTH'        => 'No se puede autentificar',
    'ERROR_KEY'         => 'Llave pública no válida',
    'ERROR_PERMISSION'  => 'Permisos insuficientes',
    'ERROR_ARGUMENTS'   => 'Argumentos incorrectos',
    
    'USER_ERROR_LOGIN'  => 'Combinación usuario/contraseña no encontrada',
    'USER_ERROR_REGISTER_NAME'  => 'Nombre de usuari ya en uso',
    'USER_ERROR_REGISTER_EMAIL' => 'Email ya en uso',
    'USER_COMMENT_LENGTH_ERROR' => 'Comentario demasiado corto',
    'USER_COMMENT_TYPE_ERROR'   => 'Tipo de elemento no válido',
    'USER_COMMENT_NO_ELEMENT'   => 'No se ha encontrado ningún elemento',
    'USER_RATE_ERROR'           => 'Valoración inválida',
    
    'USER_RECOVER_ERROR'        => 'No hay ningún usuario con este email',
    'USER_RECOVER_PASSWORD'     => 'eMuseum: Recuperar contraseña',
    'USER_RECOVER_PASSWORD_MSG' => 'Este email le ha sido enviado para recuperar la contraseña perdida.<br />
        Si no ha pedido un cambio de contraseña, puede ignorar este mensaje. <br /><b />
        Sino, puede acceder al siguiente enlace:<br />
            <a href="%LINK%">Recuperar contraseña</a><br />
        Si no ve el enlace, copie esta dirección en el campo URL de su navegador.<br />
        %LINK%
        <br /><br />
        Allí podrá establecer una nueva contraseña.'
};

print "\t[OK] Carregat castellà\n";

1

__END__
