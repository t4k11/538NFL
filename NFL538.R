library(dplyr)
library(ggplot2)

df <- read.csv('NFL538.csv')

df$actual <- df$score2 - df$score1

# Which is more Accurate? RMSE
df$X538.diff <- df$X538.spread - df$actual
df$fd.diff <- df$fd.spread - df$actual

sqrt(mean(df[,"X538.diff"]^2)) # 13.57337
sqrt(mean(df[,"fd.diff"]^2)) # 13.10273
sqrt(mean(df[,"actual"]^2)) # 14.50431

ggplot() + 
  geom_histogram(data=df, aes(x=X538.diff, y=..density.., fill = '538'), binwidth = 2, alpha = .3) +
  geom_histogram(data=df, aes(x=fd.diff, y=..density.., fill = 'Vegas'), binwidth = 2, alpha = .3) + 
  geom_line(data=df, aes(x=X538.diff), color='red', stat="density", size=2, alpha=.5) +
  geom_line(data=df, aes(x=fd.diff), color='blue', stat="density", size=2, alpha=.5) +
  scale_fill_manual(values = c('red', 'blue'), name="") +
  xlab("Difference Between Predicted Spread and Actual Spread") + 
  ylab("Density") +
  ggtitle("2018 Season")

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
           aes(x = reorder(Category, x), y = x), fill = 'skyblue') + 
  xlab("") + 
  ylab("Difference from Predicted Spread") +
  ggtitle('Avg Performance Compared to 538 Predictions - 2018')
