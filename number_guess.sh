#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN () {

  # Generate random secret number
  SECRET_NUMBER=$((1 + $RANDOM % 1000))
  # echo $SECRET_NUMBER

  echo Enter your username:
  read USERNAME

  # Get games_played
  GAMES_PLAYED=$($PSQL "select games_played from users where username='$USERNAME';")

  # Check its existance
  if [[ -z $GAMES_PLAYED ]]
  then
    
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  
  else
    
    # Get best_game
    BEST_GAME=$($PSQL "select best_game from users where username='$USERNAME';")

    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  
  fi

  NUMBER_OF_GUESSES=0
  GAME "Guess the secret number between 1 and 1000:"

}

GAME () {

  echo $1
  read GUESS_NUMBER
  # echo $GUESS_NUMBER

  # Increment #guess
  ((NUMBER_OF_GUESSES++))

  # Check guessed number is number
  if [[ ! $GUESS_NUMBER =~ ^[0-9]+$ ]]
  then
   
    GAME "That is not an integer, guess again:"

  else


    if [[ $GUESS_NUMBER > $SECRET_NUMBER ]]
    then

      GAME "It's lower than that, guess again:"
    
    elif [[ $GUESS_NUMBER < $SECRET_NUMBER ]]
    then

      GAME "It's higher than that, guess again:"
    
    else
      
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

      # check if user exists
      if [[ -z $GAMES_PLAYED ]]
      then
        
        # insert user
        INSERT_RESULT=$($PSQL "insert into users(username, games_played, best_game) values ('$USERNAME', 1, $NUMBER_OF_GUESSES);")

      else
        
        # update user
        UPDATE_RESULT=$($PSQL "update users set games_played=$GAMES_PLAYED+1,
          best_game=$(($BEST_GAME<$NUMBER_OF_GUESSES ? $BEST_GAME : $NUMBER_OF_GUESSES));")
      
      fi
    
    fi

  fi

}

MAIN