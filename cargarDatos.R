# Cargar datos ------------------------------------------------------------

library(readxl)
library(dplyr)
library(tidyverse)

# Tabla número de días por semana de ejercicio físico
actFisica <- read_excel("INPUT/DATA/Act_Fisica.xlsx", 
                        range = "A7:H70")

# Tabla de enfermedades crónicas
saludMental <- read_excel("INPUT/DATA/s_mental.xlsx", 
                          range = "A7:CS71")

# Tabla satisfacción con las zonas verdes
zonasVerdes <- read_excel("INPUT/DATA/satisf_ZV.xlsx", 
                          range = "A7:F27")



# Creación de tablas ------------------------------------------------------


# * Actividad física ------------------------------------------------------

# Tabla número de días por semana de ejercicio físico durante el tiempo de ocio 
# según sexo y comunidad autónoma. Población de 15 y más años.

AF <-
actFisica %>% 
  slice(3:21) %>% 
  rename(Comunidades = ...1, d1_2 = `1 o 2 días a la semana`, 
         d3_4 = `3 o 4 días a la semana`,
         d5_6 = `5 o 6 días a la semana`,
         d7 = `7 días a la semana`) %>% 
  select(c(1,2,4:7)) %>% 
  pivot_longer(names_to = "Frecuencia", values_to = "Días", cols = c(`d1_2`:`d7`)) %>% 
  group_by(Comunidades) %>% 
  summarise(.data = ., dias_prom = mean(Días, na.rm = TRUE))
  

#AF$Comunidades <- as.factor(AF$Comunidades)
AF
View(AF)  



# * Salud mental ----------------------------------------------------------

# Tabla problemas o enfermedades crónicas o de larga evolución padecidas en los 
# últimos 12 meses y diagnosticadas por un médico según sexo y comunidad autónoma.

SM <- saludMental %>% 
  rename(Comunidades = ...1, depresión = ...60, ansiedad = ...63) %>% 
  pivot_longer(names_to = "Enfermedades", values_to = "Personas", cols = c(depresión, ansiedad)) %>%
  slice(c(7:44)) %>% 
  select(c(1,96,97))
  
SM
View(SM)



# * Satisfacción de zonas verdes ------------------------------------------

# Tabla satisfacción con las zonas verdes y áreas recreativas por CCAA  
# y nivel de satisfacción.

ZV <- zonasVerdes %>% 
  slice(2:20) %>% 
  rename(comunidades = ...1, Valoración = `Valoración media`)

ZV
View(ZV)


# Comprobar que todos los niveles son iguales.

levels(AF$Comunidades)
ZV$comunidades
SM$Comunidades



# Objetivos específicos ---------------------------------------------------


# * Relación entre zonas verdes y actividad física. -----------------------

AF_ZV <-  
  AF %>% 
  select(Comunidades, dias_prom) %>% 
  full_join(x = ., 
            y = ZV %>% 
              select(comunidades, Valoración),
            by = c("Comunidades" = "comunidades"))

AF_ZV 
View(AF_ZV)

 
# Gráfica
AF_ZV %>% 
  filter(Valoración > 4) %>% 
  ggplot(data = ., aes(x = Valoración, y = dias_prom)) +
    geom_point(aes(colour = factor(Comunidades))) +
    geom_smooth() +
    theme_bw()



# * Relación entre actividad física y salud mental. -----------------------

AF_SM <-  
  AF %>% 
  select(Comunidades, dias_prom) %>% 
  full_join(x = ., 
            y = SM %>% 
              select(Comunidades, Enfermedades, Personas),
            by = "Comunidades")

AF_SM
View(AF_SM)


# Gráfica
AF_SM %>% 
  ggplot(data = ., aes(x = Personas, y = dias_prom)) +
  geom_point(aes(colour = factor(Comunidades))) +
  geom_smooth() +
  theme_bw()# no me pinta la linea



# * Relación entre zonas verdes y salud mental. ---------------------------

ZV_SM <-  
  ZV %>% 
  select(comunidades, Valoración) %>% 
  full_join(x = ., 
            y = SM %>% 
              select(Comunidades, Enfermedades, Personas),
            by = c("comunidades" = "Comunidades"))

ZV_SM
View(ZV_SM)


# Gráfica
ZV_SM %>% 
  filter(Valoración > 4) %>% 
  ggplot(data = ., aes(x = Personas, y = Valoración)) +
  geom_point(aes(colour = factor(comunidades))) +
  geom_smooth() +
  theme_bw()
