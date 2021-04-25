# Global Preferences Survey

## Description

In this repository, we are reproducing the analysis of the article [Relationship of gender differences in preferences to economic development and gender equality](https://science.sciencemag.org/content/362/6412/eaas9899.full) (doi: 10.1126/science.aas9899). It is suggested to have a look at the page [ReproduceArticle.md](https://github.com/scerioli/Global_Preferences_Survey/blob/master/ReproduceArticle.md), which describes steps  from the data collection (sources of the datasets and the way we cleaned them) to the logic behind the analysis.

The online version of the page is available at the website [scerioli.github.io/Global-Preferences-Survey/](https://scerioli.github.io/Global-Preferences-Survey/)


## Content

The repository consists of several different sub-directories:

- [ReproductionAnalysis](https://github.com/scerioli/Global_Preferences_Survey/tree/master/ReproductionAnalysis) is the folder where the replication analysis of the main article and its supplementary material is performed.
  - [**ReproduceArticle.md**](https://github.com/scerioli/Global_Preferences_Survey/blob/master/ReproductionAnalysis/ReproduceArticle.md), as already mentioned, helps to get through the main code and get the concept of the analysis. For a more in-depth look at the analysis and the methods, the authors refer to the main paper (mentioned above).
  - [files](https://github.com/scerioli/Global_Preferences_Survey/tree/master/files)
   - [input](https://github.com/scerioli/Global_Preferences_Survey/tree/master/files/input): files used for the analysis, modified to be easy to read. These code allows the reader to reproduce the analysis. The core GPS dataset on economic preferences is not included due to copyright restrictions but can be easily downloaded using the links on the official webpage we provided.
   - [output](https://github.com/scerioli/Global_Preferences_Survey/tree/master/files/output): the .csv files that contain the results of our replication of the analysis that we subsequently use for plots. The same files can be obtained by running the analysis pipeline
  - [functions](https://github.com/scerioli/Global_Preferences_Survey/tree/master/functions)
    - The replication of pipeline is divided in functions.
    - [helper_functions](https://github.com/scerioli/Global_Preferences_Survey/tree/master/functions/helper_functions): 
  parts of the code were aggregated into functions, that we called "helper_functions". They are sourced in the main code with *SourceFunctions.r*.
  - [plots](https://github.com/scerioli/Global_Preferences_Survey/tree/master/plots): The relevant plots are saved here. The files which start with "main" are figures from the main part of the article, while the "supplementary" are from the supplementary online material. Two extra plots for the comparison between our analysis and the article's results are in this folder as well.
  - [interactive_plots](https://github.com/scerioli/Global_Preferences_Survey/blob/master/interactive_plots) contains a very basic dashboard created with Shiny package in R, to have a quicker visualization of the plots. *It is still a "beta version" because the description is not exhaustive about which plots can be created.* The user is of course invited to visualize their wished plots from the dataset already provided. Check the [code](https://github.com/scerioli/Global-Preferences-Survey/tree/master/ReproductionAnalysis/interactive_plots) or [run the app](http://127.0.0.1:4382/)
  - [GenderPreferencesAnalysis.r](https://github.com/scerioli/Global_Preferences_Survey/blob/master/GenderPreferencesAnalysis.r) is the main code of this analysis. It produces the *output* files (see above).
  - [CreatePlotsArticle.r](https://github.com/scerioli/Global_Preferences_Survey/blob/master/CreatePlotsArticle.r) uses the output files to create figures from the main text and supplementary).
- [PublicPosts](https://github.com/scerioli/Global-Preferences-Survey/tree/master/PublicPosts) contains some short analysis to be published as posts.

## Additional Information

In addition to the main article, the following two papers contains a lot of relevant information for the full understanding of the analysis steps. They have to be cited in all publications that make use of or refer in any kind to the GPS dataset:

- Falk, A., Becker, A., Dohmen, T., Enke, B., Huffman, D., & Sunde, U. (2018). [Global evidence on economic preferences.](https://doi.org/10.1093/qje/qjy013) *Quarterly Journal of Economics*, 133 (4), 1645–1692.

- Falk, A., Becker, A., Dohmen, T. J., Huffman, D., & Sunde, U. (2016). The preference survey module: A validated instrument for measuring risk, time, and social preferences. IZA Discussion Paper No. 9674.
