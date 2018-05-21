library(tidyverse)
setwd("C:/Udvikling/R/equity/30-10-17")
bal <- tribble(
   ~Amt, ~period,
   88414, "30/09",
   88314, "03/10",
   88214, "04/10",
   68214, "05/10",
   68154, "05/10",
   94152, "06/10",
   89154, "07/10",
   89093, "07/10",
   84093, "07/10",
   84033, "07/10",
   79033, "10/10",
   78972, "10/10",
   202472, "14/10",
   202442, "14/10",
   205684, "14/10",
   212184, "16/10",
   182184, "16/10",
   182124, "16/10",
   181624, "28/10",
   181585, "28/10",
   179485, "28/10",
   179429, "28/10",
   273888, "30/10"
)

#0725100137 - Jakakwany

ggplot(data=bal, mapping=aes(x=period, y=Amt)) +
  geom_point(mapping=aes(color=period), stat='identity', position='identity')  +
  geom_text(aes(label=Amt), hjust=0.5, vjust=-0.5) +
  ggtitle("Account closing 30-10-17") +  
  labs(x="Sep - Oct. (2017)", y="Amount", caption="Based on data from equity bank")

  

ggsave(filename="301017.png")
