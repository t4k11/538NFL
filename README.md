# Analyzing 538's NFL Predictions Over the 2018 Season

538 creates its NFL predictions using an ["Elo" rating system](https://fivethirtyeight.com/methodology/how-our-nfl-predictions-work/), similar to the one used to rank the skill levels of chess players.

Each team is assigned an Elo score, this number is then used to compare teams, calculate win probabilities, and project point spreads of each game. Their full methodology is explained [here](https://fivethirtyeight.com/methodology/how-our-nfl-predictions-work/), but the important take away is that each team's rankings are determined using **only** home field advantage and performance in previous games. Injuries, roster moves, and other important factors are not accounted for.

This is a big disadvantage in comparison to the spreads set by Vegas oddsmakers who most definitely take those things into account. Despite this, the predictions tend not to be too far off, and 538's win probabilities are still held in high regard by fans, and often cited on social media as well as in sports publications.

---

#### So how accurate were the predictions after all?

Model | RMSE
----|----
**538** | 13.57
**Vegas** | 13.10
**Predict Only Ties** | 14.50


The accuracy of the predictions fall short of the Vegas lines, as expected, but not by much! The RMSE (a measure of error, with lower values meaning less error) of 538's predictions this past season was **13.57**, and Vegas's was **13.10**. For comparison, if you had a naive model that predicted every single game to end in a tie, the RMSE would have been **14.50**.

---

#### Was the model biased in any way?

Model | Avg Pt Difference in terms of favorite/underdog|
----|----
**538** | -0.93
**Vegas** | -0.06

 Model | Avg Pt Difference in terms of home/away
----|----
**538** | -0.39
**Vegas** | 0.01

538's model includes constants such as a home-field advantage adjustment and *k-factor*, which is a measure of how much a game's outcome should adjust the Elo rating of a specific team. Undoubtedly a lot of research has been put into setting these constants in a way that  accurately reflects reality, but it is impossible to be perfect, and if they are off we might expect to see biases emerge in the spreads.

This year, 538's model overestimated the performance of the favorite team on average by **.93**, almost one point, whereas Vegas tended to overestimate the favorite by only **.06**.

538 overestimated the home team by **.39** points whereas Vegas saw very little bias in terms of home field and favored the away team by only **.01**!

The whole distribution of prediction accuracy is visualized here: 

#### [Accuracy of Point Spreads over 2018 Season](https://i.imgur.com/EFSoxlK.jpg)

Positive values mean that the favored team outperformed the spread, whereas negative values mean the favored team underperformed.

---

#### Who selected winners better?

Model | Winners Predicted Correctly
----|----
**538** | 158.5
**Vegas** | 171

Out of the 256 games played this season, 538 correctly favored the winning team 155 times. 

Their model also gave a 'PK' or 0 spread seven times. If we assume that someone using this model to make predictions just flips a coin whenver they get a 'PK', they would be expected to get the prediction right 50% or 3.5 times. 

So we can say that over the course of the season 538 predicted **158.5** correct winners. Compare this to Vegas who predicted the correct winner **171** times.

---

#### What were the best and worst predictions by 538?

11 games ended 31 points or more off from 538's spread. These were mainly big blowouts from the season, except notably the Panther's victory over the Saints where they were expected to be 13 point underdogs.

Home| | | Away | 538 Spread for Home Team
---|---|----|---- | ----
BAL	|47	|3	|BUF | -4.0
DET	|17	|48	|NYJ | -6.0
CHI	|48	|10	|TB | -1.0
DAL	|40	|7	|JAX | -1.0
ARI	|10	|45	|DEN | -3.0
IND	|37	|5	|BUF | +0.5
CIN	|14	|51	|NO | +4.0
NYJ	|10	|41	|BUF | -3.5
NO	|48	|7	|PHI | -7.5
GB	|0	|31	|DET | -4.5
NO	|14	|33	|CAR | -13.0

Conversely, 11 games ended within half a point of 538's spread.

Home| | | Away | 538 Spread for Home Team
---|---|----|---- | ----
MIN	|24	|16	|SF | -8.0
DEN	|23	|27	|KC | +4.5
BUF	|13	|12	|TEN | -0.5
ATL	|34	|29	|TB | -5.0
CIN	|37	|34	|TB | -3.5
LAR	|36	|31	|SEA | -5.5
CHI	|24	|17	|GB | -7.5
BAL	|20	|12	|TB | -8.0
DAL	|27	|20	|TB | -7.5
NE	|24	|12	|BUF | -11.5
SF	|9	|14	|CHI | +5.5

---

#### Which teams were favored or unfavored more than others?

As stated earlier, 538's model does not take into account injuries or roster changes. So teams like the Bills that performed well last season were projected to continue that streak into this year and ended up scoring almost 5 less point per game than the model projected. While teams like the Bears that did poorly last year were placed very low in the preseason power rankings and actually ended up scoring 7.5 points per game *more* than projected.

Overrated Teams | Avg Performance Relative to Prediction
---|---
ARI |-8.25
OAK |-5.88
MIA| -5.78
BUF |-4.91

Underrated Teams | Avg Performance Relative to Prediction
---|---
CHI |+7.50
IND |+7.31
HOU |+6.09
CLE |+5.31

### [Average Performance of Every Team Compared to 538 Projections](https://i.imgur.com/ZxqPwLc.jpg)

---

### But the most important question is...

What would happen if you bet on the Vegas lines using 538 as a guide? If 538 managed to beat the Vegas oddsmakers for a season, someone using their spreads could stand to make a lot of money. However, at least in this season, that is not how it played out.

538 beat the Vegas spreads 116 times this season, and set spreads exactly equal to Vegas 13 times. If someone betting on those games were to flip a coin when the spreads were set equal, they would be expected to correctly predict 6.5 of them. So we can say that someone using 538 to place bets would have won **122.5** out of 256 bets in the season, less than half. 

---

So while 538's model is certainly no oddsbreaking magic bullet, it does a pretty good job despite being completely blind to important factors like team roster.
