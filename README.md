# Use R to access your Google Analytics 

<p align="center">
<img src="/map.png" width="600">
</p>



If you use Google Analytics to monitor your website traffic you probably have become frustrated with the Google Analytics interface (both web and app). I find the website sluggish and was looking for an easier way to get the information that I want from Google Analytics fast. After a bit of searching I found the `googleAnalyticsR` package in R. In this repository I explain how you can use R to very easily get reports on key metrics about the traffic of your website. 

The entire R script to download is available [here](googleanalytics.R).

## Setting up Google Analytics 
I assume that you have Google Analytics set up on your webpage already. If this is not the case here is a guide on how to do this: https://analytics.google.com/analytics/academy/course/6

## Packages

In order to query the data from Google Analytics, reduce the amount of data we collect, and make a couple of easy data transformations we will use the following three R packages. 

```
library("googleAnalyticsR")
library("tidyverse")
library("lubridate")
```
The `googleAnalyticsR` package allows us to interact with the Google Analytics API and query our web traffic data. The `lubridate` package is used to handle dates and allows us to generate a seven day window for our query, and the `tidyverse` package is used to do some data wrangling. 

## Grant permission to access your Google Account

In order to be able to query from our Google Analytics account we must first grant a permission. We can do this with the following function. You will be promted to grant access after you run this in R. 

```
ga_auth()
```

## Get the accounts listed

You might have multiple Google Analytics accounts. The code below gives you the list of all acocunts that you can query after you gave access. 
```
account_list <- ga_account_list()
```
## View account_list and see all monitored accounts

In my case there are two accounts and I can get the `viewID` with the code below. With the ID number I can verify in the Google Analytics dashboard which account I want to query. 

```
account_list$viewId
```

##  Pick the viewId you want to extract data from

The acocunt that I want to query is the second one. If you want to query the first account (or only have one account) replace the `[2]` with `[1]`.

```
ga_id <- account_list$viewId[2]
```

## Get today's date to be able to restrict the query

I don't want to include all of the traffic on my website in every call. I'm usually only interested in the traffic that happened in the last seven days. In order to do reduce the query to a one week window I need todays's date and the `lubridate` package allows this:

```
date_today <- lubridate::today()
```

## Simple Google Analytics Query

Now we have all the pieces for our query. Something that you might be interested in is where the traffic on your website was coming from in the last week. The query below gets the date, country, city, latitude, longitude, and source (Google, Twitter, or other) of your web traffic for the last week. 

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

## Todos
- add maps
- other visualizations
- better explanation
