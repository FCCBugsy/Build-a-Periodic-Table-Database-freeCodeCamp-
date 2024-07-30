#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INFO() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."

  else

    # regex to see if the first argument is an int or not
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      SEARCH_COLUMN="atomic_number=$1"
    else
      SEARCH_COLUMN="symbol='$1' OR name='$1'"
    fi

    GET_DATA=$($PSQL "SELECT * FROM elements WHERE $SEARCH_COLUMN")
    if [[ -z $GET_DATA ]]
    then
      echo "I could not find that element in the database."

    else
      #here, 'xargs' will remove any whitespaces found in the selected values in the db
      ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE $SEARCH_COLUMN")
      ELEMENT_NAME=$(echo $ELEMENT_NAME | xargs)

      ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE $SEARCH_COLUMN")
      ELEMENT_ID=$(echo $ELEMENT_ID | xargs)

      ELEMENT_SYM=$($PSQL "SELECT symbol FROM elements WHERE $SEARCH_COLUMN")
      ELEMENT_SYM=$(echo $ELEMENT_SYM | xargs)

      ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = (SELECT type_id FROM properties WHERE atomic_number='$ELEMENT_ID')")
      ELEMENT_TYPE=$(echo $ELEMENT_TYPE | xargs)

      ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ELEMENT_ID'")
      ELEMENT_MASS=$(echo $ELEMENT_MASS | xargs)

      ELEMENT_MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ELEMENT_ID'")
      ELEMENT_MELT=$(echo $ELEMENT_MELT | xargs)

      ELEMENT_BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ELEMENT_ID'")
      ELEMENT_BOIL=$(echo $ELEMENT_BOIL | xargs)

      echo "The element with atomic number $ELEMENT_ID is $ELEMENT_NAME ($ELEMENT_SYM). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELT celsius and a boiling point of $ELEMENT_BOIL celsius."
    fi
  fi
}

INFO $1