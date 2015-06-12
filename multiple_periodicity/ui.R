library(shiny)
library(shinythemes)
library(htmltools)

  alignCenter <- function(el) {
    htmltools::tagAppendAttributes(el,
    style="margin-left:auto;margin-right:auto;margin-top:0; margin-bottom:0;"
  )
  }
shinyUI(fluidPage(theme = shinytheme("spacelab"),
#  includeCSS("css/style.css"), 
  fluidRow(
    column(2,
	alignCenter(sliderInput('a1',label = "a1", min=0, max=10, value=0.5, step=0.5, animate=TRUE)),
	alignCenter(sliderInput('b1',label = "b1", min=0, max=10, value=2, step=0.5)),
	alignCenter(sliderInput('c1',label = "c1", min=0, max=100, value=50, step=10)),
	alignCenter(sliderInput('a2',label = "a2", min=0, max=10, value=1, step=0.5)),
	alignCenter(sliderInput('b2',label = "b2", min=0, max=10, value=4, step=0.5)),
	alignCenter(sliderInput('c2',label = "c2", min=0, max=100, value=70, step=10)),
	alignCenter(sliderInput('a3',label = "a3", min=0, max=10, value=1.5, step=0.5)),
	alignCenter(sliderInput('b3',label = "b3", min=0, max=10, value=6, step=0.5)),
	alignCenter(sliderInput('c3',label = "c3", min=0, max=100, value=60, step=10)),
	alignCenter(sliderInput('n',label = "n", min=1, max=2200, value=2100, step=10)),
        alignCenter(uiOutput("periodControl"))
    ),
    column(10,
	headerPanel("Multiple Periodicity in Time Series"),
	tags$div(tags$small("s1 = a1 * sin(b1 + [2*"),HTML("&#960;"),tags$small("*t/c1]);  s2 = a2 * sin(b2 + [2*"),HTML("&#960;"),tags$small("*t/c2]);  s3 = a3 * sin(b3 + [2*"),HTML("&#960;"),tags$small("*t/c3])")),
      	tabsetPanel(id = "mainPanel", type = "tabs",
            tabPanel("Plot", plotOutput("plot", width="100%")),
	    tabPanel("Periodogram Data", dataTableOutput("table")),
            tabPanel("Discussion", 
		tags$div(class="mainPanel", tags$br(),
		tags$small("We examine the use of periodograms to extract the main component frequencies."),
		tags$br(),
		tags$small("The original idea ws taken from "),
		tags$a(href="http://www.analyticbridge.com/forum/topics/challenge-of-the-week-detecting-multiple-periodicity-in-time-seri","Data Science Central challenge of the week "),
		tags$br(),
		tags$small("You can control the variables for each of the 3 harmonic functions composing the final waveform that models the time series being analyzed."),
		tags$br(),
		tags$small("The periodogram leverages R\'s implementation of the Discrete Fourier Transform. f1, f2 and f3 are the top-3 most significant spectra. We also show f1\'s 95% confidence interval on a chi-squared distribution.")
          ))
     )
   )
  )
))
