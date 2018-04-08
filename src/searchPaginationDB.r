# Se informa de la libreria que se require para el funcionamiento de la funcion
require('rvest')

# Carga de la funcion searchPaginationDB()
#
# La función realiza un web scraping en RetroCollect, posibilitando un 
# acceso dinamico a la misma y configurando algunos parametros de control
# en la llamada a la pagina web de RetroCollect indicando algunas
# variables de carga y control de visualización:
#
# url_base:   La dirección web generalde acceso a RetroCollect
# listview:   Sistema de visualización, por defecto 'list'
# modeview:   Por defecto se buscan 'games'
# plataforma: La plataofrma de filtro, por defecto = 0, todas sin excepcion
# sort:       Esquema de ordenación, puede tomar 4 parametros:
#             1 - 'title', es el defectivo y es igual a NA
#             2 - 'system', organiza por S.O. y es igual a "platform"
#             3 - 'publisher', organiza por cia. de publicación y es igual a "publisher"
#             4 - 'year', organiza por año de publicación y es igual a "year"
# filas:      Indica el numero de filas de visualización por página, defecto = 20
# verbose:    Indica si se desea o no información de progreso, defecto TRUE
#

searchPaginationDB <- function( 
  # Esta es la url base de búsqueda de videojuegos en Retrocollect
  url_base = "http://www.retrocollect.com/videogamedatabase/search?", 
  listview = "list",
  modeview = "games",
  plataforma = 0,
  sort = NA,
  filas = 20,
  verbose = TRUE
  
){
  
  # Generamos la url base de trabajo
  # Dirección de la URL de RetroCollect, ya formateada para los resultados
  
  if (is.na(sort)){   # Si no hay dato nuevo: sort = NA
    
    url_direccion = paste0(url_base, "mode=", modeview, "&", "view=", listview, 
                           "&", "rows=", filas, "&", "platform=", plataforma)      
    
  }else{              # si hay dato nuevo
    
    url_direccion = paste0(url_base, "mode=", modeview, "&", listview, 
                           "&", "rows=", filas, "&", "sort=", sort, 
                           "&", "platform=", plataforma) 
    
  }  
  
  # llenamos la url, generando el data frame original
  url <- read_html(url_direccion)

  # Se carga en una variable 'platform' el conjunto de resultados de extraer
  # todos los textos que se encuentran en los datos de plataformas 
  # en la pagina html cargada.
  #platform = html_nodes(url, xpath='//a[(@class = "searchPagination")]')
  pagination = html_nodes(url, xpath='//div[(@class = "searchPagination")]/a')
  
  # Ajustamos los datos recibidos
  # Se ajusta a la llongitud de la lista, por es menor de 6, que es el maximo
  pagination = xml_attrs(pagination[[length(pagination)]])[["href"]]
  
  # Ahora limpiamos el resultado y obtenemos el dato
  resultado = as.numeric(vapply(strsplit(pagination, '='), 
                                function(x) x[length(x)], character(1)))

  # devolvemos el resultado de la funcion
  return(as.integer(resultado))
  
}
