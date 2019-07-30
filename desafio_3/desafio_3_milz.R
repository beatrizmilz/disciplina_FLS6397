# Carregar as bibliotecas ---------------------
library(tidyverse)
library(janitor)
library(readr)

# Download das bases --------------

## MUNIC15 
url_MUNIC15 <- "https://raw.githubusercontent.com/leobarone/FLS6397/master/data/Base_MUNIC_2015_xls.zip"

download.file(url = url_MUNIC15, destfile = "desafio_3/data_raw/Base_MUNIC_2015.zip")

unzip(zipfile = "desafio_3/data_raw/Base_MUNIC_2015.zip", exdir = "data_raw")

## DATASUS
url_DATASUS <- "https://raw.githubusercontent.com/JonnyPhillips/FLS6397_2019/master/data/data_sus.csv"
download.file(url = url_DATASUS, destfile = "desafio_3/data_raw/data_sus.csv")

## FINBRA
url_FINBRA <- "https://raw.githubusercontent.com/leobarone/FLS6397/master/data/receitas_orc_finbra.zip"
download.file(url = url_FINBRA, destfile = "desafio_3/data_raw/receitas_orc_finbra.zip")
unzip(zipfile = "desafio_3/data_raw/receitas_orc_finbra.zip", exdir = "data_raw")

# Leitura dos dados -----------------------------

## data_sus
data_sus <- read_csv(file = "desafio_3/data_raw/data_sus.csv", locale = locale(encoding = "ISO-8859-1"))
data_sus2 <- data_sus %>% janitor::clean_names()

## munic15
munic15 <- readxl::read_excel("desafio_3/data_raw/Base_MUNIC_2015.xls", 
                              sheet = "Articulação interinstitucional")

munic15_2 <- munic15 %>% janitor::clean_names()

## finbra
finbra <- read_delim("desafio_3/data_raw/finbra.csv", 
                     ";", escape_double = FALSE, locale = locale(encoding = "ISO-8859-1"), 
                     trim_ws = TRUE, skip = 3)

finbra2 <- finbra %>%  janitor::clean_names()


## Arrumar colunas -----------------------------------

finbra2$cod_ibge <- as.numeric(substr(finbra2$cod_ibge, 1, 6))

munic15_3 <- munic15_2 %>% unite("cod_ibge", codigouf, codigomunicipio, sep = "")

munic15_3$cod_ibge <- as.numeric(substr(munic15_3$cod_ibge, 1, 6))


## Juntar as tabelas -----------------------------------
datasus_finbra <- inner_join(data_sus2, finbra2, by = "cod_ibge")

datasus_finbra_munic15 <- inner_join(datasus_finbra, munic15_3, by = "cod_ibge")


## salvar base ------------
saveRDS(datasus_finbra_munic15, file = "desafio_3/data_output/database.rds")

database <- readRDS("desafio_3/data_output/database.rds")
