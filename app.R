library(shiny)
library(shinythemes)
library(ggplot2)
library(plotly)

# Specify the UI for Dashboard
ui <- fluidPage(
  
  # Custom CSS to set the font color to orange
  tags$head(
    tags$style(HTML("
      body {
        color: orange; /* Set font color to orange */
      }
      h3, h4, p, label, .btn {
        color: orange; /* Apply orange color to headers, paragraphs, labels, and buttons */
      }
    "))
  ),
  
  # Use the theme cosmo : https://rstudio.github.io/shinythemes/
  theme = shinytheme("darkly"),
  
  titlePanel("Wet Lab Calculation Dashboard"),
  
  # Insert Tab layouts (For results and plots)
  tabsetPanel(
    tabPanel("Inputs & Results",
             sidebarLayout(
               sidebarPanel(
                 h3("Select Calculation Type"),
                 selectInput("calc_type", "Calculation:", 
                             choices = list("Serial Dilution" = "serial",
                                            "Stock Solution Dilution" = "stock",
                                            "dPCR Master Mix" = "dpcr")),
                 
                 # User Input fields for Serial Dilution
                 conditionalPanel(
                   condition = "input.calc_type == 'serial'",
                   numericInput("init_conc", "Initial Concentration (M):", 1),
                   numericInput("dil_factor", "Dilution Factor:", 10),
                   numericInput("num_steps", "Number of Dilution Steps:", 3)
                 ),
                 
                 # User Input fields for Stock Solution Dilution
                 conditionalPanel(
                   condition = "input.calc_type == 'stock'",
                   numericInput("stock_conc", "Stock Concentration (M):", 10),  # Example: 10X stock solution
                   numericInput("final_conc", "Desired Final Concentration (M):", 1),  # Example: 1X buffer
                   numericInput("final_vol", "Final Volume (mL):", 500)  # Example: Prepare 500 mL
                 ),
                 
                 # User Input fields for dPCR Master Mix
                 conditionalPanel(
                   condition = "input.calc_type == 'dpcr'",
                   numericInput("num_samples", "Number of Samples:", 8),
                   numericInput("reaction_vol", "Reaction Volume (µL):", 40),
                   numericInput("primer_vol", "Primer Volume per Reaction (µL):", 2),
                   numericInput("rtmix_vol", "RT Mix per Reaction (µL):", 1),
                   numericInput("gcenhancer_vol", "GC Enhancer per Reaction (µL):", 1),
                   numericInput("mmmix_vol", "MM Mix per Reaction (µL):", 1)
                 )
               ),
               
               # Main panel to display results and visuals
               mainPanel(
                 h3("Results"),
                 textOutput("result"),
                 uiOutput("schematic")  # Textual explanation for each calculation
               )
             )
    ),
    
    tabPanel("Plots",
             h3("Plots"),
             plotlyOutput("plot_output")  # Updated plot output element name
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$result <- renderText({
    calc_type <- input$calc_type
    
    if (calc_type == "serial") {
      # Serial Dilution Calculation Logic
      init_conc <- input$init_conc
      dil_factor <- input$dil_factor
      num_steps <- input$num_steps
      conc_after_dil <- init_conc / (dil_factor ^ num_steps)
      return(paste("After", num_steps, "steps, the final concentration is:",
                   round(conc_after_dil, 6), "M"))
      
    } else if (calc_type == "stock") {
      # Stock Solution Dilution Calculation Logic (C1 * V1 = C2 * V2)
      stock_conc <- input$stock_conc
      final_conc <- input$final_conc
      final_vol <- input$final_vol
      stock_vol <- (final_conc * final_vol) / stock_conc
      water_vol <- final_vol - stock_vol
      return(paste(
        "To prepare", final_vol, "mL of", final_conc, "M solution, use",
        round(stock_vol, 2), "mL of the stock solution and",
        round(water_vol, 2), "mL of water."
      ))
      
    } else if (calc_type == "dpcr") {
      # dPCR Master Mix Calculation Logic
      num_samples <- input$num_samples
      reaction_vol <- input$reaction_vol
      primer_vol <- input$primer_vol
      rtmix_vol <- input$rtmix_vol
      gcenhancer_vol <- input$gcenhancer_vol
      mmmix_vol <- input$mmmix_vol
      
      total_primer <- num_samples * primer_vol
      total_rtmix <- num_samples * rtmix_vol
      total_gcenhancer <- num_samples * gcenhancer_vol
      total_mmmix <- num_samples * mmmix_vol
      total_water <- (reaction_vol * num_samples) - (total_primer + total_rtmix + total_gcenhancer + total_mmmix)
      
      return(paste("For", num_samples, "Samples of", reaction_vol, "µL each:",
                   "\nTotal Primer Volume:", total_primer, "µL",
                   "\nTotal RT Mix Volume:", total_rtmix, "µL",
                   "\nTotal GC Enhancer Volume:", total_gcenhancer, "µL",
                   "\nTotal Master Mix Volume:", total_mmmix, "µL",
                   "\nTotal Water to add:", round(total_water, 2), "µL"))
    }
  })
  
  # Visual Plot for Serial Dilution
  output$plot_output <- renderPlotly({
    calc_type <- input$calc_type
    
    if (calc_type == "serial") {
      # Plot for Serial Dilution
      init_conc <- input$init_conc
      dil_factor <- input$dil_factor
      num_steps <- input$num_steps
      
      steps <- 0:num_steps
      concentrations <- init_conc / (dil_factor ^ steps)
      
      df <- data.frame(steps, concentrations)
      p <- ggplot(df, aes(x = steps, y = concentrations)) +
        geom_line() +
        geom_point() +
        labs(x = "Dilution Steps", y = "Concentration (M)",
             title = "Concentration vs. Dilution Steps") +
        theme_minimal()
      
      ggplotly(p)
      
    } else if (calc_type == "stock") {
      # Bar Plot for Stock Solution Dilution
      stock_conc <- input$stock_conc
      final_conc <- input$final_conc
      final_vol <- input$final_vol
      stock_vol <- (final_conc * final_vol) / stock_conc
      water_vol <- final_vol - stock_vol
      
      df <- data.frame(Volume = c("Stock Solution", "Water"), Amount = c(stock_vol, water_vol))
      p <- ggplot(df, aes(x = Volume, y = Amount, fill = Volume)) +
        geom_bar(stat = "identity") +
        labs(title = "Stock Solution and Water Volumes for Dilution", y = "Volume (mL)") +
        theme_minimal()
      
      ggplotly(p)
      
    } else if (calc_type == "dpcr") {
      # Bar Plot for dPCR Master Mix
      num_samples <- input$num_samples
      primer_vol <- input$primer_vol
      rtmix_vol <- input$rtmix_vol
      gcenhancer_vol <- input$gcenhancer_vol
      mmmix_vol <- input$mmmix_vol
      reaction_vol <- input$reaction_vol
      
      total_primer <- num_samples * primer_vol
      total_rtmix <- num_samples * rtmix_vol
      total_gcenhancer <- num_samples * gcenhancer_vol
      total_mmmix <- num_samples * mmmix_vol
      total_water <- (reaction_vol * num_samples) - (total_primer + total_rtmix + total_gcenhancer + total_mmmix)
      
      df <- data.frame(Reagent = c("Primer", "RT Mix", "GC Enhancer", "MM Mix", "Water"),
                       Volume = c(total_primer, total_rtmix, total_gcenhancer, total_mmmix, total_water))
      p <- ggplot(df, aes(x = Reagent, y = Volume, fill = Reagent)) +
        geom_bar(stat = "identity") +
        labs(title = "dPCR Master Mix Volumes", y = "Total Volume (µL)") +
        theme_minimal()
      
      ggplotly(p)
    }
  })
  
  # Schematic explanation for each calculation type
  output$schematic <- renderUI({
    calc_type <- input$calc_type
    
    if (calc_type == "serial") {
      HTML("<p><strong>Serial Dilution:</strong> This process involves diluting a solution step-by-step. For each step, you reduce the concentration by a factor (Dilution Factor). The interactive plot in the 'Plots' tab shows how the concentration decreases across steps.</p>")
      
    } else if (calc_type == "stock") {
      HTML("<p><strong>Stock Solution Dilution:</strong> To make a solution of lower concentration from a stock, mix a precise volume of the stock solution with water or solvent. The bar plot in the 'Plots' tab shows the volumes of the stock solution and water required for dilution.</p><p><strong>Example:</strong>How to prepare 1X TAE buffer from 10X stock solution for Gel Electrophoresis?</p><p><strong>Solution:</strong>Using the equation, <strong>C1V1 = C2V2</strong>,</p><p>C1 = 10, V1 = ?, C2 = 1, V2 = 500 mL</p><p>V1 = 50 mL (So, take 50 mL of 10X stock and dilute with 450 mL of water)</p>")
      
      
    } else if (calc_type == "dpcr") {
      HTML("<p><strong>dPCR Master Mix Preparation:</strong> This method allows you to calculate the volumes of reagents (primer, RT mix, GC enhancer, MM mix) required for preparing digital PCR reactions. The bar plot in the 'Plots' tab shows the amount of each reagent needed for the specified number of samples.</p>")
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
