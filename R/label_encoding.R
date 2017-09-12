#' @title label encoding  
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' 
#' }
#' 
#' @export 



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