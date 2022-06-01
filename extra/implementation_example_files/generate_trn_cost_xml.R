source("C:/Users/wait467/OneDrive - PNNL/Desktop/GCAM/seasia/input/gcamdata/R/breakout_helpers.R")
library(tidyverse)
library(gcamdata)


output_xml_name <- "trn_cost_ev_2065p_2075f_test.xml"

# read in Thailand road transportation costs (from L254.StubTranTechCost)
ref_costs <- read.csv("thailand_road_trn_costs.csv")


calculate_adjusted_costs <- function(data, start_year_pass, start_year_freight, 
                                     parity_year_pass, parity_year_freight,
                                     tech_match, tech_adjust,
                                     subsectors_pass, subsectors_freight){
  
  start_years <- c(start_year_pass, start_year_freight)
  parity_years <- c(parity_year_pass, parity_year_freight)
  subsectors <- list(subsectors_pass, subsectors_freight)
  
  # filter cost data to desired techs
  ref_costs_filtered <- data %>% 
    filter(stub.technology %in% c(tech_match, tech_adjust)) 
  
  
  # initialize df with all NA costs
  adjusted_costs <- ref_costs_filtered %>% 
    mutate(adjusted_cost = NA)
  # loop through each combination of tech match and tech adjust for each subsector
  for(fp in c(1,2)){
    parity_year <- parity_years[fp]
    start_year <- start_years[fp]
    for (s in subsectors[[fp]]){
      df <- ref_costs_filtered %>% 
        filter(tranSubsector == s)
      # get technologies in the subsector
      techs <- unique(df$stub.technology)
      # make sure tech_match is in techs
      if(!tech_match %in% techs){
        print("One or more subsector does not include tech_match")
      }
      # get cost of tech_match in parity year
      parity_cost <- df$input.cost[df$stub.technology == tech_match & df$year == parity_year]
      for(t in techs[techs != tech_match]){
        # get cost of tech_adjust in start_year
        start_cost <- df$input.cost[df$stub.technology == t & df$year == start_year]
        # calculate CAGR
        cagr <- (parity_cost/start_cost)^(1/(parity_year - start_year))-1
        # apply cagr iteratively until parity_year
        cost <- start_cost
        for(y in seq(start_year+5, parity_year, 5)){
          cost <- cost*(1+cagr)^5
          # add adjusted cost into final df
          adjusted_costs$adjusted_cost[adjusted_costs$year==y &
                                         adjusted_costs$tranSubsector == s &
                                         adjusted_costs$stub.technology == t] <- cost
        }
        # for years after parity_year, cost equals tech_match cost
        for(yy in seq(parity_year+5, 2100, 5)){
          cost_match <-
            adjusted_costs$input.cost[adjusted_costs$year==yy &
                                        adjusted_costs$tranSubsector == s &
                                        adjusted_costs$stub.technology == tech_match]
          adjusted_costs$adjusted_cost[adjusted_costs$year==yy &
                                         adjusted_costs$tranSubsector == s &
                                         adjusted_costs$stub.technology == t] <- cost_match
        }
      }
      
    }
    # for years before start_year, fill in adjusted costs with original costs
    adjusted_costs$adjusted_cost <- ifelse(adjusted_costs$year <= start_year,
                                           adjusted_costs$input.cost,
                                           adjusted_costs$adjusted_cost)
  }
  final_df <- adjusted_costs %>% 
    select(!input.cost) %>% rename(input.cost = adjusted_cost)
  
  # fill in tech_match costs from original ref_costs data
  tech_match_costs <- ref_costs %>% 
    filter(stub.technology == tech_match)
  final_df <- full_join(final_df, tech_match_costs) %>% 
    drop_na()
  
  return(as_tibble(final_df))
}





tranTechCost <- calculate_adjusted_costs(ref_costs, 2020, 2020, 2065, 2075,
                                         "Liquids", c("BEV", "Hybrid Liquids"), 
                                         c("Car", "Large Car and Truck", "Mini Car", "2W and 3W"), 
                                         c("Heavy truck", "Medium truck", "Light truck"))


# write to breakout regions (this is something that's assumed not to change
# between subregions so we're just copying the exact values from the CSV
# to each subregion)
subregions <- c("Bangkok", "Nonthaburi", "SamutPrakan", "Rest of Thailand")
tranTechCost_Subregions_Thailand <- write_to_breakout_regions(tranTechCost,
                                                                  composite_region = "Thailand",
                                                                  disag_regions = subregions)


# create and write XML
# (since run_xml_conversion doesn't take a filepath, need to create in 
# project directory then move to desired folder)
trn_cost_ev_XML<- create_xml(output_xml_name) %>%
  add_xml_data(tranTechCost_Subregions_Thailand, "StubTranTechCost")

run_xml_conversion(trn_cost_ev_XML)

file.copy(from = output_xml_name,
          to   = paste0("ev_cost_xml/", output_xml_name))
file.remove(output_xml_name)






