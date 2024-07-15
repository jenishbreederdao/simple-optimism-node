#!/bin/sh
set -eou

# Start op-node.
exec op-node \
  --l1=$OP_NODE__RPC_ENDPOINT \
  --l2=$L2_RPC_WS_URL \
  --rpc.addr=0.0.0.0 \
  --rpc.port=$PORT__OP_NODE_RPC \
  --rollup.config=/chainconfig/rollup.json \
  --l2.jwt-secret=/shared/jwt.txt \
  --l1.trustrpc \
  --l1.rpckind=$OP_NODE__RPC_TYPE \
  --l1.beacon=$OP_NODE__L1_BEACON \
  --syncmode=execution-layer \
  $EXTENDED_ARG $@
