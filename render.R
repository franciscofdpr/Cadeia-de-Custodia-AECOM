
library(rmarkdown)
library(openxlsx)
library(tidyverse)
library(knitr)
library(kableExtra)
library(rmarkdown)
library(purrr)
library(tinytex)
library(pandoc)
library(janitor)
library(chron)


dados = read.xlsx("C:\\Users\\RibeiroF\\OneDrive - AECOM\\Francisco\\Área de Trabalho\\Atividades\\Agro\\COC Agro\\Coc Agro Matriz Não Carnes\\unificado_geral.xlsx")

dados = dados %>%
  clean_names()%>%
  dplyr::mutate(data = as.numeric(data),
                data = as.Date(data, format = "%d/%m/%Y", origin = "30/12/1899"))%>%
  dplyr::mutate(novadata=paste0(substr(as.character(data),9,10),"/",substr(as.character(data),6,7),"/",substr(as.character(data),1,4)))%>%
  dplyr::select(-data)%>%
  dplyr::mutate(data = novadata)%>%
  dplyr::mutate(data = str_replace_all(data, "NA/NA/NA", "NA"))

purrr::walk(
  .x = dados$amostra,
  ~ rmarkdown::render(
    input = "index.Rmd",
    output_file = glue::glue("{.x}.pdf"),
    params = list(amostra = {.x})
  )
)
