library(tidyverse)

mrtcars %>% glimpse()

mtcars %>%
  select(mpg, hp, wt) %>%
  summarise(mean(mpg))
