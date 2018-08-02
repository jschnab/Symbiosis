# this script defines functions for plotting of root colonization by mycorrhizal fungus quantitative data
library(tidyverse)
library(reshape2)

#this functions draws plot where a crossbar represents the median of the data and the points represent individual data
#select the grouping method with argument 'grouping' (="genotype" or ="structures")
colonization_crossbar <- function(grouping="genotype"){
  
  #reads the data file in a csv format (it opens a pop-up window)
  col <- read.csv(file.choose())
  
  #turn fungal structures into a variable
  col2 <- melt(data=col, id.vars=colnames(col)[1])
  
  #the next two lines serve to maintain original genotype order from csv file
  # make sure the header for the column containing genotype names is "genotype"
  genotypes = unique(col[,1])
  col2 <- mutate(col2, genotype=factor(genotype, levels=genotypes))
  
  #calculate median after grouping data by genotype
  summary_data2 <- col2 %>%
    group_by(genotype, variable) %>%
    summarise(median=median(value))
  
  #plots median as bar and individual data points as points with color corresponding to fungal structures
  #vertical bars are added to separate the genotypes
  #first calculate the position of vertical separators
  v_pos <- seq(from=1.5, to=length(genotypes) -0.5, by=1)
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
    geom_vline(xintercept=v_pos, color="grey80")
}

#this functions draws plot where the height of a bar represents the median of the data and the points represent 
#individual data select the grouping method with argument 'grouping' (="genotype" or ="structures")
colonization_barchart <- function(grouping="genotype"){
  col <- read.csv(file.choose())
  
  #turn fungal structures into a variable
  col2 <- melt(data=col, id.vars=colnames(col)[1])
  
  #the next two lines serve to maintain original genotype order from csv file
  # make sure the header for the column containing genotype names is "genotype"
  genotypes = unique(col[,1])
  col2 <- mutate(col2, genotype=factor(genotype, levels=genotypes))
  
  #calculate median after grouping data by genotype and fungal structure
  summary_data2 <- col2 %>%
    group_by(genotype, variable) %>%
    summarise(median=median(value))
  
  ggplot() +
    geom_bar(data=summary_data2, 
             aes(x=genotype, y=median, fill=variable), 
             stat="identity", 
             position="dodge",
             color="black") +
    ylab("Root length colonization(%)") +
    scale_fill_hue(name="Fungal structures",
                   breaks=colnames(col[,-1]),
                   labels=colnames(col[,-1])) +
    geom_point(data=col2, 
               aes(x=genotype, y=value, fill=variable), 
               position=position_dodge(0.9), 
               show.legend=FALSE,
               size=1)
}
