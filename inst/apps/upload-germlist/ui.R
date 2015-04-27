shinyUI(pageWithSidebar(
  # Include css file;
  tagList(
    tags$head(
      tags$title("Upload Data")
    )
  ),
  # Control panel;
  sidebarPanel(
    fileInput(inputId = "iFile", label = "", accept="application/vnd.ms-excel"),
    tags$hr(),
    uiOutput(outputId = "ui"),
    submitButton("Upload!"),
    uiOutput(outputId = "uiMe")
  ),
  # Output panel;
  mainPanel(tableOutput(outputId = "contents"))
))
