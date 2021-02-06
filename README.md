# Global_Preferences_Survey

## Description

In this repository, we have tried to reproduce the analysis of the article [Relationship of gender differences in preferences to economic development and gender equality](https://science.sciencemag.org/content/362/6412/eaas9899.full) (doi: 10.1126/science.aas9899). To guide the reader, it is suggested to have a look at the file [ReproduceArticle.md](https://github.com/scerioli/Global_Preferences_Survey/blob/master/ReproduceArticle.md), which describes step by step what 
has been done, from the data collection (their sources and the way we cleaned them) to the logic behind the analysis.


## Content

The repository consists in several different sub-directories:

- [files](https://github.com/scerioli/Global_Preferences_Survey/tree/master/files)
  - [income](https://github.com/scerioli/Global_Preferences_Survey/tree/master/files/income): the files used for the analysis from the sources mentioned, modified to be easy to read and already cleaned. These files are the ones that should allow the reader to reproduce in the most complete way the analysis. The original files are not included, but can be easily got using the links to the sources we gave. Note that within the income files it is NOT included the GSP dataset for a license reason. The download of the dataset can be anyway done very straightforwardly from their website, as indicated in the sources.
  - [outcome](https://github.com/scerioli/Global_Preferences_Survey/tree/master/files/outcome): the csv files containing the data we use for our plots. Hopefully, this is the result one should obtain when using the same input and following the
  steps of the analysis as we indicate
- [functions](https://github.com/scerioli/Global_Preferences_Survey/tree/master/functions)
  - It contains all the functions that are very specific for the analysis
  - [helper_functions](https://github.com/scerioli/Global_Preferences_Survey/tree/master/functions/helper_functions): In this directory, all the helper functions created for the analysis used in the main code and to create the plots can be found. Nothing needs to be done, in the main code they are sourced thanks to the SourceFunctions.r
- [plots](https://github.com/scerioli/Global_Preferences_Survey/tree/master/plots): The relevant plots are saved here. The plots starting with "main" indicate those plots found in the main article, while the "supplementary" indicate the plots found in the supplementary online material. Two extra plots for the comparison between our analysis and the article's results are there.
- [GenderPreferencesAnalysis.r](https://github.com/scerioli/Global_Preferences_Survey/blob/master/GenderPreferencesAnalysis.r) is the main code of this analysis, and it produces the outcome files.
- [CreatePlotsArticle.r](https://github.com/scerioli/Global_Preferences_Survey/blob/master/CreatePlotsArticle.r) uses the outcome files to create the plot of the analysis (both in the main article and in the supplementary online material).
- [ReproduceArticle.md](https://github.com/scerioli/Global_Preferences_Survey/blob/master/ReproduceArticle.md), as already mentioned, helps (hopefully) the readers to get through the main code and the concept of the analysis. For a more in-depth look at the analysis and the methods, the authors refer to the main paper (mentioned above) and to this file.

## Additional Information

We found particularly helping, during the analysis, reading the paper [Global Evidence on Economic Preferences](https://doi.org/10.1093/qje/qjy013) 
to understand better some choices made by the authors of the analysed-paper and to have a more complete view on the work and the sources of the Global Preferences Survey.

Moreover, the following two papers have to be cited in all publications that make use of or refer in any kind to the files provided:

- Falk, A., Becker, A., Dohmen, T., Enke, B., Huffman, D., & Sunde, U. (2018). [Global evidence on economic preferences.](https://doi.org/10.1093/qje/qjy013) *Quarterly Journal of Economics*, 133 (4), 1645–1692.

- Falk, A., Becker, A., Dohmen, T. J., Huffman, D., & Sunde, U. (2016). The preference survey module: A validated instrument for measuring risk, time, and social preferences. IZA Discussion Paper No. 9674.
