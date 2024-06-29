rm(list = ls())

# Load the Shiny package
library(shiny)
library(bslib)
library(devtools)
# Load the libraries
library(rvest)
library(dplyr)
#Library
library(ggplot2)
library(ggthemes)
library(dplyr)
library(tidyr)
# Load necessary library
library(readr)



# Define the initial theme
initial_theme <- bs_theme(bootswatch = "cerulean")

# Custom Blue Theme
blue_theme <- bs_theme(
  bg = "#0b3d91", fg = "white", primary = "#FCC780",
  base_font = font_google("Space Mono"),
  code_font = font_google("Space Mono"),
)


github <- 'https://github.com/sapphire-haeward'
chatGPT <- 'https://chatgpt.com'
youtube <- 'https://www.youtube.com/watch?v=BpjLQY452wY'


mySites <- list("ChatGPT"= chatGPT, "Listen: Tarry Among The Peach Blossoms" = youtube, "GitHub" = github)


# Define UI
ui <- fluidPage(
  
  
  # This is how you can change the theme if you need to
  # theme = bs_theme(version = 4, bootswatch = "minty"),
  
  theme = initial_theme,
  
  titlePanel("Sapphire's Demo App: ETL and Data Application"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Analytical Downloads"),
      
      selectInput("theme", "Choose Theme:",
                  choices = c("Default (Light)" = "cerulean",
                              "Dark" = "darkly")),
      
      #"Blue" = blue_theme)),
      p("Download Analysis"),
      
      
      # Binary to Number Converter
      
      # BTC Growth/Loss
      downloadButton("downloadPlot", "BTC Growth/Loss Analysis"),
      
      # Stock Gainers
      downloadButton("downloadExcel", "Download Stock Gainers")
      
    ),
    
    # actionButton("data_visualization", "Under Construction"),
    
    # MAIN PANEL
    mainPanel(
      
      tabsetPanel(
        # tabPanel("Analysis Buttons",
        #          h3("Analysis"),
        #          actionButton("stock_gainers", "Inactive1"),
        #          actionButton("tab1_button2", "Inactive2")
        # ),
        tabPanel("Miscellaneous",
                 h3("Miscellaneous Activity:"),
                 selectInput(inputId='variable',label="Pick a Site",choices=mySites),
                 htmlOutput("inc"),
                 
                 # actionButton("tab2_button2", "Inactive 2")
        )
        
      )
    ) # end main panel
  ) # end sidebar layout
  
) # End UI




