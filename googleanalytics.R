# Load Libraries
library("googleAnalyticsR")
library("tidyverse")
library("lubridate")
library("maps")


# Authenticate with Google
ga_auth()

# Get your accounts
account_list <- ga_account_list()

# Account_list to see if there are multiple accounts
account_list$viewId

# Pick the viewId you want to extract data from, in my case the second one.
ga_id <- account_list$viewId[2]

# Get today's date to be able to reduce query to a week
date_today <- lubridate::today()

# Simple query that gets traffic for the last week
df_analytics <-
  google_analytics(ga_id,
                 date_range = c(date_today-7, date_today),
                 metrics = "sessions", 
                 dimensions = c("date", "country", "city",
                                "sourceMedium", "latitude","longitude")) %>% 
  mutate(source = ifelse(sourceMedium == "google / organic", "Google", 
                         ifelse(sourceMedium == "(direct) / (none)", "Direct",
                                ifelse(sourceMedium == "t.co / referral", "Twitter", "Other")))) %>% 
  dplyr::select(-sourceMedium)
                 
# Look at the result of the traffic query
df_analytics


# Generate a world map
df_analytics %>%
  filter(longitude != "0.0000") %>% 
  mutate(longitude = round(as.numeric(longitude), 2),
         latitude = round(as.numeric(latitude), 2)) %>% 
  ggplot() +
  geom_point(aes(x=longitude, y=latitude, size=sessions, 
                 fill=sessions, color=sessions), 
             show.legend = FALSE) + 
  borders("world") + 
  theme_void() +
  coord_equal() 
