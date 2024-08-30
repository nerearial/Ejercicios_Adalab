# Importar librería para la conexión con MySQL
# -----------------------------------------------------------------------
# Importar librerías para manipulación y análisis de datos
# -----------------------------------------------------------------------
from ast import literal_eval

import mysql.connector


def creacion_bbdd_tablas(query, contraseña, nombre_bbdd=None):
    """
    Crea una conexión a la base de datos MySQL y ejecuta una consulta para crear una tabla.

    Args:
    - query (str): Consulta SQL para crear la tabla en la base de datos.
    - contraseña (str): Contraseña para acceder a la base de datos.
    - nombre_bbdd (str): Nombre de la base de datos a la que se conectará.

    Returns:
        - None

    """
    if nombre_bbdd is not None:
        cnx = mysql.connector.connect(
            user="root", 
            password=contraseña, 
            host="127.0.0.1"
        )

        mycursor = cnx.cursor()

        try:
            mycursor.execute(query)
            print(mycursor)

        except mysql.connector.Error as err:
            print(err)
            print("Error Code:", err.errno)
            print("SQLSTATE", err.sqlstate)
            print("Message", err.msg)
    else:
        cnx = mysql.connector.connect(
            user="root", 
            password=contraseña,
            host="127.0.0.1", 
            database=nombre_bbdd
        )

        mycursor = cnx.cursor()

        try:
            mycursor.execute(query)
            print(mycursor)
            cnx.close()

        except mysql.connector.Error as err:
            print(err)
            print("Error Code:", err.errno)
            print("SQLSTATE", err.sqlstate)
            print("Message", err.msg)
            cnx.close()


def convertir_lista(col):
    """
    Intenta convertir una cadena en una lista utilizando la función literal_eval de la biblioteca ast.

    Args:
    - col (str): Cadena que se intentará convertir en una lista.

    Returns:
    - list or str: Devuelve una lista si la conversión es exitosa. Si no puede convertir la cadena a lista, devuelve la cadena original.

    """
    try:
        return literal_eval(col)
    # trunk-ignore(ruff/E722)
    except:
        return col


def insertar_datos(query, contraseña, nombre_bbdd, lista_tuplas):
    """
    Inserta datos en una base de datos utilizando una consulta y una lista de tuplas como valores.

    Args:
    - query (str): Consulta SQL con placeholders para la inserción de datos.
    - contraseña (str): Contraseña para la conexión a la base de datos.
    - nombre_bbdd (str): Nombre de la base de datos a la que se conectará.
    - lista_tuplas (list): Lista que contiene las tuplas con los datos a insertar.

    Returns:
    - None: No devuelve ningún valor, pero inserta los datos en la base de datos.

    This function connects to a MySQL database using the given credentials, executes the query with the provided list of tuples, and commits the changes to the database. In case of an error, it prints the error details.
    """
    cnx = mysql.connector.connect(
        user="root", 
        password=contraseña, 
        host="127.0.0.1", database=nombre_bbdd
    )

    mycursor = cnx.cursor()

    try:
        mycursor.executemany(query, lista_tuplas)
        cnx.commit()
        print(mycursor.rowcount, "registro/s insertado/s.")
        cnx.close()

    except mysql.connector.Error as err:
        print(err)
        print("Error Code:", err.errno)
        print("SQLSTATE", err.sqlstate)
        print("Message", err.msg)
        cnx.close()


def convertir_float(lista_tuplas):
    """
    Convierte los elementos de una lista de tuplas a float cuando sea posible.

    Args:
    - lista_tuplas (list): Una lista que contiene tuplas con elementos que pueden ser convertidos a float.

    Returns:
    - list: Una nueva lista con las mismas tuplas de entrada, pero con los elementos convertidos a float si es posible.
    """
    datos_tabla_caract_def = []
    
    for tupla in lista_tuplas:
        lista_intermedia = []
        for elemento in tupla:
            try:
                lista_intermedia.append(float(elemento))
            except:
                lista_intermedia.append(elemento)
            
        datos_tabla_caract_def.append(tuple(lista_intermedia))
    
    return datos_tabla_caract_def
