 library(sqldf)
library(shiny)
 library(shinyWidgets)

 aggregated_data = sqldf("SELECT YEAR, COUNTRY, JOB_CATEGORY, COUNT(PHONE_SCREENING) AS PHONE_SCREENING, COUNT(INTERVIEW) AS INTERVIEW, COUNT(OFFER) AS OFFER
                         FROM j_h2
                         GrOUP BY JOB_CATEGORY, YEAR, COUNTRY
                         ORDER BY JOB_CATEGORY")
 shinyApp(
         ui = fluidPage(
                 titlePanel("JOB HUNT RESULTS"),
                 sidebarPanel(
                         selectizeGroupUI(
                                 id = "fancy_filters",
                                 inline = FALSE,
                                 params = list(
                                         YEAR = list(inputId = "YEAR", placeholder = 'All'),
                                         COUNTRY = list(inputId = "COUNTRY", title = "Country", placeholder = 'All'),
                                         JOB_CATEGORY = list(inputId = "JOB_CATEGORY", title = "Job category", placeholder = 'All'),
                                         PHONE_SCREENING = list(inputId = "PHONE_SCREENING", title = "Number of positive replies", placeholder = 'All'),
                                         INTERVIEW = list(inputId = "OFFER", title = "Number of offers", placeholder = 'All')
                                     )
                             )
                     ),
                 mainPanel(
                         tableOutput("jobhuntData")
                     )
             ),
         server = function(input, output, session) {
                 res_mod <- callModule(
                         module = selectizeGroupServer,
                         id = "fancy_filters",
                         data = aggregated_data,
                         vars = c("YEAR", "COUNTRY", "JOB_CATEGORY", "PHONE_SCREENING", "INTERVIEW", "OFFER")
                     )
                 output$jobhuntData <- renderTable({
                         res_mod()
                     })
             }
     )