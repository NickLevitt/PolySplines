# Written by Alex Jacobs and Nick Levitt
library(ggplot2)
library(splines)

# Define UI for spline visualization application
shinyUI(navbarPage("Visualization of Polynomial Splines", 
                   tabPanel("Spline",
                            sidebarLayout(
                              sidebarPanel(
                                selectInput('data', "Select Data To Use",  # Select between mtcars and randomly generated data
                                            choices = c('cars','random')),
                                sliderInput("datasize", "Number of Data Points",  # Select number of datapoints to be shown/generated
                                            min = 10, max = 200, value = 50, step = 10),
                                uiOutput('knotNumber'),  # Select the number of knots to render
                                sliderInput('degrees', 'Degrees of Spline',  # Select the degree of the spline to render
                                            min = 1, max = 20, value = 1, step = 1)
                              ),

                              #Render the plots
                              mainPanel(
                                plotOutput('splinePlot')  # Display the rendered graph
                              )
                            )
                   )
                   
))
