library(shiny)
library(stats)
options(digits=2)

shinyServer(function(input, output, session) {
 	get.s1 <- reactive({
		ts((input$a1*sin(input$b1 + 2*pi*1:input$n/input$c1)), start=1, end=input$n, frequency=1)
})
	get.s2 <- reactive({
		ts((input$a2*sin(input$b2 + 2*pi*1:input$n/input$c2)), start=1, end=input$n, frequency=1)
})
	get.s3 <- reactive({
		ts((input$a3*sin(input$b3 + 2*pi*1:input$n/input$c3)), start=1, end=input$n, frequency=1)
})
	get.w1 <- reactive({
		input$c1/input$n
})
	get.w2 <- reactive({
		input$c2/input$n
})
	get.w3 <- reactive({
		input$c3/input$n
})

	get.period <- reactive({
		data.frame(t=as.numeric(1:input$n), period = as.numeric(abs(2*fft(get.s1()+get.s2()+get.s3())/input$n)^2))	
})
	get.asq1 <- reactive({
		(input$a1^2)+(input$b1^2)
})
	get.asq2 <- reactive({
		(input$a2^2)+(input$b2^2)
})
	get.asq3 <- reactive({
		(input$a3^2)+(input$b3^2)
})
	output$table <- renderDataTable({
    		get.period()
  }, options = list(searching = FALSE))
  	output$plot <- renderPlot({
		all.ts <- get.s1()+get.s2()+get.s3()
		w1 <- get.w1()
		w2 <- get.w2()
		w3 <- get.w3()
		asq1 <- get.asq1()
		asq2 <- get.asq2()
		asq3 <- get.asq3()
		par(mfrow=c(5,1), mar=c(5,4,2,1), cex.main=1.5)
		plot(get.s1(),main=paste("s1, omega =",round(w1,5),"A^2 =",asq1, sep=" "),axes=FALSE)
		axis(side=1, at=seq(0, input$n, by=100))
		axis(side=2, at=(c(round(min(get.s1()),2),0,round(max(get.s1()),2))))
		plot(get.s2(),main=paste("s2, omega =",round(w2,5),"A^2 =",asq2, sep=" "), axes=FALSE)
                axis(side=1, at=seq(0, input$n, by=100))
                axis(side=2, at=(c(round(min(get.s2()),2),0,round(max(get.s2()),2))))
		plot(get.s3(),main=paste("s3, omega =",round(w3,5),"A^2 =",asq3, sep=" "), axes=FALSE)
                axis(side=1, at=seq(0, input$n, by=100))
                axis(side=2, at=(c(round(min(get.s3()),2),0,round(max(get.s3()),2))))
		plot(get.s1()+get.s2()+get.s3(),main="s1+s2+s3",axes=TRUE)
		p <- get.period()
		Freq = (0:input$n-1)/input$n
		f1 <- which.max(p$period[1:(input$n/2)])
		f2 <- which.max(p$period[1:(input$n/2)][-f1])
		f3 <- which.max(p$period[1:(input$n/2)][-c(f1,f2)])
		#f1 <- f1-1/input$n
		#f2 <- f2-1/input$n
		#f3 <- f3-1/input$n
		U <- qchisq(.025,2) # Upper 95% quant/2 df
		L <- qchisq(.975,2) # Lower 95%quant/2 df
		f1.low <- 2*p$period[f1]/L
		f1.upp <- 2*p$period[f1]/U
		plot(Freq[1:input$n/2], p$period[1:input$n/2], type='o', lwd=1, main=paste("Periodogram. 95% f1 C.I. = [",f1.low,",",f1.upp,"]",sep=" "), ylab="Spectrum",xlab=paste("Frequency (P1=",round(p$period[f1],6),",",round((f1-1)/input$n,6),"cyc/min, P2=",round(p$period[f2],6),",",round((f2-1)/input$n,6),"cyc/min, P3=",round(p$period[f3],6),",",round((f3-1)/input$n,6),"cyc/min", sep=" "),axes=TRUE)
	},height=650)
})
