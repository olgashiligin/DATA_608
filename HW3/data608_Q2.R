# Question 2:
# Often you are asked whether particular States are improving their mortality rates (per cause) faster than, 
# or slower than, the national average. Create a visualization that lets your clients see this for themselves 
# for one cause of death at the time. Keep in mind that the national average should be weighted by the national 
# population.

library(rsconnect)
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)

df<-read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv")


ui<-fluidPage(
  titlePanel(h4("Q2: Mortality Rate By States By Year VS National Average Mortality Rate By Year", align = "center")),
  sidebarPanel(
    selectInput("disease", "Select Disease", choices = sort(unique(df$ICD.Chapter))),
    selectInput("state", "Select State", choices = sort(unique(df$State)))
  ),
  mainPanel(
    plotOutput('plot3')
  )
)
   
  server<- function(input, output) {
    output$plot3 <- renderPlot({
      # df for states mortality rate by year
      state_avg <- df %>% 
        filter(State==input$state, ICD.Chapter==input$disease)
      
      # df for national average mortality rate by year
      nat_avg <- df %>% 
        filter(ICD.Chapter==input$disease) %>% 
        group_by(Year) %>% 
        summarise(nat_avg_by_year=(sum(as.numeric(Deaths))/sum(as.numeric(Population))*100000))
      
      ggplot(state_avg, aes(x=Year, y=Crude.Rate)) + 
        geom_bar(stat="identity", width = 0.7, alpha = 0.5) +  
        geom_line(aes(x=nat_avg$Year, y=nat_avg$nat_avg_by_year, color='red'),size=0.5) +
        scale_color_manual(labels=c('National Average'), 'Legend', values=c('red'='red'))+
        ylab("Mortality Rate")+
        theme(axis.title.x=element_blank())+
        theme_bw()+
        theme(text = element_text(size = 9, color = "black")) +
        ggtitle ("Mortality Rate By States By Year VS National Average Mortality Rate By Year")
    })
  }

shinyApp(ui = ui, server = server)
