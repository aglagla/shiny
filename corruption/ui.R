library(shiny)

cuts <- c(1:5)
cutColors <- c("#556270", "#4ECDC4", "#1B676B", "#FF6B6B", "#C44D58")
methods <- c("ward.D","ward.D2","average","complete","centroid")

shinyUI(fluidPage(
  includeCSS("css/style.css"), 
  fluidRow(
    column(12,headerPanel("Corruption Perception Index Explorer"))
  ),
  fluidRow(
    column(1,
      uiOutput("regionControl"),
      selectInput('met', label = h6("Agglomerative method", style="color:#ffd7e0;"), methods, selected="average", selectize=FALSE),
      sliderInput('cut', label = h6("Number of cuts", style="color:#ffd7e0;"), min=1, max=5, value=1),
      tags$div(style="color:#ffffff;", tags$small("Visit us at "), tags$a(href="http://www.aleph-tech.com","Aleph Technologies"))
    ),
    column(11,
      tabsetPanel(id = "mainPanel", type = "tabs",
            tabPanel("Plot", plotOutput("plot", width="100%")),
     	    tabPanel("Data", dataTableOutput("table"), style="background-color:#f0f0f0; border-color:#000033;"),
            tabPanel("Description", 
		tags$div(class="mainPanel", style="color:#ffe0e0;", tags$br(),
		tags$small("This application was inspired by the "),
		tags$a(href="http://arxiv.org/abs/1502.00104","Worldwide clustering of the corruption perception "),
		tags$small("paper by "), tags$b("Michal Paulus"), tags$small(" and "), tags$b("Ladislav Kristoufek"),tags$small("."),
		tags$br(),
		tags$small("We used the "), tags$b("Transparency International\'s "), tags$a(href="http://www.transparency.org/research/cpi/overview","Corruption Perception Index "),
		tags$small("for the report years 2014, 2013 and 2012."),
		tags$br(),
		tags$small("To build the fan-style dendrogram we have used a hierarchical clustering algorithm with different agglomerative methods. Our cluster is based upon the euclidean "),
		tags$br(),
		tags$small("distance of each country\'s CPI observation.  We can also filter the dataset based on the region and cut the tree so that clusters having the same height share "),
		tags$small("the same color.")
          ))
     )
   )
  )
))
