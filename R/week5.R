# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
Adata_tbl <- read_delim("../data/Aparticipants.dat", delim = "-", col_names = c("casenum", "parnum", "stimver", "datadate", "qs"))
Anotes_tbl <- read_csv("../data/Anotes.csv")
Bdata_tbl <- read_tsv("../data/Bparticipants.dat", col_names = c("casenum", "parnum", "stimver", "datadate", paste0("q",1:10)))
Bnotes_tbl <- read_tsv("../data/Bnotes.txt", col_names = TRUE, col_types = "ic") # One of these needs to be read_table() or read_fwf()

# Data Cleaning
Aclean_tbl <- Adata_tbl %>% 
  separate(qs, into = paste0("q", 1:5), sep = "-") %>% 
  mutate(datadate = mdy_hms(datadate)) %>% 
  mutate(across(q1:q5, as.integer)) %>%
  left_join(Anotes_tbl, by = "parnum") %>% 
  filter(is.na(notes))
ABclean_tbl <- Bdata_tbl %>% 
  mutate(datadate = mdy_hms(datadate)) %>% 
  mutate(across(q1:q10, as.integer)) %>%
  left_join(Bnotes_tbl, by = "parnum") %>%
  filter(is.na(notes)) %>% 
  bind_rows(mutate(Aclean_tbl, lab = "A")) %>% replace_na(list(lab = "B")) %>% 
  select(-notes)
