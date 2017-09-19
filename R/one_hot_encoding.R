#' @title one hot encoding  
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' 
#' }
#' 
#' @importFrom caret dummyVars contr.ltfr
#' @export 

one_hot_encoding <- function(features = features, mode = "auto") {
  
  features_names <- colnames(features)
  
  for (f in features_names) {
    if (class(features[[f]])=="character") {
      levels <- unique(c(features[[f]]))
      features[[f]] <- as.factor(features[[f]], levels=levels)
    }
  }
  
  if (mode == "auto") {
    dmy <- caret::dummyVars("~.", data = features, fullRank = T)
  } else if (mode == "manual") {
    dmy <- caret::dummyVars("~.", data = features)
  } else {
    print("make sure mode is 'manual' or 'auto'")
    break
  }
  dummy_df <- data.frame(predict(dmy, newdata = features))
  return(dummy_df)
}
