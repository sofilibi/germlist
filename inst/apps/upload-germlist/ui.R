shinyUI(
  pageWithSidebar(
    
    tagList(
      tags$head(
        
        tags$title("Germlist")
      )
    )
    ,
    # Control panel;
    sidebarPanel(
      
      fileInput(inputId = "iFile", label = "", accept="application/vnd.ms-excel"),
      tags$hr(),
      uiOutput(outputId = "ui"),
      submitButton("Show data"),
      tags$br(),
      tags$div(
        HTML('
             <a href="/template.xltx"><img src="/b2.png"  alt="germlist template" title="germlist template"></a>
             
             ')
        ),
      
      
      uiOutput(outputId = "uiMe")
      
      
        )  ,
    
    # Output panel;
    mainPanel(tableOutput(outputId = "contents"))
    
    
      )
  
)



