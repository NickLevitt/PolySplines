library(ggplot2)
library(splines)

# Initialize the server
shinyServer(function(input, output, session) {
  
  # Generate the UI for selecting the number of knots.
  # Set the max number of knots possible to the number of datapoints minus one.
  output$knotNumber = renderUI({
    sliderInput("knots", "Number of Knots",
                min = 1, max = input$datasize - 1, value = 1, step = 1)
  })
  
  # Render the plot.
  output$splinePlot = renderPlot({
    # If the data is selected to be randomly generated:
    if(input$data == 'random') {
      # Generate the x and y data, set the seed for consistency
      x = c(1:input$datasize)
      mu = 10 + 5 * sin(x*pi / 24) - 2 * cos((x-6)*4/24)
      set.seed(2010)
      eee = rnorm(length(mu))
      y = mu+eee
      # Build the dataframe to store the knots in
      linedf = data.frame(cname = seq(range(x)[1],range(x)[2],(((max(x)-min(x))-1)/input$knots))[2:(input$knots)])
      # Build the dataframe to store the x,y data in
      df = data.frame(x,y)
    }
    # If the data is selected to be the mtcars
    else if (input$data == 'cars') {
      # Grab the data from mtcars, x is quarter mile time and y is weight
      x = mtcars$qsec
      y = mtcars$wt
      # Build the dataframe to store the knots in
      linedf = data.frame(cname = seq(range(x)[1],range(x)[2],(((max(x)-min(x))-1)/input$knots))[2:(input$knots)])
      # Build the dataframe to store the x,y data in
      df = data.frame(x,y)
    }
    
    # If the number of knots is not equal to one, display the data and the knots on a ggplot graph.
    if(input$knots != 1) {
    qplot(x, y, data=df, geom=c('point', 'smooth'), method='lm', se = FALSE, formula=y ~ bs(x, knots = seq(range(x)[1],range(x)[2],(((max(x)-min(x))-1)/input$knots))[2:(input$knots)], degree = input$degrees)) +
      geom_vline(data = linedf, aes(xintercept= cname, color = 'red'), linetype = 'dashed', show_guide = F)
    }
    # Otherwise, just display the data and plot the line/polynomial
    else{
    qplot(x, y, data=df, geom=c('point', 'smooth'), method='lm', se = FALSE, formula=y ~ bs(x, df = input$knots - 1, degree = input$degrees))
    }
  })
})