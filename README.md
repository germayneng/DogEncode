DogEncode  <img src="man/Picture2.jpg" align="right" />
================

*DogEncode* provides some methods to encode categoical features fast and easy. From simple methodology like dummy variables to Owen Zhang's kaggle famous leave one out encoding, this R package will cover them all.   


## Installation

```s
# install.packages("devtools")
devtools::install_github("germayneng/DogEncode")
```
## Usage

Currently, DogEncode covers the following encoding methods. I will be glad to add more as I learn more :) 
1) one hot encoding (dummy)

```r
# feed in dataframe wtih cat variables. class of variables to be character 
# mode = auto to automate dropping off one dummy 
# mode = manual to generate all dummy 
one_hot_encoding(df, mode = "manual") # you can bind this entire dataframe to your features 

```

2) label encoding aka colhot encoding 

```r
# feed in dataframe with cat variable. class of variables to be character 
# if you have both train and test, you can feed both inside to ensure that the labels are standardized between them 
# otherwise, let argument test = NULL 

# example if there is test 
end <- label_encoding(train = temp, test = temp_test) 
Names <- end[[1]] # encoded for train 
Names_test <- end[[2]] # encoded for test 

# if there is no test 
end <- label_encoding(train = temp, test = NULL) 
```

3) Count encoding aka counthot encoding 

```r
# feed in single column of variable, i.e train$cat 
# example 

example <- data.frame(
   id = c(rep("a", 5), rep("b", 3), rep("c", 2), "d"),
   resp = c(1, 0, 0, NA, 0, 1, 0, 0, 1, 0, 1))
   
 
 count_encoding(example$id, mode = "normal")
 
 # if want log scale 
 count_encoding(example$id, mode = "log")
 
```

4) Label count encoding 

```r
example <- data.frame(
   id = c(rep("a", 5), rep("b", 3), rep("c", 2), "d"),
   resp = c(1, 0, 0, NA, 0, 1, 0, 0, 1, 0, 1))
   
   
label_count_encoding(example$id)
```

5) Leave one out encoding

```r
example <- data.frame(
   id = c(rep("a", 5), rep("b", 3), rep("c", 2), "d"),
   resp = c(1, 0, 0, NA, 0, 1, 0, 0, 1, 0, 1))
   
 LOO_encode(example$id, example$resp) 

```


## To do

* Add more documentation to explain every function and credit to respective people.  
* Hash encoding

## Credit 

Owen Zhang, HJ van Veen, Dex Grooves and [Simone Aiosa's dog logo](https://dribbble.com/shots/2673237-Dog)
<br>
[super helpful post to help debug ^.^](http://alyssafrazee.com/2014/01/21/namespaces.html)

## License 
