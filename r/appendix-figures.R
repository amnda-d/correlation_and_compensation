library(tidyverse)
library(ggthemes)
library(lme4)
library(broom.mixed)
library(ggeffects)

source("r/util.R")

# load and process data

exclude_langs <- c(
  "Bengali",
  "Cebuano",
  "Hindi",
  "Indonesian",
  "Kabardian",
  "Kashubian",
  "Kyrgyz",
  "Maltese",
  "Maori",
  "Oromo",
  "Shona",
  "Swahili",
  "Tagalog",
  "Telugu",
  "Turkmen",
  "Urdu",
  "Uyghur",
  "Tajik",
  "Gothic"
)

data <- read.csv("data/processed.tsv", sep = "\t")

data$simple_pos <- data$pos
data$simple_pos <- case_match(
  data$simple_pos,
  "N" ~ "N",
  "V" ~ "V",
  "ADJ" ~ "ADJ",
  "V.CVB" ~ "V",
  "V.MSDR" ~ "V",
  "V.PTCP" ~ "V",
  .default = "X"
)
data$pos <- as.factor(data$pos)
data$simple_pos <- as.factor(data$simple_pos)

data$lang <- code_to_name(data$lang)
data <- data %>% filter(!(lang %in% exclude_langs))
data$lang <- as.factor(data$lang)
data <- data %>% filter(count > 0)
data <- data %>% filter(!is.na(phon_loss))

include_langs <- c(
  "Albanian",
  "Amharic",
  "Azerbaijani",
  "Catalan",
  "Czech",
  "Dutch",
  "English",
  "French",
  "German",
  "Hungarian",
  "Italian",
  "Mongolian",
  "Polish",
  "Portuguese",
  "Romanian",
  "Russian",
  "Serbo Croatian",
  "Spanish",
  "Swedish",
  "Turkish",
  "Ukrainian",
  "Zulu",
  "Kazakh",
  "Chewa",
  "Uzbek"
)

data_pim <- read.csv(
  "data/phono-lang-results.csv"
)
data_pim$lang <- code_to_name(data_pim$lang)
data_pim <- data_pim %>% filter(lang %in% include_langs)
data_pim$lang <- as.factor(data_pim$lang)

data_words_pim <- read.csv(
  "data/phono-results.csv"
)
data_words_pim$lang <- code_to_name(data_words_pim$lang)
data_words_pim <- data_words_pim %>% filter(lang %in% include_langs)
data_words_pim$lang <- as.factor(data_words_pim$lang)
data_g2p <- data %>% filter(morph_complexity != "NA") %>% transform_data()
data_g2p$type <- lang_to_type(as.character(data_g2p$lang))
data_base_g2p <- group_by_base(data_g2p) %>% transform_data()
data_base_g2p$type <- lang_to_type(as.character(data_base_g2p$lang))

# three language plots

# PC ~ MI
plot_langs <- data_g2p %>%
  filter(lang %in% c("Polish", "English", "Romanian"))
plot_langs_base <- data_base_g2p %>%
  filter(lang %in% c("Polish", "English", "Romanian"))

plot_lang_facet_2(
  data1 = plot_langs,
  data2 = plot_langs_base,
  x_axis = "phon_loss",
  y_axis = "morph_complexity",
  x_lab = "Phonotactic Complexity",
  y_lab = "Morphological Irregularity",
  lab1 = "By Word",
  lab2 = "By Lemma",
  fill1 = "#1A4571",
  fill2 = "#FF5A48",
  color1 = "#073361",
  color2 = "#FF1E06",
  frm = formula(morph_complexity ~ phon_loss + logfreq + phon_len)
)
ggsave("figs-final/appendix_pc_mi.png", width = 20, height = 14, units = "cm")

# PC ~ WL
data_words_pim$phon_loss <- data_words_pim$phoneme_loss
data_words_pim$phon_len <- data_words_pim$phoneme_len
plot_langs <- data_g2p %>%
  filter(lang %in% c("Chewa", "Italian", "English"))
plot_langs_pim <- data_words_pim %>%
  filter(lang %in% c("Chewa", "Italian", "English"))

plot_lang_facet_2(
  data2 = plot_langs_pim,
  data1 = plot_langs,
  x_axis = "phon_len",
  y_axis = "phon_loss",
  y_lab = "Phonotactic Complexity",
  x_lab = "Word Length",
  lab2 = "Phonotactic Data",
  lab1 = "UniMorph Data",
  fill1 = "#482C7B",
  fill2 = "#FF6B00",
  color1 = "#2F0086",
  color2 = "#B54C00",
  formula(phon_loss ~ phon_len)
)
ggsave("figs-final/appendix_pc_wl.png", width = 20, height = 14, units = "cm")


# MI ~ FR
plot_langs <- data_g2p %>%
  filter(lang %in% c("Turkish", "Italian", "English"))
plot_langs_base <- data_base_g2p %>%
  filter(lang %in% c("Turkish", "Italian", "English"))

