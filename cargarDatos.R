# Cargar datos ------------------------------------------------------------

# Tabla número de días por semana de ejercicio físico durante el tiempo de ocio según sexo y comunidad autónoma. Población de 15 y más años.
library(readxl)
library(dplyr)
library(tidyverse)

actFisica <- read_excel("INPUT/DATA/Act_Fisica.xlsx", 
                        range = "A7:H70")

AF <-
actFisica %>% 
  slice(2:21) %>% 
  rename(Comunidades = ...1, d1_2 = `1 o 2 días a la semana`, 
         d3_4 = `3 o 4 días a la semana`,
         d5_6 = `5 o 6 días a la semana`,
         d7 = `7 días a la semana`) %>% 
  pivot_longer(names_to = "Frecuencia", values_to = "Días", cols = c(`Ninguno`:`No consta`)) 
  

AF$Comunidades <- as.factor(AF$Comunidades)

View(AF)  

# Tabla problemas o enfermedades crónicas o de larga evolución padecidas en los últimos 12 meses y diagnosticadas por un médico según sexo y comunidad autónoma.

library(readxl)
library(dplyr)

saludMental <- read_excel("INPUT/DATA/s_mental.xlsx", 
                          range = "A7:CS71")

saludMental <- slice(.data = saludMental, c(3:22))


SM <- select(.data = saludMental, c(1,60,63))
names(SM) <- c("Comunidades","Depresión","Ansiedad")

SM
View(SM)

# Tabla satisfacción con las zonas verdes y áreas recreativas por CCAA  y nivel de satisfacción.
library(readxl)
zonasVerdes <- read_excel("INPUT/DATA/satisf_ZV.xlsx", 
                          range = "A7:F27")
ZV <- select(.data = zonasVerdes, c(1,6))
names(ZV) <- c("Comunidades","Valoración")
ZV
View(ZV)

# Comprobar que todos los niveles son iguales.

levels(AF$Comunidades)
ZV$Comunidades
SM$Comunidades

# Relación entre zonas verdes y actividad física.

AF_ZV <- left_join(x = AF, y = ZV, by = c("Comunidades"))
View(AF_ZV)

levels(AF_ZV$Comunidades)

# Relación entre actividad física y salud mental.
AF_SM <- left_join(x = AF, y = SM, by = c("Comunidades"))
View(AF_SM)

# Relación entre zonas verdes y salud mental.
ZV_SM <- left_join(x = ZV, y = SM, by = c("Comunidades"))
View(ZV_SM)


