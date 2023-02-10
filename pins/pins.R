library(tidyverse)
library(tidymodels)
library(pins)

# Create local folder
board <- pins::board_folder(here::here("pins"))
squirrels <- 
  read_csv(
  'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-01-10/PFW_count_site_data_public_2021.csv'
  ) %>%
  mutate(squirrels = ifelse(squirrels, "squirrels", "no squirrels"))

board %>% pins::pin_write(squirrels, "squirrels", type = "rds")
board %>% pins::pin_list()
board %>% pins::pin_read("squirrels")

# Read from github
github_raw <- function(x) paste0("https://raw.githubusercontent.com/", x)
board <- board_url(c(
  squirrels = github_raw("jrosell/tidytuesday/main/pins/squirrels/20230210T083753Z-a5873/")
))
board %>% pin_read("squirrels")