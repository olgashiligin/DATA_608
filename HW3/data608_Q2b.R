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
head(df)

ui<-fluidPage(
  titlePanel(h4("Q2 (aggregated data for all years): Mortality Rates By State VS National Average Mortality Rate", align = "center")),
  sidebarPanel(
    selectInput("disease", "Select Disease", choices = unique(df$ICD.Chapter))
  ),
  mainPanel(
    plotOutput('plot3')
  )
)


server<-shinyServer(function (input, output){
  
  output$plot3 <- renderPlot({
    
    selectedData <- df %>%
      group_by(State, ICD.Chapter) %>% 
      summarise(avg_rate = mean(Crude.Rate)) %>% 
      filter(ICD.Chapter == input$disease)
    
    ggplot(selectedData, aes(reorder(State, avg_rate), avg_rate)) + 
      geom_bar(stat="identity", alpha = 0.5)+
      geom_hline(yintercept = mean(selectedData$avg_rate), color="red") +
      scale_color_manual(labels=c('National Average'), 'Legend', values=c('red'='red'))+
      coord_flip() +
      ggtitle ("Mortality Rates By State VS National Average Mortality Rate (red line - national average mortality rate)") + 
      ylab("Average Mortality Rate")+
      theme_bw()+
      theme(axis.title.y=element_blank())+
      theme(text = element_text(size = 9, color = "black"))
    
    
  }
  )
  
}
)  

shinyApp(ui = ui, server = server)
