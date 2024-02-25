if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM \
  elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) \
  WHERE atomic_number=$1;")
  if [[ -z $ELEMENT_INFO ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM \
    elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)\
    WHERE symbol='$1';")
    if [[ -z $ELEMENT_INFO ]]
    then
      ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM \
      elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) \
      WHERE name='$1';")
    fi
  fi
  if [[ -n $ELEMENT_INFO ]]
  then
    echo "$ELEMENT_INFO" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELT BOIL
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi
