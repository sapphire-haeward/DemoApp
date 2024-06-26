# https://www.globenewswire.com/newsroom

rm(list = ls())

# Load the libraries
library(rvest)
library(dplyr)

# URL of the website to scrape
url <- 'https://stockanalysis.com/markets/gainers/'

# Read the webpage content
webpage <- read_html(url)

# Extract the table containing the top gaining stocks
today <- webpage %>%
  html_node('table') %>%
  html_table()


class(table)

# Weekly
# URL of the website to scrape
url <- 'https://stockanalysis.com/markets/gainers/week'

# Read the webpage content
webpage <- read_html(url)

# Extract the table containing the top gaining stocks
week_gainers <- webpage %>%
  html_node('table') %>%
  html_table()


# Month
# URL of the website to scrape
url <- 'https://stockanalysis.com/markets/gainers/month'

# Read the webpage content
webpage <- read_html(url)

# Extract the table containing the top gaining stocks
month_gainers <- webpage %>%
  html_node('table') %>%
  html_table()


# YTD
# URL of the website to scrape
url <- 'https://stockanalysis.com/markets/gainers/ytd'

# Read the webpage content
webpage <- read_html(url)

# Extract the table containing the top gaining stocks
ytd_gainers <- webpage %>%
  html_node('table') %>%
  html_table()


colnames(today)[4] <- "% Change (TODAY)"
colnames(week_gainers)[4] <- "% Change (WEEK)"
colnames(month_gainers)[4] <- "% Change (MONTH)"
colnames(ytd_gainers)[4] <- "% Change (YTD)"

#--------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------
# ...Comparing...
# Month to Year


# Find the intersection of Day and Week  
consistent_day_week_gainers <- merge(today, week_gainers, by = "Symbol")
consistent_day_week_gainers
# View(consistent_day_week_gainers)

# Find the intersection of Day and Month  
consistent_day_month_gainers <- merge(today, month_gainers, by = "Symbol")
consistent_day_month_gainers

# Find the intersection of Month and Week
consistent_month_week_gainers <- merge(month_gainers, week_gainers, by = "Symbol")
consistent_month_week_gainers
# View(consistent_month_week_gainers)

# Intersect Day Month Week
day_month_week <- merge(today, consistent_month_week_gainers, by = "Symbol")
day_month_week
# View(day_month_week)
downloads <- "/Users/sapphirehaeward/Downloads"
setwd(downloads)
# write.csv(day_month_week, paste0("Consistent Day Week Month Gainer - ", Sys.Date(), ".csv"))

# # Path to the directory
# dir_path <- downloads
# 
# # Check write permissions
# if (file.access(dir_path, mode = 2) == 0) {
#   print("Write permission granted for the directory.")
# } else {
#   print("Write permission denied for the directory.")
# }
# 
# # Path to the file
# file_path <- paste0(downloads,"/Consistent Day Week Month Gainer2.csv")
# file_path
# # Check write permissions
# if (file.access(file_path, mode = 2) == 0) {
#   print("Write permission granted for the file.")
# } else {
#   print("Write permission denied for the file.")
# }



# # Find the intersection of Month/Week with YTD
# consistent_mw_ytd_gainers <- merge(consistent_month_week_gainers, ytd_gainers, by = "Symbol")
# consistent_mw_ytd_gainers
# 
# # Find the intersection of Day and YTD (bet it'll be empty)  
# day_ytd <- merge(today, ytd_gainers, by = "Symbol")
# day_ytd
# View(day_ytd)

day_month_week_clean <- day_month_week[, c(1, 2, 3, 5, 4, 16, 10, 6,7 )]

day_month_week_clean[ ,5]<- gsub("%", "", day_month_week_clean[ ,5])
day_month_week_clean[ ,6] <- gsub("%", "", day_month_week_clean[ ,6])
day_month_week_clean[ ,7] <- gsub("%", "", day_month_week_clean[ ,7])

day_month_week_clean[ ,5:7] <- sapply(day_month_week_clean[ ,5:7], as.numeric)

day_month_week_clean[ ,8] <- gsub(",", "", day_month_week_clean[ ,8])
day_month_week_clean[ ,8] <- as.numeric(day_month_week_clean[ ,8])

# Class Check
sapply(day_month_week_clean[,5:8], class)

colnames(day_month_week_clean)
# Clean and structure the data
# Note: Adjust column names and types as necessary
colnames(day_month_week_clean) <- c('Daily Rank', 'Ticker', 'Name', 'Price', 'ChangePercent (TODAY)', 'ChangePercent (WEEK)', 'ChangePercent (MONTH)', 'Volume', 'MarketCap')

# Print the first few rows of the table
print(head(day_month_week_clean))



setwd(downloads)
# Save the data to a CSV file
library(openxlsx)
wb <- createWorkbook()
addWorksheet(wb, "Top Gaining Stocks")

#Styles
s <- createStyle(numFmt = "#,##0.00", border="TopBottomLeftRight", borderStyle = "medium") # numerical
gen_num <- createStyle(numFmt = "GENERAL", border="TopBottomLeftRight", borderStyle = "medium", wrapText = T)
date_style <- createStyle(numFmt = "mm/dd/yyyy", border="TopBottomLeftRight", borderStyle = "medium")
headerStyle <- createStyle(fontSize = 12, fontColour = "#000000", halign = "center", textDecoration = c("BOLD"),
                           fgFill = "#bdbdbd", border="TopBottomLeftRight", borderStyle = "thick")


addStyle(wb, sheet = 1, headerStyle, rows = 1, cols = 1:ncol(day_month_week_clean), gridExpand = TRUE)
addStyle(wb, sheet = 1, gen_num, rows = 2:nrow(day_month_week_clean), cols = 5:8, gridExpand = TRUE)
writeData(wb, sheet = 1, day_month_week_clean, startRow = 1, startCol = 1, borders = "all", borderStyle = "medium")

openXL(wb)
