# testing to see if I can query the DataONE API for a specific term

install.packages("dataone")
library(dataone)
library(stringr)

cn <- CNode("PROD")

term <- "Exxon Valdez Oil Spill Trustees' Council"

the_q <- paste("abstract:", term, sep="")
queryParamList <- list(q="id:*", rows=1000, fq=the_q, fl="id,title,abstract,author,datasource")  
result <- query(cn, solrQuery=queryParamList, as="data.frame")

out_date <- as.character(Sys.time()) %>% str_remove(" EDT") %>% str_replace(" ", "T")
out_file <- paste("all_evos/search_results/search_", term, "_", out_date, ".csv", sep="")

write.csv(result, file=out_file)

