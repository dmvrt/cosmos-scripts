#!/bin/bash

SLEEPING_TIME=1200
MIN_BALANCE=500000
LOG_PATH="${HOME}/comission.log"
. ~/.bash_profile

while :
do
  echo ${EVMOS_PASS} | evmosd tx distribution withdraw-rewards --commission ${EVMOS_VALOPER} --from=${EVMOS_ADDRESS} --chain-id=${EVMOS_CHAIN} -y > /dev/null 2>&1
  balance_before=$(evmosd query bank balances $EVMOS_ADDRESS --chain-id=${EVMOS_CHAIN} -o json | jq -r '.balances[0].amount')
  amount_to_delegate=$((balance_before - MIN_BALANCE))
  echo "$(date) Balance before: ${balance_before} to delegate: ${amount_to_delegate}"
  sleep 5

  if [[ ${amount_to_delegate} -gt 0 ]]
  then
    echo "$(date) Balance before: ${balance_before} to delegate: ${amount_to_delegate}" >> "${LOG_PATH}" 2>&1
    echo ${EVMOS_PASS} | evmosd tx staking delegate ${EVMOS_VALOPER} ${amount_to_delegate}aevmos --from=${EVMOS_ADDRESS} --chain-id=${EVMOS_CHAIN} --gas 200000 -y >> "${LOG_PATH}" 2>&1
    balance_after=$(evmosd query bank balances ${EVMOS_ADDRESS} --chain-id=${EVMOS_CHAIN} -o json | jq -r '.balances[0].amount')
    sleep 5
    echo "$(date) Balance after:  ${balance_after}"
    echo "Current Voting Power: $(evmosd status 2>&1 | jq -r '.ValidatorInfo.VotingPower')"
  else
    echo "TOO LITTLE BALANCE FOR DELEGATION"
    sleep 5
  fi
  sleep ${SLEEPING_TIME}
done
