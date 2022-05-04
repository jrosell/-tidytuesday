library(tidyverse)
library(ggstream)
library(rcartocolor)
library(showtext)
devtools::install_github("nrennie/usefunc")
library(usefunc)

# load fonts
font_add_google(name = "Red Rose", family = "rose")
showtext_auto()

# read data
capacity <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-05-03/capacity.csv')

# prep data
plot_data <- capacity %>%
  drop_na() %>%
  mutate(type = factor(type, levels = c("Solar", "Wind", "Storage", "Gas", "Nuclear", "Coal", "Other"))) 

plot_data %>% 
  arrange(year) %>% 
  group_by(type) %>% 
  mutate(first_year = first(year)) %>% 
  count(type, first_year)


# text data
text_data <- plot_data %>%
  filter(year == 2020) %>%
  mutate(year = year + 0.1,
    y = c(900, 550, -300, -1025, -1100, -1175, -1250))

# subtitle
st <- str_wrap_break("Energy capacity in the United States has increased dramatically in recent years, mainly due to increases in storage and solar capacities.", 70)

# stream plot
ggplot(data = plot_data,
  mapping = aes(x = year, y = total_gw, fill = type)) +
  geom_stream(bw = 0.85,
    extra_span = 0.2,
    sorting = "onset",
    colour = "white") +
  geom_text(data = text_data,
    mapping = aes(x = year,
      y = y,
      label = type,
      colour = type),
    hjust = 0,
    family = "rose") +
  scale_x_continuous(limits = c(2014, 2021)) +
  scale_fill_carto_d(palette = "Bold") +
  scale_colour_carto_d(palette = "Bold") +
  labs(caption = "N. Rennie | Data: Berkeley Lab",
    title = "Energy Capacity in the United States",
    subtitle = st) +
  theme(panel.grid = element_blank(),
    panel.background = element_rect(fill = "white", colour = "white"),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_text(family = "rose"),
    legend.position = "none",
    plot.title = element_text(size = 14, hjust = 0, family = "rose",
      face = "bold",
      margin = margin(t = 10, b = 5)),
    plot.subtitle = element_text(size = 10, hjust = 0, family = "rose",
      margin = margin(t = 10, b = 5)),
    plot.caption = element_text(size = 8, hjust = 0, family = "rose",
      margin = margin(t = 20, b = 5)))

# bar plot
ggplot(data = plot_data,
  mapping = aes(x = year, y = total_gw, fill = type)) +
  geom_col(colour = "white") +
  scale_fill_carto_d(palette = "Bold") +
  scale_x_continuous(breaks = c(2014:2021)) +
  labs(caption = "N. Rennie | Data: Berkeley Lab",
    title = "Energy Capacity in the United States",
    subtitle = st) +
  guides(fill = guide_legend(ncol = 2)) +
  theme(panel.grid = element_blank(),
    panel.background = element_rect(fill = "white", colour = "white"),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_text(family = "rose"),
    legend.position = c(0.18, 0.7),
    legend.title = element_blank(),
    plot.title = element_text(size = 14, hjust = 0, family = "rose",
      face = "bold",
      margin = margin(t = 10, b = 5)),
    plot.subtitle = element_text(size = 10, hjust = 0, family = "rose",
      margin = margin(t = 10, b = 5)),
    plot.caption = element_text(size = 8, hjust = 0, family = "rose",
      margin = margin(t = 20, b = 5)))



# stacked area plot 
area_plot_data <- plot_data %>%
  group_by(type, year) %>%
  summarise(total_gw = sum(total_gw)) %>% 
  bind_rows(
    tibble(
      type = c("Nuclear", "Coal", "Other", "Storage"),
      year = c(2019, 2019, 2019, 2019),
      total_gw  = rep(0, 4),
    )
  ) %>% 
  print(n = Inf)
ggplot(data = area_plot_data, aes(x = year, y = total_gw, fill = type, col = type)) +
  geom_area(aes(fill = type), position = 'stack') +
  scale_x_continuous(limits = c(2014, 2020)) +
  scale_y_continuous(position = "right") +
  scale_fill_carto_d(palette = "Bold") +
  scale_colour_carto_d(palette = "Bold") +
  labs(caption = "N. Rennie | Data: Berkeley Lab",
    title = "Energy Capacity in the United States",
    subtitle = st) +
  guides(fill = guide_legend(ncol = 2)) +
  theme(
    legend.position = c(0.18, 0.7),
    legend.title = element_blank(),
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "white", colour = "white"),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.x = element_text(family = "rose"),
    axis.text.y.right = element_text(family = "rose", hjust = 0),
    plot.title = element_text(size = 14, hjust = 0, family = "rose",
      face = "bold",
      margin = margin(t = 10, b = 5)),
    plot.subtitle = element_text(size = 10, hjust = 0, family = "rose",
      margin = margin(t = 10, b = 5)),
    plot.caption = element_text(size = 8, hjust = 0, family = "rose",
      margin = margin(t = 20, b = 5))
  )

