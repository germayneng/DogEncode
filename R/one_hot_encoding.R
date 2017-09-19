#' @title one hot encoding  
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' 
#' }
#' 
#' @importFrom caret dummyVars
#' @export 

one_hot_encoding <- function(features = features, mode = 1) {
  
  features_names <- colnames(features)
  
  for (f in features_names) {
    if (class(features[[f]])=="character") {
      levels <- unique(c(features[[f]]))
      features[[f]] <- as.factor(features[[f]], levels=levels)
    }
  }
  
  if (mode == 1) {
    dmy <- caret::dummyVars("~.", data = features, fullRank = T)
  } else if (mode == 2) {
    dmy <- caret::dummyVars("~.", data = features)
  } else {
    print("make sure mode is 2:'manual' or 1:'auto' (default)")
    break
  }
  dummy_df <- data.frame(predict(dmy, newdata = features))
  return(dummy_df)
}
