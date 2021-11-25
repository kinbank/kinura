# /usr/bin/Rscript

### This RScript fills in subsidary kinterms in the kinbank universe. 
### E.g. If a language has a record for mB (male speaking brother).
### We can infer that this term also refers to meB & myB. 
### It may be the case the language has other words for the more 
### specific case, but, these terms should also apply. 

suppressMessages(library(dplyr))
suppressMessages(library(stringr))


getHierarchicalRelations = function(parameters){
  hr = c("a", "a")
  for(i in 1:length(parameters)){
    p = parameters[i]
    new_p = stringr::str_remove(p,  "(?<=(m|f)[A-Z]{1,4})(e|y)")
    hr = rbind(hr, c(p, new_p))
  }
  # if there is no subsidary remove it
  hr = hr[hr[,1] != hr[,2],]
  # only hold unique pairs
  hr = hr[!duplicated(hr[,1]),]
  hr  
}


dd = data.frame(parameter = c("mB", "meB"),
                terms = c("brother", "brother"))


fillSubordinates = function(dd, subordinate, superordinate){
  super = dd[dd$parameter == superordinate,]
  sub   = dd[dd$parameter == subordinate,]
  
  # if there are no terms for subordinate (e.g. older sister)
  if(nrow(sub) == 0){
    # And there are terms for the superordinate (e.g. sister)
    if(nrow(super) != 0){
      # Then duplicate sister terms
      new_subordinate = super
      # Change parameter to the subordinate
      new_subordinate$parameter = subordinate
      # Indicate term was inferred in comments
      new_subordinate$comment = paste("Inferred;", new_subordinate$comment)
      # add inferred entries
      dd = rbind(dd, new_subordinate)
    }
  }
  dd
}

fillAllSubordinates = function(dd, hr){
  for(i in 1:nrow(hr)){
    subordinate = hr[i,1]
    superordinate = hr[i,2]
    dd = fillSubordinates(dd, subordinate, superordinate)
  }
  dd
}

files = list.files("kinbank/raw/", 
                   pattern = "*.csv", 
                   full.names = TRUE,
                   recursive = TRUE)


template = read.csv('kinbank/template/template.csv')
hierarchical_relations = getHierarchicalRelations(template$parameter)

for(f in files){
  dd = read.csv(f)
  dd_filled = fillAllSubordinates(dd, hierarchical_relations)
  write.csv(dd_filled, f, quote = TRUE, na = "", row.names = FALSE)
}
