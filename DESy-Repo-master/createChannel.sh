export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/ca.crt
export PEER0_MANAGERAL_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME1=btechcse
export CHANNEL_NAME2=btechece

setGlobalsForOrderer(){
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp
}

setGlobalsForPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Institute1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute1.example.com/users/Admin@institute1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Org1(){
    export CORE_PEER_LOCALMSPID="Institute1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute1.example.com/users/Admin@institute1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0Org2(){
    export CORE_PEER_LOCALMSPID="Institute2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute2.example.com/users/Admin@institute2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer1Org2(){
    export CORE_PEER_LOCALMSPID="Institute2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute2.example.com/users/Admin@institute2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    
}

setGlobalsForPeer0Org3(){
    export CORE_PEER_LOCALMSPID="Institute3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute3.example.com/users/Admin@institute3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
    
}

setGlobalsForPeer1Org3(){
    export CORE_PEER_LOCALMSPID="Institute3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute3.example.com/users/Admin@institute3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:12051
}

setGlobalsForPeer0Manageral(){
    export CORE_PEER_LOCALMSPID="ManageralMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MANAGERAL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/manageral.example.com/users/Admin@manageral.example.com/msp
    export CORE_PEER_ADDRESS=localhost:13051
}

setGlobalsForPeer1Manageral(){
    export CORE_PEER_LOCALMSPID="ManageralMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MANAGERAL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/manageral.example.com/users/Admin@manageral.example.com/msp
    export CORE_PEER_ADDRESS=localhost:14051
}

createChannel1(){
    # rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Org1
    peer channel create -o localhost:7050 -c $CHANNEL_NAME1 \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./artifacts/channel/${CHANNEL_NAME1}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME1}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

createChannel2(){
    # rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Org1
    peer channel create -o localhost:7050 -c $CHANNEL_NAME2 \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./artifacts/channel/${CHANNEL_NAME2}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME2}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

removeOldCrypto(){
    rm -rf ./api-1.4/crypto/*
    rm -rf ./api-1.4/fabric-client-kv-org1/*
    rm -rf ./api-2.0/org1-wallet/*
    rm -rf ./api-2.0/org2-wallet/*
}


joinChannel(){
    ###Joining  BTech_CSE Channel
	
	setGlobalsForPeer0Org1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME1.block --tls --cafile $ORDERER_CA
    
    setGlobalsForPeer1Org1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME1.block --tls --cafile $ORDERER_CA
    
    setGlobalsForPeer0Org2
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME1.block --tls --cafile $ORDERER_CA
    
    setGlobalsForPeer1Org2
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME1.block --tls --cafile $ORDERER_CA
	
	setGlobalsForPeer0Org3
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME1.block --tls --cafile $ORDERER_CA
    
    setGlobalsForPeer1Org3
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME1.block --tls --cafile $ORDERER_CA
	
	setGlobalsForPeer0Manageral
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME1.block --tls --cafile $ORDERER_CA

    setGlobalsForPeer1Manageral
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME1.block --tls --cafile $ORDERER_CA
	
	##Joining  BTech_ECE Channel
	
	setGlobalsForPeer0Org1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME2.block --tls --cafile $ORDERER_CA
    
    setGlobalsForPeer1Org1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME2.block --tls --cafile $ORDERER_CA
    
    setGlobalsForPeer0Org2
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME2.block --tls --cafile $ORDERER_CA
    
    setGlobalsForPeer1Org2
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME2.block --tls --cafile $ORDERER_CA
	
	setGlobalsForPeer0Org3
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME2.block --tls --cafile $ORDERER_CA
    
    setGlobalsForPeer1Org3
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME2.block --tls --cafile $ORDERER_CA
	
	setGlobalsForPeer0Manageral
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME2.block --tls --cafile $ORDERER_CA

    setGlobalsForPeer1Manageral
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME2.block --tls --cafile $ORDERER_CA
}

updateAnchorPeers(){
    
	##Anchor Peers for Channel 1
	setGlobalsForPeer0Org1
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME1 -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_${CHANNEL_NAME1}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0Org2
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME1 -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_${CHANNEL_NAME1}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
	
	setGlobalsForPeer0Org3
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME1 -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_${CHANNEL_NAME1}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0Manageral
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME1 -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_${CHANNEL_NAME1}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
	
	
	#Anchor Peers for Channel 2
	setGlobalsForPeer0Org1
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME2 -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_${CHANNEL_NAME2}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0Org2
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME2 -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_${CHANNEL_NAME2}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
	
	setGlobalsForPeer0Org3
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME2 -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_${CHANNEL_NAME2}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0Manageral
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME2 -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_${CHANNEL_NAME2}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

# channelList(){
#     setGlobalsForPeer0Org1
#     peer channel list
    
#     setGlobalsForPeer0Org2
#     peer channel list
    
#     setGlobalsForPeer0Org3
#     peer channel list
    
#     setGlobalsForPeer0Manageral
#     peer channel list
# }


# removeOldCrypto
createChannel1
createChannel2
joinChannel
updateAnchorPeers
# channelList