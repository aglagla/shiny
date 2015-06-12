library(shiny)
library(ape)
library(stats)

cuts <- c(1:5)
cutColors <- c("#556270", "#4ECDC4", "#1B676B", "#FF6B6B", "#C44D58")
methods <- c("ward.D","ward.D2","average","complete","centroid")
CCPI <- readRDS("data/CPI.Rda")
regions <- unique(levels(CCPI$Region))
regions[7] <- "All"

shinyServer(function(input, output, session) {
  output$regionControl <- renderUI({
	regions <- unique(levels(CCPI$Region))
	regions[7] <- "All"
	selectInput('reg', label = h6("Region", style="color:#ffd7e0;"), regions, selected="All", selectize=FALSE)
  })


  labelSize <- reactive({
    if (input$reg == "All"){
      n <- 0.65
    }
    else {
      n <- 0.8
    }
    n
  })

  dataset <- reactive({
    
    d <<- CCPI
    if (input$reg == "All"){
	d <- d[, 3:5]
    }
    else {
    	d <- d[which(d$Region == input$reg), 3:5]     
    }
    d
  })
  
  output$plot <- renderPlot({
    x <- dataset()
    hc <- hclust(dist(x), method = input$met)
    hcuts <- cutree(hc, input$cut)
    plot(as.phylo(hc), type="fan", font = 2, cex=labelSize(), tip.color = cutColors[hcuts], no.margin=TRUE)
  }, height=600, width=600)

  output$table <- renderDataTable({
    x <<- CCPI
    cbind(Country = rownames(x), x)
  }, options = list(searching = FALSE))
})
