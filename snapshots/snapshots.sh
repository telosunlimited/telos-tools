#!/bin/bash

DST="/var/www/snapshots"
NODEOS_SNAPSHOT_DIR="/srv/tn-telosunlimit/snapshots/"

#Take the snapshot and get the block id

block_id=`curl -X POST http://127.0.0.1:8888/v1/producer/create_snapshot | jq -r '.head_block_id'`

echo "Snapshot done block id: ${block_id}"

#get block number and date

NOW=$(date +"%Y%m%d")

block_num=`cleos get block $block_id | jq ".block_num"`

#compress and move the file to the directory

tar -cvzf ${DST}/telos-mainet-${NOW}-blk-${block_num}.tar.gz ${NODEOS_SNAPSHOT_DIR}snapshot-${block_id}.bin

#remove original bin file

rm ${NODEOS_SNAPSHOT_DIR}snapshot-${block_id}.bin
