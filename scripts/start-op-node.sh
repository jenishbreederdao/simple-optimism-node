#!/bin/sh
set -eou

# Start op-node.
exec op-node \
  --l1=$OP_NODE__RPC_ENDPOINT \
  --l2=$OP_GETH_AUTH_RPC_URL \
  --rpc.addr=0.0.0.0 \
  --rpc.port=$PORT__OP_NODE_HTTP \
  --rollup.config=/chainconfig/rollup.json \
  --l2.jwt-secret=/chainconfig/jwt.txt \
  --l1.trustrpc \
  --l1.rpckind=$OP_NODE__RPC_TYPE \
  --p2p.listen.ip=0.0.0.0 \
  --p2p.listen.tcp=$PORT__OP_NODE_P2P \
  --l1.beacon=$OP_NODE__L1_BEACON \
  --syncmode=execution-layer \
  $EXTENDED_ARG_OP_NODE $@
