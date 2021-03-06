#' M_traits UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_M_traits_ui <- function(id){
  ns <- NS(id)
  tagList(
    HTML('<h1 style="font-weight: bold; color: #00a65a;">Spatial Analysis for Several Traits</h1>'),
    # HTML('<h4 style="font-weight: bold; color: #00a65a;">Using SpATS</h4>'),
    fluidRow(
      column(width = 4,
             fluidRow(
               bs4Dash::box(width = 12,status = "success", solidHeader = TRUE,title = tagList(icon=icon("cogs"), "Components"),   # background = "light-blue"  
                            selectInput(inputId=ns("variable"),
                                        label= tagList( "Response Variables",
                                                        icon=bs4TooltipUI(icon("question-circle"),
                                                                          title = "The column with the continous response variable. 
                                                                          (More than one)",
                                                                          placement = "top")),
                                        choices="", width = "100%", multiple = T),
                            selectInput(inputId=ns("genotype"),
                                        label=tagList( "Genotype",
                                                       icon=bs4TooltipUI(icon("question-circle"),
                                                                         title = "The column with genotypes.",
                                                                         placement = "top")),
                                        choices="", width = "100%"),
                            awesomeCheckbox(inputId = ns('res_ran') ,
                                            label='Random Genotype',  
                                            value = TRUE ,status = "danger"  ),
                            hr(),
                            shinyjs::hidden(
                              pickerInput(
                                inputId = ns("selected_checks"),
                                label = tagList( "Checks",
                                                 icon=bs4TooltipUI(icon("question-circle"),
                                                                   title = "Select Checks",
                                                                   placement = "top")
                                ), 
                                choices = NULL,
                                options = list(
                                  `actions-box` = TRUE, size = 5, `live-search` = TRUE), 
                                multiple = TRUE, width = "100%"
                              )
                            ),
                            hr(),
                            fluidRow(
                              column(6,
                                     selectInput(inputId=ns("column"),label = "Column",choices="", width = "100%")
                              ),
                              column(6,
                                     selectInput(inputId=ns("row"),label = "Row",choices="", width = "100%")
                              )
                            ),
                            fluidRow(
                              column(6,
                                     selectizeInput(ns("show_fixed"), width = "100%",
                                                    label=tagList( "Fixed",
                                                                   icon=bs4TooltipUI(icon("question-circle"),
                                                                                     title = "Additional fixed factors.",
                                                                                     placement = "top")),
                                                    choices = "", multiple = TRUE),
                                     shinyjs::hidden(
                                       pickerInput(
                                         inputId = ns("fix_traits"),
                                         label = "Experiments", 
                                         choices = "",
                                         multiple = T,
                                         options = list(
                                           size = 5)
                                       )
                                     )
                              ),
                              column(6,
                                     selectizeInput(ns("show_random"), width = "100%",
                                                    label=tagList( "Random",
                                                                   icon=bs4TooltipUI(icon("question-circle"),
                                                                                     title = "Additional random factors.",
                                                                                     placement = "top")),
                                                    choices = "", multiple = TRUE),
                                     shinyjs::hidden(
                                       pickerInput(
                                         inputId = ns("ran_traits"),
                                         label = "Experiments", 
                                         choices = "",
                                         multiple = T,
                                         options = list(
                                           size = 5)
                                       )
                                     )
                              )
                            ),
                            selectizeInput(ns("covariate"), width = "100%",
                                           label=tagList( "Covariate",
                                                          icon=bs4TooltipUI(icon("question-circle"),
                                                                            title = "Additional covariate.",
                                                                            placement = "top")),
                                           choices = "", multiple = TRUE,selected=NULL),
                            hr(),
                            awesomeCheckbox(inputId = ns('outliers'),
                                            label='Remove Outliers',  
                                            value = FALSE ,status = "danger"),
                            numericInput(ns("times"), "Number of Times to Check", value = 1, min=1, max=3, step=1, width = "100%" ),
                            fluidRow(
                              col_2(),
                              col_8(
                                actionBttn(inputId = ns("check"),label = "Run Models",style = "jelly",color = "success",block = T, icon = icon("check") )
                              ),
                              col_2()
                            )
               )
             ) 
      ),
      column(8,
             shinyjs::hidden(
               div(id=ns("only"),
                   fluidRow(
                     
                     column(12,
                            fluidRow(
                              bs4TabCard(width = 12,id = "multi_trait",tabStatus = "light",maximizable = T,solidHeader = T,closable = F,
                                         status ="success", 
                                         bs4TabPanel(tabName = "Spatial-Plot",active = T,
                                                     dropdown(
                                                       prettyRadioButtons(inputId = ns("typefile"),label = "Download Plot File Type", outline = TRUE,fill = FALSE,shape = "square",inline = TRUE,
                                                                          choices = list(PNG="png",PDF="pdf"),
                                                                          icon = icon("check"),animation = "tada" ),
                                                       conditionalPanel(condition="input.typefile=='png'", ns = ns,
                                                                        sliderInput(inputId=ns("png.wid"),min = 200,max = 2000,value = 900,label = "Width pixels") ,
                                                                        sliderInput(inputId=ns("png.hei"),min = 200,max = 2000,value = 600,label = "Height pixels")
                                                       ),
                                                       conditionalPanel(condition="input.typefile=='pdf'", ns = ns,
                                                                        sliderInput(inputId=ns("pdf.wid"),min = 2,max = 20,value = 10,label = "Width") ,
                                                                        sliderInput(inputId=ns("pdf.hei"),min = 2,max = 20,value = 8,label = "Height")
                                                       ),
                                                       downloadButton(ns("descargar"), "Download Plot", class="btn-success",
                                                                      style= " color: white ; background-color: #28a745"), br() ,
                                                       animate = shinyWidgets::animateOptions(
                                                         enter = shinyWidgets::animations$fading_entrances$fadeInLeftBig,
                                                         exit  = shinyWidgets::animations$fading_exits$fadeOutLeftBig
                                                       ),
                                                       style = "unite", icon = icon("gear"),
                                                       status = "warning", width = "300px"
                                                     ),
                                                     shinycssloaders::withSpinner(plotOutput(ns("plot_spats")),type = 5,color = "#28a745"),
                                                     materialSwitch(ns("tog_plot"),label = "Percentage",status = "success", value = FALSE),
                                                     fluidRow(
                                                       col_3(),
                                                       col_4(
                                                         selectInput(ns("selected"), label = HTML("<center> Trait </center>"), choices = "", width = "100%")
                                                       ),
                                                       col_3(
                                                         rep_br(1),
                                                         actionBttn(
                                                           inputId = ns("sum_mod"),
                                                           label = "summary",
                                                           style = "unite", size = "sm",block = F,
                                                           color = "warning",icon = icon("spinner")
                                                         )
                                                       ),
                                                       col_2()
                                                     ),
                                                     # fluidRow(
                                                     #   col_4(),
                                                     #   col_4(
                                                     #     selectInput(ns("selected"), label = HTML("<center> Trait </center>"), choices = "", width = "100%")),
                                                     #   col_4()
                                                     # ),
                                                     icon = icon("th")
                                         ),
                                         # bs4TabPanel(tabName = "Corr-1",
                                         #             echarts4r::echarts4rOutput(ns("correlation")),
                                         #             icon = icon("arrow-circle-right")
                                         # ),
                                         bs4TabPanel(tabName = "Correlations",
                                                     dropdown(
                                                       prettyRadioButtons(inputId = ns("type"),label = "Download Plot File Type", outline = TRUE,fill = FALSE,shape = "square",inline = TRUE,
                                                                          choices = list(PNG="png",PDF="pdf"),
                                                                          icon = icon("check"),animation = "tada" ),
                                                       conditionalPanel(condition="input.type=='png'", ns = ns,
                                                                        sliderInput(inputId=ns("png.wid.c"),min = 200,max = 2000,value = 900,label = "Width pixels") ,
                                                                        sliderInput(inputId=ns("png.hei.c"),min = 200,max = 2000,value = 600,label = "Height pixels")
                                                       ),
                                                       conditionalPanel(condition="input.type=='pdf'", ns = ns,
                                                                        sliderInput(inputId=ns("pdf.wid.c"),min = 2,max = 20,value = 10,label = "Width") ,
                                                                        sliderInput(inputId=ns("pdf.hei.c"),min = 2,max = 20,value = 8,label = "Height")
                                                       ),
                                                       
                                                       downloadButton(ns("descargar2"), "Download Plot", class="btn-success",
                                                                      style= " color: white ; background-color: #28a745"), br() ,
                                                       animate = shinyWidgets::animateOptions(
                                                         enter = shinyWidgets::animations$fading_entrances$fadeInLeftBig,
                                                         exit  = shinyWidgets::animations$fading_exits$fadeOutLeftBig
                                                       ),
                                                       style = "unite", icon = icon("gear"),
                                                       status = "warning", width = "300px"
                                                     ),
                                                     shinycssloaders::withSpinner(plotOutput(ns("corr")),type = 5,color = "#28a745"),
                                                     actionBttn(
                                                       inputId = ns("pca"), 
                                                       label = "PCA",
                                                       style = "minimal", 
                                                       color = "success",
                                                       icon = icon("chart-pie")
                                                     ),
                                                     icon = icon("arrow-circle-right")
                                         ),
                                         bs4TabPanel(tabName = "Summary", 
                                                     shinycssloaders::withSpinner( 
                                                       DT::dataTableOutput(ns("summ")),type = 5,color = "#28a745" 
                                                     )
                                         ),
                                         bs4TabPanel(tabName = "Predictions", 
                                                     DT::dataTableOutput(ns("effects")),
                                                     downloadButton(ns("downloadeffects"), 
                                                                    "Download Table",
                                                                    class="btn-success",
                                                                    style= " color: white ; background-color: #28a745; float:left"),
                                                     downloadButton(ns("spread_effects"), 
                                                                    "Spread Table",
                                                                    class="btn-danger",
                                                                    style= " color: white ; background-color: #d9534f; float:left"),
                                                     icon = icon("arrow-circle-right")
                                         ),
                                         bs4TabPanel(tabName = "Potential Outliers", 
                                                     DT::dataTableOutput(ns("extrem")),
                                                     icon = icon("arrow-circle-right")
                                         )
                              )
                            )
                     ),
                     bs4Dash::box(width = 12, status = "success", solidHeader = T,title = "Predictions Plot",
                                  collapsible = T, maximizable = T,
                                  echarts4r::echarts4rOutput(ns("ranking")))
                   )
                   # fluidRow(
                   #   bs4Dash::box(width = 12, title =  tagList(icon=icon("wrench"), "Factors"),status = "success", solidHeader = TRUE,collapsible = TRUE ,
                   #                shinycssloaders::withSpinner( 
                   #                  DT::dataTableOutput(ns("summ")),type = 5,color = "#28a745" 
                   #                )
                   #   )
                   # )
               )
             )
      )
    )
 
  )
}
    
