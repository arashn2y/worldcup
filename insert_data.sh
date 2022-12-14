#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE=$($PSQL "TRUNCATE teams, games")
if [[ $TRUNCATE == "TRUNCATE TABLE" ]]
then
  echo "Truncate tables -> teams, games"
fi

#INSERT TEAMS NAME INTO teams TABLE
cat games.csv |while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #FIND TEAM ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    #IF TEAM NOT EXIST
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
  fi
done

#INSERT RESULTS INTO games TABLE
cat games.csv |while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #FIND TEAM ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    #INSERT RESULTS TO TABLE
    INSERT_GAMES_RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
