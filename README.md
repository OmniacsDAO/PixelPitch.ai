# PixelPitch.ai

PixelPitch.ai is a novel, gamified approach to Gitcoin capital allocation that uses generative AI to transform the arduous task of reading through countless project descriptions into a fun and mysterious adventure. Within this app, project descriptions have been replaced with their generative AI representations and placed within a grid. The user is then given $900, or really any amount they select, and can now simply go through the images, donating to the ones that stand out to them and have the highest "it" factor.  After pressing "Donate", the project descriptions are revealed and a ranked list of how your capital was allocated appears before you. This app is a quirky, yet intuitive and visually appealing spin on the Gitcoin donation process that is not only original, but also uses the Allo protocol, innovative uses of generative AI, is open source and can be easily implemented within the main site,

<img src="www/pitchai2.gif" align="center"/>


## [App Walkthrough on YouTube](https://www.youtube.com/watch?v=fJW5L0IeJNs) <<< Click Here

## [App deployed on a tiny droplet](http://143.198.107.189:7519) <<< Click Here

<hr>

### Walkthrough

#### 1. Open R and install the requirements using

```
install.packages("shiny")
install.packages("shinyjs")
install.packages("bslib")
install.packages("bsicons")
install.packages("readr")
install.packages("shinyWidgets")
devtools::install_github("OmniacsDAO/alloDataR")
```
#### 2. Clone this repo and set the R path to the repo.

```
setwd("~/Desktop/PixelPitch.ai)
```

#### 3. Load the alloDataR package and download the Project Data frame from Arbitrum Chain and save the projects which have rich description (>100 characters)

```
library(alloDataR)
library(readr)
data <- chainProjectData(42161)
write_csv(data[nchar(data$projectDescription)>100,],"data/arbProjectsDFg100.csv")
```

#### 4. Generate the images for all of those project descriptions and save them in the www folder (Can be done with API or manually)


#### 5. Run the Shiny Dashboard

```
library(shiny)
runApp()
```

<img src="www/appEx.jpg" align="center"/>
<div align="center">Dashboard</div>

<hr>