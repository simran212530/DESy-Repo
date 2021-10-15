var express = require('express');
var bodyParser = require('body-parser');


var app = express();
var urlencodedParser = bodyParser.urlencoded({ extended: true });
app.use(bodyParser.json());
// Setting for Hyperledger Fabric
const { Gateway,Wallets } = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const path = require('path');
const fs = require('fs');
const helper = require('./helper')
//const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
  //      const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
app.set("view engine","pug");

app.get('/', function (req, res) {

    res.render('index');

});

app.get('/registration', function (req, res) {

    res.render('registration');

});

app.get('/addCriteria', function (req, res) {

    res.render('criteria');

});

app.get('/addCourse', function (req, res) {

    res.render('course');

});

app.get('/updateCriteria', function (req, res) {

    res.render('updateCriteria');

});

app.get('/studentonboarding', function (req, res) {

    res.render('studentonboarding')

});

app.get('/queryapplications', function (req, res) {

    res.render('queryapplications')

});

app.get('/transferapplications', function (req, res) {

    res.render('transferapplications')

});

app.post('/addadmin/', urlencodedParser, async function (req, res) { 
    try {
        var orgName = req.body.orgName;
        if (!orgName) {
            res.json(getErrorMessage('\'orgName\''));
            return;
        }
        
        const ccp = await helper.getCCP(orgName);

        const walletPath = await helper.getWalletPath(orgName);
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        await helper.enrollAdmin(orgName);
        res.send('Admin enrolled successfully');
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
})

app.post('/addAdmissionCriteria', urlencodedParser, async function (req, res) {
    try {
        var orgName = req.body.instituteName;
        if (!orgName) {
            res.json(getErrorMessage('\'orgName\''));
            return;
        }

        const ccp = await helper.getCCP(orgName);
        // console.log(ccp)
        
        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(orgName) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);

        let identity = await wallet.get('admin');

        if (!identity) {
            console.log(`An identity for the user ${username} does not exist in the wallet, so registering user`);
            await helper.getRegisteredUser(username, orgName, true)
            identity = await wallet.get(username);
            console.log(identity)
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, {
            identity: 'admin',
            wallet
        });

        var channelName = req.body.degree;
        if (!channelName) {
            res.json(getErrorMessage('\'channelName\''));
            return;
        }

        let chaincodeName = "chaincode_student";
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);

        const contract = network.getContract(chaincodeName);

        await contract.submitTransaction('createAdmissionCriteria', req.body.instituteId, req.body.instituteName, req.body.stream, req.body.maxSeatCount, req.body.minimumAge, req.body.minimumRankExam, req.body.minimumBoardPercentage, req.body.extras);

        console.log('Transaction has been submitted');
        res.send('Transaction has been submitted Criteria ADDED');




    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
});

app.post('/addCourse', urlencodedParser, async function (req, res) {
    try {
        var orgName = req.body.instituteName;
        if (!orgName) {
            res.json(getErrorMessage('\'orgName\''));
            return;
        }

        const ccp = await helper.getCCP(orgName);
        // console.log(ccp)
        
        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(orgName) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);

        let identity = await wallet.get('admin');

        if (!identity) {
            console.log(`An identity for the user ${username} does not exist in the wallet, so registering user`);
            await helper.getRegisteredUser(username, orgName, true)
            identity = await wallet.get(username);
            console.log(identity)
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, {
            identity: 'admin',
            wallet
        });

        var channelName = req.body.degree;
        if (!channelName) {
            res.json(getErrorMessage('\'channelName\''));
            return;
        }

        let chaincodeName = "chaincode_student";
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);

        const contract = network.getContract(chaincodeName);

        await contract.submitTransaction('createCourse', req.body.instituteName, req.body.stream, req.body.totalLectures, req.body.totalPracticals, req.body.totalTutorial, req.body.courseCredits, req.body.courseProfessor, req.body.courseSem, req.body.courseSyllabus);

        console.log('Transaction has been submitted');
        res.send('Transaction has been submitted Course ADDED');




    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
});

app.post('/updateAdmissionCriteria', urlencodedParser, async function (req, res) {
    try {
        var orgName = req.body.instituteName;
        if (!orgName) {
            res.json(getErrorMessage('\'orgName\''));
            return;
        }

        const ccp = await helper.getCCP(orgName);
        // console.log(ccp)
        
        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(orgName) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);

        let identity = await wallet.get('admin');

        if (!identity) {
            console.log(`An identity for the user ${username} does not exist in the wallet, so registering user`);
            await helper.getRegisteredUser(username, orgName, true)
            identity = await wallet.get(username);
            console.log(identity)
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, {
            identity: 'admin',
            wallet
        });

        var channelName = req.body.degree;
        if (!channelName) {
            res.json(getErrorMessage('\'channelName\''));
            return;
        }

        let chaincodeName = "chaincode_student";
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);

        const contract = network.getContract(chaincodeName);

        await contract.submitTransaction('updateAdmissionCriteria', req.body.instituteId, req.body.fieldToChange, req.body.change);

        console.log('Transaction has been submitted');
        res.send('Transaction has been submitted Criteria UPDATED');




    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
});

