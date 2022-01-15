LoadData <- function() {
  
  # Select the directory
  path_dir     <- "ReproductionAnalysis/files/input/"
  path_GPS_dir <- paste0(path_dir, "GPS_Dataset/GPS_dataset_individual_level/")
  
  # Load the data
  data          <- read_dta(paste0(path_GPS_dir, "individual_new.dta")) %>%
                    setDT(.)
  world_area    <- fread(file = paste0(path_dir, "world_area.txt"), 
                         sep = ",")
  indicators    <- fread(file = paste0(path_dir, "world_bank_GDP_2010USdollars.csv"),
                         na = "..")
  timeWomenSuff <- fread(file = paste0(path_dir, "womens_suffrage_date.csv"), 
                         na.strings = "-") %>% setDT(.)
  WEF           <- fread(paste0(path_dir, "WEF_Global_Gender_Gap_Index.txt"),
                         sep = "\t")
  ratioLabor    <- fread(file = paste0(path_dir, "ratio_labor_MF.csv"), 
                         skip = 4)
  UNindex       <- fread(file = paste0(path_dir, "Gender_Inequality_Index_UN_2015.csv"),
                         na = "..")
  
  return(list(data = data,
              world_area = world_area,
              indicators = indicators,
              timeWomenSuff = timeWomenSuff,
              WEF = WEF,
              ratioLabor = ratioLabor,
              UNindex = UNindex))
}