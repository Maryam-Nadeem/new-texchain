const Roles = artifacts.require("Roles");
const fs =require('fs')
const path= require('path')
module.exports = function (deployer) {
  deployer.deploy(Roles).then(() => {
    fs.writeFile(
      __dirname + path,
      'const ADDRESS = ' + "'" + Roles.address + "';",
      (err) => {
        if (err) {
          console.log(err)
        } else {
        }
      },
    )
    fs.appendFile(
      __dirname + path,
      '\nconst ABI = ' + JSON.stringify(Roles.abi) + ';',
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
