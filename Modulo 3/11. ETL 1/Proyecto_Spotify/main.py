
#%%
from src import api_soportePROPIA as api
import pandas as pd

#%%
sp = api.credenciales()
sp

#%% 
url_playlist = api.preparamos_url('https://open.spotify.com/playlist/37i9dQZF1DXdo6A3mWpdWx?si=454b5dbe72394269')
url_playlist

#%%
resultados_api = api.extraer_canciones(sp, url_playlist)

#%%
df_canciones = api.limpiar_datos(resultados_api)

# %%