#' M_traits Server Function
#'
#' @noRd 
mod_M_traits_server <- function(input, output, session, data){
  ns <- session$ns
  
  observeEvent(!input$outliers, toggle("times",anim = TRUE,time = 1,animType = "fade"))
  
  
  observeEvent(data$data(),{
    req(data$data())
    dt <- data$data()
    updateSelectInput(session, "variable", choices=names(dt), selected = "YdHa_clean")
    updateSelectInput(session, "genotype", choices=names(dt),selected = "line")
    updateSelectInput(session, "column", choices=names(dt),selected = "col")
    updateSelectInput(session, "row", choices=names(dt),selected = "row")
    updateSelectInput(session, "show_fixed", choices = names(dt), selected = "NNNN")
    updateSelectInput(session, "show_random", choices = names(dt), selected = "NNNN")
    updateSelectInput(session, "covariate", choices = names(dt), selected = "NNNN")
  })
  
  observe({
    toggle(id = "fix_traits", condition = !is.null(input$show_fixed) )
    toggle(id = "ran_traits", condition = !is.null(input$show_random) )
    updatePickerInput(session, "fix_traits", choices = input$variable, selected = "NNNN")
    updatePickerInput(session, "ran_traits", choices = input$variable, selected = "NNNN")
  })
  
  observe({
    shinyjs::toggle(id = "selected_checks", anim = T, time = 1, animType = "fade", condition = input$genotype != "")
    req(input$genotype)
    req(data$data())
    req(input$genotype  %in% names(data$data()))
    lvl <- as.character(unique(data$data()[,input$genotype]))
    updatePickerInput(session, inputId = "selected_checks", choices = lvl)
  })
  
  w <- Waiter$new(
    html = HTML("<center> <div class='ball-loader'></div> </center>"), 
    color = transparent(0.3)
  )
  
  
  Modelo <- reactive({
    input$check
    isolate({
      validate(
        need(input$variable != "", " "),
        need(input$genotype != "", " "),
        need(input$column != "", " "),
        need(input$row != "", " ") )
      
      req(length(input$variable)>=2)
      req(data$data())
      dt <- data$data()
      dupl <- sum(duplicated(dt[,c(input$column,input$row)]))
      
      if (dupl>=1) {    # Duplicated Row-Col
        Modelo <- try(silent = T)
        tryCatch({if(class(Modelo)=="try-error") stop("Duplicated row & column coordinates")},
                 error = function(e) {shinytoastr::toastr_error(title = "Warning:", conditionMessage(e),position =  "bottom-right",progressBar = TRUE)})
        return()
      } else {
        
        w$show()
        msgs <- paste("Fitting ", input$variable, "... " )
        i <- 1
        variables <- input$variable
        Models <- list()
        for (var in variables) {
          fixed  <- input$show_fixed
          random <- input$show_random
          
          if(!is.null(fixed)){
            if(!is.null(input$fix_traits) & var %in% input$fix_traits){
              fixed <- input$show_fixed
            } else{
              fixed <- NULL
            }
          }
          
          if(!is.null(random)){
            if(!is.null(input$ran_traits) & var %in% input$ran_traits){
              random <- input$show_random
            } else{
              random <- NULL
            }
          }
          
          Models[[var]] = SpATS_mrbean(dt, var, input$genotype,
                                       input$column, input$row, FALSE , NULL, NULL,
                                       fixed , random , input$res_ran, input$covariate,
                                       input$outliers, input$times, input$selected_checks )
          
          if(class(Models[[var]] )=="try-error"){
            Models[[var]]  <-  NULL
          }
          w$update(html= HTML("<center>",
                              '<div class="dots-loader"></div>',
                              "<br>","<br>","<br>",
                              '<h5 style="font-weight: bold; color: grey;">',msgs[i],'</h5>',
                              "</center>")
          )
          i <- i+1
        }
        w$hide()
      }
      Models
    })
  })
  
  observeEvent(input$check,{
    if(!is.null(Modelo())){
      show(id = "only", anim = TRUE, animType = "slide" )
    } else{
      hide(id = "only", anim = TRUE, animType = "slide" )
    }
  }, ignoreInit = T, ignoreNULL = T)

  
  output$summ <- DT::renderDataTable({
    input$check
    isolate({
      req(Modelo())
      Models <- Modelo()
      resum <- msa_table(Models, gen_ran = input$res_ran)
      names(resum)[1] <- "Trait"
      dt <- resum %>% dplyr::mutate_if(is.numeric, round, 3)
      DT::datatable(dt,
                    extensions = 'Buttons', filter = 'top', selection="multiple",
                    options = list(pageLength=5, scrollX = TRUE,
                                   columnDefs = list(list(className = 'dt-center', targets = 0:ncol(dt)))))
    })
  })
  
  observeEvent(input$check,{
    req(Modelo())
    exp <- names(Modelo())
    updateSelectInput(session, "selected", choices = exp, selected = exp[1])
  })
  
  output$plot_spats <- renderPlot({
    input$check
    input$selected
    input$tog_plot
    isolate({
      req(Modelo())
      mod_selected <- Modelo()[[input$selected]]
      req(mod_selected)
      spaTrend <- ifelse(input$tog_plot==TRUE, "percentage", "raw")  
      plot(mod_selected, spaTrend = spaTrend)  
    })
  })


# BLUPS -------------------------------------------------------------------



  blups <- reactive({
    req(input$check)
    req(Modelo())
    effects <- multi_msa_effects(Modelo())
    names(effects)[1] <- "Trait"
    return(effects)
  })


 
  output$ranking <- echarts4r::renderEcharts4r({
    input$check
    req(input$selected)
    isolate({
      req(blups())
      req(input$selected)
      tmp_effects <- blups() %>%
        dplyr::group_by(Trait) %>%
        dplyr::mutate(predicted.values = predicted.values-mean(predicted.values,na.rm = T)) %>%
        dplyr::ungroup() %>%
        dplyr::filter(Trait %in% input$selected) %>%
        dplyr::mutate(lower = predicted.values-1.645*standard.errors,
                      upper = predicted.values+1.645*standard.errors) %>%
        dplyr::arrange(dplyr::desc(predicted.values)) %>%
        droplevels()
      names(tmp_effects)[2] <- "Genotype"
      value <- ifelse(nrow(tmp_effects)>=200, 2 , 0)
      g8 <- tmp_effects %>%
        e_charts(Genotype) %>%
        e_scatter(predicted.values,bind=Genotype,symbol_size = 10 ) %>%
        e_tooltip() %>%
        e_error_bar(lower = lower, upper=upper) %>%
        e_toolbox_feature(feature = "dataView") %>%
        e_toolbox_feature(feature = "dataZoom") %>%
        e_legend(show = T,type = "scroll") %>%
        e_title(text = paste("Genotype Ranking: ", input$selected)) %>%
        e_x_axis(axisLabel = list(interval = value, rotate = 75, fontSize=8 , margin=8  ))
      g8
    })
  })

  # Correlations interactive way
  # output$correlation <- echarts4r::renderEcharts4r({
  #   input$check
  #   isolate({
  #     req(blups())
  #     bl <- blups()
  #     bl <- bl[,-4] %>% tidyr::spread(., "Trait", "predicted.values" )
  #     CC <- round(cor(bl[,-1], use = "pairwise.complete.obs"),3)
  #     g3 <- CC %>%
  #       e_charts() %>%
  #       e_correlations(order = "hclust",visual_map = F) %>%
  #       e_tooltip() %>%   e_visual_map( color=c("#4285f4" ,"white","#db4437"),
  #                                       min = -1 ,
  #                                       max =  1 ,
  #                                       orient= 'horizontal',
  #                                       left= 'center',
  #                                       bottom = 'bottom'
  #       ) %>%
  #       e_title("Correlation", "Between Traits") %>%
  #       e_toolbox_feature(feature = "saveAsImage") %>%
  #       e_x_axis(axisLabel = list(interval = 0, rotate = -45, fontSize=12 , margin=8  ))  %>% # rotate
  #       e_grid(left = "20%",height = "60%")
  #     g3
  #   })
  # })
  
  output$corr <- renderPlot({
    input$check
    isolate({
      req(blups())
      bl <- blups()
      bl <- bl[,1:3] %>% tidyr::spread(., "Trait", "predicted.values" )  
      validate(
        need(ncol(bl)>=3, "Only one trait fitted.")
      )
      Models <- Modelo()
      resum <- msa_table(Models, gen_ran = input$res_ran)
      names(resum)[1] <- "Trait"
      if(input$res_ran){
        Heritability <- resum$h2
        names(Heritability) <- resum$Trait
        ggCor(bl[,-1],colours = c("#db4437","white","#4285f4"), Diag = Heritability) 
      } else {
        ggCor(bl[,-1],colours = c("#db4437","white","#4285f4")) 
      }
    })
    
  })

  output$effects <- DT::renderDataTable(
    if (is.null(blups())) {return()}
    else {
      DT::datatable({
        blups()
      },
      option=list(pageLength=5, scrollX = TRUE,columnDefs = list(list(className = 'dt-center', targets = 0:ncol(blups())))),
      filter="top",
      selection="multiple"
      )} )
  
  
  # Single Summary 
  
  output$summary2 <- renderPrint({
    input$check
    mod_selected <- Modelo()[[input$selected]]
    req(mod_selected)
    summary(mod_selected)
  })
  
  observeEvent(input$sum_mod,{
    showModal(modalDialog(
      title = "Summary", size = "l", easyClose = T,
      shinycssloaders::withSpinner(
        verbatimTextOutput(ns("summary2")),
        type = 5,color = "#28a745")
    )
    )
  })
  

# PCA ---------------------------------------------------------------------

  output$plot_pca <- renderPlot({
    input$pca
    input$typep
    input$number
    input$ind_pca
    input$var_pca
    input$scale
    input$invisible_pca
    isolate({
      # req(model$model())
      # m <- model$model()
      # data <- model$model()$predictions[,1:3] %>% 
      #   tidyr::spread(., "trial", "predicted.value" ) %>%
      #   tibble::column_to_rownames("gen")
      
      req(blups())
      data <- blups()
      data <- data[,1:3] %>% tidyr::spread(., "Trait", "predicted.values" ) 
      validate(
        need(ncol(data)>=3, "Only one trait fitted.")
      )
      names(data)[1] <- "gen"
      data <- data %>% tibble::column_to_rownames("gen")
      
      res.pca <- prcomp(data, scale. = T)
      
      if(input$typep=="var"){
        
        res.pca.non <- prcomp(data, scale. = input$scale)
        factoextra::fviz_pca_var(res.pca.non, col.var="steelblue", repel = T, alpha.var = 0.2)
        
      } else if(input$typep=="ind"){
        
        top <- as.numeric(input$number)
        req(top<=nrow(data))
        fa12_scores <- res.pca$x[,1:2] %>% data.frame() %>%  tibble::rownames_to_column("Genotypes")
        fa12_scores$Score <- sqrt(fa12_scores$PC1^2+fa12_scores$PC2^2)
        gen <- fa12_scores %>% dplyr::arrange(desc(Score)) %>% dplyr::top_n(top) %>% dplyr::pull(Genotypes)
        factoextra::fviz_pca_ind(res.pca, repel = T, alpha.ind = 0.5, select.ind = list(name = gen ), labelsize = 4)
        
      } else{
        
        geom.ind <- c("point","text")
        geom.var =  c("arrow","text")
        invisible <- "none"
        
        if(!is.null(input$ind_pca))  geom.ind = input$ind_pca
        if(!is.null(input$var_pca))  geom.var = input$var_pca
        if(!is.null(input$invisible_pca))  invisible = input$invisible_pca
        
        factoextra::fviz_pca_biplot(res.pca, repel = F, alpha.ind=0.5, geom.ind = geom.ind, geom.var = geom.var, invisible =  invisible )
        
      }
      
    })
  })

  observeEvent(input$pca,{
    showModal(modalDialog(
      title = tagList(icon=icon("chart-pie"), "PCA"), size = "l", easyClose = T,
      prettyRadioButtons(
        inputId = ns("typep"),
        label = "Choose:", 
        choices = c("Biplot"="bip", "Variables"="var", "Individuals"="ind"),
        selected = "bip",
        inline = TRUE, 
        status = "danger",
        fill = TRUE,
        icon = icon("check"),  animation = "jelly"
      ),
      shinycssloaders::withSpinner(plotOutput(ns("plot_pca")),type = 6,color = "#28a745"),icon = icon("arrow-circle-right"),
      conditionalPanel(condition = "input.typep=='ind'",  ns = ns,
                       fluidRow(
                         col_4(
                         ),
                         col_4(
                           pickerInput(
                             inputId = ns("number"),
                             label = "Top (n)", 
                             choices = 4:100, selected = 20,
                             options = list(
                               size = 5)
                           )
                         ),
                         col_4(
                         )
                       )
      ),
      conditionalPanel(condition = "input.typep=='var'",  ns = ns,
                       fluidRow(
                         col_4(
                         ),
                         col_4(
                           switchInput(
                             inputId = ns("scale"),
                             label = "Scale?", 
                             labelWidth = "100%",  
                             onStatus = "success", 
                             offStatus = "danger",
                             width = "100%", value = TRUE
                           )
                         ),
                         col_4(
                         )
                       )
      ),
      conditionalPanel(condition = "input.typep=='bip'",  ns = ns,
                       fluidRow(
                         col_1(
                         ),
                         col_3(
                           checkboxGroupButtons(
                             inputId = ns("ind_pca"),
                             label = "Individuals",
                             choices = c("point","text"),justified = T,
                             status = "success",
                             checkIcon = list(yes = icon("ok", lib = "glyphicon"),
                                              no = icon("remove", lib = "glyphicon"))
                           )
                         ),
                         col_3(
                           checkboxGroupButtons(
                             inputId = ns("var_pca"),
                             label = "Variables",
                             choices = c("arrow","text"),justified = T,
                             status = "success",
                             checkIcon = list(yes = icon("ok", lib = "glyphicon"),
                                              no = icon("remove", lib = "glyphicon"))
                           )
                         ),
                         col_3(
                           checkboxGroupButtons(
                             inputId = ns("invisible_pca"),
                             label = "Invisible",
                             choices = c("ind", "var"),justified = T,
                             status = "success",
                             checkIcon = list(yes = icon("ok", lib = "glyphicon"),
                                              no = icon("remove", lib = "glyphicon"))
                           )
                         )
                       )
      )
      # br()
    )
    )
  }, ignoreInit = T, ignoreNULL = T)
  

# Tabla Out ---------------------------------------------------------------


  data_extreme <- reactive({
    input$check
    isolate({
      req(Modelo())
      effects <- table_outlier(Modelo())
      return(effects)
    })
  })  
  
  output$extrem <- DT::renderDataTable(
    if (is.null(data_extreme())) {return()}
    else {
      DT::datatable({
        data_extreme()
      },
      option=list(pageLength=5, scrollX = TRUE,columnDefs = list(list(className = 'dt-center', targets = 0:ncol(data_extreme())))),
      filter="top",
      selection="multiple"
      )} )


  # download effects

  output$downloadeffects <- downloadHandler(
    filename = function() {
      paste("Effects_mrbean",".csv", sep = "")
    },
    content = function(file) {
      req(blups())
      datos <- data.frame(blups())
      write.csv(datos, file, row.names = FALSE)
    }
  )

  output$spread_effects <- downloadHandler(
    filename = function() {
      paste("Effects_mrbean_spread",".csv", sep = "")
    },
    content = function(file) {
      req(blups())
      datos <- data.frame(blups()[,1:3] %>% tidyr::spread(., "Trait", "predicted.values" ))
      write.csv(datos, file, row.names = FALSE)
    }
  )
  
  
  # Download PLOT SPATIAL
  output$descargar <- downloadHandler(
    filename = function() {
      req(input$selected)
      paste(paste0("plotSpATS_",input$selected), input$typefile, sep = ".")
    },
    content = function(file){
      if(input$typefile=="png") {
        png(file,width = input$png.wid ,height = input$png.hei)
        spaTrend <- ifelse(input$tog_plot==TRUE, "percentage", "raw") 
        plot(Modelo()[[input$selected]],spaTrend = spaTrend,cex.lab = 1.5, cex.main = 2, cex.axis = 1.5, axis.args = list(cex.axis = 1.2))
        dev.off()
      } else {
        pdf(file,width = input$pdf.wid , height = input$pdf.hei )
        spaTrend <- ifelse(input$tog_plot==TRUE, "percentage", "raw") 
        plot(Modelo()[[input$selected]],spaTrend = spaTrend,cex.lab = 1.5, cex.main = 2, cex.axis = 1.5, axis.args = list(cex.axis = 1.2))
        dev.off()
      }
    }
  )
  
  
  # Download correlation plot
  
  output$descargar2 <- downloadHandler(
    filename = function() {
      paste("corrPlot", input$type, sep = ".")
    },
    content = function(file){
      if(input$type=="png") {
        png(file,width = input$png.wid.c ,height = input$png.hei.c)
            bl <- blups()
            bl <- bl[,1:3] %>% tidyr::spread(., "Trait", "predicted.values" )  
            validate(
              need(ncol(bl)>=3, "Only one trait fitted.")
            )
            Models <- Modelo()
            resum <- msa_table(Models, gen_ran = input$res_ran)
            names(resum)[1] <- "Trait"
            if(input$res_ran){
              Heritability <- resum$h2
              names(Heritability) <- resum$Trait
              g1 <- ggCor(bl[,-1],colours = c("#db4437","white","#4285f4"), Diag = Heritability) 
              print(g1)
            } else {
              g1 <- ggCor(bl[,-1],colours = c("#db4437","white","#4285f4")) 
              print(g1)
            }
        dev.off()
      } else { 
        pdf(file,width = input$pdf.wid.c , height = input$pdf.hei.c )
            bl <- blups()
            bl <- bl[,1:3] %>% tidyr::spread(., "Trait", "predicted.values" )  
            validate(
              need(ncol(bl)>=3, "Only one trait fitted.")
            )
            Models <- Modelo()
            resum <- msa_table(Models, gen_ran = input$res_ran)
            names(resum)[1] <- "Trait"
            if(input$res_ran){
              Heritability <- resum$h2
              names(Heritability) <- resum$Trait
              g1 <- ggCor(bl[,-1],colours = c("#db4437","white","#4285f4"), Diag = Heritability) 
              print(g1)
            } else {
              g1 <- ggCor(bl[,-1],colours = c("#db4437","white","#4285f4")) 
              print(g1)
            }
        dev.off()
      }
    }
  )
  
  
}
    
## To be copied in the UI
# mod_M_traits_ui("M_traits_ui_1")
    
## To be copied in the server
# callModule(mod_M_traits_server, "M_traits_ui_1")
 
