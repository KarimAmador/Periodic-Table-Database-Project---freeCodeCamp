PSQL="psql -U freecodecamp -d periodic_table -t --no-align -c"

GET_ELEMENT() {
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1;")
  elif [[ ${#1} -le 2 ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol ILIKE '$1';")
  elif [[ $1 =~ ^[A-Za-z]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name ILIKE '$1';")
  fi

  if [[ -z $ELEMENT ]]
  then
    echo I could not find that element in the database.
    return
  fi
  
  IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< $ELEMENT

  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  GET_ELEMENT $1
fi
