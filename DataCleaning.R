###Cleaning of data downloaded using initial set of species present in the "modelling_species.tsv" file
##author: Amy Davis
library(tidyverse)

#Import occurrences downloaded on GBIF


#occ<-read.delim("D://Adavis/Projects/TrIAS/TrIAS/Modeling/Rcode/trias_pipeline/data/output/0002202-181108115102211/occurrence.txt",header=TRUE,sep="\t", quote="")

occ<-read.csv("D://Adavis/Projects/TrIAS/TrIAS/Modeling/Rcode/trias_pipeline/data/output/0002202-181108115102211/occurrence1.csv",header=TRUE)

#Clean the data
occ_clean<- occ %>%
   filter(basisOfRecord!="FOSSIL_SPECIMEN") %>%
   filter(hasCoordinate =="TRUE") %>%
   filter(hasGeospatialIssues=="FALSE") %>%
   filter(is.na(coordinateUncertaintyInMeters)| coordinateUncertaintyInMeters< 708) %>%
   select(taxonKey,species, scientificName,decimalLatitude,decimalLongitude,eventDate,year,coordinateUncertaintyInMeters,datasetKey,countryCode,establishmentMeans)%>%#select desirable variables
   filter(!grepl("^[0-9]+(\\.[0-9]{0,1})?$",decimalLatitude))%>%
   filter(!grepl("^[0-9]+(\\.[0-9]{0,1})?$",decimalLongitude)) #filter points with unacceptable accuracy


###Generate separate occurrrence data sets for each species for display in GIS
#split dataframe by taxon key
splitDFs1<-split(occ_clean,occ_clean$species) ##returns 43, but the first df has 0 rows returns 42 species same as modelling_species.tsv
lapply(names(splitDFs1), function(x){write.csv(splitDFs1[[x]], file = paste(x,".csv", sep = ""))})
