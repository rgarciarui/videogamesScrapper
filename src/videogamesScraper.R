## web scraping RetroCollect

# Cargamos el paquete 'rvest'
library('rvest')
# Cargamos el codigo fuente de la función accessVideoGameDatabase()
source("src/accessVideoGameDatabase.r")
# Cargamos el codigo fuente de la función getPlatfomrDB()
source("src/getPlatformDB.r")
# Cargamos el codigo fuente de la función searchPaginationDB()
source("src/searchPaginationDB.r")

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

sort = "year"

# Solicitaremos la carga de la pagina 2 hasta la final del listado
# para ello accedemos dinamicamente a la web de Retrocollect con la
# funcion searchPaginationDB() y le pedimos que nos dé la ultima pagina
filas = 200

endpages = searchPaginationDB(sort=sort, filas=filas)

webPages <- 2:endpages

# solicitamos a la función accessVideoGameDatabase() con los datos indicados
resultados = accessVideoGameDatabase(sort=sort, pages=webPages, filas=filas)

# Eliminamos los objetos que ya no nos son necesarios para ajustar la memoria usada
rm(url_0, table_0, result_0, table_start, url_start, urls, url_direccion, url_step, alt2)

#Finalmente exportamos el data frame como un fichero cvs
setwd(paste0(baseDirectory, "/csv"))
write.csv2(resultados, file = "videoGames.csv", row.names = FALSE)
setwd(baseDirectory)

# Eliminamos el dataframe
rm(resultados)
