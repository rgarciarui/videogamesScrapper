# Se informa de la libreria que se require para el funcionamiento de la funcion
require('rvest')

# Carga de la funcion accessVideoGameDatabase()
#
# La función realiza un web scrapin en RetroCollect, posibilitando un 
# acceso dinamico a la misma y configurando algunos parametros de control
# en la llamada a la pagina web de RetroCollect indicando algunas
# variables de carga y control de visualización:
#
# url_base:   La dirección web generalde acceso a RetroCollect
# view_list:  Sistema de visualización, por defecto 'list'
# sort:       Esquema de ordenación, puede tomar 4 parametros:
#             1 - 'title', es el defectivo y es igual a NA
#             2 - 'system', organiza por S.O. y es igual a "platform"
#             3 - 'publisher', organiza por cia. de publicación y es igual a "publisher"
#             4 - 'year', organiza por año de publicación y es igual a "year"
# filas:      Indica el numero de filas de visualización por página, defecto = 20
# pages:      Número de paginas a recolectar, defecto 2:10. Se debe empezar por 2
# verbose:    Indica si se desea o no información de progreso, defecto TRUE
#

accessVideoGameDatabase <- function (
                            url_base = "http://www.retrocollect.com/videogamedatabase/search?", 
                            view_list = "view=list",
                            sort = NA,
                            filas = 20,
                            pages = c(2:10),
                            verbose = TRUE
                            ){
  

    # Generamos la url base de trabajo
    # Dirección de la URL de RetroCollect, ya formateada para los resultados
  
    if (is.na(sort)){   # Si no hay dato nuevo: sort = NA
      
      url_direccion = paste0(url_base, "mode=games", "&", view_list, 
                          "&", "rows=", filas)      

    }else{              # si hay dato nuevo
      
      url_direccion = paste0(url_base, "mode=games", "&", view_list, 
                          "&", "rows=", filas, "&", "sort=", sort) 

    }
  
    # De esta manera concatenamos para la misma dirección la pagina correspondiente,
    # generando una array de direcciones url, relativas a cada pagina
    urls <- paste0(url_direccion, "&page=", pages)

    # Para poder generar el data.frame correctamente, cargamos la primera pagina
    url_0 <- paste0(url_direccion, "&page=1")
    
    if(verbose == TRUE) print(paste0("Se esta procesando la pagina: ",url_0))
    
    # y llenamos la url, generando el data frame original, siguiendo los siguientes pasos:
    #
    # leemos la URL
    url_start <- read_html(url_0)

    # leemos los nodos que correspondan el css = table
    table_start <- html_nodes(url_start, css = "table")
    
    # establecemos los resultados en la variable, como dataframe
    results = html_table(table_start, header = TRUE, fill = TRUE)[[1]]
    
    # Si no esta el año indicado, se ajusta el valor a NA
    results$Year = gsub("???", NA, results$Year)
    
    # Ajustamos los resultados de las regiones a modo binario
    # 1 -> Se comercializo en esa region
    # 0 -> No se comercializo en esa region
    #
    results$Europe = as.numeric(gsub("x", 0, results$Europe))
    results$Europe[is.na(results$Europe)] <- 1
    
    results$US = as.numeric(gsub("x", 0, results$US))
    results$US[is.na(results$US)] <- 1
    
    results$Japan = as.numeric(gsub("x", 0, results$Japan))
    results$Japan[is.na(results$Japan)] <- 1
    
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
    alt2 = gsub("* ", "", gsub('\\"',"", gsub('alt=',"",alt2)))
    
    # Finalmente se eliminan los items que no corresponden con los valores 
    # alternativos de las imagenes, es decir: "Europe", "US", "Japan"
    alt2 = alt2[! alt2 %in% c("Europe", "US", "Japan")]
    
    # Despues del proceso de limpieza, se procede a cargar los datos correctos en el dataframe
    results$`Original System` = alt2
    
    # Ahora creamos un simple loop que nos ira leyendo las paginas de las urls
    # y cada nuevo data frame se unira al final del primero
    for(url_step in urls){
      
      if(verbose == TRUE) print(paste0("Se está procesando la pagina: ",url_step))

      # llenamos la url, generando el data frame original
      url_0 <- read_html(url_step)
      table_0 <- html_nodes(url_0, css = "table")
      result_0 = html_table(table_0, header = TRUE, fill = TRUE)[[1]]
      
      # Si no esta el año indicado, se ajusta el valor a NA
      result_0$Year = gsub("???", NA, result_0$Year)
      
      # Ajustamos los resultados de las regiones a modo binario
      result_0$Europe = as.numeric(gsub("x", 0, result_0$Europe))
      result_0$Europe[is.na(result_0$Europe)] <- 1
      
      result_0$US = as.numeric(gsub("x", 0, result_0$US))
      result_0$US[is.na(result_0$US)] <- 1
      
      result_0$Japan = as.numeric(gsub("x", 0, result_0$Japan))
      result_0$Japan[is.na(result_0$Japan)] <- 1
      
      # Se carga en una variable 'alt2' el conjunto de resultados de extraer todos los textos
      # que se encuentran en los tag 'alt' en la pagina html cargada.
      # El resultado es mucho mayor que el numero de filas de valores que se deben recoger
      # por lo que se sigue con un proceso de limpieza.
      alt_step = html_nodes(table_0, xpath='//td[contains(@class, "searchResultsTableCenterAlign")]//img/@alt')
      
      # En este paso se eliminan los textos 'alt=', las comillas, y los espacios en 
      # blanco al comienzo de cada texto
      alt_step = gsub("* ", "", gsub('\\"',"", gsub('alt=',"",alt_step)))
      
      # Finalmente se eliminan los items que no corresponden con los valores 
      # alternativos de las imagenes, es decir: "Europe", "US", "Japan"
      alt_step = alt_step[! alt_step %in% c("Europe", "US", "Japan")]
      
      # Despues del proceso de limpieza, se procede a cargar los datos correctos en el dataframe
      result_0$`Original System` = alt_step
      
      # Hacemos un merge tomando en consideración que son dataframes iguales en columnas
      results = rbind(results, result_0)
      
    }
    # Finalmente se devuelve el dataframe al codigo de llamada
    return(results)
}


