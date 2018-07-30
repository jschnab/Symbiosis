## Presentation
The *symbiosis* repository contains Python and R scripts for data analysis of mycorrhizal symbiosis colonization quantification. The scripts
provide tools for data visualization and statistical analysis. Please read individual *readme* markdown files for details about the scripts.

## About the scripts
### PyMS
*PyMS* is a GUI software written in Python. It allows plotting of data with several option for data grouping and graphical parameters. The
software also allows statistical testing using Mann-Whitney or Kruskal-Wallis-Dunn tests.

### R scripts
*colonization_genotype_grouping.R* and *colonization_structure_grouping.R* allow plotting of data and statistical testing using Mann-Whitney 
or Kruskal-Wallis-Dunn tests.
*colonization_tidyverse.R* contains definition of functions for plotting of quantitative root colonization data using tydiverse, which shortens significantly the amount of instructions compared to previous scripts. Crossbar + scatter and barchart + scatter are available.

### Test file(s)
*test_colonization.csv* contains data in the format which is read by the scripts of this repository.
