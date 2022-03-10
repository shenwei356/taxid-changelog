#!/usr/bin/env Rscript
library(scales)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(lubridate)

theme1 <- theme(
    panel.border = element_rect(color = "grey40", size = 0.6, fill = NA),
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    
    legend.position = "top",
    legend.spacing.x = unit(0.4, "cm"),
    legend.text = element_text(size = 11),
    legend.margin = margin(0.1, 0.1, 0.1, 0.1, unit = "cm"),
    
    plot.title = element_text(size = 15),        
    text = element_text(size = 10),
    
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    axis.ticks.y = element_line(size = 0.6),
    axis.ticks.x = element_line(size = 0.6),
    axis.title = element_text(size = 13),
)

df <- read.csv("changes.g.csv")
df$types <- factor(df$types, levels = unique(df$types), ordered = TRUE)
df$date <- as.Date(parse_date_time(df$version, "%y-%m-%d"))

df <- df %>% filter(!is.na(count)) %>% filter(version != "2013-02-21")

p <- ggplot(df, aes(x = date, y = count, color = types, shape = types)) +
  geom_line(size = 0.7, alpha = 0.7) +
  geom_point(aes(shape = types), size = 1.8) +
  scale_color_colorblind() +
  xlab(NULL) +
  ylab("#TaxIds") + 
  theme1 +
  labs(title = "NCBI Taxonomy TaxID Changes",
    subtitle = "2013-02-21 ~ 2022-03-01",
    caption = "https://github.com/shenwei356/taxid-changelog"
  )

ggsave(
  p,
  file = "changes.png",
  width = 10,
  height = 4,
  dpi = 300
)

