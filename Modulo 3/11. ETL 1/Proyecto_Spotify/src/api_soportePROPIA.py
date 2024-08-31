#%%
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import pandas as pd
import os
import sys

# %%
import os
from dotenv import load_dotenv
from dotenv import main
from dotenv import dotenv_values
load_dotenv()

# %%
def credenciales():

    CLIENT_ID = os.getenv('client_id')
    CLIENT_SECRET = os.getenv('client_secret')

    credenciales = SpotifyClientCredentials(CLIENT_ID,CLIENT_SECRET)
    sp = spotipy.Spotify(client_credentials_manager = credenciales)
    
    return sp

# %%
def preparamos_url(link):
    return link.split("/")[-1].split("?")[0]

# %%
def extraer_canciones(conexion, playlist_URI):

    # Obtener el número total de canciones en la playlist
    numero_canciones = conexion.playlist_tracks(playlist_URI, limit=1)["total"]

    # Calcular el número de iteraciones necesarias para obtener todas las canciones
    numero_canciones = int(str(numero_canciones + 100)[0])

    # Inicializar el desplazamiento (offset) y la lista que almacenará todos los datos
    offset = 0
    all_data = []

    # Iterar a través de las páginas de resultados para obtener todas las canciones
    for _ in range(numero_canciones):
        # Realizar una solicitud para obtener un lote de canciones
        batch_data = conexion.playlist_tracks(playlist_URI, offset=offset)["items"]
        
        # Agregar las canciones del lote a la lista de datos
        all_data.extend(batch_data)
        
        # Incrementar el desplazamiento para la próxima solicitud
        offset += 100

    return all_data

#%%
def limpiar_datos(all_data):
  
    # Crear un diccionario para almacenar la información básica de las canciones
    basic_info = {"song": [], 
                  "artist": [], 
                  "date": [], 
                  "explicit": [], 
                  "uri_cancion": [], 
                  "popularity": [],
                  "usuario": [], 
                  "links": [], 
                  'uri_artista': [], 
                  "duracion": []}

    for cancion in all_data:
        basic_info["song"].append(cancion["track"]["name"])
        basic_info["date"].append(cancion["added_at"])
        basic_info["explicit"].append(cancion["track"]["explicit"])
        basic_info["uri_cancion"].append(cancion["track"]["uri"])
        basic_info["popularity"].append(cancion["track"]["popularity"])
        basic_info["usuario"].append(cancion["added_by"]["id"])
        basic_info["links"].append(cancion["track"]["external_urls"]["spotify"])
        basic_info["duracion"].append(cancion["track"]["duration_ms"])
          
        lista_artistas = []
        lista_uris = []
        for artista in cancion["track"]["artists"]:
            lista_artistas.append(artista["name"])
            lista_uris.append(artista["id"])
        basic_info["artist"].append(lista_artistas)
        basic_info["uri_artista"].append(lista_uris)
      
    df_canciones = pd.DataFrame(basic_info) 
    df_canciones.to_csv("datos/canciones_spotify.csv") # CREAR LA CARPETA datos EN EL DIRECTORIO PRINCIPAL
      
    return df_canciones
# %%
