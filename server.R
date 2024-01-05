## Load Libraries
library(bslib)
library(bsicons)
library(shinyjs)
library(shinyWidgets)
library(readr)

## Load Grants
projectsDF <- read_csv("data/arbProjectsDFg100.csv",show_col_types = FALSE)
unpid <- unique(projectsDF$projectId)
unpidex <- unpid[unpid %in% gsub(".jpeg","",list.files("www"))]
projectsDF <- projectsDF[projectsDF$projectId %in% unpidex,]
projectsDF$image <- paste0(projectsDF$projectId,".jpeg")

## Helper Function Generate Image Card
genImgCard <- function(imgid,idx)
{
	card(
			id = paste0("imgc",idx),
			full_screen = FALSE,
			card_header(paste0("Project ",idx)),
			img(src=imgid),
			fluidRow(column(12,numericInputIcon(paste0("nd",idx),label=NULL,value=1,step=1,min=1,max=100,help_text="Donate between $1-$100.",size="sm",icon = icon("dollar-sign")),align="center"))
		)
}

genImgCardSolved <- function(imgid,idx,imginfo,imgdonated)
{
	layout_column_wrap(
			card(
				id = paste0("imgc",idx),
				full_screen = FALSE,
				card_header(paste0("Project ",idx)),
				fluidRow(column(12,h3(paste0("You Donated $",imgdonated)),align="center")),
				img(src=imgid)
		),
			card(
				id = paste0("descpc",idx),
				max_height = 900,full_screen = TRUE,
				card_header(paste0("Project ",idx)),
				markdown(imginfo)
			)
	)
}

## Helper Function to parse markdown
parse_grant <- function(x) paste0(paste("<strong>",names(x),"</strong>","<br/>",x),collapse="<br/><br/>")

## Num Projects at once
num_projs <- 9
budgetallowed <- num_projs*100

server <- function(input, output, session) {

	## Reactive Values to store the app progress
	output$appStatus <- reactive({nrow(projDFR$projDF)>0})
	outputOptions(output, "appStatus", suspendWhenHidden = FALSE)
	projDFR <- reactiveValues(projDF=projectsDF[sample(1:nrow(projectsDF),num_projs),],projDFSolved=data.frame())

	########################################################################
	## Start Project Layout
	########################################################################
	output$projUI <- renderUI({
									projectsDFT <- projDFR$projDF
									if(nrow(projectsDFT)==0) return(NULL)
									cc <- mapply(genImgCard,projectsDFT$image,1:num_projs,SIMPLIFY=FALSE)
									layout_column_wrap(
														width = 1/3,
														cc[[1]],
														cc[[2]],
														cc[[3]],
														cc[[4]],
														cc[[5]],
														cc[[6]],
														cc[[7]],
														cc[[8]],
														cc[[9]]
													)
						})
	output$currbudget <- renderText({
										if(is.null(input$nd1)) return("")
										paste0("$",sum(sapply(1:num_projs,function(x) as.numeric(input[[paste0("nd",x)]])),na.rm=TRUE))
									})
	output$totbudget <- renderText({paste0("$",budgetallowed)})
	observeEvent(input$donate,{
								cbudget <- sum(sapply(1:num_projs,function(x) input[[paste0("nd",x)]]),na.rm=TRUE)
								if(cbudget>budgetallowed) 
								{
									sendSweetAlert(session = session,title = "Budget Error",text = "Donations are more than the budget allowed.",type = "error")
									return(NULL)
								}
								sendSweetAlert(session = session,title = "Donated",text = "The Project Descriptions are now available.",type = "success")
								projectsDFT <- projDFR$projDF
								projectsDFT$Id <- 1:num_projs
								projectsDFT$Donated <- sapply(1:num_projs,function(x) as.numeric(input[[paste0("nd",x)]]))
								projectsDFT <- projectsDFT[order(projectsDFT$Donated,decreasing=TRUE),]
								projDFR$projDFSolved <- projectsDFT
								projDFR$projDF <- data.frame()
	})
	########################################################################
	########################################################################


	########################################################################
	## Solved Project Layout
	########################################################################
	output$projUISolved <- renderUI({
									## Select Projects
									projectsDFT <- projDFR$projDFSolved
									if(nrow(projectsDFT)==0) return(NULL)
									# cmatcheshtml <- apply(projectsDFT[,c(6:9,12:13)],1,parse_grant)
									cmatcheshtml <- apply(projectsDFT[,c(11:13,16:17)],1,parse_grant)
									projUI <- mapply(genImgCardSolved,projectsDFT$image,projectsDFT$Id,cmatcheshtml,projectsDFT$Donated,SIMPLIFY=FALSE)
									return(projUI)
						})
	observeEvent(input$refresh,{
								projDFR$projDFSolved <- data.frame()
								projDFR$projDF <- projectsDF[sample(1:nrow(projectsDF),num_projs),]
	})

	########################################################################
	########################################################################
	
}