# Define server logic
server <- function(input, output, session) {
  # Currently, no server-side logic is needed for empty buttons
  
  # observeEvent(input$BTC_growth_loss, {
  #   withProgress(message = "Generating Analysis",{
  #     source_url("https://raw.githubusercontent.com/sapphire-haeward/DemoApp/main/BTC_ALL_TIME_SLOPE_ANALYSIS_v2_ONLINE.R")
  #   
  #   # setwd("/Users/sapphirehaeward/Downloads/Misc_Application_Buttons")
  #   # source("BTC_ALL_TIME_SLOPE_ANALYSIS.R")  # set value first, then `source`
  # })
  #   output$output_text <- renderText({
  #     "Analysis script executed!"
  #   })
  #   
  # })
  
  # Light/Dark Theme
  observe({
    new_theme <- if (input$theme == "darkly") {
      bs_theme(bootswatch = "darkly")
    } else {
      # else if (input$theme == "cerulean") {
      bs_theme(bootswatch = "cerulean")
    }
    # else if(input$theme == blue_theme) {
    #   blue_theme
    # }
    # 
    # Set new theme
    session$setCurrentTheme(new_theme)
  })
  
  
  
  # Download PDF
  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste("BTC_All-Time_Growth_and_Loss", Sys.Date(), ".pdf", sep="")
    },
    content = function(file) {
      
      # Create a ggplot2 plot
      source_url("https://raw.githubusercontent.com/sapphire-haeward/DemoApp/main/BTC_ALL_TIME_SLOPE_ANALYSIS_v2_ONLINE.R")
      
      # Save the plot as a PDF
      pdf(file)
      print(plot1)
      dev.off()
      
    }
  )
  output$output_text <- renderText({
    "Analysis script executed!"
  })
  
  
  
  
  
  # Download Excel File
  output$downloadExcel <- downloadHandler(
    filename = function() {
      paste("StockAnalysisGAINERS-", Sys.Date(), ".xlsx", sep="")
    },
    content = function(file) {
      
      
      source_url("https://raw.githubusercontent.com/sapphire-haeward/DemoApp/main/Compare_Stock_Gainers.R")
      # Create a workbook and add a worksheet
      wb <- createWorkbook()
      addWorksheet(wb, "Gainers")
      
      # Add some data to the worksheet
      #Styles
      s <- createStyle(numFmt = "#,##0.00", border="TopBottomLeftRight", borderStyle = "medium") # numerical
      gen_num <- createStyle(numFmt = "GENERAL", border="TopBottomLeftRight", borderStyle = "medium", wrapText = T)
      date_style <- createStyle(numFmt = "mm/dd/yyyy", border="TopBottomLeftRight", borderStyle = "medium")
      headerStyle <- createStyle(fontSize = 12, fontColour = "#000000", halign = "center", textDecoration = c("BOLD"),
                                 fgFill = "#bdbdbd", border="TopBottomLeftRight", borderStyle = "thick")
      
      
      addStyle(wb, sheet = 1, headerStyle, rows = 1, cols = 1:ncol(day_month_week_clean), gridExpand = TRUE)
      addStyle(wb, sheet = 1, gen_num, rows = 2:nrow(day_month_week_clean), cols = 5:8, gridExpand = TRUE)
      writeData(wb, sheet = 1, day_month_week_clean, startRow = 1, startCol = 1, borders = "all", borderStyle = "medium")
      
      
      # Save the workbook to the specified file
      saveWorkbook(wb, file, overwrite = TRUE)
      
    })
  output$output_text <- renderText({
    "Gainers Downloaded!"
  })
  
  # Open Websites/Buttons
  
  getPage<-function() {
    
    #GitHub
    if(input$variable == github){
      return((HTML(readLines(github))))
    }
    #ChatGPT
    #     if(input$variable == chatGPT){
    #       
    #       return(
    #         
    #         HTML('<a href="https://chatgpt.com">
    #             <img src="
    # https://img.freepik.com/free-photo/3d-rendering-planet-earth_23-2150498436.jpg?t=st=1719609452~exp=1719613052~hmac=58c2548e9451bbe7c0bc3aef224d73e6a30930d7ae3e37310aec72963c973eb8&w=1060            
    #             " alt="ChatGPT Logo" width="100 height="60">
    #             </a>')
    #       )
    #     }
    
    #ChatGPT
    if (input$variable == "chatGPT") {
      return(
        HTML('<a href="https://chatgpt.com" style="text-decoration: none;">
      <img src="https://img.freepik.com/free-photo/3d-rendering-planet-earth_23-2150498436.jpg?t=st=1719609452~exp=1719613052~hmac=58c2548e9451bbe7c0bc3aef224d73e6a30930d7ae3e37310aec72963c973eb8&w=1060" 
      alt="ChatGPT Logo" style="width: 200px; height: auto; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.3);">
      </a>')
      )
    }
    
    
    if(input$variable == youtube){
      
      return(
        # Button
        # HTML('<a href="https://www.youtube.com/watch?v=BpjLQY452wY">
        #        <img src="https://upload.wikimedia.org/wikipedia/commons/9/90/Logo_of_YouTube_%282013-2015%29.svg" alt="YouTube Logo" width="150" height="50">
        #        </a>')
        
        #Embed
        HTML(
          '<iframe width="560" height="315" 
          src="https://www.youtube.com/embed/bIrOJ2qdnEA?si=3NTzSjRpaKRwfc-z" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>'
        )
      )  
      
    }
    
  } #end getPage function
  output$inc<-renderUI({
    x <- input$variable  
    getPage()
  })
  
  
}   # end of server

# Run the application 
shinyApp(ui = ui, server = server)

