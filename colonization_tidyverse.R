# this script defines functions for plotting of root colonization by mycorrhizal fungus quantitative data
library(tidyverse)
library(reshape2)

#this functions draws plot where a crossbar represents the median of the data and the points represent individual data
#select the grouping method with argument 'grouping' (="genotype" or ="structures")
colonization_crossbar <- function(grouping="genotype"){
  
  #reads the data file in a csv format (it opens a pop-up window)
  col <- read.csv(file.choose())
  
  #clean data frame from rows or columns made of NA only
  col <- col[col[,1]!='',] #for rows
  col <- col[, colSums(is.na(col)) != nrow(col)] #for columns
  
  #turn fungal structures into a variable
  col2 <- melt(data=col, id.vars=colnames(col)[1])
  
  #the next two lines serve to maintain original genotype order from csv file
  #name of the first column is changed to 'genotype'
  genotypes = unique(col[,1])
  colnames(col2)[1] <- "genotype"
  col2 <- mutate(col2, genotype=factor(genotype, levels=genotypes))
  
  #calculate median after grouping data by genotype
  summary_data2 <- col2 %>%
    group_by(genotype, variable) %>%
    summarise(median=median(value, na.rm=TRUE))
  
  if(grouping=="genotype"){
  #plots median as bar and individual data points as points with color corresponding to fungal structures
  #vertical bars are added to separate the genotypes
  #first calculate the position of vertical separators
  v_pos <- seq(from=1.5, to=length(genotypes) -0.5, by=1)
  h_pos <- seq(from=0, to=100, by=12.5)
  ggplot() +
    geom_crossbar(data=summary_data2,
                  mapping=aes(x=genotype, 
                              y=median, 
                              ymin=median, 
                              ymax=median,
                              group=variable),
                  position=position_dodge(0.9)) +
    geom_point(data=col2, 
               aes(x=genotype, y=value, color=variable), 
               position=position_dodge(0.9), 
               size=2) +
    labs(color="Fungal structures") +
    ylab("Root length colonization (%)") +
    theme_classic() +
    geom_vline(xintercept=v_pos, color="grey70", size=1) +
    geom_hline(yintercept=h_pos, color="grey75", linetype="dotted")
  }
  
  #grouping by structure
  else if(grouping=="structure"){
    v_pos <- seq(from=1.5, to=length(genotypes) -0.5, by=1)
    h_pos <- seq(from=0, to=100, by=12.5)
    ggplot() +
      geom_crossbar(data=summary_data2,
                    mapping=aes(x=variable, 
                                y=median, 
                                ymin=median, 
                                ymax=median,
                                group=genotype),
                    position=position_dodge(0.9)) +
      geom_point(data=col2, 
                 aes(x=variable, y=value, color=genotype), 
                 position=position_dodge(0.9), 
                 size=2) +
      labs(color="Genotypes") +
      ylab("Root length colonization (%)") +
      theme_classic() +
      geom_vline(xintercept=v_pos, color="grey70", size=1) +
      geom_hline(yintercept=h_pos, color="grey75", linetype="dotted")
  }
}

#this functions draws plot where the height of a bar represents the median of the data and the points represent 
#individual data select the grouping method with argument 'grouping' (="genotype" or ="structures")
colonization_barchart <- function(grouping="genotype"){
  col <- read.csv(file.choose())
  
  #clean data frame from rows or columns made of NA only
  col <- col[col[,1]!='',] #for rows
  col <- col[, colSums(is.na(col)) != nrow(col)] #for columns
  
  #turn fungal structures into a variable
  col2 <- melt(data=col, id.vars=colnames(col)[1])
  
  #the next two lines serve to maintain original genotype order from csv file
  # make sure the header for the column containing genotype names is "genotype"
  genotypes = unique(col[,1])
  colnames(col2)[1] <- "genotype"
  col2 <- mutate(col2, genotype=factor(genotype, levels=genotypes))
  
  #calculate median after grouping data by genotype and fungal structure
  summary_data2 <- col2 %>%
    group_by(genotype, variable) %>%
    summarise(median=median(value))
  
  #plot grouped by genotype
  if(grouping == "genotype"){
    ggplot() +
      geom_bar(data=summary_data2, 
               aes(x=genotype, y=median, fill=variable), 
               stat="identity", 
               position="dodge",
               color="black") +
      ylab("Root length colonization(%)") +
      xlab("") +
      scale_fill_hue(name="Fungal structures",
                     breaks=colnames(col[,-1]),
                     labels=colnames(col[,-1])) +
      geom_point(data=col2, 
                 aes(x=genotype, y=value, fill=variable), 
                 position=position_dodge(0.9), 
                 show.legend=FALSE,
                 size=1)
  }
  
  #plot grouped by structure
  else if(grouping == "structure"){
    ggplot() +
      geom_bar(data=summary_data2, 
               aes(x=variable, y=median, fill=genotype), 
               stat="identity", 
               position="dodge",
               color="black") +
      ylab("Root length colonization(%)") +
      xlab("") +
      scale_fill_hue(name="Genotypes",
                     breaks=genotypes,
                     labels=genotypes) +
      geom_point(data=col2, 
                 aes(x=variable, y=value, fill=genotype), 
                 position=position_dodge(0.9), 
                 show.legend=FALSE,
                 size=1)
  }
}
