# Step 1: This script queries the github API Issues section and brings down the raw json
# Step 2: A simple function is run on the JSON files to extract relevant information
# Step 3: Extracts lists and collate into a dataframe
# Step 4: Ported out to excel file to help with viewability

library(tibble)
library(dplyr)
library(stringr)
library(tidyr)
library(xlsx)
library(RJSONIO)

# Extracting data from the website
Raw1 <- fromJSON("https://api.github.com/repos/pharmaverse/admiral/issues?page=1")
Raw2 <- fromJSON("https://api.github.com/repos/pharmaverse/admiral/issues?page=2")
Raw3 <- fromJSON("https://api.github.com/repos/pharmaverse/admiral/issues?page=3")
Raw4 <- fromJSON("https://api.github.com/repos/pharmaverse/admiral/issues?page=4")
Raw5 <- fromJSON("https://api.github.com/repos/pharmaverse/admiral/issues?page=5")
Raw6 <- fromJSON("https://api.github.com/repos/pharmaverse/admiral/issues?page=6")

# Quick Look at the Raw contents of one JSON file
Raw1[[14]]$user$login
Raw1[[14]]$node_id
Raw1[[14]]$number
Raw1[[14]]$title
Raw1[[14]]$created_at
is_empty(Raw1[[14]]$labels)
length(Raw1[[14]]$labels)
Raw1[[14]]$labels[[1]]$name
Raw1[[14]]$labels[[2]]$name
Raw1[[14]]$labels[[3]]$name

#' Extract releveant JSON information
#'
#' @param data File with JSON data in it
#' @param index The location in the list
#'
#' @return
#' @export
#'
#' @examples
get_issue <- function(data, index){
  
  c0 <- data[[index]]$user$login
  c1 <- data[[index]]$node_id
  c2 <- data[[index]]$number
  c3 <- data[[index]]$title
  c4 <- data[[index]]$created_at
  
  if (length(data[[index]]$labels) == 1 ){
    #length(data[[index]]$labels)
    c5 <- data[[index]]$labels[[1]]$name
    
    a <- tibble(c0, c1, c2, c3, c4, c5, c6 = "", c7 = "")
    return(a)
    
  } else if (length(data[[index]]$labels) == 2 ) {
    
    c5 <- data[[index]]$labels[[1]]$name
    c6 <- data[[index]]$labels[[2]]$name
    
    a <- tibble(c0, c1, c2, c3, c4, c5, c6, c7 = "")
    
    return(a)
    
  } else if (length(data[[index]]$labels) == 3 ) {
    
    c5 <- data[[index]]$labels[[1]]$name
    c6 <- data[[index]]$labels[[2]]$name
    c7 <- data[[index]]$labels[[3]]$name
    
    a <- tibble(c0, c1, c2, c3, c4, c5, c6, c7)
    
    return(a)
    
  } else {
    a <- tibble(c0, c1, c2, c3, c4, c5 = "", c6 = "", c7 = "")
    
    return(a)
  }
}

#' Collate lists into one dataframe
#'
#' @param input_raw 
#' @param num_vec 
#'
#' @return
#' @export
#'
#' @examples
loop_it <- function(input_raw, num_vec){
  page = list()
  for (i in num_vec) {
    dat <- get_issue(input_raw, i)  
    page[[i]] <- dat  
  }
  page_data = do.call(rbind, page) 
  return(page_data)
}

# Run loop_it on each section of raw data
page_1_data <- loop_it(Raw1, 1:length(Raw1))
page_2_data <- loop_it(Raw2, 1:length(Raw2))
page_3_data <- loop_it(Raw3, 1:length(Raw3))
page_4_data <- loop_it(Raw4, 1:length(Raw4))
page_5_data <- loop_it(Raw5, 1:length(Raw5))
page_6_data <- loop_it(Raw6, 1:length(Raw6))

# Combine data and clean up
all_pgs <- bind_rows(page_1_data, page_2_data, page_3_data,
                     page_4_data, page_5_data, page_6_data) %>%
  rename("Author" = c0, "Type" = c1, "Number" = c2, "Description" = c3,
         "Date Created" = c4, "Label 1" = c5, "Label 2" = c6,
         "Label 3" = c7) %>%
  mutate(Type = case_when(
    Type = str_detect(Type, "I_") ~ "Issue",
    Type = str_detect(Type, "PR_") ~ "Pull Request",
    Type = str_detect(Type, "MDU6") ~ "Issue",
    TRUE ~ "Not Classisfied"
  ),
  `Date Created` = gsub("(T).*", "\\1", `Date Created`),
  Resolution = "",
  Notes = ""
  )

# Subset data so it can used in excel as sheets
all_issues <- all_pgs %>% filter(Type == "Issue")
all_pr <-  all_pgs %>% filter(Type == "Pull Request")

# Write the first data set in a new workbook
write.xlsx(all_issues, file="github_triage.xlsx",
           sheetName="Issues", append=FALSE)
# Add a second data set in a new worksheet
write.xlsx(all_pr, file="github_triage.xlsx", sheetName="Pull Request",
           append=TRUE)













