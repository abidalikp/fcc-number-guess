#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN () {

  # Generate random secret number
  SECRET_NUMBER=$((1 + $RANDOM % 10))
  # echo $SECRET_NUMBER

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

  GAME "Guess the secret number between 1 and 1000:"

}

GAME () {

  echo $1
  read GUESS_NUMBER

  if [[ $GUESS_NUMBER =~ "^[0-9]+$" ]]
  then

    if [[ $GUESS_NUMBER > $SECRET_NUMBER ]]
    then
      GAME "It's lower than that, guess again:"
    elif [[ $GUESS_NUMBER < $SECRET_NUMBER ]]
    then
      GAME "It's higher than that, guess again:"
    else
      echo "You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!"
    fi

  else
  
    GAME "That is not an integer, guess again:"

  fi

}

MAIN