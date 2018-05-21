library(tidyverse)
# https://www.tidyverse.org/

mpg

# Datatyper:
# * `int` stands for integers.
# * `dbl` stands for doubles, or real numbers.
# * `chr` stands for character vectors, or strings.
# * `dttm` stands for date-times (a date + a time).
# * Andre: `lgl`, `fctr`, `date`


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# ggplot2 (part of tidyverse) based on (layered) grammar of graphics.

# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) + 
#   <GEOM_FUNCTION>()

# Data + aesthetic mapping (`aes`) of how to perceive data
# Layers: `geom_`* + `stat_`*
# Scales (color, size, ...)
# Coordinate (cartesian, polar, log10, ...)
# Faceting (conditioning or latticing/trellising)
# Theme (font size, background color, ...)
# No suggestions of which plots to use. 
# No interactivity, only static graphics.
# Reference: http://r4ds.had.co.nz/data-visualisation.html
# Documentation: # http://ggplot2.tidyverse.org/reference/

# > Exercises 3.2.4

if (FALSE) {
  ggplot(data = mpg) + 
    geom_histogram()
}

ggplot(data = mpg, mapping = aes(hwy))

ggplot(data = mpg, mapping = aes(hwy)) + 
  geom_histogram()

ggplot(mpg) + 
  geom_histogram(aes(hwy))

# Generic template:
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# mapping (aes()) in ggplot is inherited to layers (geom_*/stat_*) if not overridden.

# Captions, labels, themes:
ggplot(mpg, aes(hwy)) + 
  geom_histogram() + 
  labs(title = "Fuel economy data", 
       subtitle = "1999 and 2008 for 38 popular models of car",
       x = "Highway miles per gallon", y = "Count") +
  theme_bw() 

# Always use black/white theme from now on
theme_set(theme_bw())


# > 3.3.1 Exercises


# Faceting/conditioning/latticing/trellising:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) + 
  facet_grid(drv ~ cyl, labeller = label_both)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = year, color = class)) + 
  facet_grid(drv ~ cyl, labeller = label_both) 

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = year, color = class)) + 
  facet_grid(drv ~ cyl, labeller = label_both) +
  scale_size_continuous("Årgang", range = c(1, 3)) +
  scale_color_discrete("Type") +
  labs(title = "Titel", 
       subtitle = "Undertitel",
       x = "Motorstørrelse", y = "Brændstofeffektivitet på motorvej")


# > 3.5.1 Exercises


# Bar plot
  
ggplot(data = mpg, mapping = aes(x = class)) + 
  geom_bar()

ggplot(mpg, aes(class)) + 
  geom_bar()

p <- ggplot(mpg, aes(manufacturer)) + 
  geom_bar()
p

ggplot(mpg, aes(manufacturer)) + 
  geom_bar() +
  theme_bw(base_size = 16) 
p + theme_bw(base_size = 16) 

p +
  theme_bw(base_size = 16) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

p
p + scale_y_continuous(breaks = scales::pretty_breaks(n = 20))


ggplot(mpg, aes(class, fill = cyl)) + 
  geom_bar()

ggplot(mpg, aes(class, fill = factor(cyl))) + 
  geom_bar()

ggplot(mpg, aes(class, fill = factor(cyl))) + 
  geom_bar()

ggplot(mpg, aes(class, fill = factor(cyl))) + 
  geom_bar(position = position_dodge())

# Points / scatter plots

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(alpha = 0.2)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_count()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter(alpha = 0.2) # control jitter with width and height parameters

# log:

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() +
  scale_x_log10() + 
  scale_y_log10()

library(scales)
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() +
  scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
  annotation_logticks()

# http://ggplot2.tidyverse.org/reference/annotation_logticks.html

# Boxplots

ggplot(mpg, aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(mpg, aes(x = class, y = hwy, color = class)) + 
  geom_boxplot()


# 3.8.1 Exercises

