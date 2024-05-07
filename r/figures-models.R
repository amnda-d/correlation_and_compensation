library(tidyverse)
library(ggthemes)
library(lme4)
library(broom.mixed)
# library(sjPlot)

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

# data_g2p <- data_g2p %>%
#   mutate(lang = paste(
#     case_match(type, "Agglutinative" ~ sprintf("\u25A0"), "Fusional" ~ sprintf("\u25A1"), "?" ~ ""),
#     lang
#     ))
# 
# data_base_g2p <- data_base_g2p %>%
#   mutate(lang = paste(
#     case_match(type, "Agglutinative" ~ sprintf("\u25A0"), "Fusional" ~ sprintf("\u25A1"), "?" ~ ""),
#     lang
#   ))

# figures

mi.pc <- model.by.lang(
  data_g2p,
  formula(morph_complexity_z ~ phon_loss_z + logfreq_z + phon_len_z),
  "phon_loss_z"
)
mi.pc.lem <- model.by.lang(
  data_base_g2p,
  formula(morph_complexity_z ~ phon_loss_z + logfreq_z + phon_len_z),
  "phon_loss_z"
)
plot.by.lang.2(mi.pc.lem, mi.pc, "By Lexeme", "By Word")
ggsave(
  "figs-final/corr_mi_pc_g2p.png", width = 20, height = 14, units = "cm"
)

pc.wl <- model.by.lang(
  data_g2p,
  formula(phon_loss_z ~ phon_len_z),
  "phon_len_z"
)
pc.wl.pim <- model.by.lang(
  data_words_pim,
  formula(phoneme_loss ~ phoneme_len),
  "phoneme_len"
)
plot.by.lang.2(
  pc.wl.pim, pc.wl, "Phonotactic Data", "UniMorph Data", "#482C7B", "#FF6B00"
)
ggsave("figs-final/corr_pc_wl_g2p.png", width = 20, height = 14, units = "cm")

pc.fr <- model.by.lang(
  data_g2p,
  formula(phon_loss_z ~ logfreq_z + phon_len_z),
  "logfreq_z"
)
plot.by.lang(pc.fr)
ggsave("figs-final/corr_pc_fr_g2p.png", width = 20, height = 14, units = "cm")

mi.fr <- model.by.lang(
  data_g2p,
  formula(morph_complexity_z ~ logfreq_z),
  "logfreq_z"
)
mi.fr.lem <- model.by.lang(
  data_base_g2p,
  formula(morph_complexity_z ~ logfreq_z),
  "logfreq_z"
)
plot.by.lang.2(mi.fr.lem, mi.fr, "By Lexeme", "By Word")
ggsave("figs-final/corr_mi_fr_g2p.png", width = 20, height = 14, units = "cm")

wl.fr <- model.by.lang(
  data_g2p,
  formula(phon_len_z ~ logfreq_z),
  "logfreq_z"
)
plot.by.lang.sig(wl.fr)
ggsave("figs-final/corr_wl_fr_g2p.png", width = 20, height = 14, units = "cm")

mi.wl <- model.by.lang(
  data_g2p,
  formula(morph_complexity_z ~ phon_len_z + logfreq_z),
  "phon_len_z"
)
mi.wl.lem <- model.by.lang(
  data_base_g2p,
  formula(morph_complexity_z ~ phon_len_z + logfreq_z),
  "phon_len_z"
)
plot.by.lang.2(mi.wl.lem, mi.wl, "By Lexeme", "By Word")
ggsave("figs-final/corr_mi_wl_g2p.png", width = 20, height = 14, units = "cm")

pc_means <- data_g2p %>%
  group_by(lang) %>%
  summarise(
    mean_len = mean(phon_len),
    mean_pc = mean(phon_loss)
  )

data_pim %>% ggplot(aes(x = val_loss, y = avg_len)) +
  geom_text(aes(label = lang), family = "Times") +
  geom_text(data = pc_means, aes(label = lang, x = mean_pc, y = mean_len), family = "Times") +
  geom_smooth(color = "#482C7B", linetype = 2) +
  geom_smooth(method = "lm", color = "#482C7B") +
  geom_smooth(
    data = pc_means,
    aes(x = mean_pc, y = mean_len),
    color = "#FF6B00",
    linetype = 2
  ) +
  geom_smooth(
    data = pc_means,
    aes(x = mean_pc, y = mean_len),
    method = "lm",
    color = "#FF6B00"
  ) +
  theme_hc() +
  scale_x_log10(expand = expansion(mult = 0.1)) +
  ylab("Average Length (# IPA Tokens)") +
  xlab("Bits Per Phoneme") +
  theme(text = element_text(family = "Times", size = 18))

ggsave("figs-final/pim.png", width = 20, height = 14, units = "cm")

plot_across_langs(
  data_base_g2p,
  phon_len,
  morph_complexity,
  "Word Length",
  "Morphological Irregularity"
)
ggsave("figs-final/mi_wl_g2p_b.png", width = 20, height = 14, units = "cm")

plot_across_langs(
  data_base_g2p,
  phon_loss,
  morph_complexity,
  "Phonotactic Complexity",
  "Morphological Irregularity"
)
ggsave("figs-final/mi_pc_g2p_b.png", width = 20, height = 14, units = "cm")

