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

# y llenamos la url, generando el data frame original, siguiendo los siguientes pasos:
#
# leemos la URL
url_start <- read_html(url_0)

# leemos los nodos que correspondan el css = table
table_start <- html_nodes(url_start, css = "table")

# establecemos los resultados en la variable, como dataframe
results = html_table(table_start, header = TRUE, fill = TRUE)[[1]]

# ahora refinamos la busqueda para la variable 'OriginalSystem'
# ya que al cargarse con los comandos previos resulta en NA porque no
# se cargan los datos correctos, ya que se encuentran en el tag 'alt'.
# Se siguen los siguientes pasos:

# Se carga en una variable 'alt2' el conjunto de resultados de extraer todos los textos
# que se encuentran en los tag 'alt' en la pagina html cargada.
# El resultado es mucho mayor que el numero de 200 valores que se deben recoger
# por lo que se sigue con un proceso de limpieza.
alt2 = html_nodes(table_start, xpath='//td[contains(@class, "searchResultsTableCenterAlign")]//img/@alt')

# En este paso se eliminan los textos 'alt=', las comillas, y los espacios en 
# blanco al comienzo de cada texto
alt2 = gsub("* ", "", gsub('\\"',"", gsub('alt=',"",alt2),))

# Finalmente se eliminan los items que no corresponden con los valores 
# alternativos de las imagenes, es decir: "Europe", "US", "Japan"
alt2 = alt2[! alt2 %in% c("Europe", "US", "Japan")]

# Despues del proceso de limpieza, se procede a cargar los datos correctos en el dataframe
results$`Original System` = alt2

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
