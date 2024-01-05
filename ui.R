## Load Libraries
library(shiny)
library(bslib)
library(bsicons)
library(shinyjs)

ui <- bslib::page(title = "PixelPitch.ai",theme =  bs_theme(),useShinyjs(),

	########################################################################
	## Logo
	########################################################################
	br(),
	conditionalPanel(	
						condition = "output.appStatus",
						layout_column_wrap(
											height = 80,
											fluidRow(
												column(12,tags$div(style = "text-align: center;", tags$img(src = "logo.jpeg", width=100))),
												# column(8,actionButton("test", label = "PixelPitch.ai",class = "m-4"),align="center")
											),
											value_box(title = "Budget",value = textOutput("totbudget"),showcase = bs_icon("bank",size=".5em")),
											value_box(title = "Total Donations",value = textOutput("currbudget"),showcase = bs_icon("cart",size=".5em")),
											actionButton("donate", label = "Donate",class = "btn-success m-3"),
					),
	br(),
	h6("Elevate your Gitcoin donation experience with AI gamification! Invest your capital based on the 'Coolness' factor of each image, make a donation, and discover the projects you've backed!",align="center"),
	br(),
	uiOutput("projUI"),
	),
	conditionalPanel(
						condition = "!output.appStatus",
						layout_column_wrap(
											height = 80,
											fluidRow(
												column(12,tags$div(style = "text-align: center;", tags$img(src = "logo.jpeg", width=100))),
												# column(8,actionButton("test", label = "PixelPitch.ai",class = "m-4"),align="center")
											),
											h5(),
											h5(),
											actionButton("refresh", label = "Restart and Play Again",class = "btn-danger m-3"),
					),
	br(),
	uiOutput("projUISolved"),
	),
	########################################################################
	########################################################################
)