app.post('/addapplication/', urlencodedParser, async function (req, res) {
    try {
        var orgName = req.body.orgName;
        // console.log(orgName)
        if (!orgName) {
            res.json(getErrorMessage('\'orgName\''));
            return;
        }

        var username = req.body.username;
        if (!username) {
            res.json(getErrorMessage('\'username\''));
            return;
        }
        // console.log(username)
        
        const ccp = await helper.getCCP(orgName);
        // console.log(ccp)
        
        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(orgName) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        usern = "admin"
        // Check to see if we've already enrolled the user.
        let identity = await wallet.get('admin');
        console.log(identity)
        if (!identity) {
            console.log(`An identity for the user ${username} does not exist in the wallet, so registering user`);
            await helper.getRegisteredUser(username, orgName, true)
            identity = await wallet.get(username);
            console.log(identity)
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        
        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, {
            identity: 'admin',
            wallet
        });

        var channelName = req.body.degree;
        if (!channelName) {
            res.json(getErrorMessage('\'channelName\''));
            return;
        }

        let chaincodeName = "chaincode_student";
        // let channelName = "btechcse";
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);

        const contract = network.getContract(chaincodeName);
        let applicationid = req.body.ApplicationID;
        let Name = req.body.Name;
        let DOB = req.body.DOB;
        let Gender = req.body.Gender;
        let email = req.body.EMAIL;
        let Mobile_number = req.body.Mobile_number;
        let Aadhar_Number = req.body.Aadhar_Number;
        let Marksheet_10 = req.body.Marksheet_10;
        let Marksheet_12 = req.body.Marksheet_12;
        let EntranceResult = req.body.EntranceResult;
        let Achievements = req.body.Achievements;
        let Password = req.body.Password;
        
        // const text = '{"ApplicationID":"'+applicationid+'","Name":"'+Name+'","DOB":"'+DOB+'","Gender":"'+Gender+'","email":"'+email+'", "Mobile_number":"'+Mobile_number+'", "Aadhar_Number":"'+Aadhar_Number+'","Marksheet_10":"'+Marksheet_10+'", "Marksheet_12":"'+Marksheet_12+'", "EntranceResult":"'+EntranceResult+'","Achievements":"'+Achievements+'", "Password":"'+Password+'", "Username":"'+username+'"}';
        const text = '{"Application":{"ApplicationNumber":"'+applicationid+'","Name":"'+Name+'","DOB":"'+DOB+'","Gender":"'+Gender+'","email":"'+email+'", "Mobile_number":"'+Mobile_number+'", "Aadhar_Number":"'+Aadhar_Number+'","Marksheet_10":"'+Marksheet_10+'", "Marksheet_12":"'+Marksheet_12+'", "EntranceResult":"'+EntranceResult+'","Achievements":"'+Achievements+'", "Password":"'+Password+'", "Username":"'+username+'"}}';

        console.log(text)
        const applicationData = JSON.parse(text);
        let result
        let message;
        let key = Object.keys(applicationData)[0]
        const transientDataBuffer = {}
        console.log(applicationData)
        transientDataBuffer[key] = Buffer.from(JSON.stringify(applicationData.Application))
        
        result = await contract.createTransaction("createApplication")
            .setTransient(transientDataBuffer)
            .submit()
        message = `Successfully submitted transient data`
        res.send('Adpplication submitted successfully');

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
})

