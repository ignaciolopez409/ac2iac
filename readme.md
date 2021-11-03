**AC2IaC**

En el repositorio se encuentra la definición de la infraestructura solicitada para la tarea.

* En el archivo main.tf ubicado en la raíz del repositorio se detalla la creacíón de los recursos solicitados, VPC, IGW,  subredes, tablas de ruteo y sus correspondientes asociaciones, security groups, instancias. Las instancias están definidas como módulos.

  * Se creó un security group que permite el acceso http para validaciones y ssh para realizar las configuraciones mediante terraform remote-exec (este SG se debería eliminar en un ambiente productivo).
  * Cada instancia tiene asociado un security grup el cual permite solamente el acceso y salida solicitado en la tarea
    * Frontend: Acceso TCP público puerto 80, salida por puerto 8080 a subred de Backend.
    * Backend: Acceso TCP puerto 80, salida puerto 27017 a subred de base de datos.
    * Database: Acceso TCP puerto 27017

En cada instancia se configuró un servidor web para validar que estan correctos los accesos (no requerido pero sugerencia de Mauricio)

La infraestructura implementada simula un servidor Apache en la instancia frontend, una instancia backend donde se ejecutaría la aplicación y una base de datos MongoDB interactuando con el backend de la aplicación. 