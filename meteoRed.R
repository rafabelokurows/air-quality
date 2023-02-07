library(rvest)
library(tidyverse)
library(jsonlite)
library(httr)
library(rrapply)

res = GET("https://services.meteored.com/web/aq/forecast/v4/meteored/1-32080.json")
res

weather_list <- jsonlite::read_json("https://services.meteored.com/web/aq/forecast/v4/meteored/1-32080.json")
weather = tibble(dia = weather_list$data$respuesta$aq$forecast[[1]]$dias)

# weather %>% 
#   unnest_wider(dia) %>%
#   select(-utime) %>%
#   pluck("horas",1) %>% enframe() %>% unnest_wider(value) %>% unnest_wider(contaminantes) %>% 
#   map_dfr()
#   pluck("pm2p5",c("concentracion"))%>% 
#   hoist("pm10",c("concentracion")) %>% View()

detalhes = rrapply(
  weather_list$data$respuesta$aq$forecast[[1]]$dias,
  f = \(x) x,
  classes = "numeric",
  how = "melt"
) |>
  filter(!L2 %in% c("utime","dominante")) %>% 
  filter(!L4 %in% c("utime","dominante")) %>% select(-c(L4,L2)) %>% 
  group_by(L1,L3,L5) %>% select(-L7) %>% mutate(L1=as.numeric(L1))



weather %>% 
  unnest_wider(dia) %>% select(dia,dia_semana) %>% mutate(no = row_number()) %>% 
  left_join(detalhes ,by=c("no"="L1"))
  
#   unnest_longer(horas) %>% unnest_longer(horas)   %>% hoist(contaminante)

# weather_list$data$respuesta$aq$forecast[[1]]$dias[[1]]$horas[[1]]$contaminantes$pm10

# str(weather_list$data$respuesta$aq$forecast[[1]]$dias,max.level=2)
# rrapply(
#   weather_list$data$respuesta$aq$forecast[[1]]$dias,
#   f = \(x) x,
#   classes = "numeric",
#   how = "melt"
# ) |>
#   filter(!L2 %in% c("utime","dominante")) %>% 
#   filter(!L4 %in% c("utime","dominante")) %>% select(-c(L4,L2)) %>% 
#   group_by(L1,L3,L5) %>% View()
