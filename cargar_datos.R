library(readr)
saludM <- read_delim("INPUT/DATA/depresion_ansiedad.csv", 
                                 delim = ";", escape_double = FALSE, trim_ws = TRUE)

library(readxl)
ansiedadDepresion <- read_excel("INPUT/DATA/ansiedas.xlx.xlsx")

ansiedadDepresion

library(readxl)
zonasVerdes <- read_excel("INPUT/DATA/zonas_verdes_xlsx.xlsx")

zonasVerdes


library(readxl)
ejercicioDias <- read_excel("INPUT/DATA/ejercicio_dias_xlsx.xlsx")

ejercicioDias
