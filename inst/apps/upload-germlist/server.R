library(XLConnect)

shinyServer(function(input, output) {
  chooseFile <- reactive({
    inFile <- input$iFile
    if (!is.null(inFile)) {
      # Determine document format;
      ptn <- "\\.[[:alnum:]]{1,5}$"
      suf <- tolower(regmatches(inFile$name, regexpr(ptn, inFile$name)))
      
      # Options for Excel documents;
      if (suf %in% c('.xls', '.xlsx')) {
        wb <- loadWorkbook(inFile$datapath)
        sheets <- getSheets(wb)
        output$ui <- renderUI({
          list(
            selectInput(inputId = "sheet", label = "Select a sheet:", choices = sheets),
            textInput(inputId = 'arg', label = 'Additional Arguments:', value = ' '),
            tags$hr()
          )
        })
        return(list(path = inFile$datapath, suf = suf))
      }
      
      # Options for txt documents;
      if (suf %in% c('.txt', '.csv')) {
        output$ui <- renderUI({
          list(
            checkboxInput(inputId = 'header', label = 'First line as header', value = TRUE),
            textInput(inputId = 'sep', label = 'Separator', value = " "),
            textInput(inputId = 'quote', label = 'Quote', value = '\"'),
            textInput(inputId = 'arg', label = 'Additional Arguments:', value = ' '),
            tags$hr()
          )
        })
        return(list(path = inFile$datapath, suf = suf))
      }
    } else {return(NULL)}
  })
  
  
  output$contents <- renderTable({
    objFile <- chooseFile()
    if (!is.null(objFile)) {
      suf <- objFile$suf
      # For Excel documents;
      if (suf %in% c('.xls', '.xlsx')) {
        Sheet <- input$sheet
        if (!is.null(Sheet)){
          
          if (input$arg %in% c(' ', '')) {
            wb <- loadWorkbook(objFile$path)
            dat <- readWorksheet(wb, Sheet)
            dat <- dat[1:10, 1:5]
            print(dat)
            print(class(dat))
            return(dat)
          } else {
            wb <- loadWorkbook(objFile$path)
            expr <- paste('readWorksheet(wb, Sheet,', input$arg, ')', sep = '')
            print(expr)
            dat <- eval(parse(text = expr))
            
            
            return(dat)
          }
          
        } else {return(NULL)}
      }
      # For .txt and .csv documents;
      if (suf %in% c('.txt', '.csv')) {
        if (is.null(input$header)) {
          dat <- read.table(objFile$path)
          return(dat)
        } else {
          if (input$arg %in% c(' ', '')) {
            dat <- read.table(objFile$path, header=input$header, sep=input$sep, quote=input$quote)
            return(dat)
          } else {
            expr.1 <- paste('"', gsub('\\', '/', objFile$path, fixed = TRUE), '"', sep = '')
            expr.2 <- paste(expr.1,
                            paste('header =', input$header),
                            paste('sep =', paste("'", input$sep, "'", sep = '')),
                            paste('quote =', paste("'", input$quote, "'", sep = '')), input$arg,  sep = ', ')
            print(expr.2)
            expr <- paste('read.table(', expr.2, ')', sep = '')
            print(expr)
            dat <- eval(parse(text = expr))
            return(dat)
          }
        }
      }
      
    } else {return(NULL)}
    
  })
  
})
