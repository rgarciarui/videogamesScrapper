library(rvest)
library(dplyr)

years <- 1970:2016
urls <- paste0("http://www.baseball-reference.com/teams/MIL/", years, ".shtml")
# head(urls)

get_table <- function(url) {
  url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="div_team_batting"]/table[1]') %>% 
    html_table()
}

results <- sapply(urls, get_table)

pages <- 1:78
urls <- paste0("http://www.retrocollect.com/videogamedatabase/search?sort=year&mode=games&rows=200&view=list&page=", pages)


get_table <- function(url) {
  url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="divResults"]/table[1]') %>% 
    html_table(header = TRUE)
}

results <- sapply(urls, get_table)

#########


pages <- 1:78
urls <- paste0("http://www.retrocollect.com/videogamedatabase/search?sort=year&mode=games&rows=200&view=list&page=", pages)


get_table <- function(url) {
  url %>%
    read_html(css = "table") %>%
    html_nodes(xpath = '//*[@id="divResults"]/table[1]') %>% 
    html_table(header = TRUE)
}

results <- sapply(urls, get_table)




url_0 <- read_html("http://www.retrocollect.com/videogamedatabase/search?sort=year&mode=games&rows=200&view=list&page=1")

table_0 <- html_nodes(url_0, css = "table")
result_0 = html_table(table_0, header = TRUE, fill = TRUE)[[1]]
result_1 = html_table(table_0, header = FALSE, fill = TRUE)[[1]]


# Dirección de la URL de RetroCollect, ya formateada para los 200 resultados
url_direccion = "http://www.retrocollect.com/videogamedatabase/search?sort=year&mode=games&rows=200&view=list&page="

# Solicitaremos la carga de la pagina 1 a la 78
#pages <- 1:78

pages <- 2:3

# De esta manera concatenamos para la misma dirección la pagina correspondiente,
# generando una array de 78 direcciones url, relativas a cada pagina
url_0 <- paste0(url_direccion, "1")
urls <- paste0(url_direccion, pages)

url_start <- read_html(url_0)
table_start <- html_nodes(url_start, css = "table")
result_start = html_table(table_start, header = TRUE, fill = TRUE)[[1]]
View(result_start)

get_table <- function(url, result_start) {
  url_0 <- read_html(url)
  table_0 <- html_nodes(url_0, css = "table")
  result_0 = data.frame(html_table(table_0, header = TRUE, fill = TRUE)[[1]])
  
  result_start = rbind(result_start, result_0)
  
  return(data.frame(result_start))
}

results <- sapply(urls, FUN=get_table, result_start=result_start)


results <- as.data.frame(results)
##########################################################################

# Dirección de la URL de RetroCollect, ya formateada para los 200 resultados
url_direccion = "http://www.retrocollect.com/videogamedatabase/search?sort=year&mode=games&rows=200&view=list&page="

# Solicitaremos la carga de la pagina 1 a la 78
#pages <- 1:78

pages <- 2:3

# De esta manera concatenamos para la misma dirección la pagina correspondiente,
# generando una array de 78 direcciones url, relativas a cada pagina
url_0 <- paste0(url_direccion, "1")
urls <- paste0(url_direccion, pages)

url_start <- read_html(url_0)
table_start <- html_nodes(url_start, css = "table")
results = html_table(table_start, header = TRUE, fill = TRUE)[[1]]


for(url_steep in urls){
  
  url_0 <- read_html(url_steep)
  table_0 <- html_nodes(url_0, css = "table")
  result_0 = html_table(table_0, header = TRUE, fill = TRUE)[[1]]
  
  results = rbind(results, result_0)
  
}

rm(url_0, table_0, result_0, table_start, url_start, urls, url_direccion, url_steep)

