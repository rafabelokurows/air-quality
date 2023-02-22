library(rvest)
library(dplyr)
library(jsonlite)
library(httr)

data = Sys.Date()
estacao = 1023 #Ermesinde

urlbase=paste0("https://qualar.apambiente.pt/api/site.php?type=dados&data=",data,"&estacao_id=",estacao,"&poluente_id=")

ozono=content(GET(paste0(urlbase,"7")))%>% bind_rows()
ozono

dioxidoNO=content(GET(paste0(urlbase,"8")))%>% bind_rows()
dioxidoNO

PM10=content(GET(paste0(urlbase,"5")))%>% bind_rows()
PM10

df=bind_rows(ozono,dioxidoNO,PM10)
write.csv(df,"qualar.csv")
