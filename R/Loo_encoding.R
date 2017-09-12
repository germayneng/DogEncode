#' @title count encoding
#'
#' @examples
#'
#' \dontrun{
#'
#'
#' }
#' @import dplyr
#' @importFrom data.table data.table
#' @export Loo_encode

Loo_encode <- function(id, resp) {
  working_df <- data.table::data.table(id, resp)
  colnames(working_df) <- c("id","resp")


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


loo_grouped_vector <- function(resp) {
  resp <- resp[complete.cases(resp)]
  total <- sum(resp)
  divisor <- length(resp) - 1
  sapply(resp, function(x) (total - x)/divisor)
}
