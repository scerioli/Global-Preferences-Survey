gini <- fread("../New_Analysis/data/API_SI.POV.GINI_DS2_en_csv_v2_2916486.csv", 
              skip = 3, header = TRUE)

setnames(gini, old = "Country Name", new = "country")
setnames(gini, old = "Country Code", new = "isocode")


gini <- gini[isocode %in% unique(dataCoeff$isocode)]

# average from 2008 to 2012
avgGINI <- rowMeans(gini[, 53:57], na.rm = TRUE)
gini[, avgIndex := avgGINI]

gini <- gini[, .(country, isocode, avgIndex)]

# Higher GINI, higher inequality
summaryIndex[gini, avgIndex := i.avgIndex, on = "isocode"]

dataCoeff_summary[gini, avgIndex := i.avgIndex, on = "isocode"]

PlotSummary(data = summaryIndex[!is.na(avgIndex)], 
            var2 = "avgGenderDiff",
            var1 = "avgIndex",
            display = TRUE,
            regression = TRUE)

PlotSummary(data = dataCoeff_summary[!is.na(avgIndex)],
            var1 = "avgIndex", 
            var2 = "gender", 
            var3 = "preference",
            display = TRUE,
            regression = TRUE)
