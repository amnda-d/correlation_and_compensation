transform_data <- function(d) {
  d <- d %>%
    group_by(lang) %>%
    mutate(
      mean_mi = mean(morph_complexity),
      mean_omi = mean(ortho_morph_complexity),
      mean_pc = mean(phon_loss),
      mean_wl = mean(phon_len),
      mean_fr = mean(log(freq)),
      n = n(),
    ) %>%
    ungroup()

  d <-  d %>%
    group_by(lang, base) %>%
    mutate(
      lemma_mi = mean(morph_complexity),
      lemma_omi = mean(ortho_morph_complexity)
    ) %>%
    ungroup()

  d <- d %>%
    mutate(
      phon_len_z = (phon_len - mean(phon_len)) / sd(phon_len),
      logfreq = log(freq),
      logfreq_z = (log(freq) - mean(log(freq))) / sd(log(freq)),
      morph_complexity_z = (morph_complexity - mean(morph_complexity)) / sd(morph_complexity),
      ortho_morph_complexity_z = (ortho_morph_complexity - mean(ortho_morph_complexity)) / sd(ortho_morph_complexity),
      phon_loss_z = (phon_loss - mean(phon_loss)) / sd(phon_loss),
      lemma_mi_z = (lemma_mi - mean(lemma_mi)) / sd(lemma_mi)
    )

  d <- d %>%
    group_by(lang) %>%
    mutate(
      mean_mi_z = mean(morph_complexity_z),
      mean_omi_z = mean(ortho_morph_complexity_z),
      mean_pc_z = mean(phon_loss_z),
      mean_wl_z = mean(phon_len_z),
      mean_fr_z = mean(logfreq_z),
      n = n()
    ) %>%
    ungroup()
  return(d)
}

group_by_base <- function(d) {
  bases <- d %>%
    group_by(lang, base) %>%
    summarise(
      morph_complexity = mean(morph_complexity),
      ortho_morph_complexity = mean(ortho_morph_complexity),
      phon_loss = mean(phon_loss),
      lang = first(lang),
      phon_len = mean(phon_len),
      simple_pos = first(simple_pos),
      freq = sum(freq),
    )
  return(bases)
}

plot_across_langs <- function(d, v1, v2, lab1 = "", lab2 = "") {
  v1col <- enquo(v1)
  v2col <- enquo(v2)
  dat <- d %>%
    group_by(lang) %>%
    summarise(
      mean_v1 = mean(!!v1col),
      mean_v2 = mean(!!v2col)
    )
  dat %>%
    ggplot(aes(x = mean_v1, y=mean_v2)) +
    geom_smooth(color = "#1A4571") +
    geom_smooth(method = "lm", color = "#FF5A48") +
    geom_text(aes(label = lang)) +
    theme_hc() +
    xlab(lab1) +
    ylab(lab2)
}

code_to_name <- function(data) {
  case_match(
    data,
    "amh" ~ "Amharic",
    "aze" ~ "Azerbaijani",
    "ben" ~ "Bengali",
    "cat" ~ "Catalan",
    "ceb" ~ "Cebuano",
    "ces" ~ "Czech",
    "csb" ~ "Kashubian",
    "deu" ~ "German",
    "eng" ~ "English",
    "fra" ~ "French",
    "got" ~ "Gothic",
    "hbs" ~ "Serbo Croatian",
    "hin" ~ "Hindi",
    "hun" ~ "Hungarian",
    "ind" ~ "Indonesian",
    "ita" ~ "Italian",
    "kaz" ~ "Kazakh",
    "kbd" ~ "Kabardian",
    "khk" ~ "Mongolian",
    "kir" ~ "Kyrgyz",
    "mao" ~ "Maori",
    "mlt" ~ "Maltese",
    "nld" ~ "Dutch",
    "nya" ~ "Chewa",
    "ood" ~ "O\"odham",
    "orm" ~ "Oromo",
    "pol" ~ "Polish",
    "por" ~ "Portuguese",
    "ron" ~ "Romanian",
    "rus" ~ "Russian",
    "sna" ~ "Shona",
    "spa" ~ "Spanish",
    "swc" ~ "Swahili",
    "swe" ~ "Swedish",
    "sqi" ~ "Albanian",
    "tel" ~ "Telugu",
    "tgk" ~ "Tajik",
    "tgl" ~ "Tagalog",
    "tuk" ~ "Turkmen",
    "tur" ~ "Turkish",
    "uig" ~ "Uyghur",
    "ukr" ~ "Ukrainian",
    "urd" ~ "Urdu",
    "uzb" ~ "Uzbek",
    "zul" ~ "Zulu",
    .default = data
  )
}

