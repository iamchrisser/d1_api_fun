# these are the packages needed for this script
needs <- c("dataone", "stringr")

# Install packages not yet installed
installed_packages <- needs %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(needs[!installed_packages])
}

# Packages loading
invisible(lapply(needs, library, character.only = TRUE))

cn <- CNode("PROD")
evos_terms <- c("Exxon Valdez Oil Spill Trustee Council", "Exxon Valdez Oil Spill Trustees Council", "Exxon Valdez Oil Spill Trustees' Council", "Exxon Valdez Oil Spill Trustee's Council", "EVOSTC", "EVOS")

d1_api <- function(term){
  the_q <- paste("abstract:", term, sep="")
  queryParamList <- list(q="id:*", rows=1000, fq=the_q, fl="id,title,abstract,author,datasource")  
  result <- query(cn, solrQuery=queryParamList, as="data.frame")
}
# get first 1000 results for each of the terms above, writing each set of results to a csv
for (t in evos_terms){
  out_date <- as.character(Sys.time()) %>% str_remove(" EDT") %>% str_replace(" ", "T")
  out_file <- paste("all_evos/search_results/search_", t, "_", out_date, ".csv", sep="")
  result <- d1_api(t)
  write.csv(result, file=out_file)
}

print("Done getting api results.")

# read in each csv and combine into a single dataframe
files <- list.files(path="search_results", pattern="*.csv", full.names=TRUE)
evos_df <- do.call(rbind, lapply(files, read.csv))
write.csv(evos_df, file="all_evos/search_results/processed/combined_search_results.csv")

evos_unique <- unique(evos_df)
write.csv(evos_unique, file="all_evos/search_results/processed/unique_search_results.csv")