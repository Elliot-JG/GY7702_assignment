# GY7702 Assignment repository 

## Introduction
This is a repository for the [**GY7702 R for Data Science**](https://le.ac.uk/modules/2020/gy7702) assignment at the University of Leicester. 
The aim of this assignment was to explore various aspects of the R programming language through the use of popular libraries and real-life data. 
Additionally, this was a fantastic exercise in the exploration of Github, README.md files and professional coding practice. 

This assignment is broken down into 4 stages: 

1. Basic vector manipulation with example survey data. 
2. Exploring table operations with the *penguins* table in *palmerpenguins*.
3. Reading data with *readr* and utilizing UK COVID-19 data 
4. Analysis of COVID-19 cases with accompanying UK population data

## Table of contents 
* [General info](#introduction)
* [Prerequisites](#prerequisites)
* [Data](#data)
* [Usage](#usage)

## Prerequisites
The dependencies for the assignment are:
* [tidyverse](https://www.tidyverse.org/)
* [dplyr](https://dplyr.tidyverse.org/)
* [knitr](https://yihui.org/knitr/)
* [palmerpenguins](https://github.com/allisonhorst/palmerpenguins)
* [readr](https://readr.tidyverse.org/)

## Data 
The data used in this assignment is in [GY7702_data](https://github.com/Elliot-JG/GY7702_assignment/tree/main/GY7702_data). There are two .csv files:
* covid19_cases_20200301_20201017.csv\
UK Covid-19 daily and cumulative cases 01/03/2020 - 17/10/2020 
* lad19_population.csv\
UK population per local authority 

## Usage
* To clone this git repository using [Git Bash](https://gitforwindows.org/):
```r
$ git clone https://github.com/Elliot-JG/GY7702_assignment.git
```
* Alternatively, press the green button at the top of this page and unzip the folder in an appropriate place  ![](https://github.com/Elliot-JG/GY7702_assignment/blob/main/README_graphics/Code_download_updated_url.PNG)  

## Guide to the files 
* **Master_code.R**  
  + In this file you will find 4 sections that address the 4 questions of the assignment
  + Highly commented, raw code with no further comments on the data analysis
* **GY7702_Greatrix.Rmd** 
  + An R Markdown version of *Master_code.R*.
  + Contains further analysis of the data such as short paragraphs on what the data tells us  
  + While I am working in *Master_code.R* now, I predict that the work flow will move over mainly to this file 
* **GY7702_Greatrix.pdf**
  + A .pdf file created when *GY7702_Greatrix.Rmd* is executed or *knitted*

