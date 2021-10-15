'use strict';

var { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const FabricCAServices = require('fabric-ca-client');
const fs = require('fs');

const util = require('util');

const shell = require('shelljs')

const addorg = async (org,caport) => {
    shell.exec('sh ../artifacts/channel/addOrg/addorg.sh '+ org +' '+ caport,
      function (error, stdout, stderr) {
        if (error !== null) {
          console.log(error);
        } else {
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        }
    })
    // shell.exec('../channelList.sh '+ org, 
    //     function (error, stdout, stderr) {
    //     if (error !== null) {
    //       console.log(error);
    //     } else {
    //     console.log('stdout: ' + stdout);
    //     console.log('stderr: ' + stderr);
    //     }
    // })
}

exports.addorg = addorg