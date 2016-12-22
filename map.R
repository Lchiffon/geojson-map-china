setwd("D:/git/geojson-map-china")
Sys.setlocale('LC_CTYPE','chs')
library(jsonlite)
china = fromJSON("china.json")
names(china)
china$type

names(china$features)
china$features$type
china$features$properties

china$features$geometry$type
china$features$geometry$coordinates


jsonToGeoJSON = function(filename){
  
}


library(leaflet)
Sys.setlocale("LC_CTYPE","eng")
leaflet() %>% 
  setView(lng = 116.30, lat = 40.03, zoom = 12) %>%
  addTiles() %>%
  addGeoJSON(fromJSON("china.json",simplifyVector=F))


leaflet() %>% 
  setView(lng = 116.30, lat = 40.03, zoom = 12) %>%
  addTiles() %>%
  addGeoJSON(fromJSON("geometryCouties/130300.json",simplifyVector=F))



leaflet() %>% 
  setView(lng = 116.30, lat = 40.03, zoom = 12) %>%
  addTiles('http://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
           tileOptions(tileSize=256,  minZoom=9,maxZoom=17),
           attribution = '&copy; <a href=" ">高德地图</a >',  )%>%
  addGeoJSON(jsonlite::fromJSON("geometryProvince/31.json",simplifyVector=F))


library(rgdal)

# From http://data.okfn.org/data/datasets/geo-boundaries-world-110m
countries <- readOGR("china.json", "OGRGeoJSON")
map <- leaflet(countries)
map %>%addTiles()%>%
  addPolygons(stroke = T,
              smoothFactor = 0.2,
              fillOpacity = 1)

topoData <- readLines("counti.geojson") %>% paste(collapse = "\n")

leaflet() %>% setView(lng = -98.583, lat = 39.833, zoom = 3) %>%
  addTiles() %>%
  addGeoJSON(topoData, weight = 1, color = "#444444", fill = FALSE)

leaflet() %>% setView(lng = -98.583, lat = 39.833, zoom = 3) %>%
addTiles('http://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
         tileOptions(tileSize=256,  minZoom=9,maxZoom=17),
         attribution = '&copy; <a href=" ">高德地图</a >',  )%>%
  addGeoJSON(topoData, weight = 1, color = "#444444", fill = FALSE)




library(leaflet)
topoData <- readLines("geometryProvince/city.json") %>% paste(collapse = "\n")

leaflet() %>% setView(lng = -98.583, lat = 39.833, zoom = 3) %>%
  addTiles() %>%
  addGeoJSON(topoData, weight = 1, color = "#444444", fill = FALSE)

library(rgdal)

# From http://data.okfn.org/data/datasets/geo-boundaries-world-110m
countries <- readOGR("geometryProvince/city.json", "OGRGeoJSON")
countries$gdp_md_est = runif(384)
pal <- colorNumeric(
  palette = "Blues",
  domain = countries$gdp_md_est
)
map <- leaflet(countries)
map %>% addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 0.7,
              color = ~pal(gdp_md_est)
  )

library(RODBC)
library(dplyr)
library(jsonlite)
Sys.setlocale("LC_CTYPE","chs")
con = odbcConnect("cn04")
query = "/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
FROM [PIN_Dealer].[dbo].[Transform_DealerList]
where brand in ('Shanghai Volkswagen','FAW Volkswagen (old)','Buick','Beijing Hyundai',
'ShanghaiVolkswagen','FAW Volkswagen','Changan Ford')
and city =N'上海'"
# query = iconv(query,"UTF-8","GB2312")
data = sqlQuery(con,query)
close(con)



head(data)
data$popup = paste0(data$Brand," <br/> Type:",
                    data$Type," <br/> Name:",
                    data$Name)
library(htmltools)

data = data[data$lng>0,]
data = data[!is.na(data$lng),]
data$popup = iconv(data$popup,"GBK","UTF-8")
leaflet(data) %>% addTiles() %>%
  addMarkers(~lng, ~lat, popup = ~htmlEscape(popup))



iconLists = icons(
  iconUrl = ifelse(data$Brand == 'Beijing Hyundai',
                   "img/h.png",
                   ifelse(data$Brand == 'Buick',
                          'img/b.png',
                          ifelse(data$Brand == 'Changan Ford',
                                 'img/f.png',
                                 'img/v.png'
                          ))
  )
)
leaflet(data) %>% addTiles() %>%
  addMarkers(~lng, ~lat, popup = ~popup, icon = iconLists)

