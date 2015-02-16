
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(monocle)
library(reshape2)
library(ggplot2)
library(marray)
library(stringr)
library(dplyr)
library(tidyr)

load("data/dat.iN.RData")

dat<-dat.iN

lookupGeneName<-function(eset,gene_id){
  res <- fData(eset[gene_id,])$gene_short_name
  res <- unique(res)
  res
}


lookupGeneId<-function(eset,gene_names){
  res <- rownames(fData(eset))[fData(eset)$gene_short_name %in% gene_names]
  res <- c(res,rownames(fData(eset))[rownames(fData(eset)) %in% gene_names])
  res <- unique(res)
  res
}

shinyServer(function(input, output) {



  output$spanningTree <- renderPlot({

    if(input$geneList != "Comma separated gene names..."){
        tmp<-str_trim(unlist(str_split(input$geneList,",")))
        markerList<-tmp
    } else {
      markerList = c("")
    }

    colorChoices = c("State","factor(day)")
    color_by=colorChoices[as.numeric(input$colorBy)]

    # draw the spanning tree with appropriate marker genes
    plot_spanning_tree(dat,color_by=color_by,marker=markerList) + coord_equal(0.8)

  })

  output$Jitter <-renderPlot({
    if(input$geneList != "Comma separated gene names..."){
      tmp<-str_trim(unlist(str_split(input$geneList,",")))
      geneIds<-lookupGeneId(dat,tmp)
    } else {
      return(NULL)
    }


    colorChoices = c("State","factor(day)")
    color_by=colorChoices[as.numeric(input$colorBy)]

    plot_genes_jitter(dat[c(geneIds)],grouping=color_by,color_by=color_by,plot_trend = TRUE,cell_size=3)

  })

  output$Pseudotime <-renderPlot({
    if(input$geneList != "Comma separated gene names..."){
      tmp<-str_trim(unlist(str_split(input$geneList,",")))
      geneIds<-lookupGeneId(dat,tmp)
    } else {
     return(NULL)
    }


    colorChoices = c("State","factor(day)")
    color_by=colorChoices[as.numeric(input$colorBy)]

    plot_genes_in_pseudotime(dat[c(geneIds)],color_by=color_by,cell_size=3)

  })

  output$BranchedPseudotime <-renderPlot({
    if(input$geneList != "Comma separated gene names..."){
      tmp<-str_trim(unlist(str_split(input$geneList,",")))
      geneIds<-lookupGeneId(dat,tmp)
    } else {
     return(NULL)
    }


    colorChoices = c("State","factor(day)")
    color_by=colorChoices[as.numeric(input$colorBy)]

    plot_genes_branched_pseudotime(dat[c(geneIds)],color_by=color_by,cell_size=3)

  })

})
