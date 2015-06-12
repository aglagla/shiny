library(shiny)
library(reshape2)
library(plyr)
library(data.table)

sim_corr <- readRDS("data/sim_corr.Rda")
beers <- readRDS("data/beers.Rda")
beer_styles <- function() {
  styles <- beers[,c("beer_style"), with=FALSE]
  setkey(styles,beer_style)
  styles <- unique(styles)
  d <- c("All",styles$beer_style)  
  d
}

find_similar_beers <- function(mybeer, style=NULL, n=5) {
  similar <- subset(sim_corr, beer1==mybeer)
  similar <- merge.data.frame(beers, similar, by.x="beer_name", by.y="beer2")
  if (style != "All") {
    similar <- subset(similar, beer_style==style)
  }
  similar <- similar[order(-similar$sim),]
  n <- min(n, nrow(similar))
  similar <- similar[1:n,c("brewery_name", "beer_name", "beer_style", "sim")]
  names(similar) <- c("Brewery","Beer Name","Beer Style","Similarity")
  similar
}

shinyServer(function(input, output) {
  beer_names <- reactive({
    b <- beers
    setkey(b,beer_name)
    b <- unique(b)
    if (input$sty == "All"){
	d <- b[,c("beer_name"), with=FALSE]$beer_name
    }
    else {
    	d <- b[which(b$beer_style == input$sty)]$beer_name     
    }
    d
  })

  output$styleControl <- renderUI({
        selectInput('sty', label = h6("Beer Style", style="color:#ffd7e0;"), beer_styles(), selected="All", selectize=FALSE)
  })

  output$beerControl <- renderUI({
    selectInput('bee', label = h6("Beer Name", style="color:#ffd7e0;"), beer_names(), selectize=FALSE)
})

  output$recommendations <- renderDataTable({
    find_similar_beers(input$bee, input$sty, input$nrecs) 
})
  output$table <- renderDataTable({
   b <- beers 
   names(b) <- c("Brewery","Beer Name","Beer Style")
   b
  }, options = list(searching = FALSE))

})
