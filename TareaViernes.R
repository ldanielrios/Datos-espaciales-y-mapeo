#Establecer directorio
setwd("C:/Users/ldani/OneDrive/Escritorio/R/Siste/DATA _ R SISTES")

#Paquetes
library(ggplot2)  # ggplot() fortify()
library(dplyr)  # %>% select() filter() bind_rows()
library(rgdal)  # readOGR() spTransform()
library(raster)  # intersect()
library(ggsn)  # north2() scalebar()
library(rworldmap)  # getMap()

#Datos por especie
Fpendul <- read.csv("F.pendul.csv", sep = ",",row.names = NULL)
Pcarinat <- read.csv("P.carinat.csv", sep = ",")
Pfelic <- read.csv("P.felic.csv", sep = ",")
vars <- c("scientificName", "decimalLongitude",
          "decimalLatitude")
Pcarinat_trim <- Pcarinat %>% dplyr::select(one_of(vars))
Pfelic_trim <- Pfelic %>% dplyr::select(one_of(vars))
Fpendul_trim <- Fpendul %>% dplyr::select(one_of(vars))

#Archivos shape por países. 
Bra_shp <- shapefile("C:/Users/ldani/OneDrive/Escritorio/R/Siste/DATA _ R SISTES/BRA_adm1.shp")
Bol_shp <- shapefile("C:/Users/ldani/OneDrive/Escritorio/R/Siste/DATA _ R SISTES/BOL_adm1.shp")


#Mapa con archivos shape y ocurrencia de especies. 
(sp_map <- ggplot() + 
    geom_polygon(data = Bra_shp,
                 aes(x = long, y = lat, group = group),
                 fill = NA, colour = "black") +
    geom_polygon(data = Bol_shp,
                     aes(x = long, y = lat, group = group),
                     fill = NA, colour = "black") +
    geom_point(colour = "blue", alpha = 0.5,
               aes(x = decimalLongitude, y = decimalLatitude),
               data = Fpendul_trim) +
    geom_point(colour = "red", alpha = 0.5,
                   aes(x = decimalLongitude, y = decimalLatitude),
                   data = Pcarinat_trim) +
    theme_bw() +
    xlab("Longitude") +
    ylab("Latitude") + 
    coord_quickmap())

#Mapa generado en R con ocurrencia de especies.
world <- getMap(resolution = "low")
saf_countries <- c("Brazil","Bolivia")
world_saf <- world[world@data$ADMIN %in% saf_countries, ]
(sp_map <- ggplot() + 
        geom_polygon(data = world_saf,
                     aes(x = long, y = lat, group = group),
                     fill = NA, colour = "black") + 
        geom_point(colour = "blue", alpha = 0.5,
                   aes(x = decimalLongitude, y = decimalLatitude),
                   data = Fpendul_trim) +
        geom_point(colour = "red", alpha = 0.5,
                   aes(x = decimalLongitude, y = decimalLatitude),
                   data = Pcarinat_trim) +
        theme_bw() +
        xlab("Longitude") +
        ylab("Latitude") + 
        coord_quickmap())


#Mapa a partir de archivo shape con ecoregiones de Morroney ocurrencia de especies.
Morrone_shp <- shapefile("C:/Users/ldani/OneDrive/Escritorio/R/Siste/DATA _ R SISTES/Lowenberg_Neto_2014.shp")
Morrone <- fortify(Morrone_shp, region = "Subregio_1")
(map_Morrone <- ggplot() +
        geom_polygon(data = Morrone,
                     aes(x = long, y = lat, group = group, fill = id),
                     color = "black", size = 0.5) +
        geom_point(colour = "blue", alpha = 0.5,
                   aes(x = decimalLongitude, y = decimalLatitude),
                   data = Fpendul_trim) +
        geom_point(colour = "red", alpha = 0.5,
                   aes(x = decimalLongitude, y = decimalLatitude),
                   data = Pcarinat_trim) +
        theme_classic() +
        theme(legend.position="bottom") +
        theme(legend.title=element_blank()) + 
        xlab("Longitude") +
        ylab("Latitude") + 
        coord_quickmap())
