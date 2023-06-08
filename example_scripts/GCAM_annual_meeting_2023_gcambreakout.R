
# ..............................................................................
# Install packages from github -------------------------------------------------
# ..............................................................................
# Uncomment these lines if you need to install the packages
# Hint: Select multiple lines and then (CTRL+SHIFT+C)
# install.packages("remotes") # If required
# install.packages("dplyr") # If required
# library(remotes)
# remotes::install_github("JGCRI/gcambreakout")
library(gcambreakout)
library(dplyr)


gcamdataFolderx <- "C:/gcam/gcam-v6.0-Windows-Release-Package/input/gcamdata"
gcam_version_i="6.0"
#gcamdataFolderx <- "C:/gcam/gcam-v5.4-Windows-Release-Package/input/gcamdata"
#gcamdataFolderx <- "C:/gcam/gcam-v6.0-Windows-Release-Package/input/gcamdata"

countries_allowed <- read.csv(paste0(gcamdataFolderx,"/inst/extdata/common/iso_GCAM_regID.csv"), comment.char = '#', header=T); countries_allowed$country_name%>%sort()
current_GCAM_regions <- read.csv(paste0(gcamdataFolderx,"/inst/extdata/common/GCAM_region_names.csv"), comment.char = '#', header=T); current_GCAM_regions%>%arrange(GCAM_region_ID)

#-----------------------------------------------------------------
# Breakout a new custom region called "Peru"
#-----------------------------------------------------------------
breakout_regions(gcamdataFolder = gcamdataFolderx,
                 regionsNew = c("Peru"),
                 countriesNew = c("Peru"))
# Users can confirm that a new region has been added by opening the .csv file: ./input/gcamdata/inst/extdata/common/GCAM_region_names.csv
restore(gcamdataFolder = gcamdataFolderx)  # (OPTIONAL) Uncomment this line and restore the datasystem to original state


#-----------------------------------------------------------------
# Breakout a new custom region called "Peru_Chile" with both Peru and Chile
#-----------------------------------------------------------------
breakout_regions(gcamdataFolder = gcamdataFolderx,
                 regionsNew = c("Peru_Chile"),
                 countriesNew = c("Peru","Chile"))
# Users can confirm that a new region has been added by opening the .csv file: ./input/gcamdata/inst/extdata/common/GCAM_region_names.csv
restore(gcamdataFolder = gcamdataFolderx)  # (OPTIONAL) Uncomment this line and restore the datasystem to original state



#-----------------------------------------------------------------
# Breakout a new region for a new region with a single country
#-----------------------------------------------------------------
restore(gcamdataFolder = gcamdataFolderx)  # (OPTIONAL) Uncomment this line and restore the datasystem to original state

breakout_regions(gcamdataFolder = gcamdataFolderx,
                 regionsNew = c("Thailand"),
                 countriesNew = c("Thailand"),
                 gcam_version=gcam_version_i)
# Users can confirm that a new region has been added by opening the .csv file: ./input/gcamdata/inst/extdata/common/GCAM_region_names.csv
# restore(gcamdataFolder = gcamdataFolderx)  # (OPTIONAL) Uncomment this line and restore the datasystem to original state

#--------------------------------------
# SubRegions
#-------------------------------------

city_files_folder <- "C:/gcam/gcam-v6.0-Windows-Release-Package/input/gcamdata/inst/extdata/breakout"

breakout_subregions(gcamdataFolder = gcamdataFolderx,
                    region = "Thailand",
                    pop_projection = c(paste0(city_files_folder,"/Subregions_Thailand_pop.csv")),
                    pcgdp_projection = c(paste0(city_files_folder,"/Subregions_Thailand_pcgdp.csv")),
                    industry_shares = c(paste0(city_files_folder,"/Subregions_Thailand_industry_shares.csv")))

restore(gcamdataFolder = gcamdataFolderx)
