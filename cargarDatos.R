# Cargar datos ------------------------------------------------------------

library(readxl)
library(dplyr)
library(tidyverse)

# Tabla número de días por semana de ejercicio físico
actFisica <- read_excel("INPUT/DATA/Act_Fisica.xlsx", 
                        range = "A7:H70")

# Tabla de enfermedades crónicas
saludMental <- read_excel("INPUT/DATA/s_mental.xlsx", 
                          range = "A9:CS71")


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
  rename(Comunidades = ...1,
         d1_2 = `1 o 2 días a la semana`, 
         d3_4 = `3 o 4 días a la semana`,
         d5_6 = `5 o 6 días a la semana`,
         d7 = `7 días a la semana`) %>% 
  select(c(1,4:7)) %>% 
  pivot_longer(names_to = "Frecuencia", values_to = "AF_pers", cols = c(d1_2:`d7`)) 
 
  

AF
View(AF)  

# Gráfico vista general de actividad física
AF%>% 
  ggplot(data = ., aes(x = Frecuencia, y = AF_pers)) +
  geom_violin(aes(fill=AF_pers))+
  theme_bw() +
  labs(
    x = "Frecuencia de actividad física",
    y = "Numero de personas",
    title = "Frecuencia de actividad física ",
    colour = "Comunidades Autónomas"
  )

# En general la gente realiza ejercicio de 3 a 4 días a la semana.



# * Salud mental ----------------------------------------------------------

# Tabla problemas o enfermedades crónicas o de larga evolución padecidas en los 
# últimos 12 meses y diagnosticadas por un médico según sexo y comunidad autónoma.

SM <- 
  saludMental %>% 
  rename(Comunidades = "Ambos sexos", depresión = ...60, ansiedad = ...63) %>% 
  pivot_longer(names_to = "Enfermedades", values_to = "SM_pers", cols = c(depresión, ansiedad)) %>%
  slice(c(3:44)) %>% 
  select(c(1,96,97)) 
  
SM
View(SM)



# * Satisfacción de zonas verdes ------------------------------------------

# Tabla satisfacción con las zonas verdes y áreas recreativas por CCAA  
# y nivel de satisfacción.

ZV <- zonasVerdes %>% 
  slice(2:20) %>% 
  rename(comunidades = ...1, Valoracion = `Valoración media`)

ZV
View(ZV)


# Comprobar que todos los niveles son iguales.

levels(factor(AF$Comunidades))
levels(factor(ZV$comunidades))
levels(factor(SM$Comunidades))



# Objetivos específicos ---------------------------------------------------


# * Relación entre zonas verdes y actividad física. -----------------------


AF_ZV

# tabla completa
AF_ZV <-  
  AF %>% 
  select(Comunidades, Frecuencia, AF_pers) %>% 
  full_join(x = ., 
            y = ZV %>% 
              select(comunidades, Valoracion),
            by = c("Comunidades" = "comunidades"))

AF_ZV 
View(AF_ZV)

 
# Gráfica 

AF_ZV %>% 
  filter(Valoracion > 4) %>% 
  ggplot(data = ., aes(x = AF_pers, y = Valoracion)) +
  geom_point() +
  geom_smooth(method = "lm", aes(colour = factor(Frecuencia)), level = 0.3) +
  theme_bw() +
  labs(
    x = "Nº de personas que hace ejercicio",
    y = "Valoracion de zonas verdes",
    title = "Relación actividad física y zonas verdes ",
    colour = "Días ejercicio"
    
  )



# * Relación entre actividad física y salud mental. -----------------------

AF_SM <-  
  AF %>% 
  select(Comunidades, Frecuencia, AF_pers) %>% 
  full_join(x = ., 
            y = SM %>% 
              select(Comunidades, Enfermedades, SM_pers),
            by = "Comunidades") %>% 
  drop_na()

AF_SM
View(AF_SM)


# Gráfica

AF_SM %>% 
  ggplot(data = ., aes(x = AF_pers, y = SM_pers))+ 
  geom_point() +
  geom_smooth(method = "lm", aes(colour = factor(Frecuencia)), level = 0.2) + 
  theme_bw() +
  facet_wrap( ~ Enfermedades, nrow = 2) +
  labs(
    x = "Nº de personas que hace ejercicio",
    y = "% de personas con trastorno",
    title = "Relación actividad física y salud mental ",
    colour = "Días de ejercicio"
    
  )




# * Relación entre zonas verdes y salud mental. ---------------------------

ZV_SM <-  
  ZV %>% 
  select(comunidades, Valoracion) %>% 
  full_join(x = ., 
            y = SM %>% 
              select(Comunidades, Enfermedades, SM_pers),
            by = c("comunidades" = "Comunidades"))

ZV_SM
View(ZV_SM)


# Gráfica
ZV_SM %>% 
  filter(Valoracion > 4) %>% 
  ggplot(data = ., aes(x = SM_pers, y = Valoracion)) +
  geom_point(aes(colour = factor(comunidades)), 
             show.legend = FALSE) +
  geom_smooth() +
  theme_bw() +
  facet_wrap( ~ Enfermedades, nrow = 1) +
  labs(
    x = "% personas con trastorno mental ",
    y = "Valoración zonas verdes",
    title = "Relación zonas verdes y salud mental ",
    colour = "Comunidades Autónomas"
    
  )
