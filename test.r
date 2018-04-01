
# Download the HTML
library(rvest)
frozen <- read_html("http://www.imdb.com/title/tt2294629/")
frozen

#Extract nodes
itals <- html_nodes(frozen, "em")
itals


# Extract content from nodes

html_text(itals)
html_name(itals)
html_children(itals)
html_attrs(itals)

# Extract content

#Read in the Frozen HTML
#Select the nodes that are both spans and class = "itemprop"
#Extract the text from the nodes

library(rvest)
frozen <- read_html("http://www.imdb.com/title/tt2294629/")
cast <- html_nodes(frozen, "span.itemprop")
html_text(cast)

#Practice scraping data
#Look up the cost of living for your hometown on Sperling’s Best Places. 
#Then extract it with html_nodes() and  html_text()

#For me, this means I need to obtain information on Sterling, Virginia.

sterling <- read_html("http://www.bestplaces.net/cost_of_living/city/virginia/sterling")

col <- html_nodes(sterling, css = "#mainContent_dgCostOfLiving tr:nth-child(2) td:nth-child(2)")
html_text(col)

# or use a piped operation
sterling %>%
  html_nodes(css = "#mainContent_dgCostOfLiving tr:nth-child(2) td:nth-child(2)") %>%
  html_text()


#Tables
#Use html_table() to scrape whole tables of data as a data frame.
library(dplyr)
tables <- html_nodes(sterling, css = "table")

tables %>%
  # get the second table
  nth(2) %>%
  # convert to data frame
  html_table(header = TRUE)


#Extract climate statistics
#Visit the climate tab for your home town. 
#Extract the climate statistics of your hometown as a 
#data frame with useful column names.

sterling_climate <- read_html("http://www.bestplaces.net/climate/city/virginia/sterling")

climate <- html_nodes(sterling_climate, css = "table")
html_table(climate, header = TRUE, fill = TRUE)[[2]]

sterling_climate %>%
  html_nodes(css = "table") %>%
  nth(2) %>%
  html_table(header = TRUE)





