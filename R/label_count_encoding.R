#' @title label count encoding
#'
#' @examples
#'
#' \dontrun{
#'
#'
#' }
#' @import dplyr
#' @importFrom  data.table data.table
#' @export


label_count_encoding <- function(id){

  working_df <- data.table::data.table(name = id)
  working_df$name <- as.factor(working_df$name)
  summary_count <- table(id) %>% data.frame()
  colnames(summary_count) <- c("name","count")
  summary_count$name <- as.factor(summary_count$name)
  working_df <- working_df %>% left_join(summary_count, by = "name")
  working_df <- working_df %>% arrange(desc(count)) %>% group_by(name) %>%
    mutate(value = as.numeric(name)) %>% ungroup() %>%
    group_by(name) %>% mutate(encoded = (n_distinct(working_df$name) +1) - value) %>% ungroup
  return(working_df$encoded)

}
