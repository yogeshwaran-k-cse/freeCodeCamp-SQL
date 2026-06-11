#! /bin/bash

PSQL=$(echo "psql -X --username=freecodecamp --dbname=salon --no-align -t --tuples-only -c")

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

BOOK_APPOINTMENT() {
    SERVICE_ID_SELECTED=$1
    SERVICE_NAME=$2
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    IS_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $IS_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      IS_NAME=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      if [[ $IS_NAME = 'INSERT 0 1' ]]
      then
        echo $CUSTOMER_PHONE $CUSTOMER_NAME
      fi
    fi
    IS_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE_NAME, $IS_NAME?"
    read SERVICE_TIME
    IS_TIME=$($PSQL "INSERT INTO appointments(time) VALUES('$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $IS_NAME."
  }

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICE=$($PSQL "SELECT service_id,name FROM services")
  echo "$SERVICE" | while IFS='|' read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  SERVICE_SELECT_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_SELECT_NAME ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    BOOK_APPOINTMENT "$SERVICE_ID_SELECTED" "$SERVICE_SELECT_NAME"
  fi

  
}
MAIN_MENU