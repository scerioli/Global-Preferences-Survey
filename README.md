# Global_Preferences_Survey

## Description

In this repository, we have tried to reproduce the analysis of the article "Relationship of gender differences in preferences to economic development and 
gender equality" (doi: 10.1126/science.aas9899). To guide the reader, it is suggested to have a look at the "WhatWeDid.md", which describes step by step what 
has been done, from the data collection (their sources and the way we cleaned them) to the logic behind the analysis.

**DISCLAIMER:** Because of the licenses and so on, we decided not to publish on GitHub the data we used but only to cite the sources, because we didn't want to break any rule. On the other side, with the sources and the code provided, the input files can be reproduced quite easily.

## Content

The repository consists in several different sub-directories:

- files
  - outcome: the csv files containing the data we use for our plots. Hopefully, this is the result one should obtain when using the same input and following the
  steps of the analysis as we indicate
- functions
  - SourceFunctions.r allows to source all the helper functions
  - functions: In this directory, all the functions created for the analysis and their helper functions used in the main code can be found. Nothing needs to be done, in the main code they are sourced 
  thanks to the SourceFunctions.r
- plots: Some relevant plots are saved here as a reference for the authors during the analysis. The plots starting with "main" indicate those plots found in the main article, while the "supplementary" indicate the plots found in the supplementary online material.
- GenderAnalysis.r is the main code of this analysis, and it produces the outcome files.
- CreatePlotsArticle.r uses the outcome files to create the pot of the analysis (both in the main article and in the supplementary online material).
- WhatWeDid.md, as already mentioned, helps (hopefully) the readers to get through the main code and the concept of the analysis. For a more in-depth look at the
analysis and the methods, the authors refer to the main papers (mentioned above) and to the Confluence page.

## Additional Information

We found particularly helping, during the analysis, reading the paper "Global Evidence on Economic Preferences" (https://doi.org/10.1093/qje/qjy013) 
to understand better some choices made by the authors of the analysed-paper and to have a more complete view on the work and the sources of the Global Preferences Survey.
