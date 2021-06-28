const Supplychain = artifacts.require("Supplychain");
const fs =require('fs')
const path= require('path')
module.exports = function (deployer) {
  deployer.deploy(Supplychain,{from:"0x53fe80034db699cb19663e8a7d9abab1e64e7f0c"}).then(() => {
    fs.writeFile(
      __dirname + path,
      'const ADDRESS = ' + "'" + Supplychain.address + "';",
      (err) => {
        if (err) {
          console.log(err)
        } else {
        }
      },
    )
    fs.appendFile(
      __dirname + path,
      '\nconst ABI = ' + JSON.stringify(Supplychain.abi) + ';',
      (err) => {
        if (err) {
          console.log(err)
        } else {
          fs.appendFile(
            __dirname + path,
            '\nmodule.exports = { ADDRESS, ABI };',
            (err) => {
              if (err) {
                console.log(err)
              }
            },
          )
        }
      },
    )
  })
};
