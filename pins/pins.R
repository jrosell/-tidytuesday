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



github_raw <- function(x) paste0("https://raw.githubusercontent.com/", x)

## with a named vector of URLs to specific pins:
b1 <- board_url(c(
  files = github_raw("rstudio/pins-r/main/tests/testthat/pin-files/"),
  rds = github_raw("rstudio/pins-r/main/tests/testthat/pin-rds/"),
  raw = github_raw("rstudio/pins-r/main/tests/testthat/pin-files/first.txt")
))

b1 %>% pin_read("squirrels")

board <- board_url(c(
  squirrels = "https://raw.githubusercontent.com/jrosell/tidytuesday/main/pins/squirrels/"
))
board %>% pin_read("squirrels")
