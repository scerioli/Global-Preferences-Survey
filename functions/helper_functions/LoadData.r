LoadData <- function() {
  
  # Select the directory
  path_GPS_dir   <- "files/GPS_Dataset/GPS_dataset_individual_level/"
  path_Index_dir <- "files/Data_Extract_From_World_Development_Indicators/"
  path_GEI_dir   <- "files/Gender_Equality_Index_Data/"
  
  # Load the data
  data          <- read_dta(paste0(path_GPS_dir, "individual_new.dta")) %>%
                    setDT(.)
  world_area    <- fread(file = paste0(path_GPS_dir, "world_area.txt"), sep = ",")
  indicators    <- fread(file = paste0(path_Index_dir, "Data.csv"), na = "..")
  timeWomenSuff <- fread(file = paste0(path_GEI_dir, "Womens_suffrage_date_mod.csv"), 
                         na.strings = "-") %>% setDT(.)
  WEF           <- fread(paste0(path_GEI_dir, "WEF_Global_Gender_Gap_Index.txt"),
                         sep = "\t")
  ratioLabor    <- fread(file = paste0(path_GEI_dir, "RatioLaborMF.csv"), skip = 4)
  UNindex       <- fread(file = paste0(path_GEI_dir, "UN_Gender_Inequality_Index_mod.csv"),
                         na = "..")
  
  return(list(data = data,
              world_area = world_area,
              indicators = indicators,
              timeWomenSuff = timeWomenSuff,
              WEF = WEF,
              ratioLabor = ratioLabor,
              UNindex = UNindex))
}