#!/bin/sh
set -eou

# Wait for the Bedrock flag for this network to be set.
# echo "Waiting for Bedrock node to initialize..."
# while [ ! -f /shared/initialized.txt ]; do
#   sleep 1
# done

# if [ -z "${IS_CUSTOM_CHAIN+x}" ]; then
#   if [ "$NETWORK_NAME" == "op-mainnet" ] || [ "$NETWORK_NAME" == "op-goerli" ]; then
#     export EXTENDED_ARG="${EXTENDED_ARG:-} --rollup.historicalrpc=${OP_GETH__HISTORICAL_RPC:-http://l2geth:8545} --op-network=$NETWORK_NAME"
#   else
#     export EXTENDED_ARG="${EXTENDED_ARG:-} --op-network=$NETWORK_NAME"
#   fi
# fi

# Init genesis if custom chain
if [ -n "${IS_CUSTOM_CHAIN+x}" ]; then
  geth init --datadir="$BEDROCK_DATADIR" /chainconfig/genesis.json
fi

# Determine syncmode based on NODE_TYPE
if [ -z "${OP_GETH__SYNCMODE+x}" ]; then
  if [ "$NODE_TYPE" = "full" ]; then
    export OP_GETH__SYNCMODE="snap"
  else
    export OP_GETH__SYNCMODE="full"
  fi
fi

# Start op-geth.
exec geth \
  --datadir="$BEDROCK_DATADIR" \
  --http \
  --http.corsdomain="*" \
  --http.vhosts="*" \
  --http.addr=0.0.0.0 \
  --http.port=$PORT__OP_GETH_HTTP \
  --http.api=web3,debug,eth,txpool,net,engine \
  --ws \
  --ws.addr=0.0.0.0 \
  --ws.port=$PORT__OP_GETH_WS \
  --ws.origins="*" \
  --ws.api=debug,eth,txpool,net,engine,web3 \
  --syncmode="$OP_GETH__SYNCMODE" \
  --gcmode="$NODE_TYPE" \
  --authrpc.vhosts="*" \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port=$PORT__OP_GETH_AUTH_RPC \
  --authrpc.jwtsecret=/chainconfig/jwt.txt \
  --rollup.sequencerhttp="$BEDROCK_SEQUENCER_HTTP" \
  --rollup.disabletxpoolgossip=true \
  --port="${PORT__OP_GETH_P2P:-39393}" \
  --discovery.port="${PORT__OP_GETH_P2P:-39393}" \
  --db.engine=pebble \
  $EXTENDED_ARG_OP_GETH $@

