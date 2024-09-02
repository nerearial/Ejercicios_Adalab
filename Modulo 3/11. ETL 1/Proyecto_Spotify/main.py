#%%
import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
#%%
from src import api_soportePROPIA as api
import pandas as pd

#%%
sp = api.credenciales()
sp

#%% 
uri_playlist = api.preparamos_url('https://open.spotify.com/playlist/37i9dQZF1DXdo6A3mWpdWx?si=454b5dbe72394269')
uri_playlist

#%%
resultados_api = api.extraer_canciones(sp, uri_playlist)

#%%
df_canciones = api.limpiar_datos(resultados_api)

# %%
df_canciones.reset_index()





# %%
import pandas as pd

## Cargar el fichero csv.
df = pd.read_csv('../datos/canciones_spotify.csv')
df.head()

# %%
# 2. Crear la BBDD con las tablas
# 3. Insertar los datos en las tablas

# %%
# 1. Conectarse a la base de datos.
import mysql.connector

cnx = mysql.connector.connect(
    user='root',
    password='AlumnaAdalab',
    host='127.0.0.1'
)

cursor = cnx.cursor()
query_create_db = 'CREATE SCHEMA IF NOT EXISTS `spotify`'
cursor.execute(query_create_db)


# %%
query_create_table_canciones = """
                CREATE TABLE IF NOT EXISTS `spotify`.`canciones` (
                `idcanciones` VARCHAR(1024) NOT NULL,
                `nombre` VARCHAR(1024) NULL,
                PRIMARY KEY (`idcanciones`))
                """

cursor.execute(query_create_table_canciones)


# %%
# 3. query para meter las canciones

query_insertar_canciones = """ 
    INSERT INTO `spotify`.`canciones` 
    (`idcanciones`, `nombre`) VALUES (%s, %s)
    ON DUPLICATE KEY UPDATE `nombre` = VALUES(`nombre`)
    """
# INSERTAR LISTA DE CANCIONES

datos_tabla_canciones = list(set(zip(df['uri_cancion'].values, 
                                 df['song'].values)))

# %%
from mysql.connector import IntegrityError

try:
    cursor.executemany(query_insertar_canciones, datos_tabla_canciones)
    cnx.commit()
except IntegrityError as e:
    print(f"Error occurred: {e}")

# %%
