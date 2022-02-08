#!/bin/bash

mainnet_url="https://mainnet.telos.net"

#gets the list
cleos --url $mainnet_url system listproducers -l 150 | grep -v "EOS1111111111111111111111111111111114T1Anm" | head -n -1| awk '{if(NR>1)print $1}' | sort > bplist.txt

testnet_url="https://testnet.telos.net"

input="bplist.txt"
while IFS= read -r bp
do
        last_produced=`curl -s $testnet_url'/v2/history/get_actions?producer='$bp'&limit=1' | jq -r '.actions[].timestamp'`
        if [[ $(cleos --url $testnet_url system listproducers -l 200 | grep $bp | grep -v "EOS1111111111111111111111111111111114T1Anm") ]]; then
          echo "$bp OK - Last produced block on testnet "$last_produced
        else
          echo "$bp Not on testnet or kicked from schedule - Last produced block on testnet "$last_produced
        fi
done < "$input"
