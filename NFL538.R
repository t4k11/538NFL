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

# Create columns for favorite vs underdog, flipping sign if away team is favorite
df$X538.fav.spread <- ifelse(df$X538.spread <= 0, df$X538.spread, -df$X538.spread)
df$X538.fav.actual <- ifelse(df$X538.spread <= 0, df$actual, -df$actual)
df$X538.fav.diff   <- ifelse(df$X538.spread <= 0, df$X538.diff, -df$X538.diff)

df$fd.fav.spread <- ifelse(df$fd.spread <= 0, df$fd.spread, -df$fd.spread)
df$fd.fav.actual <- ifelse(df$fd.spread <= 0, df$actual, -df$actual)
df$fd.fav.diff   <- ifelse(df$fd.spread <= 0, df$fd.diff, -df$fd.diff)

# Does either have any bias?
mean(df[,"X538.diff"]) # -0.3867188, favors home team
mean(df[,"fd.diff"]) # 0.01171875, favors away team

mean(df[,"X538.fav.diff"]) #  -0.9257812, favors favorite
mean(df[,"fd.fav.diff"]) #  -0.0625, favors favorite

ggplot() + 
  geom_histogram(data=df, aes(x=X538.fav.diff, y=..density.., fill = '538'), binwidth = 2, alpha = .3) +
  geom_histogram(data=df, aes(x=fd.fav.diff, y=..density.., fill = 'Vegas'), binwidth = 2, alpha = .3) + 
  geom_line(data=df, aes(x=X538.fav.diff), color='red', stat="density", size=2, alpha=.5) +
  geom_line(data=df, aes(x=fd.fav.diff), color='blue', stat="density", size=2, alpha=.5) +
  scale_fill_manual(values = c('red', 'blue'), name="") +
  xlab("Difference Between Predicted Spread and Actual Result") + 
  ylab("Density") +
  ggtitle("Accuracy of Point Spreads over 2018 Season")

# Which selects the winner better?
df$winner <- ifelse(df$score1 > df$score2, 'team1', ifelse(df$score1<df$score2, 'team2', 'tie'))

nrow(df[(df$X538.spread < 0 & df$winner == 'team1') | (df$X538.spread > 0 & df$winner == 'team2'),]) # 155
nrow(df[(df$fd.spread < 0 & df$winner == 'team1') | (df$fd.spread > 0 & df$winner == 'team2'),]) # 171

nrow(df[df$X538.spread == 0,]) # 7 ties

# What would happen if you bet on FD using 538?
nrow(df[(df$X538.spread > df$fd.spread & df$fd.spread < df$actual) | (df$X538.spread < df$fd.spread & df$fd.spread > df$actual),]) # All correct 116
nrow(df[(df$X538.spread == df$fd.spread & df$fd.spread < df$actual) | (df$X538.spread == df$fd.spread & df$fd.spread > df$actual),]) # All ties 13
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
  ggtitle('Avg Performance Compared to 538 Predictions')
