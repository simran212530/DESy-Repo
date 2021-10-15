export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute1.example.com/peers/peer0.institute1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute2.example.com/peers/peer0.institute2.example.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/institute3.example.com/peers/peer0.institute3.example.com/tls/ca.crt
export PEER0_MANAGERAL_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/manageral.example.com/peers/peer0.manageral.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collection_config_desy.json

export CHANNEL_NAME=btechcse

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

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./artifacts/src/github.com/DESy
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup


CHANNEL_NAME="btechcse"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./artifacts/src/github.com/DESy"
CC_NAME="chaincode_student"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0Manageral
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.manageral ===================== "
}
# packageChaincode

# packageChaincode

installChaincode() {
    setGlobalsForPeer0Manageral
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.manageral ===================== "

    setGlobalsForPeer1Manageral
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.manageral ===================== "

    setGlobalsForPeer0Org1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org1 ===================== "

    setGlobalsForPeer1Org1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.org1 ===================== "

    setGlobalsForPeer0Org2
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org2 ===================== "

    setGlobalsForPeer1Org2
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.org2 ===================== "

    setGlobalsForPeer0Org3
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org3 ===================== "

    setGlobalsForPeer1Org3
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer1.org3 ===================== "
}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0Manageral
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.manageral on channel ===================== "
}

# queryInstalled


approveForMyManageral() {
    setGlobalsForPeer0Manageral
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from Manageral ===================== "

}


checkCommitReadyness() {
    setGlobalsForPeer0Manageral
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from Manageral ===================== "
}

# checkCommitReadyness

approveForMyOrg1() {
    setGlobalsForPeer0Org1
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from Institute 1 ===================== "

}

checkCommitReadyness() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from Institute 1 ===================== "
}

# checkCommitReadyness

approveForMyOrg2() {
    setGlobalsForPeer0Org2

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from Institute 2 ===================== "
}
# approveForMyOrg2

checkCommitReadyness() {
    setGlobalsForPeer0Org2
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from Institute 2 ===================== "
}

# checkCommitReadyness

approveForMyOrg3() {
    setGlobalsForPeer0Org3

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from Institute 3 ===================== "
}

# approveForMyOrg3

checkCommitReadyness() {
    setGlobalsForPeer0Org3
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from Institute 3 ===================== "
}

# checkCommitReadyness



commitChaincodeDefination() {
    setGlobalsForPeer0Manageral
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required

}

# commitChaincodeDefination


queryCommitted() {
    setGlobalsForPeer0Manageral
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0Manageral
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
        --isInit -c '{"Args":[]}'

}

# chaincodeInvokeInit

chaincodeDummyInvoke() {
    
    setGlobalsForPeer0Manageral

    # Create Criteria
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
        -c '{"function": "createAdmissionCriteria","Args":["1111","IIIT Delhi","Btech CSE","100","18","500","90","Anyone Sports"]}'
    
    # # Adding Dummy Prospective Student
   
    # setGlobalsForPeer0Org1
    # export student=$(echo -n "{\"Name\":\"Aditya\", \"DOB\":\"01-02-03\", \"Gender\":\"Male\", \"Email\":\"xyz@abc.com\", \"Mob_No\":\"9876543210\", \"Aadhar_no\":\"987698769876\", \"Username\":\"mayank\", \"Password\":\"Aditya\", \"Address\":\"42, Paschim Vihar, Delhi\"}" | base64 | tr -d \\n)

        
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
    #     -c '{"function": "prospectiveStudent", "Args":[]}' \
    #     --transient "{\"ProspectiveStudent\":\"$student\"}"

    
    
    # Adding Dummy Application
    # setGlobalsForPeer0Org1
    # export student=$(echo -n "{\"ApplicationID\":\"1\", \"Name\":\"Aditya\", \"DOB\":\"0\", \"Gender\":\"M\", \"Email\":\"x\", \"Mob_No\":\"9876543210\", \"Aadhar_no\":\"0\", \"Marksheet_10\":\"9876543210\", \"Marksheet_12\":\"Advregareitya\", \"EntranceResult\":\"vreagerb\", \"Achievements\":\"vreavteb\", \"Username\":\"mayank\", \"Password\":\"Aditya\", \"Status\":\"Unverified\"}" | base64 | tr -d \\n)

    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
    #     -c '{"function": "createApplication", "Args":[]}' \
    #     --transient "{\"Application\":\"$student\"}"


    # # # Update Dummy Application
    # setGlobalsForPeer0Org1
    # # export student1=$(echo -n "{\"ApplicationID\":\"1\"}" | base64 | tr -d \\n)

    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
    #     -c '{"function": "updateApplication1", "Args":["1"]}' \

}

