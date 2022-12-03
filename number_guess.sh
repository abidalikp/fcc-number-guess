#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate random secret number
SECRET_NUMBER=$((1 + $RANDOM % 10))
echo $SECRET

echo Enter your username:
read USERNAME

# Get best_game
BEST_GAME=$($PSQL "select best_game from users where username='$USERNAME';")

# Check its existance
if [[ -z $BEST_GAME ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  echo "Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses."
fi
