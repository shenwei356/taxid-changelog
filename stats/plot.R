#!/usr/bin/env Rscript

library(scales)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(swr)
library(lubridate)

theme1 <- theme(
    text = element_text(size = 9),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.title = element_text(size = 13),
    strip.background = element_rect(
        colour = "grey80",
        fill = "grey95",
        size = 0.5
    ),
    legend.position = "top",
    legend.spacing.x = unit(0.4, "cm"),
)

df <- read.csv("changes.g.csv")
df$types <- factor(df$types, levels = unique(df$types), ordered = TRUE)
df$date <- as.Date(parse_date_time(df$version, "%y-%m-%d"))

df <- df %>% filter(!is.na(count)) %>% filter(version != "2014-08-01")


p <- ggplot(df, aes(x = date, y = count, color = types)) +
  geom_line(size = 0.7, alpha = 0.7) +
  geom_point(aes(shape = types), size = 1.8) +
  scale_color_colorblind() +
  xlab("Date") +
  ylab("#TaxIDs") +
  shenwei356.theme() +
  theme1 +
  labs(title = "NCBI Taxonomy TaxID Changes",
    subtitle = "2014-08-01 ~ 2021-08-01",
    caption = "https://github.com/shenwei356/taxid-changelog"
  )

ggsave(
  p,
  file = "changes.png",
  width = 10,
  height = 4,
  dpi = 300
)

