# Cargar datos ------------------------------------------------------------

# Tabla número de días por semana de ejercicio físico durante el tiempo de ocio según sexo y comunidad autónoma. Población de 15 y más años.
library(readxl)
library(dplyr)
actFisica <- read_excel("INPUT/DATA/Act_Fisica.xlsx", 
                        range = "A7:H70")


actFisica <- slice(.data = actFisica, 2:21)

AF <- pivot_longer(data = actFisica, names_to = "Frecuencia", values_to = "Valores", cols = c(`Ninguno`:`No consta`))

names(AF) <- c("Comunidades","Total","Frecuencia","Valores")

AF <- select(.data = AF, c(1,3:4))

View(AF)

# Tabla problemas o enfermedades crónicas o de larga evolución padecidas en los últimos 12 meses y diagnosticadas por un médico según sexo y comunidad autónoma.

library(readxl)
saludMental <- read_excel("INPUT/DATA/s_mental.xlsx", 
                          range = "A7:CS71")

saludMental
View(saludMental)

# Tabla satisfacción con las zonas verdes y áreas recreativas por CCAA  y nivel de satisfacción.
library(readxl)
zonasVerdes <- read_excel("INPUT/DATA/satisf_ZV.xlsx", 
                          range = "A7:F27")

zonasVerdes
View(zonasVerdes)

