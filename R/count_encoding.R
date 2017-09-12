#' @title count encoding
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' 
#' }
#' @import dplyr
#' @export 


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