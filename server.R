
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
library(knitr)


#load("data/dat.iN.RData")
load("data/dat_filtered_spec.RData")

#dat<-dat.iN
dat<-dat.filtered

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

    colorChoices = c("State","factor(day)","protocol")
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


    colorChoices = c("State","factor(day)","protocol")
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


    colorChoices = c("State","factor(day)","protocol")
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


    colorChoices = c("State","factor(day)","protocol")
    color_by=colorChoices[as.numeric(input$colorBy)]

    plot_genes_branched_pseudotime(dat[c(geneIds)],color_by=color_by,cell_size=3)

  })
  
  output$cellInfo <-renderDataTable({
    #brushedPoints(pData(dat),input$spanning_brush)
    cells<-colnames(reducedDimS(dat))[reducedDimS(dat)[2,] > input$spanning_brush$ymin & 
                                   reducedDimS(dat)[2,] < input$spanning_brush$ymax & 
                                   reducedDimS(dat)[1,] > input$spanning_brush$xmin & 
                                   reducedDimS(dat)[1,] < input$spanning_brush$xmax]
    #cells
    pData(dat[,cells])[,-c(1,2,3)]
    #input$spanning_brush
  })

})
