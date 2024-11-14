# copied from https://r-graph-gallery.com/272-basic-scatterplot-with-ggplot2.html
library(tidyverse)
 
# The iris dataset is provided natively by R
#head(iris)
 
# basic scatterplot
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
    geom_point()
