#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  if [[ $YEAR != year ]]
  then
    #get team_id WINNER
    TEAM_ID_W=$($PSQL "select team_id from teams where name='$WINNER'")
    if [[ -z $TEAM_ID_W ]]
    then
      #insert team winner
      INSERT_TEAM_W_R=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_TEAM_W_R == 'INSERT 0 1' ]]
      then
        echo "Inserted into team, $WINNER"
      fi
      TEAM_ID_W=$($PSQL "select team_id from teams where name='$WINNER'")
    fi
    #get team_id OPPONENT
    TEAM_ID_O=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -z $TEAM_ID_O ]]
    then
      #insert team opponent
      INSERT_TEAM_O_R=$($($PSQL "insert into teams(name) values('$OPPONENT')"))
      if [[ $INSERT_TEAM_O_R == "INSERT 0 1" ]]
      then
        echo "Inserted into team, $OPPONENT"
      fi
      TEAM_ID_O=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi
    INSERT_GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    values($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_G, $OPPONENT_G) ")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo "Inserted into games, $ROUND $WINNER $OPPONENT"
    fi
  fi
done