app.post('/applicationsquery', urlencodedParser, async function (req, res) {
    try {
        var orgName = req.body.orgName;
        // console.log(orgName)
        if (!orgName) {
            res.json(getErrorMessage('\'orgName\''));
            return;
        }

        const ccp = await helper.getCCP(orgName);
        // console.log(ccp)
        
        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(orgName) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        // Check to see if we've already enrolled the user.
        let identity = await wallet.get('admin');
        console.log(identity)
        

        const gateway = new Gateway();
        await gateway.connect(ccp, {
            identity: 'admin',
            wallet
        });

        var channelName = req.body.degree;
        console.log(channelName)
        if (!channelName) {
            res.json(getErrorMessage('\'channelName\''));
            return;
        }

        let chaincodeName = "chaincode_student";
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);

        const contract = network.getContract(chaincodeName);
        if (orgName == "Manageral") {
            const result = await contract.evaluateTransaction('readApplication', req.body.ApplicationID);
            console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
            res.status(200).json({response: result.toString()});
        }
        if (orgName == "Institute1") {
            const result = await contract.evaluateTransaction('readApplication', req.body.ApplicationID);
            console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
            res.status(200).json({response: result.toString()});
        }
        if (orgName == "Institute2") {
            const result = await contract.evaluateTransaction('instituteFetchApplication', req.body.ApplicationID);
            console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
            res.status(200).json({response: result.toString()});
        }
        if (orgName == "Institute3") {
            const result = await contract.evaluateTransaction('instituteFetchApplication', req.body.ApplicationID);
            console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
            res.status(200).json({response: result.toString()});
        }

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        res.status(500).json({error: error});
        process.exit(1);
    }
});


app.post('/applicationtransfer', urlencodedParser, async function (req, res) {
    try {
        let orgName = "Manageral";
        const ccp = await helper.getCCP(orgName);
        // console.log(ccp)
        
        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(orgName) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        // Check to see if we've already enrolled the user.
        let identity = await wallet.get('admin');
        console.log(identity)
        

        const gateway = new Gateway();
        await gateway.connect(ccp, {
            identity: 'admin',
            wallet
        });

        var channelName = req.body.degree;
        console.log(channelName)
        if (!channelName) {
            res.json(getErrorMessage('\'channelName\''));
            return;
        }

        let chaincodeName = "chaincode_student";
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);

        const contract = network.getContract(chaincodeName);

        const result = await contract.evaluateTransaction('readApplication', req.body.ApplicationID);
        console.log(result)
        // const text = '{"Application":{"ApplicationID":"'+applicationid+'","Name":"'+Name+'","DOB":"'+DOB+'","Gender":"'+Gender+'","email":"'+email+'", "Mobile_number":"'+Mobile_number+'", "Aadhar_Number":"'+Aadhar_Number+'","Marksheet_10":"'+Marksheet_10+'", "Marksheet_12":"'+Marksheet_12+'", "EntranceResult":"'+EntranceResult+'","Achievements":"'+Achievements+'", "Password":"'+Password+'", "Username":"'+username+'"}}';
        const text1 = '{"Application":'+result+'}';
        // console.log(text1)
        const applicationData = JSON.parse(text1);

        let result1
        let message;
        console.log(applicationData.Application.ApplicationID)
        const text = '{"Application":{"ApplicationID":"'+applicationData.Application.ApplicationID+'","Name":"'+applicationData.Application.Name+'","DOB":"'+applicationData.Application.DOB+'","Gender":"'+applicationData.Application.Gender+'","email":"'+applicationData.Application.email+'", "Mobile_number":"'+applicationData.Application.Mobile_number+'", "Aadhar_Number":"'+applicationData.Application.Aadhar_Number+'","Marksheet_10":"'+applicationData.Application.Marksheet_10+'", "Marksheet_12":"'+applicationData.Application.Marksheet_12+'", "EntranceResult":"'+applicationData.Application.EntranceResult+'","Achievements":"'+applicationData.Application.Achievements+'", "Password":"'+applicationData.Application.Password+'", "Username":"'+applicationData.Application.username+'"}}';

        


        const applicationData1 = JSON.parse(text);
        
        let key = Object.keys(applicationData1)[0]
        const transientDataBuffer = {}
        console.log(applicationData1)
        transientDataBuffer[key] = Buffer.from(JSON.stringify(applicationData1.Application))


        if ((req.body.transferto) == "Institute1") {
            result1 = await contract.createTransaction("transferApplication1")
            .setTransient(transientDataBuffer)
            .submit()
            message = `Successfully submitted transient data`
            res.send('Application tranfered successfully');
        }

        if ((req.body.transferto) == "Institute2") {
            result1 = await contract.createTransaction("transferApplication2")
            .setTransient(transientDataBuffer)
            .submit()
            message = `Successfully submitted transient data`
            res.send('Application tranfered successfully');
        }

        if ((req.body.transferto) == "Institute3") {
            result1 = await contract.createTransaction("transferApplication3")
            .setTransient(transientDataBuffer)
            .submit()
            message = `Successfully submitted transient data`
            res.send('Application tranfered successfully');
        }
        


        console.log(`Transaction has been evaluated, result is: ${result1.toString()}`);
        res.status(200).json({response: result1.toString()});
    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        res.status(500).json({error: error});
        process.exit(1);
    }
});









app.listen(8080);
