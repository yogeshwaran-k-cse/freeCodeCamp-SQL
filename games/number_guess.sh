#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUM=$(( (RANDOM % 1000) +1 ))
echo -e "\nEnter your username:"
read USERNAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
if [[ $USER_ID ]]
then
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = $USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(total_guess) FROM games WHERE user_id = $USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
  
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  if [[ $INSERT_USER = 'INSERT 0 1' ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  fi
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

fi

echo -e "\nGuess the secret number between 1 and 1000:"
read INPUT
COUNT=0
GUESS() {
  if [[ $1 ]]
  then
    echo $1
    read INPUT
  fi

  while [[ ! $INPUT =~ ^[0-9]+$ ]]
  do
    echo That is not an integer, guess again:
    read INPUT
  done

  (( COUNT++ ))
  if (( $INPUT == $RANDOM_NUM ))
  then
    INSERT_POINT=$($PSQL "INSERT INTO games(user_id,total_guess) VALUES($USER_ID,$COUNT)")
    if [[ $INSERT_POINT = 'INSERT 0 1' ]]
    then
      echo "You guessed it in $COUNT tries. The secret number was $RANDOM_NUM. Nice job!"
    fi

  else
    if (( $INPUT > $RANDOM_NUM ))
    then
      GUESS "It's lower than that, guess again:" 
    else
      GUESS "It's higher than that, guess again:"
    fi
  fi
}
GUESS