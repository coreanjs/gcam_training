
# ..............................................................................
# Install packages from github -------------------------------------------------
# ..............................................................................
devtools::install_github("JGCRI/gcamextractor")
devtools::install_github("JGCRI/rchart")


# ..............................................................................
# Get example data (dataAggClass1) from gcamextractor --------------------------
# ..............................................................................

# view the example data
View(gcamextractor::exampleDataAggClass1)

# choose a couple parameters of interest
exampleData <- dplyr::filter(gcamextractor::exampleDataAggClass1,
                             param %in% c("emissCO2BySectorNoBio",
                                          "elecByTechTWh"))


# ..............................................................................
# Generate a set of charts -----------------------------------------------------
# ..............................................................................

my_charts <- rchart::chart(data = exampleData,
                           chart_type = "all",
                           save = F,
                           folder = "figures")


# view line charts (parameter totals)
my_charts$chart_param_India
my_charts$chart_param_USA
my_charts$chart_region_absolute


# view bar charts (parameters by class)
my_charts$chart_class_India
my_charts$chart_class_USA
my_charts$chart_class_Reference
my_charts$chart_class_RCP_2.6


# ..............................................................................
# generate a set of charts including scenario comparison charts ----------------
# ..............................................................................

my_charts <- rchart::chart(dplyr::filter(exampleData),
                           scenRef = "Reference",
                           chart_type = "all",
                           save = F,
                           folder = "figures")


# view scenario comparison charts

# parameter totals
my_charts$chart_param_diff_absolute_India
my_charts$chart_param_diff_percent_India
my_charts$chart_param_diff_absolute_USA
my_charts$chart_param_diff_percent_USA

# by class
my_charts$chart_class_diff_absolute_India
my_charts$chart_class_diff_percent_India
my_charts$chart_class_diff_absolute_USA
my_charts$chart_class_diff_percent_USA


# waterfall charts
my_charts$chart_class_waterfall_India
my_charts$chart_class_waterfall_USA



# ..............................................................................
# Additional options -----------------------------------------------------------
# ..............................................................................


## custom palette ==============================================================

# define a custom palette
my_pal <- c("industry" = "lightgreen",
            "hydrogen" = "yellow",
            "nuclear" = "purple",
            "USA" = "orange")

# generate charts using custom palette
custom_pal_charts <- rchart::chart(data = dplyr::filter(exampleData,
                                                        param != "pop"),
                                   chart_type = "all",
                                   palette = my_pal,
                                   save = F)
# old bar charts
my_charts$chart_class_India
# new bar charts
custom_pal_charts$chart_class_India

# old line charts
my_charts$chart_region_absolute
# new line charts
custom_pal_charts$chart_region_absolute


## Add summary line to bar charts ==============================================

my_bar_chart <- rchart::chart(data = dplyr::filter(exampleData,
                                                   param != "pop"),
                              chart_type = "class_absolute",
                              save = F,
                              summary_line = T)

my_bar_chart$chart_class_USA


## Add points to line charts ===================================================
my_line_chart <- rchart::chart(data = dplyr::filter(exampleData),
                               chart_type = "param_absolute",
                               save = F,
                               include_points = T)

my_line_chart$chart_param_India
