# Step 1: This script queries the github API Issues section and brings down the raw json
# Step 2: A simple function is run on the JSON files to extract relevant information
# Step 3: Ported out to excel file to help with viewability

library(tibble)
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


page1 = list()
for (i in 1:30) {
  dat <- get_issue(Raw1, i)  # maybe you want to keep track of which iteration produced it?
  page1[[i]] <- dat # add it to your list
}
page_1_data = do.call(rbind, page1)


page2 = list()
for (i in 1:30) {
  dat <- get_issue(Raw2, i)  # maybe you want to keep track of which iteration produced it?
  page2[[i]] <- dat # add it to your list
}
page_2_data = do.call(rbind, page2)

page3 = list()
for (i in 1:30) {
  dat <- get_issue(Raw3, i)  # maybe you want to keep track of which iteration produced it?
  page3[[i]] <- dat # add it to your list
}
page_3_data = do.call(rbind, page3)


page4 = list()
for (i in 1:30) {
  dat <- get_issue(Raw4, i)  # maybe you want to keep track of which iteration produced it?
  page4[[i]] <- dat # add it to your list
}
page_4_data = do.call(rbind, page4)

page5 = list()
for (i in 1:30) {
  dat <- get_issue(Raw5, i)  # maybe you want to keep track of which iteration produced it?
  page5[[i]] <- dat # add it to your list
}
page_5_data = do.call(rbind, page5)


page6 = list()
for (i in 1:30) {
  dat <- get_issue(Raw6, i)  # maybe you want to keep track of which iteration produced it?
  page6[[i]] <- dat # add it to your list
}
page_6_data = do.call(rbind, page6)


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

all_issues <- all_pgs %>% filter(Type == "Issue")
all_pr <-  all_pgs %>% filter(Type == "Pull Request")


# Write the first data set in a new workbook
write.xlsx(all_issues, file="github_triage.xlsx",
           sheetName="Issues", append=FALSE)
# Add a second data set in a new worksheet
write.xlsx(all_pr, file="github_triage.xlsx", sheetName="Pull Request",
           append=TRUE)












quick_look <- bind_rows(get_thing(Raw1, 1),
                        get_thing(Raw1, 2),
                        get_thing(Raw1, 3),
                        get_thing(Raw1, 4),
                        get_thing(Raw1, 5),
                        get_thing(Raw1, 6),
                        get_thing(Raw1, 7),
                        get_thing(Raw1, 8),
                        get_thing(Raw1, 9),
                        get_thing(Raw1, 10),
                        get_thing(Raw1, 11),
                        get_thing(Raw1, 12),
                        get_thing(Raw1, 13))

for(var in 1:13){
  print(get_thing(Raw1, var))
}

Raw1[[1]]$node_id
Raw1[[1]]$number
Raw1[[1]]$title
Raw1[[1]]$created_at
is_empty(Raw1[[1]]$labels)
#Raw1[[1]]$labels[[1]]$name
#Raw1[[1]]$labels[[2]]$name

Raw1[[1]]$node_id
Raw1[[2]]$number
Raw1[[2]]$title
Raw1[[2]]$created_at
is_empty(Raw1[[2]]$labels)



system('curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Roche-GSK/admiral/issues?page=1 > issues1.txt')
system('curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Roche-GSK/admiral/issues?page=2 > issues2.txt')
system('curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Roche-GSK/admiral/issues?page=3 > issues3.txt')
system('curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Roche-GSK/admiral/issues?page=4 > issues4.txt')
system('curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Roche-GSK/admiral/issues?page=5 > issues5.txt')
system('curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/Roche-GSK/admiral/issues?page=6 > issues6.txt')


issues1 <- readLines("issues1.txt")
issues2 <- readLines("issues2.txt")
issues3 <- readLines("issues3.txt")
issues4 <- readLines("issues4.txt")
issues5 <- readLines("issues5.txt")
issues6 <- readLines("issues6.txt")

issues1_df <- enframe(unlist(issues1))
issues2_df <- enframe(unlist(issues2))
issues3_df <- enframe(unlist(issues3))
issues4_df <- enframe(unlist(issues4))
issues5_df <- enframe(unlist(issues5))
issues6_df <- enframe(unlist(issues6))

issues_all <- bind_rows(issues1_df, issues2_df, issues3_df, issues4_df, issues5_df, issues6_df)

issues_filter <- issues_all %>% filter(str_detect(value, "number|label|title|state")) #%>%
separate(value, c("var", "info"), sep = ":")



#system('curl -i https://api.github.com/repos/Roche-GSK/admiral/issues --header "Authorization: token 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"')

# git branch -m master main
# git fetch origin
# git branch -u origin/main main
# git remote set-he