chaincodeInvoke() {
    
    # setGlobalsForPeer0Org1
    setGlobalsForPeer0Manageral

    # # Create Criteria
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME}  \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
    #     --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
    #     -c '{"function": "createAdmissionCriteria","Args":["1111","IIIT Delhi","Btech CSE","100","18","500","90","Anyone Sports"]}'
    
    # sleep 3
    # Create Criteria
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
        -c '{"function": "createCourse","Args":[ "IIIT Delhi","Btech CSE","60","16","16","4","Dr.XYZ", "4", "IDSJN"]}'
    
    
    # # Create Criteria
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME}  \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
    #     --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
    #     -c '{"function": "updateAdmissionCriteria","Args":["1111","MaxSeatCount","120"]}'
    


    # Adding Dummy Prospective Student
   
    # setGlobalsForPeer0Manageral
    # export student=$(echo -n "{\"Name\":\"Mayank\", \"DOB\":\"01-02-03\", \"Gender\":\"Male\", \"Email\":\"xyz@abc.com\", \"Mob_No\":\"9876543210\", \"Aadhar_no\":\"987698769876\", \"Username\":\"m3\", \"Password\":\"Aditya\", \"Address\":\"42, Paschim Vihar, Delhi\"}" | base64 | tr -d \\n)

        
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
    #     -c '{"function": "prospectiveStudent", "Args":[]}' \
    #     --transient "{\"ProspectiveStudent\":\"$student\"}"


    # setGlobalsForPeer0Org1
    # # setGlobalsForPeer0Manageral
    # export student=$(echo -n "{\"ApplicationID\":\"1\", \"Name\":\"Aditya\", \"DOB\":\"0\", \"Gender\":\"M\", \"Email\":\"x\", \"Mob_No\":\"9876543210\", \"Aadhar_no\":\"0\", \"Marksheet_10\":\"9876543210\", \"Marksheet_12\":\"Advregareitya\", \"EntranceResult\":\"vreagerb\", \"Achievements\":\"vreavteb\", \"Username\":\"Aditya\", \"Password\":\"Aditya\", \"Status\":\"Unverified\"}" | base64 | tr -d \\n)

    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MANAGERAL_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
    #     -c '{"function": "createApplication", "Args":[]}' \
    #     --transient "{\"Application\":\"$student\"}"
}

# chaincodeInvoke

chaincodeQuery() {
    # setGlobalsForPeer0Org2
    # # Query Criteria by Institute Id
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCriteria","Args":["1111"]}'

    setGlobalsForPeer0Manageral
    # Query Prospective Student by Institute Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCourse","Args":["Btech CSE6374"]}'
}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
presetup

packageChaincode
installChaincode
queryInstalled
approveForMyManageral
checkCommitReadyness
approveForMyOrg1
checkCommitReadyness
approveForMyOrg2
checkCommitReadyness
approveForMyOrg3
checkCommitReadyness
sleep 3
commitChaincodeDefination
queryCommitted
sleep 3
chaincodeInvokeInit
# sleep 5
# chaincodeDummyInvoke
# chaincodeInvoke
# sleep 3
# chaincodeQuery