plot_lang_facet_2(
  data2 = plot_langs_base,
  data1 = plot_langs,
  x_axis = "logfreq",
  y_axis = "morph_complexity",
  y_lab = "Morphological Irregularity",
  x_lab = "Log Frequency",
  lab2 = "By Lemma",
  lab1 = "By Word",
  fill1 = "#1A4571",
  fill2 = "#FF5A48",
  color1 = "#073361",
  color2 = "#FF1E06",
  formula(morph_complexity ~ logfreq)
)
ggsave("figs-final/appendix_mi_fr.png", width = 20, height = 14, units = "cm")

# PC ~ FR
plot_langs <- data_g2p %>%
  filter(lang %in% c("Russian", "Italian", "English"))

plot_lang_facet(
  plot_langs,
  "logfreq",
  "phon_loss",
  "Log Frequency",
  "Phonotactic Complexity",
  formula(phon_loss ~ logfreq + phon_len)
)
ggsave("figs-final/appendix_pc_fr.png", width = 20, height = 14, units = "cm")

# MI ~ WL
plot_langs <- data_g2p %>%
  filter(lang %in% c("Czech", "Italian", "English"))
plot_langs_base <- data_base_g2p %>%
  filter(lang %in% c("Czech", "Italian", "English"))

plot_lang_facet_2(
  data2 = plot_langs_base,
  data1 = plot_langs,
  x_axis = "phon_len",
  y_axis = "morph_complexity",
  y_lab = "Morphological Irregularity",
  x_lab = "Word Length",
  lab2 = "By Lemma",
  lab1 = "By Word",
  fill1 = "#1A4571",
  fill2 = "#FF5A48",
  color1 = "#073361",
  color2 = "#FF1E06",
  formula(morph_complexity ~ phon_len + logfreq)
)
ggsave("figs-final/appendix_mi_wl.png", width = 20, height = 14, units = "cm")

# WL ~ FR
plot_langs <- data_g2p %>%
  filter(lang %in% c("Kazakh", "Russian", "English"))

plot_lang_facet(
  plot_langs,
  "logfreq",
  "phon_len",
  "Log Frequency",
  "Word Length",
  formula(phon_len ~ logfreq))
ggsave("figs-final/appendix_wl_fr.png", width = 20, height = 14, units = "cm")



# all language plots
# PC ~ MI
plot_lang_facet_2(
  data1 = data_g2p,
  data2 = data_base_g2p,
  x_axis = "phon_loss",
  y_axis = "morph_complexity",
  x_lab = "Phonotactic Complexity",
  y_lab = "Morphological Irregularity",
  lab2 = "By Lemma",
  lab1 = "By Word",
  fill1 = "#1A4571",
  fill2 = "#FF5A48",
  color1 = "#073361",
  color2 = "#FF1E06",
  frm = formula(morph_complexity ~ phon_loss + logfreq + phon_len)
)
ggsave("figs-final/appendix_pc_mi_all.png", width = 7, height = 10)

# PC ~ WL
plot_lang_facet_2(
  data2 = data_words_pim,
  data1 = data_g2p,
  x_axis = "phon_len",
  y_axis = "phon_loss",
  y_lab = "Phonotactic Complexity",
  x_lab = "Word Length",
  lab2 = "Phonotactic Data",
  lab1 = "UniMorph Data",
  fill1 = "#482C7B",
  fill2 = "#FF6B00",
  color1 = "#2F0086",
  color2 = "#B54C00",
  formula(phon_loss ~ phon_len)
)
ggsave("figs-final/appendix_pc_wl_all.png", width = 7, height = 10)


# MI ~ FR
plot_lang_facet_2(
  data1 = data_g2p,
  data2 = data_base_g2p,
  x_axis = "logfreq",
  y_axis = "morph_complexity",
  y_lab = "Morphological Irregularity",
  x_lab = "Log Frequency",
  lab2 = "By Lemma",
  lab1 = "By Word",
  fill1 = "#1A4571",
  fill2 = "#FF5A48",
  color1 = "#073361",
  color2 = "#FF1E06",
  formula(morph_complexity ~ logfreq)
)
ggsave("figs-final/appendix_mi_fr_all.png", width = 7, height = 10)

# PC ~ FR
plot_lang_facet(
  data_g2p,
  "logfreq",
  "phon_loss",
  "Log Frequency",
  "Phonotactic Complexity",
  formula(phon_loss ~ logfreq + phon_len)
)
ggsave("figs-final/appendix_pc_fr_all.png", width = 7, height = 10)

# MI ~ WL
plot_lang_facet_2(
  data1 = data_g2p,
  data2 = data_base_g2p,
  x_axis = "phon_len",
  y_axis = "morph_complexity",
  y_lab = "Morphological Irregularity",
  x_lab = "Word Length",
  lab2 = "By Lemma",
  lab1 = "By Word",
  fill1 = "#1A4571",
  fill2 = "#FF5A48",
  color1 = "#073361",
  color2 = "#FF1E06",
  formula(morph_complexity ~ phon_len + logfreq)
)
ggsave("figs-final/appendix_mi_wl_all.png", width = 7, height = 10)

# WL ~ FR
plot_lang_facet(
  data_g2p,
  "logfreq",
  "phon_len",
  "Log Frequency",
  "Word Length",
  formula(phon_len ~ logfreq))
ggsave("figs-final/appendix_wl_fr_all.png", width = 7, height = 10)