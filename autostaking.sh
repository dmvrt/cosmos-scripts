#!/bin/bash

SLEEPING_TIME=3600
MIN_BALANCE=1000000
LOG_PATH="${HOME}/evmos_staking.log"
. ~/.bash_profile

while :
do
  echo ${EVMOS_PASS} | evmosd tx distribution withdraw-all-rewards --from=${EVMOS_WALLET} --chain-id=${EVMOS_CHAIN} --fees=5000aphoton -y > /dev/null 2>&1
  balance_before=$(evmosd query bank balances $EVMOS_ADDRESS --chain-id=${EVMOS_CHAIN} -o json | jq -r '.balances[0].amount')
  amount_to_delegate=$((balance_before - MIN_BALANCE))
  echo "$(date) Balance before: ${balance_before} to delegate: ${amount_to_delegate}"
  sleep 5

  if [[ ${amount_to_delegate} -gt 0 ]]
  then
    echo "$(date) Balance before: ${balance_before} to delegate: ${amount_to_delegate}" >> "${LOG_PATH}" 2>&1 
    echo ${EVMOS_PASS} | evmosd tx staking delegate ${EVMOS_VALOPER} ${amount_to_delegate}aphoton --from=${EVMOS_WALLET} --chain-id=${EVMOS_CHAIN} --gas=auto --fees=5000aphoton -y >> "${LOG_PATH}" 2>&1
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
