#'
#'
#' @import plyr, dplyr, data.table

###########################
# One hot Encoding #######
##########################
#' Most basic categorical features treatment. normally we will drop off one column 
#' to avoid the dummy trap. Some drawback to this technique curse of dimensionality 
#' and also does not deal with missing variables in train-test
#' http://amunategui.github.io/dummyVar-Walkthrough/
#' 

#' df consist of the variables you want to dummified. make sure it is in data.frame 
#' @description auto mode will help to remove one column. manual returns n columns with
#' n variables. You can then choose who is the control. 
#'
#' @importFrom caret dummyVars
one_hot_encoding <- function(features = features, mode = "auto") {
  
  features_names <- colnames(features)
  
  for (f in features_names) {
    if (class(features[[f]])=="character") {
      levels <- unique(c(features[[f]]))
      features[[f]] <- as.factor(features[[f]], levels=levels)
    }
  }
  
  if (mode %in% "auto") {
  dmy <- caret::dummyVars("~.", data = features, fullRank = T)
  } else if (mode %in % "manual") {
    dmy <- caret::dummyVars("~.", data = features)
  } else {
    print("make sure mode is 'manual' or 'auto'")
    break
  }
  dummy_df <- data.frame(predict(dmy, newdata = features))
  return(dummy_df)
}


###########################
# Hash Encoding #######
##########################

# may have collisions (different variable but same encoding)

###########################
# Label Encoding #######
##########################

#' @description similarly, include train and test cat features in data.frame
#' if no test, add test = NULL
#' output will be in list. simply extract result[[1]] for train and [[2]] for test
#' @example ensure character categorical variables df 

label_encoding <- function(train = train, test = test){
  
  features_names <- colnames(train)
  
  for (f in features_names) {
      if (class(train[[f]])=="character") {
      # obtain the common factors between the 2
      # both train and test must have the same values for each variables 
        if(is.null(test)){
          levels <- unique(c(train[[f]]))
      } else {
          levels <- unique(c(train[[f]],test[[f]]))
      }
          train[[f]] <- as.numeric(factor(train[[f]], levels=levels))
          test[[f]] <- as.numeric(factor(test[[f]], levels=levels))    
      
      }
    
  }
  result <- list(train,test)
  return(result)
}

###########################
# Count Encoding ###
##########################
#' @description Replace categorical variables with their count 
#' This will be useful for linear and non linear alog
#' But sensitive to outliers 
#' Includes 2 modes: normal or log transformation. default at normal 
#' Be warned of collision: different variable same encoding 
#' 
#' @example 


count_encoding <- function(id, mode = "normal"){
  
  working_df <- data.table::data.table(name = id)
  summary_count <- table(id) %>% data.frame()
  colnames(summary_count) <- c("name","count")
  working_df <- working_df %>% left_join(summary_count, by = "name")
  if(mode %in% "normal"){
  return(working_df$count)
  } else if(mode %in% "log"){
  working_df$count <- log(working_df$count)
  return(working_df$count)
  } else {
    print("mode must be 'normal' or 'log'")
    break
    }
}





###########################
# label Count Encoding ###
##########################
#' 
label_count_encoding <- function(id, mode = "normal"){
  
  working_df <- data.table::data.table(name = id)
  summary_count <- table(id) %>% data.frame()
  colnames(summary_count) <- c("name","count")
  working_df <- working_df %>% left_join(summary_count, by = "name")
  working_df <- working_df %>% arrange(desc(count)) %>% group_by(name) %>%
                mutate(value = as.numeric(name)) %>% ungroup() %>% 
                group_by(name) %>% mutate(encoded = (n_distinct(working_df$name) +1) - value)
  
}

#############################
# Leave one out encoding ###
############################
#' Do Owen Zhang style leave-one-out encoding of a categorical.
#' aka likelihood encoding 

#' https://github.com/DexGroves/hacktoolkit
#' https://datascience.stackexchange.com/questions/11024/encoding-categorical-variables-using-likelihood-estimation
#' 
#' This is DexGrove's looencoding. I have a modified version with caps Looencoding. This version takes into account for possible NA values  
#' 
#'   
#' Take the mean of a variable for all rows with the same id except
#' for the current row, so as to avoid leakage.
#'
#' @import magrittr, plyr, dplyr
#' @export
#'
#' @param id vector of identifiers to group over
#' @param resp vector of response to summarise
#' @return vector of one-left-out summarised response over id
#'
#' @examples
#' test_data <- data.frame(
#'   id = c(rep("a", 5), rep("b", 3), rep("c", 2), "d"),
#'   resp = c(1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1)
#' )
#'
#' loo_encode(test_data$id, test_data$resp)
#' 


Loo_encode <- function(id, resp) {
  
  working_df <- data.frame(id, resp)
  colnames(working_df) <- c("id","resp")
  
  # check if there is any NA in the resp columns, 
  #resp_na_check <- length(which(is.na(resp)))
  
  
  #if (!resp_na_check > 0 ) {
  #working_df[, encoded := loo_grouped_vector(resp), by = id]
  #working_df[is.nan(encoded), encoded := NA]
  #return(working_df$encoded)
  
  #} else {
  working_df <- working_df %>% group_by(id) %>% mutate(encoded = loo_grouped_vector(resp)) %>% ungroup()
  working_df$encoded[is.na(working_df$encoded)] <- NA 
  working_df <- working_df %>% mutate(row = row_number()) # add to maintain order later
  # we want to extract the resp that is no NA 
  nona_df <- working_df[which(!is.na(working_df$resp)),]
  mean_without_na <- nona_df %>% group_by(id) %>% 
    summarise(
      encoded = mean(resp)
    )
  na_df <- working_df[which(is.na(working_df$resp)),]
  na_df$encoded <- NULL # since encode is the wrong one 
  na_df <- na_df %>% left_join(mean_without_na, by ="id") 
  # join them back 
  result <- rbind(nona_df,na_df) %>% arrange(row) # ensure the order is the ssame 
  result$encoded[is.na(result$encoded)] <- mean(resp, na.rm = T)
  return(result$encoded)
  #}
  
}

loo_encode <- function(id, resp) {
  working_df <- data.table(id, resp)
  working_df[, encoded := loo_grouped_vector(resp), by = id]
  working_df[is.nan(encoded), encoded := NA]
  working_df$encoded
  
}


loo_grouped_vector <- function(resp) {
  resp <- resp[complete.cases(resp)]
  total <- sum(resp)
  divisor <- length(resp) - 1
  sapply(resp, function(x) (total - x)/divisor)
}



  
