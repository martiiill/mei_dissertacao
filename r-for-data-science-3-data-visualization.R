install.packages("tidyverse")
library(tidyverse)

#Do cars with big engines use more fuel than cars with small engines?
mpg
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

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
  # categorical são variaveis que são limitadas a um grupo (manufacturer, model, trans, drv, fl, class), continuous sao variaveis que podem ter vários valores (displ, year, cyl cty, hwy)
summary(mpg)
  
#3- Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue", size=1, shape=14)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = manufacturer, y = model), color = "blue", size=1, shape=14)
  #variaveeis não continuas têm muitos mais dados dispersos

  #4- What happens if you map the same variable to multiple aesthetics?
ggplot(mpg, aes(x = displ, y = hwy, colour = hwy, size = displ)) +
  geom_point()
#Mapping a single variable to multiple aesthetics is redundant. Because it is redundant information, in most cases avoid mapping a single variable to multiple aesthetics.

  #5 What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
  # Stroke changes the size of the border for shapes (21-25). 
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 2)
  
  # 6 What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)? Note, you’ll also need to specify x and y.
ggplot(mpg, aes(x = displ, y = hwy, colour = displ < 5)) +
  geom_point()
# Aesthetics can also be mapped to expressions like displ < 5. The ggplot() function behaves as if a temporary variable was added to the data with values equal to the result of the expression. In this case, the result of displ < 5 is a logical variable which takes values of TRUE or FALSE.

# 3.5.1 Exercises
# What happens if you facet on a continuous variable?
ggplot(mpg, aes(x = displ, y = cyl)) +
  geom_point() +
  facet_grid(. ~ cty)
# The continuous variable is converted to a categorical variable, and the plot contains a facet for each distinct value.

# What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cty)) +
  facet_grid(drv ~ cyl)
#The empty cells (facets) in this plot are combinations of drv and cyl that have no points These are the same locations in the plot of drv and cyl that have no points.

# What plots does the following code make? What does . do?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# The symbol . ignores that dimension when faceting. For example, drv ~ . facet by values of drv on the y-axis. . ~ cyl will facet by values of cyl on the x-axis.

# Take the first faceted plot in this section: What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

#Advantages of encoding class with facets instead of color include the ability to encode more distinct categories. For me, it is difficult to distinguish between the colors of "midsize" and "minivan".
#Given human visual perception, the max number of colors to use when encoding unordered categorical (qualitative) data is nine, and in practice, often much less than that. Displaying observations from different categories on different scales makes it difficult to directly compare values of observations across categories. However, it can make it easier to compare the shape of the relationship between the x and y variables across categories.
#Disadvantages of encoding the class variable with facets instead of the color aesthetic include the difficulty of comparing the values of observations between categories since the observations for each category are on different plots. Using the same x- and y-scales for all facets makes it easier to compare values of observations across categories, but it is still more difficult than if they had been displayed on the same plot. Since encoding class within color also places all points on the same plot, it visualizes the unconditional relationship between the x and y variables; with facets, the unconditional relationship is no longer visualized since the points are spread across multiple plots.
#
#The benefit of encoding a variable with facetting over encoding it with color increase in both the number of points and the number of categories. With a large number of points, there is often overlap. It is difficult to handle overlapping points with different colors color. Jittering will still work with color. But jittering will only work well if there are few points and the classes do not overlap much, otherwise, the colors of areas will no longer be distinct, and it will be hard to pick out the patterns of different categories visually. Transparency (alpha) does not work well with colors since the mixing of overlapping transparent colors will no longer represent the colors of the categories. Binning methods already use color to encode the density of points in the bin, so color cannot be used to encode categories.
#
#As the number of categories increases, the difference between colors decreases, to the point that the color of categories will no longer be visually distinct.

# Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual panels? Why doesn’t facet_grid() have nrow and ncol arguments?
# nrow (ncol) determines the number of rows (columns) to use when laying out the facets. It is necessary since facet_wrap() only facets on one variable. The nrow and ncol arguments are unnecessary for facet_grid() since the number of unique values of the variables specified in the function determines the number of rows and columns.

# When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?
#There will be more space for columns if the plot is laid out horizontal

#3.6.1 Exercises
# What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
# line chart: geom_line() boxplot: geom_boxplot() histogram: geom_histogram() area chart: geom_area()

# Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# What does show.legend = FALSE do? What happens if you remove it? Why do you think I used it earlier in the chapter?
# show.legend = FALSE hides the legend box.

ggplot(data = mpg) + 
  geom_smooth( mapping = aes(x = displ, y = hwy, color = drv) , se = FALSE, show.legend = FALSE)
# the legend is suppressed because with three plots, adding a legend to only the last plot would make the sizes of plots different

# What does the se argument to geom_smooth() do?
# standard error bands to the lines.

# Will these two graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
# No. Because both geom_point() and geom_smooth() will use the same data and mappings

# Recreate the R code necessary to generate the following graphs.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(group = drv), se = FALSE) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(aes(linetype = drv), se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(size = 4, color = "white") +
  geom_point(aes(colour = drv))
