# rm(list = ls())

library(ggplot2)
library(ggthemes)
library(dplyr)
library(devtools)
library(tidyr)
# Load necessary library
library(readr)

# URL of the CSV file
csv_url <- "https://raw.githubusercontent.com/sapphire-haeward/DemoApp/main/BTC_All_graph_coinmarketcap.csv"

# Read the CSV file from the URL
data <- read.csv(url(csv_url), sep = ";")


# Consider the Monthly All-Time Data
# data <- read.csv("BTC_All_graph_coinmarketcap.csv", sep = ";")

# Convert Exp to Regular Float (Decimals)

data$volume <- format(data$volume, scientific = FALSE)
data$volume <- trimws(data$volume)
data$volume
class(data$volume)


data$marketCap
data$marketCap <- format(data$marketCap, scientific = FALSE)
data$marketCap <- trimws(data$marketCap)
data$marketCap


# Clean TimeStamp for Readability
data$timestamp
data$timestamp <- gsub("T00:00:00.000Z", "", data$timestamp)
data$timestamp


# Analyze Slopes
growth_loss <- data$close - data$open

growth_loss <- data.frame(cbind(growth_loss, data$timestamp))

colnames(growth_loss) <- c("Growth/Loss", "Date")

# View(growth_loss)

class(growth_loss$`Growth/Loss`)

growth_loss$`Growth/Loss` <- as.numeric(growth_loss$`Growth/Loss`)


# Compute the average price over all time (months)

# ggplot2 to create visualization
#------------------------------------------------------------------------------------------
# Need to calibrate this visualization to output 
# a visually line graph

# View(growth_loss)
growth_loss_date <- growth_loss[order(growth_loss$Date, decreasing = TRUE), ]
class(as.Date(as.character(growth_loss_date$Date)))

growth_loss_date$Date <- as.Date(as.character(growth_loss_date$Date))

# growth_loss_date <- growth_loss_date[1:10,] # Take the top 10 entries


# View(growth_loss_date)
class(growth_loss_date$`Growth/Loss`)

# Plot Growth- Loss over time
# Create a plot

plot1 <- growth_loss_date %>%
 ggplot(aes(x = Date, y = `Growth/Loss`)) +
        geom_smooth(  method = "loess",
                      color = "blue",
                      fill = "blue",
                      alpha = 0.5) +
        geom_line(color = "green") +
        geom_point(color = "orange")  +
        scale_x_date(date_breaks = "6 months",   # Set breaks to monthly
                     date_labels = "%m/%y"      # Format labels as "MM-YYYY"
                      ) +
        scale_y_continuous( breaks = seq(floor(min(growth_loss_date$`Growth/Loss`)/2000)*2000, 
                                         ceiling(max(growth_loss_date$`Growth/Loss`)/2000)*2000, 
                                         by = 2000),  
                            labels = function(x) x 
                            ) +
        labs( title = "Bitcoin Growth and Loss Over Time",
              subtitle = "Observe Bitcoin's Growth and Loss Changes in Time") 

          # theme_fivethirtyeight() 

# Display the plot
# print(plot1)


# Save plot as a PDF file
# pdf_file <- "bitcoin_growth_loss_plot.pdf"
# pdf(pdf_file)
# print(plot1)
# dev.off()

# Close the PDF file and open it using Adobe Acrobat or another viewer
# system(paste("open", shQuote(pdf_file)))





# 
# growth_loss_date %>%
#   ggplot(aes(x = Date, y = `Growth/Loss`)) +
#   geom_point() 



# +           # Add points
#   
#          labs(title = "Time Series Line Graph of Date vs. Growth/Loss",   # Add a title
#          x = "Date",                    # Label for x-axis
#          y = "Growth or Loss")               # Label for y-axis
# 


# Display the plot
#print(plot)


# To Do
# Plot Open Price over Time

# Plot Close Price Over Time

# Plot Open and Close Price with two different lines over time

# References
# https://r4stats.com/examples/graphics-ggplot2/


# # Example Code
# plot1 <- ggplot(data_cols, aes(x = Date)) +
#   
#   # This is how you put two y-scales on one graph
#   geom_line(aes(y = Total_Client_Assets, color = "Total_Client_Assets")) +
#   geom_area(aes(y = Total_Client_Assets, color = "Total_Client_Assets", fill = "#30A2FF")) +
#   
#   # Color coding the scales
#   scale_color_manual(values = c("Total_Client_Assets" = "#30A2FF")) +
#   labs( #labels
#     x = "Date",
#     y = "Total_Client_Assets",
#     color = "Line Key",
#     fill = "Fill Key"
#   ) +
#   
#   theme_minimal() +
#   
#   scale_x_date(labels = scales::date_format("%b-%y"), date_breaks = "1 month") +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))+ #update
#   scale_y_continuous(name = "Total_Client_Assets",
#                      breaks = seq(0, max_value, by = 250e6),
#                      labels = function(x) paste0(x/1e6, "M")
#   )
# 
# 
# plot1
# 
# # Going by the code, what should this look like?
# 
