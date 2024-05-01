library(tidyverse)
library(ggthemes)
library(lme4)
library(broom.mixed)

source("r/util.R")

# load and process data

exclude_langs <- c(
  "Bengali",
  "Cebuano",
  "Hindi",
  "Indonesian",
  "Kabardian",
  "Kashubian",
  "Kazakh",
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
  "Uzbek",
  "Chewa",
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
  "Khalka Mongolian",
  "Polish",
  "Portuguese",
  "Romanian",
  "Russian",
  "Serbo Croatian",
  "Spanish",
  "Swedish",
  "Turkish",
  "Ukranian",
  "Zulu"
)

data_pim <- read.csv(
  "scil-phonotactic-complexity/results/northeuralex/cv/orig/phoible__results-final.csv"
)
data_pim$lang <- code_to_name(data_pim$lang)
data_pim <- data_pim %>% filter(lang %in% include_langs)
data_pim$lang <- as.factor(data_pim$lang)

data_words_pim <- read.csv(
  "scil-phonotactic-complexity/results/northeuralex/cv/orig/phoible__results-per-word.csv"
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
  filter(lang %in% c("Hungarian", "English", "Romanian"))
plot_langs_base <- data_base_g2p %>%
  filter(lang %in% c("Hungarian", "English", "Romanian"))

plot_lang_facet_2(
  data1 = plot_langs_base,
  data2 = plot_langs,
  x_axis_1 = "phon_loss",
  y_axis_1 = "morph_complexity",
  x_axis_2 = "phon_loss",
  y_axis_2 = "morph_complexity",
  x_lab = "Phonotactic Complexity",
  y_lab = "Morphological Irregularity",
  lab1 = "By Lexeme",
  lab2 = "By Word",
  color1 = "#1A4571",
  color2 = "#FF5A48",
  color1_dark = "#073361",
  color2_dark = "#FF1E06"
)
ggsave("figs-final/appendix_pc_mi.png", width = 6, height = 4)

# PC ~ WL
plot_langs <- data_g2p %>%
  filter(lang %in% c("Polish", "Romanian", "English"))
plot_langs_pim <- data_words_pim %>%
  filter(lang %in% c("Polish", "Romanian", "English"))

plot_lang_facet_2(
  data1 = plot_langs_pim,
  data2 = plot_langs,
  x_axis_1 = "phoneme_loss",
  y_axis_1 = "phoneme_len",
  x_axis_2 = "phon_loss",
  y_axis_2 = "phon_len",
  x_lab = "Phonotactic Complexity",
  y_lab = "Word Length",
  lab1 = "Phonotactic Data",
  lab2 = "UniMorph Data",
  color1 = "#482C7B",
  color2 = "#FF6B00",
  color1_dark = "#2F0086",
  color2_dark = "#B54C00"
)
ggsave("figs-final/appendix_pc_wl.png", width = 6, height = 4)


# MI ~ FR
plot_langs <- data_g2p %>%
  filter(lang %in% c("Turkish", "Italian", "English"))
plot_langs_base <- data_base_g2p %>%
  filter(lang %in% c("Turkish", "Italian", "English"))

plot_lang_facet_2(
  data1 = plot_langs_base,
  data2 = plot_langs,
  x_axis_1 = "morph_complexity",
  y_axis_1 = "logfreq",
  x_axis_2 = "morph_complexity",
  y_axis_2 = "logfreq",
  x_lab = "Morphological Irregularity",
  y_lab = "Log Frequency",
  lab1 = "By Lexeme",
  lab2 = "By Word",
  color1 = "#1A4571",
  color2 = "#FF5A48",
  color1_dark = "#073361",
  color2_dark = "#FF1E06"
)
ggsave("figs-final/appendix_mi_fr.png", width = 6, height = 4)

# PC ~ FR
plot_langs <- data_g2p %>%
  filter(lang %in% c("Hungarian", "Swedish", "English"))

plot_lang_facet(
  plot_langs,
  "phon_loss",
  "logfreq",
  "Phonotactic Complexity",
  "Log Frequency"
)
ggsave("figs-final/appendix_pc_fr.png", width = 6, height = 4)

# MI ~ WL
plot_langs <- data_g2p %>%
  filter(lang %in% c("Czech", "Italian", "English"))
plot_langs_base <- data_base_g2p %>%
  filter(lang %in% c("Czech", "Italian", "English"))

plot_lang_facet_2(
  data1 = plot_langs_base,
  data2 = plot_langs,
  x_axis_1 = "morph_complexity",
  y_axis_1 = "phon_len",
  x_axis_2 = "morph_complexity",
  y_axis_2 = "phon_len",
  x_lab = "Morphological Irregularity",
  y_lab = "Word Length",
  lab1 = "By Lexeme",
  lab2 = "By Word",
  color1 = "#1A4571",
  color2 = "#FF5A48",
  color1_dark = "#073361",
  color2_dark = "#FF1E06"
)
ggsave("figs-final/appendix_mi_wl.png", width = 6, height = 4)

# WL ~ FR
plot_langs <- data_g2p %>%
  filter(lang %in% c("Albanian", "Mongolian", "English"))

plot_lang_facet(
  plot_langs,
  "logfreq",
  "phon_len",
  "Log Frequency",
  "Word Length")
ggsave("figs-final/appendix_wl_fr.png", width = 6, height = 4)



# all language plots
# PC ~ MI
plot_lang_facet_2(
  data1 = data_base_g2p,
  data2 = data_g2p,
  x_axis_1 = "phon_loss",
  y_axis_1 = "morph_complexity",
  x_axis_2 = "phon_loss",
  y_axis_2 = "morph_complexity",
  x_lab = "Phonotactic Complexity",
  y_lab = "Morphological Irregularity",
  lab1 = "By Lexeme",
  lab2 = "By Word",
  color1 = "#1A4571",
  color2 = "#FF5A48",
  color1_dark = "#073361",
  color2_dark = "#FF1E06"
)
ggsave("figs-final/appendix_pc_mi_all.png", width = 7, height = 10)

# PC ~ WL
plot_lang_facet_2(
  data1 = data_words_pim,
  data2 = data_g2p,
  x_axis_1 = "phoneme_loss",
  y_axis_1 = "phoneme_len",
  x_axis_2 = "phon_loss",
  y_axis_2 = "phon_len",
  x_lab = "Phonotactic Complexity",
  y_lab = "Word Length",
  lab1 = "Phonotactic Data",
  lab2 = "UniMorph Data",
  color1 = "#482C7B",
  color2 = "#FF6B00",
  color1_dark = "#2F0086",
  color2_dark = "#B54C00"
)
ggsave("figs-final/appendix_pc_wl_all.png", width = 7, height = 10)


# MI ~ FR
plot_lang_facet_2(
  data1 = data_base_g2p,
  data2 = data_g2p,
  x_axis_1 = "morph_complexity",
  y_axis_1 = "logfreq",
  x_axis_2 = "morph_complexity",
  y_axis_2 = "logfreq",
  x_lab = "Morphological Irregularity",
  y_lab = "Log Frequency",
  lab1 = "By Lexeme",
  lab2 = "By Word",
  color1 = "#1A4571",
  color2 = "#FF5A48",
  color1_dark = "#073361",
  color2_dark = "#FF1E06"
)
ggsave("figs-final/appendix_mi_fr_all.png", width = 7, height = 10)

# PC ~ FR
plot_lang_facet(
  data_g2p,
  "phon_loss",
  "logfreq",
  "Phonotactic Complexity",
  "Log Frequency"
)
ggsave("figs-final/appendix_pc_fr_all.png", width = 7, height = 10)

# MI ~ WL
plot_lang_facet_2(
  data1 = data_base_g2p,
  data2 = data_g2p,
  x_axis_1 = "morph_complexity",
  y_axis_1 = "phon_len",
  x_axis_2 = "morph_complexity",
  y_axis_2 = "phon_len",
  x_lab = "Morphological Irregularity",
  y_lab = "Word Length",
  lab1 = "By Lexeme",
  lab2 = "By Word",
  color1 = "#1A4571",
  color2 = "#FF5A48",
  color1_dark = "#073361",
  color2_dark = "#FF1E06"
)
ggsave("figs-final/appendix_mi_wl_all.png", width = 7, height = 10)

# WL ~ FR
plot_lang_facet(
  data_g2p,
  "logfreq",
  "phon_len",
  "Log Frequency",
  "Word Length"
)
ggsave("figs-final/appendix_wl_fr_all.png", width = 7, height = 10)