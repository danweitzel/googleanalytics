# Use R to access your Google Analytics 

## Motivation


## Packages used
```
library("googleAnalyticsR")
library("tidyverse")
library("lubridate")
```

## Grant permission to access yout Google Account
```
ga_auth()
```

## Get the accounts listed
```
account_list <- ga_account_list()
```
## account_list will have a column called "viewId"
```
account_list$viewId
```

## View account_list and pick the viewId you want to extract data from. 
```
ga_id <- account_list$viewId[2]
```

## Restrict the collected data to the last week
```
date_today <- lubridate::today()
```

## Simple Google Analytics Query
Something that you might be interested in is where the traffic on your website was coming from in the last week. The query below gets the date, country, city, latitude, longitude, and source (Google, Twitter, or other) of your web traffic for the last week. 

```
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
```                 

## Take a look at the data
```
df_analytics
```
