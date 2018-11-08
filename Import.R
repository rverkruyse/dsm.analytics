#import R packages

library(tidyverse)
library(tidytext)
library(topicmodels)
library(tm)
library(jsonlite)
library(igraph)
library(ggraph)
library(widyr)
library(splitstackshape)
library(reshape2)
library(scales)
library(knitr)
library(pdftools)
library(readr)


#Script to get data, establish source location, and define output location

#load json file with source location path
dataLocation <- read_json("dataLocation.json")$dsmData

#output location
outputLocation <- read_json("dataLocation.json")$outputLocation

#file list
file_list  <- list.files(dataLocation)

#pdf file list

pdf_list <- file_list[grepl(".pdf",file_list)]

#create function to read pdfs
Rpdf <- readPDF(control = list(text = "-layout"))

#create pdf corpus
corpus_raw <- Corpus(URISource(paste0(dataLocation, pdf_list)), 
                     readerControl = list(reader = Rpdf))

#WIP


#create TDM
corpus.tdm <- TermDocumentMatrix(corpus_raw, control = list(removePunctuation = TRUE,
                                                            stopwords = TRUE,
                                                            tolower = TRUE,
                                                            stemming = FALSE,
                                                            removeNumbers = TRUE,
                                                            grep("\r\n", ""),
                                                            bounds = list(global = c(2, Inf))))


inspect(corpus.tdm[1:10,])

#load DSM-V ASD Diagnostic Criterion
dsm5 <- pdf_text(paste0(dataLocation, "DSM5_DiagnosticCriteria_AutismSpectrumDisorder.pdf")) %>%
  strsplit(split = "\r\n")
