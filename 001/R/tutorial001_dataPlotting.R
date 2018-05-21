#Check all types of plots
plot(iris)

install.packages("tidyverse")

library(tidyverse)

#Draw the canvas
ggplot(data=iris, mapping=aes(x=Petal.Length, y=Petal.Width))


#Draw the scatterplot
ggplot(data=iris, mapping=aes(x=Petal.Length, y=Petal.Width)) + 
  geom_point() 

#And then add the aesthetics and a legend
ggplot(data=iris, mapping=aes(x=Petal.Length, y=Petal.Width)) + 
  geom_point(mapping=aes(color=Species))  

#And add a model to predict the pattern
ggplot(data=iris, mapping=aes(x=Petal.Length, y=Petal.Width)) + 
  geom_point(mapping=aes(color=Species)) +
  geom_smooth(se=F)

#Add a title to the plot
ggplot(data=iris, mapping=aes(x=Petal.Length, y=Petal.Width)) + 
  geom_point(mapping=aes(color=Species)) +
  geom_smooth(se=F) + labs(title="Plant size analysis") 

#Change the background
ggplot(data=iris, mapping=aes(x=Petal.Length, y=Petal.Width)) + 
  geom_point(mapping=aes(color=Species), show.legend = FALSE) +
  geom_smooth(se=F) + labs(title="Plant size analysis") +
  theme(panel.background = element_rect(fill="lightgrey"))

#Add some noise the scatter plot
ggplot(data=iris, mapping=aes(x=Petal.Length, y=Petal.Width)) + 
  geom_jitter(mapping=aes(color=Species), show.legend = FALSE) +
  geom_smooth(se=F) + ggtitle("Plant size analysis") +
  theme(panel.background = element_rect(fill="lightgrey"))

#Save the plot
ggplot(data=iris, mapping=aes(x=Petal.Length, y=Petal.Width)) + 
  geom_jitter(mapping=aes(color=Species), show.legend = FALSE) +
  geom_smooth(se=F) + ggtitle("Plant size analysis") +
  theme(panel.background = element_rect(fill="lightgrey")) + ggsave("irisAnalysis.png", path="C:\\Udvikling\\R");




?theme
?aes

