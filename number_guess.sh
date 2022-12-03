#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate random secret number
SECRET_NUMBER=$((1 + $RANDOM % 10))
echo $SECRET
