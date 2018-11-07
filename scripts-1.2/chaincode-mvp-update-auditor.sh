#!/bin/bash
usage() { echo "Usage: $0 [-c <channelname>] -n [chaincodename]" 1>&2; exit 1; }
while getopts ":c:n:v:" o; do
    case "${o}" in
        c)
            c=${OPTARG}
            ;;
        n)
            n=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ -z "${c}" ] || [ -z "${n}" ] ] ; then
    usage
fi

# init config
source $(dirname "$0")/env.sh

PEER_ORGS=("org1" "org2" "org3" "org4" "org5")
NUM_PEERS=5
CHANNEL_NAME=${c}
CHANNEL_TX_FILE=$DATA/$CHANNEL_NAME.tx

QUERY_TIMEOUT=30

$GOPATH/src/github.com/hyperledger/fabric/.build/bin/peer chaincode list --installed -C $CHANNEL_NAME

# instantiate chaincode

ORG=org1
initPeerVars ${ORG} 0
echo $ORDERER_CONN_ARGS

$GOPATH/src/github.com/hyperledger/fabric/.build/bin/peer chaincode invoke -C $CHANNEL_NAME -n ${n} -c '{"Args":["updateAuditor", "{\"objectType\":\"auditor\",\"id\":\"Auditor_1\",\"name\":\"Auditor 2\",\"content\":\"\"}"]}' $ORDERER_CONN_ARGS