library(tidyverse)

mrtcars %>% glimpse()

mtcars %>%
  select(mpg, hp, wt) %>%
  summarise(avg_mpg = mean(mpg))
