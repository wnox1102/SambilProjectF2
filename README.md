SambilProject
Proyecto de administracion de base de datos

Para comenzar el proyecto debe instalar las siguientes librerias de python Django

#-----------------------------------------------------------------------------------------------------------------------------------------#

Windows 
  NOTA: Antes de correr el proyecto debe configurar las variables de la base de datos para realizar una conexion segura
  
1)  pip install django

2)  Luego que se instale la libreria se procede a correr el proyecto:

3)  python manage.py makemigrations ( para guardar los cambios realizados en la base de datos )

4)  python manage.py migrate ( para crear las tablas en la base de datos )

5)  python manage.py createsuperuser ( crear un usuario para loggearte y ver la pagina administrativa del proyecto "opcional" )

6) Irse a la carpeta Sambil en el archivo settings buscar vector con el nombre DATABASES y modificar las variables de entorno con su usuario y contresena de postgres

7) configurar dichas variables que hacen llamados con psycopg2 en los archivos view.py que se encuentra en la carpeta models , se cambian igual el usuario y contresena, como tambien realizar dichos cambios en el pub.py y en el sub.py 

8)  python3.6 manage.py runserver localhost:puerto ( Comando para correr el proyecto, ejemplo python3.6 manage.py runserver localhost:8000)

#----------------------------------------------------------------------------------------------------------------------------------------#

Linux ( Ubuntu ):

1)  sudo apt update

2)  sudo apt install python3-django

3)  django-admin --version ------> output 1.11.11 u otras versionas mas recientes

4)  sudo apt install python3-pip

5)  pip install django

6)  python manage.py makemigrations ( para guardar los cambios realizados en la base de datos )

7)  python manage.py migrate ( para crear las tablas en la base de datos )

8)  python manage.py createsuperuser ( crear un usuario para loggearte y ver la pagina administrativa del proyecto "opcional" )

9)  python manage.py runserver localhost:puerto ( Comando para correr el proyecto, ejemplo python3.6 manage.py runserver localhost:8000)
