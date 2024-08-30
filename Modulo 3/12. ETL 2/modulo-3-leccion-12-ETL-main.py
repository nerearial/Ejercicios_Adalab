#%%
# Importar librerías para manipulación y análisis de datos
# -----------------------------------------------------------------------
import pandas as pd

# Importar los archivos de soporte
from src import queries_creacion_bbd_tablas as query
from src import bbdd_spotify_soporte as bss

#%%
# Cargar el csv que creamos en la lección de ayer con la música de la promo
df = pd.read_csv("../files/datos_spotify.csv", index_col = 0)

#%%
# Crear la Base de Datos
bss.creacion_bbdd_tablas(query.query_creacion_bbdd, "admin", "spotify_f")

# Crear las tablas de la BBDD
# Tabla  ARTISTAS
bss.creacion_bbdd_tablas(query.query_tabla_artistas, "admin" )

# Tabla CANCIONES
bss.creacion_bbdd_tablas(query.query_tabla_canciones, "admin" )

# Tabla CANCIONES HAS ARTISTAS
bss.creacion_bbdd_tablas(query.query_tabla_canciones_has_artistas, "admin" )

# Tabla CARACTERISTICAS
bss.creacion_bbdd_tablas(query.query_tabla_caracteristicas, "admin" )

#%%
# Crear las listas de tuplas con la información a insertar en cada tabla

# TABLA CANCIONES
datos_tabla_canciones = list(set(zip(df["uri_cancion"].values, df["song"].values)))

# TABLA ARTISTAS
df[['artist', 'uri_artista']] = df[['artist', 'uri_artista']].applymap(bss.convertir_lista)
df_explode = df.explode(["artist", "uri_artista"])[["artist", "uri_artista", "uri_cancion"]]
datos_tabla_artistas = list(set(zip(df_explode["uri_artista"].values, df_explode["artist"].values)))

# TABLA CARACTERISTICAS
datos_tabla_caracteristicas = list(set(zip(df["danceability"].values, df["acousticness"].values, df["energy"].values, df["uri_cancion"]  )))
datos_tabla_caracteristicas = bbdd.convertir_float(datos_tabla_caracteristicas)

# TABLA CANCIONES ARTISTAS
datos_tabla_canciones_artistas = list(set(zip(df_explode["uri_cancion"], df_explode["uri_artista"])))
#%%
# Insertar los datos en las tablas

# INSERTAR EN CANCIONES
bss.insertar_datos(query.query_insertar_canciones, "admin", "spotify_f", datos_tabla_canciones)

# INSERTAR EN ARTISTAS
bss.insertar_datos(query.query_insertar_artistas, "admin", "spotify_f", datos_tabla_artistas)

# INSERTAR EN CANCIONES ARTISTAS
bss.insertar_datos(query.query_insertar_canciones_artistas, "admin", "spotify_f", datos_tabla_canciones_artistas)

# INSERTAR CARACTERISTICAS
bss.insertar_datos(query.query_insertar_caracteristicas, "admin", "spotify_f", datos_tabla_caracteristas_def)

# %%
