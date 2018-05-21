Construct a graph displaying the temperature at `JFK`.

```{r}
#Unsure
jfkDayTemp <- weather %>%  group_by(year, month, day) %>% mutate_at(vars(temp, dewp), funs(round((.-32)*5/9,  2))) %>% filter(origin=='JFK') %>% summarize(deg=sum(temp))
plot(jfkDayTemp$deg, col = "blue", main="Temperature at JFK", ylab="Daily Temp")
```

Add a red line showing the mean temperature for each day.

```{r}
jfkDailyMeanTemp <- weather %>% filter(origin=='JFK') %>% group_by(year, month, day)  %>%  summarize(deg = mean(temp))

lines(jfkDailyMeanTemp$deg, type="o", pch=22, lty=2, col="red")

