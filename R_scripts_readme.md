# R scripts for analysis of mycorrhizal fungus symbiosis quantification

## Description of files
* "colonization_genotype_grouping.R" generates bar (median) + scatter plots (individual data) after grouping data by genotype and performs a 
Kruskal-Wallis followed by Dunn's test statistical analysis.

* "colonization_structure_grouping.R" generates bar (median) + scatter plots (individual data) after grouping data by fungal structure and 
performs a Kruskal-Wallis followed by Dunn's test statistical analysis.

* "colonization_tidyverse.R" defines functions which generate different types of charts. The function *colonization_crossbar()* displays the median as a crossbar and individual data points as points. The function *colonization_barchat()* displays the median as the height of a bar and individual data points as points. For both functions, it is possible to specify the type of data grouping for display, by genotype or by fungal structure. To do so, type *colonization_barchart(grouping="genotype")* (default) or *colonization_barchart(grouping="structure")*.

## Input format for the scripts
Quantification of arbuscular mycorrhizal fungus colonization of plant roots should be done via a modified version of the grid-line intersect 
method (see [Paszkowski, U., Jakovleva, L., and Boller, T. (2006). Maize mutants affected at distinct stages of the arbuscular mycorrhizal 
symbiosis. Plant J. 47 165–173) or an equivalent method.](https://www.ncbi.nlm.nih.gov/pubmed/16762030))

The input file should be a csv file with a specific formatting different from the "tidy data" specification (see "test_colonisation.csv" in 
the same repository for an example).
