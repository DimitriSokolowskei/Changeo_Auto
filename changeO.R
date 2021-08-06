library(shazam)
library(alakazam)
library(readr)


archive <- list.files("~/ImmcantationScripts/", pattern=glob2rx("*_atleast-2_igh_db-pass_parse-select.tsv*"))
data <- read_tsv(archive)

dist_ham <- distToNearest(data, sequenceColumn="junction", 
                          vCallColumn="v_call", jCallColumn="j_call",
                          model="ham", normalize="len", nproc=1)

dist_s5f <- distToNearest(data, sequenceColumn="junction", 
                          vCallColumn="v_call", jCallColumn="j_call",
                          model="hh_s5f", normalize="none", nproc=1)

output <- findThreshold(dist_ham$dist_nearest, method="density")
threshold <- output@threshold
print(output)

