
chmod -R 0755 ./crypto-config
# Delete existing artifacts
rm -rf ./crypto-config
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/

# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "desychannel"
CHANNEL_NAME1="btechcse"
CHANNEL_NAME2="btechece"

echo $CHANNEL_NAME1
echo $CHANNEL_NAME2


# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile $CHANNEL_NAME1 -configPath . -outputCreateChannelTx ./${CHANNEL_NAME1}.tx -channelID $CHANNEL_NAME1

#echo "#######    Generating anchor peer update for Institute1MSP  ##########"
configtxgen -profile $CHANNEL_NAME1 -configPath . -outputAnchorPeersUpdate ./Institute1MSPanchors_${CHANNEL_NAME1}.tx -channelID $CHANNEL_NAME1 -asOrg Institute1MSP

#echo "#######    Generating anchor peer update for Institute2MSP  ##########"
configtxgen -profile $CHANNEL_NAME1 -configPath . -outputAnchorPeersUpdate ./Institute2MSPanchors_${CHANNEL_NAME1}.tx -channelID $CHANNEL_NAME1 -asOrg Institute2MSP

#echo "#######    Generating anchor peer update for Institute3MSP  ##########"
configtxgen -profile $CHANNEL_NAME1 -configPath . -outputAnchorPeersUpdate ./Institute3MSPanchors_${CHANNEL_NAME1}.tx -channelID $CHANNEL_NAME1 -asOrg Institute3MSP

#echo "#######    Generating anchor peer update for ManageralMSP  ##########"
configtxgen -profile $CHANNEL_NAME1 -configPath . -outputAnchorPeersUpdate ./ManageralMSPanchors_${CHANNEL_NAME1}.tx -channelID $CHANNEL_NAME1 -asOrg ManageralMSP


# Generate channel configuration block
configtxgen -profile $CHANNEL_NAME2 -configPath . -outputCreateChannelTx ./${CHANNEL_NAME2}.tx -channelID $CHANNEL_NAME2

#echo "#######    Generating anchor peer update for Institute1MSP  ##########"
configtxgen -profile $CHANNEL_NAME2 -configPath . -outputAnchorPeersUpdate ./Institute1MSPanchors_${CHANNEL_NAME2}.tx -channelID $CHANNEL_NAME2 -asOrg Institute1MSP

#echo "#######    Generating anchor peer update for Institute2MSP  ##########"
configtxgen -profile $CHANNEL_NAME2 -configPath . -outputAnchorPeersUpdate ./Institute2MSPanchors_${CHANNEL_NAME2}.tx -channelID $CHANNEL_NAME2 -asOrg Institute2MSP

#echo "#######    Generating anchor peer update for Institute3MSP  ##########"
configtxgen -profile $CHANNEL_NAME2 -configPath . -outputAnchorPeersUpdate ./Institute3MSPanchors_${CHANNEL_NAME2}.tx -channelID $CHANNEL_NAME2 -asOrg Institute3MSP

#echo "#######    Generating anchor peer update for ManageralMSP  ##########"
configtxgen -profile $CHANNEL_NAME2 -configPath . -outputAnchorPeersUpdate ./ManageralMSPanchors_${CHANNEL_NAME2}.tx -channelID $CHANNEL_NAME2 -asOrg ManageralMSP