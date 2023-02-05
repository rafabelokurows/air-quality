library(rvest)
library(tidyverse)
library(jsonlite)
library(httr)

res = GET("https://services.meteored.com/web/aq/forecast/v4/meteored/1-32080.json")

res$content
data = rawToChar(res$content)



data = fromJSON(rawToChar(res$content))

data$data$respuesta$aq$tipo
data$data$respuesta$aq$forecast$temporalidad
data$data$respuesta$aq$forecast$dias[[1]] %>% str()
