rm(list = ls())

# Load the Shiny package
library(shiny)
library(bslib)
library(devtools)


# Define UI
ui <- fluidPage(
  
  # This is how you can change the theme if you need to
  theme = bs_theme(version = 4, bootswatch = "minty"),
  
  titlePanel("Sapphire's Miscellaneous ETL and Data Application: Demo App"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Sidebar Panel"),
      
      
      # Binary to Number Converter
      actionButton("BTC_growth_loss", "BTC Growth/Loss Analysis"),
      
      actionButton("data_visualization", "Under Construction")
    ),
    
    
    mainPanel(
      
      tabsetPanel(
        tabPanel("New Buttons",
                 h3("Content for Tab 1"),
                 actionButton("stock_gainers", "Stock Gainers"),
                 actionButton("tab1_button2", "Tab 1 Button 2")
        ),
        tabPanel("Tab 2",
                 h3("Content for Tab 2"),
                 actionButton("tab2_button1", "Tab 2 Button 1"),
                 actionButton("tab2_button2", "Tab 2 Button 2")
        )
        
      )
    ) # end main panel
    
  )# end sidebar layout
)

# Define server logic
server <- function(input, output) {
  # Currently, no server-side logic is needed for empty buttons
  
  observeEvent(input$BTC_growth_loss, {
    withProgress(message = "Generating Analysis",{
      source_url("https://raw.githubusercontent.com/sapphire-haeward/DemoApp/main/BTC_ALL_TIME_SLOPE_ANALYSIS_v2_ONLINE.R")
    
    # setwd("/Users/sapphirehaeward/Downloads/Misc_Application_Buttons")
    # source("BTC_ALL_TIME_SLOPE_ANALYSIS.R")  # set value first, then `source`
  })
    output$output_text <- renderText({
      "Analysis script executed!"
    })
    
  })
  
  observeEvent(input$stock_gainers, {
    withProgress(message = "Comparing Stock Gainers",{
    source_url("https://raw.githubusercontent.com/sapphire-haeward/DemoApp/main/Compare_Stock_Gainers.R")
      })
    
    output$output_text <- renderText({
      "Stock gainers compared!"
    })
  })
  

  
}

# Run the application 
shinyApp(ui = ui, server = server)


