library(shiny)

shinyUI(fluidPage(
  includeCSS("css/style.css"), 
  fluidRow(
    column(12,headerPanel("Beer Recommender"))
  ),
  fluidRow(
    column(4,
      uiOutput("styleControl"),
      sliderInput('nrecs', label = h6("Number of recommendations", style="color:#ffd7e0;"), min=1, max=20, value=5, step=1),
      uiOutput("beerControl"),
      tags$div(style="color:#ffffff;", tags$small("Visit us at "), tags$a(href="http://www.aleph-tech.com","Aleph Technologies"))
    ),
    column(8,
      tabsetPanel(id = "mainPanel", type = "tabs",
            tabPanel("Recommendations", dataTableOutput("recommendations"), style="background-color:#f0f0f0; border-color:#000033;"),
     	    tabPanel("Beer Data", dataTableOutput("table"), style="background-color:#f0f0f0; border-color:#000033;"),
            tabPanel("Description", 
		tags$div(class="mainPanel", style="color:#ffe0e0;", tags$br(),
		tags$small("This application makes use of the "),
		tags$a(href="http://beeradvocate.com/","Beer Advocate "),
		tags$small("community \'s 1.5 million beer reviews made available through "), 
		tags$a(href="http://snap.stanford.edu/data/web-BeerAdvocate.html","Stanford University Data Library "), 
		tags$small("."),
		tags$br(),
		tags$small("We were "), tags$b("greatly inspired "), tags$small("by the "), tags$a(href="http://blog.yhathq.com/posts/recommender-system-in-r.html","Yhat blog post on recommender systems in R"), 
		tags$small(", with additional optimizations to use data.table instead of data.frame whenever possible in order to speed up the process."),
		tags$br(),
		tags$small("The system first loads the review data and extracts the top 100 beers with most reviews. This subset of the reviews will be the basis for the construction of a similarity matrix in the framework of an Item-based"),
		tags$a(href="http://en.wikipedia.org/wiki/Collaborative_filtering","Collaborative Filter"),tags$small("."),
		tags$br(),
		tags$small("The similarity metric is based (as described in the post above) in the weighted correlation of each reviewed feature. There are many other ways to calculate similarities and the weight choice is arbitrary. It will suit the purposes of the current Shiny application. "),
		tags$br(),
		tags$small("The beer names could be restricted to certain beer categories (styles) and the number of recommendations can be adjusted dynamically."),
		tags$br(),
		tags$small("We will explore the possibilities of the recommenderlab packages for recommender validation in a future release.")
          ))
     )
   )
  )
))
