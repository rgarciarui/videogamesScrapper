# Se informa de la libreria que se require para el funcionamiento de la funcion
require('rvest')

getPlatformDB <- function( 
    # Esta es la url base de búsqueda de videojuegos en Retrocollect
    url_base = "http://www.retrocollect.com/videogamedatabase/search?"
    
    ){

        # llenamos la url, generando el data frame original
        url <- read_html(url_base)
        
        # Se carga en una variable 'platform' el conjunto de resultados de extraer
        # todos los textos que se encuentran en los datos de plataformas 
        # en la pagina html cargada.
        platform = html_nodes(url, xpath='//*[(@id = "searchagainplatform")]')
        
        # Ajustamos los dtos recibidos
        platform = platform[[1]]
        
        # Ahora realizamos un bucle simple y obtenemos los datos solicitados
        # xml_length(platform) nos devuelve el numero de datos que podemos extraer
        # creamos un vector para su manejo
        
        resultado = data.frame(Numeros=NA, Platforms=NA)
        
        for (step in 1:as.numeric(xml_length(platform))){
          # xml_child(platform, 1))[["value"]] devuelve el value asignado en el xml a cada item
          # xml_text(xml_child(platform, 1)), devuelve el texto del item
          
          resultado[step,] <- c(
                                as.integer(xml_attrs(xml_child(platform, step))[["value"]]),
                                xml_text(xml_child(platform, step))
                                )
          
        }
        
        # devolvemos el resultado de la funcion como un data frame
        return(resultado)

}