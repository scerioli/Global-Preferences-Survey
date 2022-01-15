CreateGDIindex <- function() {
  # This function aims to create the GDI index as reported in the technical note
  # http://hdr.undp.org/sites/default/files/hdr2020_technical_notes.pdf
  # starting from the dataset for HDI female and HDI male provided in the 
  # Human Development Report of the United Nation Development Programme of 2020
  
  # Read the input fies
  HDIf <- fread("ExtendedAnalysis/files/input/Human Development Index (HDI), female.csv", 
                skip = 5, sep = ",", nrows = 177, na.strings = "\"..\"")
  HDIm <- fread("ExtendedAnalysis/files/input/Human Development Index (HDI), male.csv", 
                skip = 5, sep = ",", nrows = 177, na.strings = "\"..\"")
  
  # Select only those columns containing some values (this is just a feature of 
  # the downloaded csv file)
  HDIf <- HDIf %>% select_if(~ sum(!is.na(.)) > 0)
  HDIm <- HDIm %>% select_if(~ sum(!is.na(.)) > 0)
  # Drop the rows containing only NAs (those countries with no data at 
  # whatsoever year)
  HDIf <- HDIf[rowSums(is.na(HDIf)) != ncol(HDIf) - 2, ]
  HDIm <- HDIm[rowSums(is.na(HDIm)) != ncol(HDIm) - 2, ]
  
  # Let's create the GDI index as a ratio of HDIf and HDIm 
  HDIf_2012 <- HDIf[, .(`2012`, Country)] 
  HDIm_2012 <- HDIm[, .(`2012`, Country)]
  HDIf_2012[HDIm_2012, m_2012 := i.2012, on = "Country"]
  GDI_index <- HDIf_2012[, .(GDI = `2012`/m_2012), by = "Country"]
  
  # Clean the name from whitespaces
  GDI_index$Country <- trimws(GDI_index$Country, which = "left")
  
  return(GDI_index)
}