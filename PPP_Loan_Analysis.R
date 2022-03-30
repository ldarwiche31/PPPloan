
# Paycheck Protection Program Loan Project --------------------------------
# Leila Darwiche ----------------------------------------------------------

# load packages
library(tidyverse)
library(readxl)
library(naniar)
library(knitr)

# read data
PPP_Data <- read_csv("data/PPP Data up to 150k 080820 IL.csv")
NAISC <- read_excel("data/NAISC.xlsx", col_types = c("text", "text"))

# Data Cleaning -----------------------------------------------------------

#filtering into just the city Chicago
  PPP_chicago <- PPP_Data %>%
    filter(City == c("Chicago", "CHICAGO")) # %>%
  # replace_with_na_all(condition = ~.x == "Unanswered")
  # commented this out for sake of loading my code because the unanswered changes are v tedious

# some mislabeled Chicago... narrowed by zipcode to compensate
  PPP_Chicago <- PPP_Data %>%
    filter(Zip %in% c(60007, 60018, 60068, 60106, 60131, 60176, 60601, 60602, 60603, 60604, 60605, 60606, 60607, 60608, 60609, 60610, 60611, 60612, 60613, 60614, 60615, 60616, 60617, 60618, 60619, 60620, 60621, 60622, 60623, 60624, 60625, 60626, 60628, 60629, 60630, 60631, 60632, 60633, 60634, 60636, 60637, 60638, 60639, 60640, 60641, 60642, 60643, 60644, 60645, 60646, 60647, 60649, 60651, 60652, 60653, 60654, 60655, 60656, 60657, 60659, 60660, 60661, 60706, 60707, 60714, 60804, 60827)) %>%
    filter(CD != "IA-02", CD != "OH-15") %>%
    replace_with_na_all(condition = ~.x == "Unanswered")

# add industry data information
  PPP_Chicago <- PPP_Chicago %>%
    inner_join(NAISC, by = "NAICSCat")

# write out table
  write.table(PPP_Chicago, file = "PPP_Chicago.txt", sep = "\t", row.names = FALSE)
  
# EDA ---------------------------------------------------------------------

  # total dollar amount of loans
  sum(PPP_Chicago$LoanAmount)
  
  # total amount of loans approved
  nrow(PPP_Chicago)
  
  # average loan granted
  mean(PPP_Chicago$LoanAmount)
  
  # median loan granted
  median(PPP_Chicago$LoanAmount)
  
  #avg loan north side
  North <- PPP_Chicago %>%
    filter(Zip %in% c(60613, 60618, 60657, 60614, 60618, 60622, 60639, 60647,  60630, 60634, 60641, 60634, 60635, 60707,  60635, 60639, 60641, 60647, 60626, 60645, 60659, 60613, 60640, 60631, 60646, 60656, 60625, 60630, 60646, 60659, 60666, 60656, 60611, 60610, 60654, 60642, 60601, 60601, 60604, 60605, 60606, 60607, 60616))
  mean(North$LoanAmount, na.rm = TRUE)
  
  #avg loan south side
  South <- PPP_Chicago %>%
    filter(Zip %in% c(60606, 60607, 60608, 60610, 60612, 60661, 60619, 60620, 60617, 60628, 60633, 60643, 60827,  60655, 60609, 60616, 60653, 60615, 60621, 60637, 60649, 60608, 60629, 60632, 60638, 60636, 60624, 60647,  60651,  60612, 60622, 60642, 60647, 60639, 60651, 60707,  60623, 60616))
  mean(South$LoanAmount, na.rm = TRUE)
  
  # a box plot of the loan data, the vast amount of outliers makes it difficult to see the stopping point of the right whisker, tells us that average will be somewhat skewed to the higher numbers
  ggplot(PPP_Chicago, aes(x = LoanAmount)) +
    geom_boxplot(width = .5) +
    ylim(-1,1) +
    theme(plot.background = element_blank(),
          panel.background = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          panel.grid.major.x = element_line(color = "lightgrey"),
          axis.line.x = element_line(color = "black"))
  # race distribution
  kable(PPP_Chicago %>%
          count(RaceEthnicity))
  
  # gender distribution
  kable(PPP_Chicago %>%
          count(Gender))
  
  # making table with percentages of loans lenders were in control of (for comparison to national patterns) as well as counts, for sake of space I decided to only put lenders who loaned to more than 10 businesses
  x <- PPP_Chicago %>%
    count(Lender)
  kable(x %>%
          filter(n > 10) %>%
          mutate(pct = n/nrow(PPP_Chicago)*100) %>%
          arrange(desc(pct)))
  
  # lender exploration
  PPP_Chicago %>%
    group_by(Zip) %>%
    count(Lender)
  PPP_Chicago %>%
    group_by(Zip) %>%
    count(Lender) %>%
    group_by(Zip) %>%
    mutate(BigLend = max(n)) %>%
    filter(n == BigLend)
  
  # making a table looking at the specifics of business types
  kable(PPP_Chicago %>%
          group_by(BusinessType) %>%
          summarise(avgloan = mean(LoanAmount),
                    totalloans = sum(LoanAmount),
                    medloan = median(LoanAmount),
                    avgsize = mean(JobsReported, na.rm = TRUE)) %>%
          arrange(desc(totalloans)))
  
  # looking at percentage of total loan money and percentage of total loans are these groups
  independent <- PPP_Chicago %>%
    filter(BusinessType %in% c("Self-Employed Individuals", "Independent Contractors", "Sole Proprietorship"))
  
  nrow(independent)/nrow(PPP_Chicago)
  sum(independent$LoanAmount) / sum(PPP_Chicago$LoanAmount)
  
  # making a table looking at the specifics of industries
  kable(PPP_Chicago %>%
          group_by(Industry) %>%
          summarise(avgloan = mean(LoanAmount),
                    totalloans = sum(LoanAmount),
                    pctloan = sum(LoanAmount)/1477812256,
                    medloan = median(LoanAmount),
                    avgsize = mean(JobsReported, na.rm = TRUE)) %>%
          arrange(desc(avgloan)))
  
  kable(PPP_Chicago %>%
          count(Industry) %>%
          filter(n > 10) %>%
          mutate(pct = n/nrow(PPP_Chicago)*100) %>%
          arrange(desc(pct)))
  
  
