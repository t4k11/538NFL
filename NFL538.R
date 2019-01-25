library(dplyr)
library(ggplot2)

df <- read.csv('NFL538.csv')

df$actual <- df$score2 - df$score1

# Which is more Accurate? RMSE
df$X538.diff <- df$X538.spread - df$actual
df$fd.diff <- df$fd.spread - df$actual

sqrt(mean(df[,"X538.diff"]^2)) # 13.57337
sqrt(mean(df[,"fd.diff"]^2)) # 13.10273

ggplot() + 
  geom_histogram(data=df, aes(x=X538.diff, y=..density..), binwidth = 2, fill = 'red', alpha = .3) +
  geom_histogram(data=df, aes(x=fd.diff, y=..density..), binwidth = 2, fill = 'blue', alpha = .3) + 
  geom_line(data=df, aes(x=X538.diff), stat="density", size=2, alpha=.5, color='red') +
  geom_line(data=df, aes(x=fd.diff), stat="density", size=2, alpha=.5, color='blue') +
  xlab("Difference Between Prediciton and Result") + 
  ylab("Density") 

# Does either have any bias?
mean(df[,"X538.diff"]) # -0.3867188
mean(df[,"fd.diff"]) # 0.01171875

# Which selects the winner better?
df$winner <- ifelse(df$score1 > df$score2, 'team1', ifelse(df$score1<df$score2, 'team2', 'tie'))

nrow(df[(df$X538.spread < 0 & df$winner == 'team1') | (df$X538.spread > 0 & df$winner == 'team2'),]) # 155
nrow(df[(df$fd.spread < 0 & df$winner == 'team1') | (df$fd.spread > 0 & df$winner == 'team2'),]) # 171

# What would happen if you bet on FD using 538?
nrow(df[(df$X538.spread > df$fd.spread & df$fd.spread < df$actual) | (df$X538.spread <= df$fd.spread & df$fd.spread > df$actual),]) # Tie goes to home 123
nrow(df[(df$X538.spread >= df$fd.spread & df$fd.spread < df$actual) | (df$X538.spread < df$fd.spread & df$fd.spread > df$actual),]) # Tie goes to away 122

# Best/Worst Predictions by 538
nrow(df[df$X538.diff <= .5 & df$X538.diff >= -.5,]) # 11 within half a point
View(df[df$X538.diff <= .5 & df$X538.diff >= -.5,])

nrow(df[df$X538.diff < -31 | df$X538.diff > 31,]) # 11 off by more than 31 points
View(df[df$X538.diff < -31 | df$X538.diff > 31,])

# Teams Favored/Unfavored
hometeams <- df %>% select(week, team1, X538.spread, actual, X538.diff)
awayteams <- df %>% select(week, team2, X538.spread, actual, X538.diff)
awayteams[,3:5] <- awayteams[,3:5]*-1

colnames(hometeams)[colnames(hometeams)=="team1"] <- "team"
colnames(awayteams)[colnames(awayteams)=="team2"] <- "team"

teams <- rbind(hometeams, awayteams)

View(teams$X538.diff %>% aggregate(by=list(Category=teams$team), FUN=mean))

ggplot() + 
  geom_col(data = teams$X538.diff %>% aggregate(by=list(Category=teams$team), FUN=mean), 
           aes(x = reorder(Category, x), y = x)) + 
  xlab("Teams") + 
  ylab("Average Performance Relative to 538 Predictions") 

