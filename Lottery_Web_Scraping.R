# Clear workspace
rm(list = ls())

# Import Packages
if (!require("rvest")) install.packages("rvest")
if (!require("readr")) install.packages("readr")
if (!require("xml2")) install.packages("xml2")

library("rvest")
library("readr") 
library("xml2")

# Set Working Directoy
setwd("C:/Users/mauri/Desktop/Lottoanalyse/")

# Set Time Period Considered
start <- 1955
end <- 2024

# Set CSS Variables
datum_css <- ".zahlensuche_datum"
gewinnzahl_1_css <- ".zahlensuche_zahl:nth-child(3)"
gewinnzahl_2_css <- ".zahlensuche_zahl:nth-child(4)"
gewinnzahl_3_css <- ".zahlensuche_zahl:nth-child(5)"
gewinnzahl_4_css <- ".zahlensuche_zahl:nth-child(6)"
gewinnzahl_5_css <- ".zahlensuche_zahl:nth-child(7)"
gewinnzahl_6_css <- ".zahlensuche_zahl:nth-child(8)"
superzahl_css <- ".zahlensuche_zz"

lottoZahlenJahre <- rep_len(NA, length(start:end)) %>% as.list()

# Loop through every year considered and read lottery numbers.
for(year in start:end) {
  URL <- paste0("https://www.lottozahlenonline.de/statistik/beide-spieltage/lottozahlen-archiv.php?j=", year, "#lottozahlen-archiv")
  page_lottozahlen <- read_html(URL)
  
  lotto_datum <- html_elements(page_lottozahlen, css = datum_css)
  lotto_gewinnzahl_1 <- html_elements(page_lottozahlen, css = gewinnzahl_1_css)
  lotto_gewinnzahl_2 <- html_elements(page_lottozahlen, css = gewinnzahl_2_css)
  lotto_gewinnzahl_3 <- html_elements(page_lottozahlen, css = gewinnzahl_3_css)
  lotto_gewinnzahl_4 <- html_elements(page_lottozahlen, css = gewinnzahl_4_css)
  lotto_gewinnzahl_5 <- html_elements(page_lottozahlen, css = gewinnzahl_5_css)
  lotto_gewinnzahl_6 <- html_elements(page_lottozahlen, css = gewinnzahl_6_css)
  lotto_superzahl <- html_elements(page_lottozahlen, css = superzahl_css)
  
  lottoZahlenJahre[[year - (start - 1)]] <-
    list(Datum = html_text(lotto_datum),
         GZ_1 = html_text(lotto_gewinnzahl_1),
         GZ_2 = html_text(lotto_gewinnzahl_2),
         GZ_3 = html_text(lotto_gewinnzahl_3),
         GZ_4 = html_text(lotto_gewinnzahl_4),
         GZ_5 = html_text(lotto_gewinnzahl_5),
         GZ_6 = html_text(lotto_gewinnzahl_6),
         Superzahl = html_text(lotto_superzahl))
  
  Sys.sleep(2)
}

# Save data as dataframe
lottoergebnisse <- data.table::rbindlist(lottoZahlenJahre)

# Export data as csv file. 
write.csv(lottoergebnisse, "lottoergebnisse.csv", row.names=FALSE)
