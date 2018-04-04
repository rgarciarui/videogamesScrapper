## web scraping RetroCollect

# Cargamos el paquete 'rvest'
library('rvest')
# Cargamos el codigo fuente de la función accessVideoGameDatabase()
source("src/accessVideoGameDatabase.r")

# Guardamos la dirección del directorio base del trabajo
baseDirectory = getwd()

# La base de datos de RetroCollect se puede acceder con menos lecturas seleccionando:
# - 200 resultados por pagina
# - Ordenación: por año
# - Modo de vista de cada pagina en formato 'List'
# Esto hace que solo se deban leer 78 paginas
#

# Esta es la url base de búsqueda de videojuegos en Retrocollect
url_base = "http://www.retrocollect.com/videogamedatabase/search?"

# Modo de acceso a la base de datos de videojuegos
view_list = "view=list"

# Modos de arreglo de ordenación de la base de datos
# Se puede escoger uno de los 4 siguientes:
#             1 - 'title', es el defectivo y es igual a NA
#             2 - 'system', organiza por S.O. y es igual a "platform"
#             3 - 'publisher', organiza por cia. de publicación y es igual a "publisher"
#             4 - 'year', organiza por año de publicación y es igual a "year"

sort_year = "year"

# Solicitaremos la carga de la pagina 2 a la 78
webPages <- 2:78

# solicitamos a la función con los datos indicados
resultados = accessVideoGameDatabase(sort=sort_year, pages=webPages, filas=200)

# Eliminamos los objetos que ya no nos son necesarios para ajustar la memoria usada
rm(url_0, table_0, result_0, table_start, url_start, urls, url_direccion, url_step, alt2)

#Finalmente exportamos el data frame como un fichero cvs
setwd(paste0(baseDirectory, "/csv"))
write.csv2(results, file = "videoGames.csv", row.names = FALSE)
setwd(baseDirectory)

# Eliminamos el dataframe
rm(results)
