#%%
import pandas as pd
from src import api_spotify_soporte as api
pd.set_option('display.max_columns', None) # para poder visualizar todas las columnas de los DataFrames

# %%
# llamamos a la función para establecer las credenciales de la API
sp = api.credenciales()
# %%
# Extraemos el uri (id) de la lista de reproducción
uri_playlist = api.preparamos_url("https://open.spotify.com/playlist/2Nwhjsc3IuvTMaUNK3VfL8?si=fb996c1e9c984259")

# %%
# extraemos todas las canciones que tenemos en nuestra lista de reproducción
canciones = api.extraer_canciones(sp, uri_playlist)
print(canciones)

# %%
# limpiamos todos los datos que nos da la API, para quedarnos solo con aquellos que nos interesan
df_songs = api.limpiar_datos(canciones)
df_songs.head()
# %%
# sacamos todos los id (uris) de las canciones para extraer sus características
listas_uris_canciones = df_songs["uri_cancion"].unique().tolist()
# %%
# sacamos todas las características de las canciones
df_final = api.sacar_caracteristicas(sp, df_songs, listas_uris_canciones, "Promo F" )
df_final.head(10)

# %%
