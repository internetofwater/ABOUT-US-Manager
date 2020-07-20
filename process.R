library(sf)
library(httr)
library(tidyverse)
library(readxl)

d <- st_read("R/NC_statewide_CWS_areas.gpkg")%>%st_transform(4326)
m <- read_excel("R/NC_CWS_metadata.xlsx")

d <- left_join(d,m,by="PWSID")
d$EPA_PWSID <- paste0("NC",gsub("-","",d$PWSID))
d <- st_transform(d,4326)
d <- distinct(d,PWS_ID,.keep_all=TRUE)

for(i in d$EPA_PWSID){
  x <- d[which(d$EPA_PWSID==i),]
  st_write(x,dsn=paste0("R/IndividualFiles/",i,".geojson"),delete_layer=TRUE)
}