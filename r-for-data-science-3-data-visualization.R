library(tidyverse)

install.packages("tidyverse")
library(tidyverse)

#Do cars with big engines use more fuel than cars with small engines?
mpg
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

#3.2.4 Exercises
  #1- Run ggplot(data = mpg). What do you see? Nada, vazio.
ggplot(data = mpg)
  #2 - How many rows are in mpg? How many columns? 234 linhas e 11 colunas
dim(mpg)
  #3- What does the drv variable describe? The type of drive train, where f = front-wheel drive, r = rear wheel drive, 4 = 4wd
help(mpg)
  #4-Make a scatterplot of hwy vs cyl.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = hwy, y = cyl))
  #5-What happens if you make a scatterplot of class vs drv? Why is the plot not useful? Porque apenas nos relaciona o drv com o tipo de veiculo e essa info nao e util 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = drv))
###################################################################
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
#> Warning: Using size for a discrete variable is not advised.

# Left
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Right
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

#3.3.1 Exercises
  #1 - What’s gone wrong with this code? Why are the points not blue? Porque faltam os (), é fora da aes
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
  #2 - Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg?
