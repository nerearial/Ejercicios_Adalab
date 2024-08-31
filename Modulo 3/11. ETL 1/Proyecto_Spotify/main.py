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
