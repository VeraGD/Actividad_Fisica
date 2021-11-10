# Cargar datos ------------------------------------------------------------

# Tabla número de días por semana de ejercicio físico durante el tiempo de ocio según sexo y comunidad autónoma. Población de 15 y más años.
library(readxl)
library(dplyr)
library(tidyverse)

actFisica <- read_excel("INPUT/DATA/Act_Fisica.xlsx", 
                        range = "A7:H70")

AF <-
actFisica %>% 
  slice(3:21) %>% 
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
SM <- saludMental %>% 
  rename(Comunidades = ...1, depresión = ...60, ansiedad = ...63) %>% 
  slice(c(4:22))
  

# select(c(1,60,63))  
SM
View(SM)

# Tabla satisfacción con las zonas verdes y áreas recreativas por CCAA  y nivel de satisfacción.
library(readxl)
zonasVerdes <- read_excel("INPUT/DATA/satisf_ZV.xlsx", 
                          range = "A7:F27")
ZV <- zonasVerdes %>% 
  slice(2:20) %>% 
  rename(comunidades = ...1, Valoración = `Valoración media`)
  

# select(c(1,6)) 

ZV
View(ZV)

# Comprobar que todos los niveles son iguales.

levels(AF$Comunidades)
ZV$Comunidades
SM$Comunidades


# Relación entre zonas verdes y actividad física.

AF_ZV <-  
  AF %>% 
  select(Comunidades, Frecuencia, Días) %>% 
  full_join(x = ., 
            y = ZV %>% 
              select(comunidades, Valoración),
            by = c("Comunidades" = "comunidades"))

AF_ZV 
View(AF_ZV)

 #ggplot(data = AF_ZV, aes (x  = Comunidades))+
  #geom_bar(aes(fill = Valoración))

#ggplot(data = AF_ZV, aes(x = Valoración, y = Días)) +
  #geom_point(aes(colour = factor(Comunidades))) +
  #geom_smooth()



AF_ZV %>% 
  filter(Valoración > 4) %>% 
  ggplot(data = ., aes(x = Valoración, y = Días)) +
    geom_point(colour = "red") +
    geom_smooth() +
    theme_bw()

#levels(AF_ZV$Comunidades)

# Relación entre actividad física y salud mental.
AF_SM <-  
  AF %>% 
  select(Comunidades, Frecuencia, Días) %>% 
  full_join(x = ., 
            y = SM %>% 
              select(Comunidades, depresión, ansiedad),
            by = "Comunidades")

AF_SM
View(AF_SM)

AF_SM %>% 
  ggplot(data = ., aes(x = ansiedad, y = Días)) +
  geom_point(colour = "red") +
  geom_smooth() +
  theme_bw() # no me pinta la linea


AF_SM %>% 
  ggplot(data = ., aes(x = depresión, y = Días)) +
  geom_point(colour = "red") +
  geom_smooth() +
  theme_bw()

# Relación entre zonas verdes y salud mental.

ZV_SM <-  
  ZV %>% 
  select(comunidades, Valoración) %>% 
  full_join(x = ., 
            y = SM %>% 
              select(Comunidades, depresión, ansiedad),
            by = c("comunidades" = "Comunidades"))

ZV_SM
View(ZV_SM)


