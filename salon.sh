#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t  -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My salon, how can I help you?"
#echo -e "\n1) cut\n2) shave\n3) style\n4) trim\n5) color"
MAIN_MENU(){
  
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  INDEX=$($PSQL "SELECT * FROM services")
  echo "$INDEX" | while read SERVICE_ID bar NAME
  do
  echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED
  SERVE=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  if [[ -z $SERVE ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $PHONE ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      echo -e "\nWhat time would you like you cut, $CUSTOMER_NAME."
      read SERVICE_TIME
      NEW_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES('$SERVICE_ID_SELECTED','$NEW_CUSTOMER_ID','$SERVICE_TIME')")
      SERVICE_TO_GIVE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
      echo -e "\nI have put you down for a $SERVICE_TO_GIVE at $SERVICE_TIME, $CUSTOMER_NAME."
    else
      OLD_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
      OLD_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      echo -e "\nWhat time would you like you cut, $OLD_NAME."
      read SERVICE_TIME
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES('$SERVICE_ID_SELECTED','$OLD_ID','$SERVICE_TIME')")
      SERVICE_TO_GIVE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
      echo -e "\nI have put you down for a $SERVICE_TO_GIVE at $SERVICE_TIME, $OLD_NAME."    
    fi
  fi
}
MAIN_MENU