model.by.lang <- function(data, f, param) {
  d <- data %>%
    group_by(lang) %>%
    do(
      tidy(lm(f, data = .), conf.int = TRUE)
    ) %>%
    filter(term == param)
  d$Significant <- d$p.value < 0.05
  d <- d %>% mutate(lang = factor(lang, levels = (d %>% arrange(estimate))$lang))
  return(d)
}

plot.by.lang <- function(d, title = "") {
  ggplot() +
    geom_segment(
      data = d,
      aes(x = lang, xend = lang, y = 0, yend = estimate),
      color = "grey"
    ) +
    geom_errorbar(
      data = d,
      aes(x = lang, y = estimate, ymin = conf.low, ymax = conf.high),
      alpha = 0.8,
      width = 0.7,
      linewidth = 0.7,
      color = "#1A4571"
    ) +
    geom_point(
      data = d,
      aes(y = estimate, x = lang, shape = Significant),
      size = 2.5,
      stroke = 1.5,
      color = "#1A4571"
    ) +
    scale_shape_manual(values = c(4, 16)) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
    theme_hc() +
    xlab("Language") +
    ylab("Coefficient") +
    ggtitle(title)
}

plot.by.lang.sig <- function(d, title = "") {
  ggplot() +
    geom_segment(
      data = d,
      aes(x = lang, xend = lang, y = 0, yend = estimate),
      color = "grey"
    ) +
    geom_errorbar(
      data = d,
      aes(x = lang, y = estimate, ymin = conf.low, ymax = conf.high),
      alpha = 0.8,
      width = 0.7,
      linewidth = 0.7,
      color = "#1A4571"
    ) +
    geom_point(
      data = d,
      aes(y = estimate, x = lang, shape = Significant),
      size = 2.5,
      stroke = 1.5,
      color = "#1A4571"
    ) +
    scale_shape_manual(values = c(16, 4)) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
    theme_hc() +
    xlab("Language") +
    ylab("Coefficient") +
    ggtitle(title)
}

plot.by.lang.2 <- function(
  d, d2, lab1, lab2, colora = "#1A4571", colorb = "#FF5A48", title = ""
) {
  ggplot() +
    geom_segment(
      data = d,
      aes(x = lang, xend = lang, y = 0, yend = estimate),
      color = "grey"
    ) +
    geom_segment(
      data = d2,
      aes(x = lang, xend = lang, y = 0, yend = estimate),
      color = "grey"
    ) +
    geom_errorbar(
      data = d,
      aes(
        x = lang, y = estimate, ymin = conf.low, ymax = conf.high, color = "a"
      ),
      alpha = 0.8,
      width = 0.7,
      linewidth = 0.7
    ) +
    geom_errorbar(
      data = d2,
      aes(
        x = lang, y = estimate, ymin = conf.low, ymax = conf.high, color = "b"
      ),
      alpha = 0.8,
      width = 0.7,
      linewidth = 0.7
    ) +
    geom_point(
      data = d,
      aes(y = estimate, x = lang, shape = Significant, color = "a"),
      size = 2.5,
      stroke = 1.5,
    ) +
    geom_point(
      data = d2,
      aes(y = estimate, x = lang, shape = Significant, color = "b"),
      size = 2,
      stroke = 1.5,
    ) +
    scale_colour_manual(
      name = "",
      values = c("a" = colora, "b" = colorb),
      labels = c(lab1, lab2)
    ) +
    scale_shape_manual(values = c(4, 16)) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
    theme_hc() +
    xlab("Language") +
    ylab("Coefficient") +
    ggtitle(title)
}