# MI ~ PC model
mi_pc_mod2 <- lmer(
  morph_complexity_z ~ phon_loss_z + logfreq_z + mean_pc_z +
    phon_len_z + mean_wl_z + (1 + phon_len_z + phon_loss_z + logfreq_z | lang),
  data = data_g2p,
  REML = FALSE,
  control = lmerControl(optimizer = "bobyqa")
)
summary(mi_pc_mod2)
# tab_model(mi_pc_mod2)

mi_pc_lem_mod2 <- lmer(
  morph_complexity_z ~ phon_loss_z + logfreq_z + mean_pc_z +
    phon_len_z + mean_wl_z + (1 + phon_len_z + phon_loss_z + logfreq_z | lang),
  data = data_base_g2p,
  REML = FALSE,
  control = lmerControl(optimizer = "bobyqa")
)
summary(mi_pc_lem_mod2)
# tab_model(mi_pc_lem_mod2)

# PC ~ WL
pc_wl_mod <- lmer(
  phon_loss_z ~ phon_len_z + mean_wl_z + (1 + phon_len_z | lang),
  data = data_g2p,
  REML = FALSE
)
summary(pc_wl_mod)
# tab_model(pc_wl_mod)

data_words_pim <- data_words_pim %>%
  group_by(lang) %>%
  mutate(
    mean_pc = mean(phoneme_loss),
    mean_wl = mean(phoneme_len),
  ) %>%
  ungroup()

pc_wl_mod_pim <- lmer(
  phoneme_loss ~ phoneme_len + mean_wl + (1 + phoneme_len | lang),
  data = data_words_pim,
  REML = FALSE,
  control = lmerControl(optimizer = "bobyqa")
)
summary(pc_wl_mod_pim)
# tab_model(pc_wl_mod_pim)

# PC ~ FR
pc_fr_mod <- lmer(
  phon_loss_z ~ logfreq_z + phon_len_z + mean_wl_z +
    (1 + logfreq_z + phon_len_z | lang),
  data = data_g2p,
  REML = FALSE,
  control = lmerControl(optimizer = "bobyqa")
)
summary(pc_fr_mod)
# tab_model(pc_fr_mod)

# MI ~ FR
mi_fr_mod <- lmer(
  morph_complexity_z ~ logfreq_z + (1 + logfreq_z | lang),
  data = data_g2p,
  REML = FALSE
)
summary(mi_fr_mod)
# tab_model(mi_fr_mod)

mi_fr_lem_mod <- lmer(
  morph_complexity_z ~ logfreq_z + (1 + logfreq_z | lang),
  data = data_base_g2p,
  REML = FALSE
)
summary(mi_fr_lem_mod)
# tab_model(mi_fr_lem_mod)

# WL ~ FR
wl_fr_mod <- lmer(
  phon_len_z ~ logfreq_z + (1 + logfreq_z | lang),
  data = data_g2p,
  REML = FALSE
)
summary(wl_fr_mod)
# tab_model(wl_fr_mod)

# MI ~ WL
mi_wl_mod <- lmer(
  morph_complexity_z ~ phon_len_z + mean_wl_z + logfreq_z +
    (1 + logfreq_z + phon_len_z | lang),
  data = data_g2p,
  REML = FALSE,
  control = lmerControl(optimizer = "bobyqa")
)
summary(mi_wl_mod)
# tab_model(mi_wl_mod)

mi_wl_lem_mod <- lmer(
  morph_complexity_z ~ phon_len_z + mean_wl_z + logfreq_z +
    (1 + logfreq_z + phon_len_z | lang),
  data = data_base_g2p,
  REML = FALSE
)
summary(mi_wl_lem_mod)
# tab_model(mi_wl_lem_mod)

data_g2p_means <- data_g2p %>% group_by(lang) %>% summarise(
  mean_mi = mean(morph_complexity),
  mean_omi = mean(ortho_morph_complexity),
  mean_pc = mean(phon_loss),
  mean_wl = mean(phon_len),
  mean_fr = mean(log(freq)),
  n = n()
)

data_g2p_means_b <- data_base_g2p %>% group_by(lang) %>% summarise(
  mean_mi = mean(morph_complexity),
  mean_omi = mean(ortho_morph_complexity),
  mean_pc = mean(phon_loss),
  mean_wl = mean(phon_len),
  mean_fr = mean(log(freq)),
  n = n()
)

cor.test(data_g2p_means$mean_mi, data_g2p_means$mean_pc, method='spearman')

cor.test(data_g2p_means$mean_mi, data_g2p_means$mean_wl, method='spearman')

cor.test(data_g2p_means$mean_mi, data_g2p_means$mean_fr, method='spearman')

cor.test(data_g2p_means$mean_pc, data_g2p_means$mean_wl, method='spearman')

cor.test(data_g2p_means$mean_pc, data_g2p_means$mean_fr, method='spearman')

cor.test(data_g2p_means$mean_wl, data_g2p_means$mean_fr, method='spearman')

cor.test(data_pim$val_loss, data_pim$avg_len, method="spearman")


cor.test(data_g2p_means_b$mean_mi, data_g2p_means_b$mean_pc, method='spearman')

cor.test(data_g2p_means_b$mean_mi, data_g2p_means_b$mean_wl, method='spearman')

cor.test(data_g2p_means_b$mean_mi, data_g2p_means_b$mean_fr, method='spearman')

cor.test(data_g2p_means_b$mean_pc, data_g2p_means_b$mean_wl, method='spearman')

cor.test(data_g2p_means_b$mean_pc, data_g2p_means_b$mean_fr, method='spearman')

cor.test(data_g2p_means_b$mean_wl, data_g2p_means_b$mean_fr, method='spearman')
