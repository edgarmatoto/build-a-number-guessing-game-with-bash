#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

# get username
echo -e "\nEnter your username: "
read USERNAME
USER=$($PSQL "SELECT * FROM users WHERE username='$USERNAME'")

# if new user
if [[ -z $USER ]]
then
  # save user to database
  INSERT_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."

# if user exist
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")

  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi


# get random number
RANDOM_NUM=$((1 + $RANDOM % 1000))

# input user guess
echo -e "\nGuess the secret number between 1 and 1000: "

NUM_OF_GUESS=0

while [[ $GUESS != $RANDOM_NUM ]]
do
  read GUESS
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    if [[ $GUESS > $RANDOM_NUM ]]
    then
      echo "It's lower than that, guess again:"
      
    elif [[ $GUESS < $RANDOM_NUM ]]
    then
      echo "It's higher than that, guess again:"
    fi

  else
    echo "That is not an integer, guess again: "
  fi

  NUM_OF_GUESS=$((1 + $NUM_OF_GUESS))
done

echo -e "\nYou guessed it in $NUM_OF_GUESS tries. The secret number was $RANDOM_NUM. Nice job!"

# save user info
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")

NEW_GAMES_PLAYED=$((1 + $GAMES_PLAYED))


if [[ $NUM_OF_GUESS < $BEST_GAME ]]
then
  BEST_GAME=$NUM_OF_GUESS
fi

UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played=$NEW_GAMES_PLAYED WHERE username='$USERNAME'")
UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game=$BEST_GAME WHERE username='$USERNAME'")
