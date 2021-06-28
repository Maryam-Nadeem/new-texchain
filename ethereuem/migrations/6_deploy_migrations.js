const Manufacturer = artifacts.require("Manufacturer");
const fs =require('fs')
const path= require('path')
module.exports = function (deployer) {
  deployer.deploy(Manufacturer,{from:"0x9576AA3eBCE42732cc94cc8Fede9fb0850ccc27F"}).then(() => {
    fs.writeFile(
      __dirname + path,
      'const ADDRESS = ' + "'" + Manufacturer.address + "';",
      (err) => {
        if (err) {
          console.log(err)
        } else {
        }
      },
    )
    fs.appendFile(
      __dirname + path,
      '\nconst ABI = ' + JSON.stringify(Manufacturer.abi) + ';',
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
