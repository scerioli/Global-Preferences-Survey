library(shiny)
library(data.table)
library(ggplot2)

# ====================== #
#### GLOBAL VARIABLES ####
# ====================== #

# Datasets to create the same plots that we have in the CreatePlotsArticle.r
dataset_1 <- fread("../files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
dataset_2 <- fread("../files/output/main_data_for_histograms.csv")

not_sel <- "Not Selected"


# =================== #
#### DEFINE THE UI ####
# =================== #

ui <- fluidPage(
  # Main title of the panel
  titlePanel("Descriptive Analysis"),
  # Create a side layout that will stay fixed for the whole time
  sidebarLayout(
    # What to show in the side panel
    sidebarPanel(
      # Short text for descriptive purposes
      helpText("Create plots for descriptive analysis"),
      # Interactive selection of input dataset
      selectInput("dataset", 
                  label = "Choose a Dataset to display",
                  choices = c("Dataset 1", 
                              "Dataset 2"
                  ),
                  selected = "Dataset 1"),
      # Interactive selection of the inputs: Select the type of plot to display
      # among the options listed, the selected by default being a scatter plot
      selectInput("plotType", 
                  label = "Choose a plot to display",
                  choices = c("Scatter", 
                              "Column",
                              "Histogram",
                              "Violin",
                              "Barplot"
                  ),
                  selected = "Scatter"),
      # According to the input selected above, set the variable names, their
      # labels and the choices among which to select. 
      # IMPORTANT: Each condition MUST have different variable names because
      # in Java each element must be named in a unique way.
      conditionalPanel(
        condition = "input.plotType == 'Scatter'", 
        selectInput("scatter_var_1", "Numeric Variable", choices = c(not_sel)),
        selectInput("scatter_var_2", "Numeric Variable", choices = c(not_sel)),
        selectInput("scatter_group_var", "Grouping Variable", choices = c(not_sel)),
        selectInput("scatter_facet_var", "Faceting Variable", choices = c(not_sel)),
        actionButton("scatter_run_button", "Run Analysis", icon = icon("play"))
      ),
      conditionalPanel(
        condition = "input.plotType == 'Histogram'",
        selectInput("hist_var_1", "Numeric Variable", choices = c(not_sel)),
        selectInput("hist_group_var", "Grouping Variable", choices = c(not_sel)),
        selectInput("hist_facet_var", "Faceting Variable", choices = c(not_sel)),
        actionButton("hist_run_button", "Run Analysis", icon = icon("play"))
      ),
      conditionalPanel(
        condition = "input.plotType == 'Violin'",
        selectInput("violin_var_1", "Numeric Variable", choices = c(not_sel)),
        selectInput("violin_group_var", "Grouping Variable", choices = c(not_sel)),
        selectInput("violin_facet_var", "Faceting Variable", choices = c(not_sel)),
        actionButton("violin_run_button", "Run Analysis", icon = icon("play"))
      ),
      conditionalPanel(
        condition = "input.plotType == 'Column'",
        selectInput("col_var_1", "Numeric Variable", choices = c(not_sel)),
        selectInput("col_var_2", "Numeric Variable", choices = c(not_sel)),
        selectInput("col_group_var", "Grouping Variable", choices = c(not_sel)),
        selectInput("col_facet_var", "Faceting Variable", choices = c(not_sel)),
        actionButton("col_run_button", "Run Analysis", icon = icon("play"))
      ),
      conditionalPanel(
        condition = "input.plotType == 'Barplot'",
        selectInput("bar_var_1", "Categorical Variable", choices = c(not_sel)),
        selectInput("bar_group_var", "Grouping Variable", choices = c(not_sel)),
        selectInput("bar_facet_var", "Faceting Variable", choices = c(not_sel)),
        actionButton("bar_run_button", "Run Analysis", icon = icon("play"))
      )
    ),
    
    # What to display in the main panel
    mainPanel(
      tabsetPanel(
        # Plot
        tabPanel(title = "Plot",
                 plotOutput("plot")
        ),
        # Instructions for the main plots of the article
        tabPanel(title = "Instructions to recreate the plots",
                 fluidRow(p(h5("Fig. 1A: Dataset 2 - Column Plot"), 
                            "Numeric Variable (x) = GDPquant", br(), 
                            "Numeric Variable (y) = meanGenderGDP", br(), 
                            "Faceting Variable = preference", 
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 1B: Dataset 1 - Scatter Plot"),
                            "Numeric Variable (x) = logAvgGDPpc", br(),
                            "Numeric Variable (y) = avgGenderDiffRescaled",
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 1C: Dataset 2 - Column Plot"),
                            "Numeric Variable (x) = GEIquant", br(), 
                            "Numeric Variable (y) = meanGenderGEI", br(), 
                            "Faceting Variable = preference",
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 1D: Dataset 1 - Scatter Plot"),
                            "Numeric Variable (x) = GenderIndexRescaled", br(), 
                            "Numeric Variable (y) = avgGenderDiffRescaled",
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 2A: Dataset 1 - Scatter Plot"), 
                            "Numeric Variable (x) = residualslogAvgGDPpc", br(), 
                            "Numeric Variable (y) = residualsavgGenderDiff_GEI", 
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 2B: Dataset 1 - Scatter Plot"), 
                            "Numeric Variable (x) = residualsGenderIndexStd", br(), 
                            "Numeric Variable (y) = residualsavgGenderDiff_GDP", 
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 2C: Dataset 1 - Scatter Plot"), 
                            "Numeric Variable (x) = residualsScoreWEFStd", br(), 
                            "Numeric Variable (y) = residualsavgGenderDiff_GDP", 
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 2D: Dataset 1 - Scatter Plot"), 
                            "Numeric Variable (x) = residualsValueUNStd", br(), 
                            "Numeric Variable (y) = residualsavgGenderDiff_GDP", 
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 2E: Dataset 1 - Scatter Plot"), 
                            "Numeric Variable (x) = residualsavgRatioLaborStd", br(), 
                            "Numeric Variable (y) = residualsavgGenderDiff_GDP", 
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                          p(h5("Fig. 2F: Dataset 1 - Scatter Plot"), 
                            "Numeric Variable (x) = residualsDateStd", br(), 
                            "Numeric Variable (y) = residualsavgGenderDiff_GDP", 
                            style = "font-family: 'arial'; font-si16pt"),
                          br(),
                 ))
      )
    )
  )
)


# =============================== #
#### DEFINE THE PLOT FUNCTIONS ####
# =============================== #
# Note: This is an extra to avoid having a lot of code in the server function

# Scatter Plot
draw_scatter <- function(data_input, scatter_var_1, scatter_var_2, 
                         scatter_group_var, scatter_facet_var) {
  if (scatter_group_var != not_sel) {
    data_input[, (scatter_group_var) := as.factor(data_input[, get(scatter_group_var)])]
  }
  
  plot <- ggplot(data = data_input, aes_string(x = scatter_var_1, 
                                               y = scatter_var_2))
  # Grouping variable
  if (scatter_group_var != not_sel) {
    plot <- plot + geom_point(aes_string(color = scatter_group_var))
  } else {
    plot <- plot + geom_point()
  }
  # Faceting variable
  if (scatter_facet_var != not_sel) {
    plot <- plot + facet_wrap(~ as.factor(get(scatter_facet_var)))
  }
  
  return(plot)
}

# Column Plot
draw_col <- function(data_input, col_var_1, col_var_2, 
                     col_group_var, col_facet_var) {
  if (col_group_var != not_sel) {
    data_input[, (col_group_var) := as.factor(data_input[, get(col_group_var)])]
  }
  
  plot <- ggplot(data = data_input, aes_string(x = col_var_1, 
                                               y = col_var_2))
  # Grouping variable
  if (col_group_var != not_sel) {
    plot <- plot + geom_col(aes_string(fill = col_group_var))
  } else {
    plot <- plot + geom_col()
  }
  # Faceting variable
  if (col_facet_var != not_sel) {
    plot <- plot + facet_wrap(~ as.factor(get(col_facet_var)))
  }
  
  return(plot)
}

# Histogram
draw_hist <- function(data_input, hist_var_1, hist_group_var, hist_facet_var) {
  if (hist_group_var != not_sel) {
    data_input[, (hist_group_var) := as.factor(data_input[, get(hist_group_var)])]
  }
  
  plot <- ggplot(data = data_input, aes_string(x = hist_var_1))
  # Grouping variable
  if (hist_group_var != not_sel) {
    plot <- plot + geom_histogram(aes_string(fill = hist_group_var), position = "dodge")
  } else {
    plot <- plot + geom_histogram()
  }
  # Faceting variable
  if (hist_facet_var != not_sel) {
    plot <- plot + facet_wrap(~ as.factor(get(hist_facet_var)))
  }
  
  return(plot)
}

# Violin Plot
draw_violin <- function(data_input, violin_var_1, violin_group_var, violin_facet_var) {
  if (violin_group_var != not_sel) {
    data_input[, (violin_group_var) := as.factor(data_input[, get(violin_group_var)])]
  }
  
  plot <- ggplot(data = data_input, aes_string(x = violin_group_var, 
                                               y = violin_var_1)) +
    geom_violin()
  # Faceting variable
  if (violin_facet_var != not_sel) {
    plot <- plot + facet_wrap(~ as.factor(get(violin_facet_var)))
  }
  
  return(plot)
}

# Barplot
draw_bar <- function(data_input, bar_var_1, bar_group_var, bar_facet_var) {
  if (bar_group_var != not_sel) {
    data_input[, (bar_group_var) := as.factor(data_input[, get(bar_group_var)])]
  }
  
  if (bar_group_var != not_sel) {
    plot <- ggplot(data = data_input, aes_string(x = bar_var_1)) +
      geom_bar(aes_string(fill = bar_group_var), position = "dodge")
  } else {
    plot <- ggplot(data = data_input, aes_string(x = bar_var_1)) +
      geom_bar()
  }
  # Faceting variable
  if (bar_facet_var != not_sel) {
    plot <- plot + facet_wrap(~ as.factor(get(bar_facet_var)))
  }
  
  return(plot)
}


# ======================= #
#### DEFINE THE SERVER ####
# ======================= #

server <- function(input, output, session) {
  
  # Update the dataset based on the selected input
  dataToPlot <- reactive({
    switch(input$dataset,
           "Dataset 1" = dataset_1,
           "Dataset 2" = dataset_2)
  })
  
  # Update the choices based on the selected dataset
  observeEvent(dataToPlot(), {
    choices <- c(not_sel, names(dataToPlot()))
    updateSelectInput(inputId = "scatter_var_1", choices = choices)
    updateSelectInput(inputId = "scatter_var_2", choices = choices)
    updateSelectInput(inputId = "scatter_group_var", choices = choices)
    updateSelectInput(inputId = "scatter_facet_var", choices = choices)
    
    updateSelectInput(inputId = "col_var_1", choices = choices)
    updateSelectInput(inputId = "col_var_2", choices = choices)
    updateSelectInput(inputId = "col_group_var", choices = choices)
    updateSelectInput(inputId = "col_facet_var", choices = choices)
    
    updateSelectInput(inputId = "violin_var_1", choices = choices)
    updateSelectInput(inputId = "violin_group_var", choices = choices)
    updateSelectInput(inputId = "violin_facet_var", choices = choices)
    
    updateSelectInput(inputId = "bar_var_1", choices = choices)
    updateSelectInput(inputId = "bar_group_var", choices = choices)
    updateSelectInput(inputId = "bar_facet_var", choices = choices)
    
    updateSelectInput(inputId = "hist_var_1", choices = choices)
    updateSelectInput(inputId = "hist_group_var", choices = choices)
    updateSelectInput(inputId = "hist_facet_var", choices = choices)
  })
  
  # Define the output for the scatter plot
  plot_scatter <- eventReactive(input$scatter_run_button, {
    # Update the values of the input variables after that the button 
    # "Run Analysis" has been pushed
    scatter_var_1 <- eventReactive(input$scatter_run_button, input$scatter_var_1)
    scatter_var_2 <- eventReactive(input$scatter_run_button, input$scatter_var_2)
    scatter_group_var <- eventReactive(input$scatter_run_button, input$scatter_group_var)
    scatter_facet_var <- eventReactive(input$scatter_run_button, input$scatter_facet_var)
    
    # Use the corresponding function to plot.
    # NOTE: The input variables are actually functions, because they are updated
    # above from eventReactive
    draw_scatter(dataToPlot(), scatter_var_1(), scatter_var_2(), 
                 scatter_group_var(), scatter_facet_var())
  })
  
  # Define the output for the column plot
  plot_col <- eventReactive(input$col_run_button, {
    # Update the values of the input variables after that the button 
    # "Run Analysis" has been pushed
    col_var_1 <- eventReactive(input$col_run_button, input$col_var_1)
    col_var_2 <- eventReactive(input$col_run_button, input$col_var_2)
    col_group_var <- eventReactive(input$col_run_button, input$col_group_var)
    col_facet_var <- eventReactive(input$col_run_button, input$col_facet_var)
    
    draw_col(dataToPlot(), col_var_1(), col_var_2(), col_group_var(), col_facet_var())
  })
  
  # Define the output for the histogram
  plot_hist <- eventReactive(input$hist_run_button, {
    
    hist_var_1     <- eventReactive(input$hist_run_button, input$hist_var_1)
    hist_group_var <- eventReactive(input$hist_run_button, input$hist_group_var)
    hist_facet_var <- eventReactive(input$hist_run_button, input$hist_facet_var)
    
    draw_hist(dataToPlot(), hist_var_1(), hist_group_var(), hist_facet_var())
  })
  
  # Define the output for the violin plot
  plot_violin <- eventReactive(input$violin_run_button, {
    
    violin_var_1     <- eventReactive(input$violin_run_button, input$violin_var_1)
    violin_group_var <- eventReactive(input$violin_run_button, input$violin_group_var)
    violin_facet_var <- eventReactive(input$violin_run_button, input$violin_facet_var)
    
    draw_violin(dataToPlot(), violin_var_1(), violin_group_var(), violin_facet_var())
  })
  
  # Define the output for the violin plot
  plot_bar <- eventReactive(input$bar_run_button, {
    
    bar_var_1     <- eventReactive(input$bar_run_button, input$bar_var_1)
    bar_group_var <- eventReactive(input$bar_run_button, input$bar_group_var)
    bar_facet_var <- eventReactive(input$bar_run_button, input$bar_facet_var)
    
    draw_bar(dataToPlot(), bar_var_1(), bar_group_var(), bar_facet_var())
  })
  
  # Render the plot as an output, choosing a different function for each type of
  # plot selected as an input
  output$plot <- renderPlot({
    switch(input$plotType,
           "Scatter"   = plot_scatter(),
           "Column"    = plot_col(),
           "Histogram" = plot_hist(),
           "Violin"    = plot_violin(),
           "Barplot"   = plot_bar()
    )
  })
  
  outputOptions(output, "plot", suspendWhenHidden = FALSE)
  
}

shinyApp(ui = ui, server = server)


