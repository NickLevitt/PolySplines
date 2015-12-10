library(ggplot2)
library(splines)
shinyServer(function(input, output, session) {
  
  output$knotNumber = renderUI({
    sliderInput("knots", "Number of Knots",
                min = 1, max = input$datasize - 1, value = 1, step = 1)
  })
  
  output$splinePlot = renderPlot({
    if(input$data == 'random') {
    x = c(1:input$datasize)
    mu = 10 + 5 * sin(x*pi / 24) - 2 * cos((x-6)*4/24)
    set.seed(2010)
    eee = rnorm(length(mu))
    y = mu+eee
    linedf = data.frame(cname = seq(range(x)[1],range(x)[2],(((max(x)-min(x))-1)/input$knots))[2:(input$knots)])
    df = data.frame(x,y)
    }
    else if (input$data == 'cars') {
      x = mtcars$qsec
      y = mtcars$wt
      linedf = data.frame(cname = seq(range(x)[1],range(x)[2],(((max(x)-min(x))-1)/input$knots))[2:(input$knots)])
      df = data.frame(x,y)
    }
    
    if(input$knots != 1) {
    qplot(x, y, data=df, geom=c('point', 'smooth'), method='lm', se = FALSE, formula=y ~ bs(x, knots = seq(range(x)[1],range(x)[2],(((max(x)-min(x))-1)/input$knots))[2:(input$knots)], degree = input$degrees)) +
      geom_vline(data = linedf, aes(xintercept= cname, color = 'red'), linetype = 'dashed', show_guide = F)
    }
    else{
    qplot(x, y, data=df, geom=c('point', 'smooth'), method='lm', se = FALSE, formula=y ~ bs(x, df = input$knots - 1, degree = input$degrees))
    }
  })
})