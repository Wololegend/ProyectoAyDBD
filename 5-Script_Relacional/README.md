# **PROYECTO: Servicio de subscripción de Indev**
## **Autores:**
* Jaime Simeón Palomar Blumenthal - ALU0101228587
* Alberto Cruz Luis - ALU0101217734
* Cristo García González - ALU0101204512
* Antonella Sofía García Álvarez - ALU0101227610

### **Índice**

1. [Tablas para almacenar **Usuarios**](#usuarios)
2. [Tablas para almacenar **Videojuegos**](#videojuegos)
3. [**Categorías** de videojuegos](#categorias)
4. [Los usuarios **filtran** por categorías](#filtran)
5. [Los videojuegos **pertenecen** a categorías](#pertenecen)
6. [**Copias físicas** de videojuegos](#cpfisicas)
7. [Los usuarios Básicos **juegan** a videojuegos](#juegabasico)
8. [Los usuarios No Básicos **juegan** a videojuegos](#jueganobasico)
9. [Los usuarios No Básicos **juegan a videojuegos online** entre ellos](#juegaonline)
10. [Comprobar la inserción en **Basico y No_Basico**](#checkbasicoinsert)
11. [Comprobar la inserción en **Externo y De_Indev**](#checkexternoinsert)
11. [Comprobar la inserción en Copia_Fisica](#checkcpfinsert)
11. [Comprobar la inserción en Juega1 y Juega2](#checkjuega1insert)
11. [Actualizar la cuenta de títulos por categoría](#checkcategoriainsert)


### **Tablas para almacenar Usuarios** <a name="usuarios"/>
Existen tres tablas que definen una relación IS_A entre los usuarios totales, los básicos, los _Deluxe_ y los _Premium_.

La tabla _Usuario_ contiene todos los datos de todos los usuarios:

![Usuarios](img/2022-01-30-10-12-53.png)

![Select_Usuario](img/2022-01-30-11-47-32.png)


Los nombres de usuarios han de ser únicos, de ahí la restricción _UNIQUE_.

Por su parte, la tabla **Basico** contiene los datos de los usuarios básicos, y la tabla **No_Basicos** la de los usuarios No Básicos, que a su vez pueden ser _Deluxe_ o _Premium_. Est último se restringe mediante la sentencia _CHECK_.

![Basicos/No_Basicos](img/2022-01-30-10-14-15.png)

![Select_Basico](img/2022-01-30-11-48-00.png)

![Select_NoBasico](img/2022-01-30-11-48-28.png)


### **Tablas para almacenar Videojuegos** <a name="videojuegos"/>
Al igual que con los usuarios, existen tres tablas que definen una relación IS_A entre los videojuegos totales, los externos, los internos de reciente lanzamiento, y los internos de NO reciente lanzamiento.

La tabla _Videojuego_ contiene todos los datos de todos los videojuuegos:

![Videojuegos](img/2022-01-30-10-20-48.png)

![Select_Videojuego](img/2022-01-30-11-50-51.png)

El PEGI de un videojuego es la edad mínima recomendada para jugarlo. Es una normativa europea y define 5 estándares PEGI: 3, 7, 12, 16 y 18 años. De ahí que se limite el atributo PEGI a estos cinco valores mediante la restricción _CHECK_.

Además, la fecha de publicación del título especificada en el atributo año tiene que ser posterior a 1950 y anterior al día actual.

Por otro lado, la tabla **Externo** contiene los videojuegos no desarrollados por la empresa que ofrece el servicio de subscripción, por lo que se añade el atributo _Desarrolladora_.

![Externo](img/2022-01-30-10-25-24.png)

![Select_Externo](img/2022-01-30-11-51-22.png)

Además, los videojuegos desarrollados por la empresa que ofrece el servicio de subscripción (en adelante **_InDev_**) se almacenan en la tabla **De_Indev**. Como pueden ser _Recientes_ o _No Recientes_ respecto a su fecha de lanzamiento, se añade el atributo _Tipo_ y se limita su dominio a estos dos valores.

![De_Indev](img/2022-01-30-10-28-52.png)

![Select_DeIndev](img/2022-01-30-11-52-04.png)


### **Categorías de videojuegos** <a name="categorias"/>
Los videojuegos se organizan por categorías según los géneros a los que pertenezcan (_Shooter_, _Estrategia_, etc). Además, de cada categoría nos interesa guardar cuántos títulos hay en ella.

![Categoria](img/2022-01-30-10-33-17.png)

![Select_Categoria](img/2022-01-30-11-52-48.png)


### **Los usuarios filtran por categorías** <a name="filtran"/>
El servicio dispondrá de una barra de búsqueda con filtros por categorías para facilitar la navegación de los usuarios, y por fines estadísticos y para mejorar las recomendaciones se pretende guardar un histórico con las búsquedas de cada usuario. Por esto debemos disponer de una tabla **Filtra** que relacione al usuario con la categoría que buscó y en qué día.

![Filtra](img/2022-01-30-10-44-19.png)

![Select_Filtra](img/2022-01-30-11-54-55.png)


### **Los videojuegos pertenecen a categorías** <a name="pertenecen"/>
Cada videojuego puede tener varios géneros, y cada categoría puede tener muchos títulos diferentes. Por eso, la relación muchos a muchos entre **Videojuego** y **Categoria** se representa mediante la tabla **Pertenece**.

![Pertenece](img/2022-01-30-10-48-36.png)

![Select_Pertenece](img/2022-01-30-11-55-37.png)


### **Copias físicas de videojuegos** <a name="cpfisicas"/>
Sólamente los usuarios No Básicos con tipo _Deluxe_ reciben copias físicas de algunos videjouegos (la comprobación del tipo se implementa más adelante mediante un trigger), por lo que se almacenan e identifican por un serial.

![Copia_Fisica](img/2022-01-30-11-11-35.png)

![Select_CpFisica](img/2022-01-30-11-54-06.png)

La clave ajena (Distribuidora, Nombre_Videojuego, Año) crea una relación de uno a muchos entre **Videojuego** y **Copia_Fisica**,  dado que una copia física sólo puede venir de un videojuego, pero un videojuego sí puede tener varias copias físicas.

La clave ajena (Email_NoBasico) crea una relación de uno a muchos entre **No_Basico** y **Copia_Fisica**, dado que una copia física sólo puede ser enviada a un usuario No Básico, pero un usuario No Básico puede recibir varias copias físicas.


### **Los usuarios Básicos juegan a videojuegos** <a name="juegabasico"/>
Los usuarios Básicos eligen entre jugar exclusivamente a juegos Externos o De Indev al jugar a su primer título. Esto es representado mediante las tablas **Juega1** y **Juega2**. En ambas sólo pueden entrar usuarios Básicos, en **Juega1** sólo pueden insertarse videojuegos Externos y en **Juega2** sólo juegos De Indev de tipo _Reciente_. Todas estas comprobaciones se realizan mediante un trigger que se explicará más adelante.

![Juega1](img/2022-01-30-11-31-39.png)

![Juega2](img/2022-01-30-11-31-56.png)

![Select_Juega1](img/2022-01-30-11-56-10.png)

![Select_Juega2](img/2022-01-30-11-56-45.png)


### **Los usuarios No Básicos juegan a videojuegos** <a name="jueganobasico"/>
Los usuarios Nos Básicos pueden jugar a cualquier videojuego sin restricciones. Esta relación muchos a muchos se representa mediante la tabla **Juega3**:

![Juega3](img/2022-01-30-11-37-48.png)

![Select_Juega3](img/2022-01-30-11-57-21.png)


### **Los usuarios **No Básicos** juegan a videojuegos online entre ellos** <a name="juegaonline"/>
Los usuarios No Básicos disponen de servidores dedicados para fomentar el juego online. Al ser usuarios de la tabla **No_Basico** los que juegan entre ellos a videojuegos de la tabla **Videojuegos** se considera una relación terciaria, representada por la tabla **Juega_Online**.

![Juega_Online](img/2022-01-30-11-44-35.png)

![Select_JuegaOnline](img/2022-01-30-11-58-06.png)

Podemos observar como existen dos claves ajenas que referncian a **No_Basico** y una que referencia a **Videojuego**.


### **Comprobar la inserción en Basico y No_Basico** <a name="checkbasicoinsert"/>
En el modelo, en ambas relaciones IS_A las subtablas no pueden compartir entradas entre ellas. Esto se comprueba mediante los trigges **Check_Basico_Insert** y **Check_NoBasico_Insert**:

![Check_Basico_Insert](img/2022-01-30-12-12-27.png)

![Check_NoBasico_Insert](img/2022-01-30-12-13-44.png)

Ambos triggers hacen lo mismo: comprueban que los datos insertados no están en la tabla contraria antes de insertarlos y, si lo están lanzan un mensaje de error.

Para comprobar su funcionamiento se trata de insertar datos erróneos duplicados para provocar la activación de los triggers.

![Insert_Check_Basico_Insert](img/2022-01-30-12-16-45.png)

![Error_Check_Basico_Insert](img/2022-01-30-12-15-51.png)

Además, también se modelizó que todos los usuarios de **Basico** y **No_Basico** debían estar en **Usuario**. Esto se comprueba en la inserción de ambas subtablas por los triggers **Basico_EstaEn_Usuario_Trigger* y **NoBasico_EstaEn_Usuario_Trigger**.

![Basico_EstaEn_Usuario_Trigger](img/2022-01-30-12-20-36.png)

Sendos triggers realizan las mismas acciones, descritas en la función **EstaEn_Usuario**: Comprueban si el Email insertado está en la lista de los de la tabla **Usuario**, y si no lo está lanza un mensaje de error.

Para comprobar su funcionamiento se trata de insertar usuarios nuevos directamente en **Basico** y **No_Basico**.

![Insert_Basico_EstaEn_Usuario_Trigger](img/2022-01-30-12-22-57.png)

![Error_Basico_EstaEn_Usuario_Trigger](img/2022-01-30-12-23-26.png)


### **Comprobar la inserción en Externo y De_Indev** <a name="checkexternoinsert"/>
Las tablas **Videojuego**, **Externo** y **De_Indev** tienen la misma relación que la de los usuarios, por lo que sus triggers de inserción son casi iguales.

Comprobaciones para que no se repitan datos entre las subtablas **Externo** y **De_Indev** con inserciones erróneas para que se activen los triggers:

![Check_Externo_Insert](img/2022-01-30-12-26-53.png)

![Check_DeIndev_Insert](img/2022-01-30-12-27-19.png)

![Insert_Check_Externo_Insert](img/2022-01-30-12-28-11.png)

![Error_Check_Externo_Insert](img/2022-01-30-12-28-44.png)

Y triggers para evitar la inserción de videojuegos que no estén en **Videojuegos**, junto a sus respectivas inserciones "ilegales" para comprobar el funcionamiento de los procedimientos.

![Externo_EstaEn_Videojuego_Trigger](img/2022-01-30-12-37-25.png)

![Insert_Externo_EstaEn_Videojuego_Trigger](img/2022-01-30-12-46-21.png)

![Error_Externo_EstaEn_Videojuego_Trigger](img/2022-01-30-12-38-15.png)


### **Comprobar la inserción en Copia_Fisica** <a name="checkcpfinsert"/>
Como se comentó anteriormente, sólamente los usuarios No Básicos cuyo tipo sea _Deluxe_ pueden recibir copias físicas de videojuegos. Esto se comprueba mediante el trigger **Check_CpFisica_Insert**:

![Check_CpFisica_Insert](img/2022-01-30-12-55-44.png)

Al insertar un registro en la tabla Copia_Fisica, selecciona el usuario con el email insertado y tipo _Deluxe_. Si la selección es nula, el tipo es incorrecto, por lo que lanza un mensaje de error.

Para comprobar el funcionamiento del trigger se realizan una serie de inserciones erróneas.

![Insert_Check_CpFisica_Insert](img/2022-01-30-12-57-33.png)

![Error_Check_CpFisica_Insert](img/2022-01-30-12-58-05.png)


### **Comprobar la inserción en Juega1 y Juega2** <a name="checkjuega1insert"/>
Para mantener la condición de exclusión se estableció en el modelo que los usuarios Básicos sólo pueden jugar a videojuegos Externos o De_Indev de tipo _Reciente_, teniendo que elegir entre uno de estas categorías; y siendo el primer videojuego al que jugasen el que la definiría.

Esto se lograba estableciendo dos tablas (**Juega1 y Juega2**). La primera contiene sólo videojuegos Externos, y la segunda sólo De Indev. Para mantener la condición de exclusividad se debe comprobar que, a la hora de insertar datos en cualquiera de las dos tablas, no haya usuarios duplicados. Mediante los triggers **Check_Juega1_Insert** y **Check_Juega2_Insert** se consigue.

![Check_Juega1_Insert](img/.png)

![Check_Juega2_Insert](img/2022-01-30-13-04-07.png)

Ambos disparadores hacen lo mismo: Comprueban que el usuario introducido no se encuentra en la tabla contraria y, si está, lanza un mensaje de error.

Para comprobar el funcionamiento de los triggers se realizan inserciones erróneas.

![Insert_Check_Juega1_Insert](img/2022-01-30-13-06-36.png)

![Error_Check_Juega1_Insert](img/2022-01-30-13-07-58.png)


### **Actualizar la cuenta de títulos por categoría** <a name="checkcategoriainsert"/>
Al asignarle nuevas categorías a vieojuegos mediante la tabla **Pertenece** se debe de actualizar la cuenta de títulos por categoría de la tabla **Categoria**. Esto se consigue mediante el trigger **Actualiza_Categoria_Trigger**.

![Actualiza_Categoria_Trigger](img/2022-01-30-13-12-11.png)

Al introducir un nuevo registro en la tabla **Pertenece** se cuenta el número de filas con el nombre de la categoría que se ha utilizado para la inserción, y se actualiza la tabla categoría estableciendo en el registro de la categoría de la inserción el atributo _Num_Titulos_ al valor de la cuenta hecha previamente.

Se realizan inserciones para comprobar que el atributo de la tabla **Categoria** se actualiza correctamente.

![Insert_Actualiza_Categoria_Trigger](img/2022-01-30-13-17-40.png)

![Select_Actualiza_Categoria_Trigger](img/2022-01-30-13-17-57.png)
