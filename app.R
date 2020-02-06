# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ----
# Shiny App to Track Time from an Audio File                                ----
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Author:  Gustavo Varela Alvarenga
# Contact: contact@ogustavo.com
# Date:    02/05/2020

# ************************************************************************* ----
# Packages and Functions                                                    ----
# >                                                                         ----

library("shiny")

# ************************************************************************* ----
# UI                                                                        ----
# >                                                                         ----
#

ui <- fluidPage(
  # |__ Import File Widget -----------------------------------------------------
  fileInput(
    inputId = "importAudio", 
    label = h3("Import Audio File"),
    accept = c(
      "audio/wav"
    )
  ),
  tags$hr(),
  # |__ Print Audio Container --------------------------------------------------
  uiOutput("getTimeAudio"),
  # |__ Print Audio Time -------------------------------------------------------
  uiOutput("trackTime")
)

# ************************************************************************* ----
# SERVER                                                                    ----
# >                                                                         ----
#
server <- function(input, output, session) {
  
  # |__ Audio Container --------------------------------------------------------
  output$getTimeAudio <- renderUI({
    list(
      # \____ JS function to get times -----------------------------------------
      ## function name: getTime()
      ## input$audioTime receives current audio time (event.currentTime)
      ## input$audioDuration receives total audio duration (event.duration)
      tags$script(paste0(
        "function getTime(event) {", "\n",
            "Shiny.setInputValue('audioTime', event.currentTime);", "\n",
            "Shiny.setInputValue('audioDuration', event.duration);", "\n",
        "};"
      )),
      
      # \____ HTML Audio Player ------------------------------------------------
      ## Prints audio player
      
      tags$audio(
        src = input$importAudio,
        type = "audio/wav",
        controls = NA,
        ontimeupdate = "getTime(this)" # <- getTime function gets info from
      )                                #    this container
    )
})
  
  # |__ Audio Time -------------------------------------------------------------
  output$trackTime <- renderUI({
    
    audioAt    <- input$audioTime
    audioTotal <- input$audioDuration
    
    if (is.null(audioAt))    audioAt       <- 0
    if (is.null(audioTotal)) audioTotal    <- 0
    
    h4(paste0("Audio at: ", audioAt, "s / ", audioTotal, "s (total time)"))
  })
  
}

# ************************************************************************* ----
# RUN APP                                                                   ----
# >                                                                         ----
#  
shinyApp(ui = ui, server = server)
# ************************************************************************* ----
# End  ----
