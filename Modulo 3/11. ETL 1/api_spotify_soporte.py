import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import pandas as pd
import os
import sys

from dotenv import load_dotenv
load_dotenv()
sys.path.append("../")

def credenciales():
    """
    Obtiene las credenciales de autenticación para acceder a la API de Spotify.

    Esta función utiliza las variables de entorno 'client_ID' y 'client_Secret' para
    configurar y autenticar una instancia de la clase 'SpotifyClientCredentials' de Spotipy,
    que se utiliza para autenticar las solicitudes a la API de Spotify.

    Returns:
    spotipy.Spotify: Un objeto de la clase 'Spotify' autenticado que se puede utilizar
    para realizar solicitudes a la API de Spotify.
    """
    CLIENT_SECRET = os.getenv("client_Secret")  # Obtener el client secret desde las variables de entorno
    CLIENT_ID = os.getenv("client_ID")          # Obtener el client ID desde las variables de entorno

    # Configurar las credenciales de autenticación
    credenciales = SpotifyClientCredentials(CLIENT_ID, CLIENT_SECRET)

    # Crear una instancia autenticada de la clase 'Spotify'
    sp = spotipy.Spotify(client_credentials_manager=credenciales)

    return sp


def preparamos_url(link):
    """
    Prepara y extrae la URI de una playlist de Spotify desde un enlace proporcionado.

    Esta función toma un enlace de Spotify como entrada y extrae la URI de la playlist,
    que es una identificación única que se utiliza para identificar la playlist en la API
    de Spotify.

    Args:
    link (str): El enlace de Spotify que contiene la URL de la playlist.

    Returns:
    str: La URI de la playlist extraída del enlace de Spotify.
    """
    # Divide el enlace en partes utilizando "/" como separador y selecciona la última parte
    # Luego, divide esa parte utilizando "?" como separador y selecciona la primera parte
    # Esto extrae la URI de la playlist de la URL del enlace
    playlist_URI = link.split("/")[-1].split("?")[0]

    return playlist_URI




def extraer_canciones(conexion, playlist_URI):
    """
    Extrae todas las canciones de una playlist de Spotify usando una conexión a la API de Spotify.

    Esta función utiliza una conexión autenticada a la API de Spotify y una URI de playlist para
    recuperar todas las canciones de la playlist y las devuelve en una lista.

    Args:
    conexion (spotipy.Spotify): Una instancia de la clase 'Spotify' autenticada que se utilizará
                        para realizar solicitudes a la API de Spotify.
    playlist_URI (str): La URI de la playlist de Spotify desde la cual se extraerán las canciones.

    Returns:
    list: Una lista de diccionarios, donde cada diccionario representa una canción en la playlist.
    """
    
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


def limpiar_datos(all_data):
    """
    Limpia y organiza los datos de canciones obtenidos de Spotify en un DataFrame.

    Esta función toma una lista de datos de canciones obtenidos de Spotify y realiza una limpieza
    y organización de los datos para crear un DataFrame estructurado.

    Args:
    all_data (list): Una lista de diccionarios, donde cada diccionario representa una canción en Spotify.

    Returns:
    pd.DataFrame: Un DataFrame que contiene información organizada sobre las canciones, artistas, fechas,
                explícitas, URIs, popularidad, usuarios, duración y enlaces de las canciones.
    """
    # Crear un diccionario para almacenar la información básica de las canciones
    basic_info = {"song": [], "artist": [], "date": [], "explicit": [], "uri_cancion": [], "popularity": [],
                "usuario": [], "links": [], 'uri_artista': [], "duracion": []}


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
    df_canciones.to_csv("../files/canciones_spotify.csv")
    
    return df_canciones



def sacar_caracteristicas(conexion, df_basic_info, list_uris_songs, nombre_lista):
    """
    Extrae características de audio de canciones de Spotify y fusiona los datos con información básica en un DataFrame.

    Esta función utiliza una conexión autenticada a la API de Spotify, una lista de URIs de canciones,
    y un DataFrame con información básica de canciones para obtener características de audio de las canciones
    y fusionar estos datos en un DataFrame final. Además, guarda el DataFrame final en un archivo CSV.

    Args:
    conexion (spotipy.Spotify): Una instancia de la clase 'Spotify' autenticada que se utilizará
                            para realizar solicitudes a la API de Spotify.
    df_basic_info (pd.DataFrame): Un DataFrame con información básica de canciones, incluyendo URI de canciones.
    list_uris_songs (list): Una lista de URIs de canciones de Spotify.
    nombre_lista (str): El nombre de la lista de reproducción o conjunto de canciones.

    Returns:
    pd.DataFrame: Un DataFrame que contiene información básica y características de audio de las canciones.
    """
    # Extraer características de audio para cada URI de canción en la lista
    features = []
    for track in list_uris_songs:
        features.append(conexion.audio_features(track))

    # Crear un DataFrame a partir de las características de audio
    df = pd.DataFrame(features)
    df_features = df[0].apply(pd.Series)

    # Fusionar el DataFrame de información básica con el DataFrame de características de audio
    final = pd.merge(df_basic_info, df_features,  left_on='uri_cancion', right_on="uri")

    # Guardar el DataFrame limpio en un archivo CSV con nombre personalizado
    final.to_csv("../files/datos_spotify.csv")
    return final