#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY;")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    if [[ -z $WIN_ID ]]
    then
      INSERT_WIN=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      # if [[ $INSERT_WIN = 'INSERT 0 1' ]]
      # then
      #   echo $WINNER
      # fi
    fi
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $OPP_ID ]]
    then
      INSERT_OPP=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      # if [[ $INSERT_OPP = 'INSERT 0 1' ]]
      # then
      #   echo $OPPONENT
      # fi
    fi 
  fi
done
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WIN_ID,$OPP_ID,$WIN_GOALS,$OPP_GOALS)")
    # if [[ $INSERT_GAMES = 'INSERT 0 1' ]]
    # then
    #   echo $YEAR $ROUND
    # fi
  fi
done