#!/bin/bash

mainnet_url="https://api.telosunlimited.io/"

#gets the list
cleos --url $mainnet_url system listproducers -l 150 | grep -v "EOS1111111111111111111111111111111114T1Anm" | head -n -1| awk '{if(NR>1)print $1}' | sort > bplist.txt

testnet_url="http://api.testnet.telosunlimited.io/"

input="bplist.txt"
while IFS= read -r bp
do
        if [[ $(cleos --url $testnet_url system listproducers -l 200 | grep $bp | grep -v "EOS1111111111111111111111111111111114T1Anm") ]]; then
          echo "$bp OK"
        else
          echo "$bp Not on testnet or kicked from schedule"
        fi
done < "$input"
