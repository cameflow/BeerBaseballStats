# BeerBaseball stats app
iOS app developed in Swift using SwiftUI framework.

* App to save statistics when you play BeerBaseball
* Tool to help you track

[BeerBaseball Rules](https://en.wikipedia.org/wiki/Baseball_(drinking_game))

## Features
- Add new users to have a list of all the players
- Create two teams before starting the Game
- When you start a game there will be a coin flip to decide who starts
- Add a play each time something happens in the Game
- You can view the score to keep track of the Game
- List of rules of the game
- View historical stats by category for each player

## Validations
- Can't start the game until each time has at least one player
- When you select the attacking team you will only be able to select players from that team as batters
- The game tracks which bases have players so when you make a HIT or a Home Run the corresponding number of runs will be added to the score
- After 3 strikes you will get an out

## Available plays
- HIT (Select base)
- Home Run
- Strike (Can select Foul)
- Out (Select catcher)
- Steal base

## Stats Available
- Batting %
  - Number of Hits
  - Number of Home runs
  - Number of strikes
  - Number of fouls
  - Number of outs


- Bases %
  - Number of hits to first base
  - Number of hits to second base
  - Number of hits to third base


- Outs %
  - Number of outs by catch
  - Number of outs by strikes
  - Number of outs when stealing base


- Base steal %
  - Number of successful steals
  - Number of unsuccessful steals


- Base defends %
  - Number of successful defends
  - Number of unsuccessful defends


- Number of outs made


## Screenshots

### Create Users
![Create Users](screenshots/add_usr.PNG)

### View Users
![View Users](screenshots/users.PNG)

### View User
![User](screenshots/user.PNG)

### Create Teams
![Create Teams](screenshots/teams.PNG)

### Start Game
![Start Game](screenshots/start.PNG)

### Coin Flip
![Coin Flip](screenshots/coinflip.PNG)

### Score
![Score](screenshots/score.PNG)

### Add Plays
![Home Run](screenshots/play.PNG)
![Hit](screenshots/play2.PNG)
![Out](screenshots/play3.PNG)

### Rules
![Rules](screenshots/rules.PNG)
