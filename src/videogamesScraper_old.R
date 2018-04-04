## web scraping RetroCollect

# Cargamos el paquete 'rvest'
library('rvest')

# Guardamos la dirección del directorio base del trabajo
baseDirectory = getwd()

# La base de datos de RetroCollect se puede acceder con menos lecturas seleccionando:
# - 200 resultados por pagina
# - Ordenación: por año
# - Modo de vista de cada pagina en formato 'List'
# Esto hace que solo se deban leer 78 paginas
#

# Dirección de la URL de RetroCollect, ya formateada para los 200 resultados
url_direccion = "http://www.retrocollect.com/videogamedatabase/search?sort=year&mode=games&rows=200&view=list&page="

# Solicitaremos la carga de la pagina 2 a la 78
pages <- 2:78

# De esta manera concatenamos para la misma dirección la pagina correspondiente,
# generando una array de 78 direcciones url, relativas a cada pagina
urls <- paste0(url_direccion, pages)

# Para poder genera el data.frame correctamente, cargamos la primera pagina
url_0 <- paste0(url_direccion, "1")

# y llemos la url, generando el data frame original
url_start <- read_html(url_0)
table_start <- html_nodes(url_start, css = "table")
results = html_table(table_start, header = TRUE, fill = TRUE)[[1]]

# Ahora creamos un simple loop que nos ira leyendo las paginas de las urls
# y cada nuevo data frame se unira al final del primero
for(url_step in urls){
  
  url_0 <- read_html(url_step)
  table_0 <- html_nodes(url_0, css = "table")
  result_0 = html_table(table_0, header = TRUE, fill = TRUE)[[1]]
  
  # Hacemos un merge tomando en consideración que son dataframes iguales en columnas
  results = rbind(results, result_0)
  
}

# Eliminamos los objetos que ya no nos son necesarios para ajustar la memoria usada
rm(url_0, table_0, result_0, table_start, url_start, urls, url_direccion, url_step)


#Finalmente exportamos el data frame como un fichero cvs
setwd(paste0(baseDirectory, "/csv"))
write.csv2(results, file = "videoGames.csv", row.names = FALSE)
setwd(baseDirectory)

# Eliminamos el dataframe
rm(results)