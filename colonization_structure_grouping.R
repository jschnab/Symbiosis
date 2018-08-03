#----------#
# Comments #
#----------#

# written by Jonathan Schnabel 27th October 2017
# email: jonathan.schnabel31@gmail.com

# modified from grouped_col_quantif5_0_3.R

# the script generates a grouped (by fungal structure) plot from grid intersect quantification of trypan blue 
#staining arbuscular mycorrhizal fungus colonization of roots

# the quantification file is expected to be in a csv file with the first column containing genotypes and the other
# columns containing fungal structures like this:
#
# genotypes # Total # EH # H # IH # A # S # V
# gen1 rep1 #  xx   # xx # x # xx # x # x # x
# gen1 rep2 #  xx   # xx # x # xx # x # x # x
# gen2 rep1 #  xx   # xx # x # xx # x # x # x
# etc
# where gen1 is genotype 1 and rep1 is experimental repetition 1 (i.e. sum of values from 1 microscopy slide)

# the script is independent on the number and names of genotypes, repetitions per genotype, number and names of fungal
# structures

# improvement from grouped_col_quantif3.R: keeps the order of genotypes from top to bottom of original csv file
# improvement from grouped_col_quantif4.R: allows different number of repetitions per genotype
# improvement from grouped_col_quantif5.R: totally independant of the name of column heads

# TO DO: find an instruction that will put the legend at the perfect location for any number of genotypes


#-------------#
# Preparation #
#-------------#

#clears the environment to avoid potential reuse of previous variables
rm(list=ls())

#transfer data from csv file into variable
quantif = read.csv(file.choose())

#clean data frame from rows or columns made of NA only
quantif <- quantif[quantif[,1]!='',] #for rows
quantif <- quantif[, colSums(is.na(quantif)) != nrow(quantif)] #for columns

#generates a vector containing the unique names of genotypes
genotypes = unique(quantif[,1])

#extract names of fungal structures
struct =  names(quantif[,-1])

#calculates number of repetition per genotype
number_rep = sapply(genotypes, function(x){sum(quantif[,1] == x)})

#removes the genotype column of the data frame to keep only numbers
quantif_numb = quantif[,-1]


#---------------------#
# Medians calculation #
#---------------------#

### calculates medians in a way to keep the order of genotypes from the original csv file

#generates vectors with row numbers from which to extract the data, useful to scan through the data frame
start_rows = c(1)
end_rows = c(number_rep[1])
counter = 1
while(counter < length(genotypes))
{
  start_rows = c(start_rows, end_rows[counter] + 1)
  end_rows = c(end_rows, end_rows[counter] + number_rep[counter + 1])
  counter = counter + 1
}

#generates a vector with x-position of begining of each group of bars (useful for legend and stripchart)
begin_group = c(1.5)
for(i in 1:(length(struct) - 1))
{
  begin_group = c(begin_group, i * (1 + length(genotypes)) + 1.5)
}

#loops through the data frame to calculate medians, by structure, for each genotype
medians = c()
for(i in 1:length(struct))
{
  for(j in 1:length(genotypes))
  {
    medians = c(medians, median(quantif_numb[,i][start_rows[j]:end_rows[j]]))
  }
}

#activate the following three lines to group data by structure
matri = matrix(medians, ncol = length(struct))
colnames(matri) = struct
rownames(matri) = genotypes


#----------#
# Graphics #
#----------#

#cols = c('violet','darkorchid4','blue','green','yellow','orange','red')
#the following colors are seen better by color-blind people
cols = c(rgb(.5,.5,.5),
         rgb(.9,.6,0),
         rgb(.35,.7,.9),
         rgb(0,.6,.5),
         rgb(.95,.9,.25),
         rgb(0,.45,.7),
         rgb(.8,.4,0),
         rgb(.8,.6,.7))

#draws a barplot and stores x location of bars in h
h = barplot(matri, beside = T, ylim = c(0,100), ylab = 'Total root length colonization (%)', 
            col = cols[1:length(genotypes)], names.arg = struct, border = 'white')

#disables clipping and draws a legend
par(xpd=T)
legend(x = begin_group[length(struct)], y = 120,legend = genotypes, fill = cols, bty='n')


# draws stripchart with individual measurements
#loops through the data frame to draw the points, by structure for each genotype
for(i in 1:length(struct))
{
  for(j in 1:length(genotypes))
  {
    stripchart(quantif_numb[,i][start_rows[j]:end_rows[j]], at = (begin_group[i] + j - 1), add=T, vertical=T, pch=19,
               cex = .5)
  }
}



#------------#
# Statistics #
#------------#

library(dunn.test)

#calculate the number of pairwise comparisons (binomial coefficients) that need to be made if the number of 
#genotypes > 2
if(length(genotypes) > 2 )
{
  nPairs = choose(length(genotypes), 2)
} else
{
  nPairs = 0
}

#create a storage matrix for the omnibus test statistic (Kruskal-Wallis or Wilcoxon)
# plus adjusted p-values for each comparison if Kruskal Wallis test is used
outputMat = matrix(NA, nPairs + 1, length(struct))
colnames(outputMat) = struct

for(st in 1:length(struct))
{
  if(length(genotypes) > 2)
  {
    ans = dunn.test(quantif[,1 + st] , quantif[,1], method="bh")
    outputMat[1, st] = kruskal.test(quantif[,1+ st], quantif[,1])$p.value
    outputMat[-1, st] = ans$P.adjusted
    
    if(st == 1){row.names(outputMat) = c("Kruskal", ans$comparisons)}
  } else
  {
    outputMat[1, st] = wilcox.test(quantif[,1 + st] ~ quantif[,1])$p.value
    if(st == 1){row.names(outputMat) = "Wilcoxon"}
  }
}

#See p value results
outputMat

#The first row will contain the p-value for the kruskal wallis test
#Each of teh subsequent rows will have the adjusted p-value for the post-hoc pairwise comparison
#If any of the values are less than 0.05 then the groups have different medians, otherwise the medians are not 
#distinguishable
