const Supplier = artifacts.require("Supplier");
const fs =require('fs')
const path= require('path')
module.exports = function (deployer) {
  deployer.deploy(Supplier,{from:"0xbc792347D9e5D4252fa5CB630CDCE0b337EFc45b"}).then(() => {
    fs.writeFile(
      __dirname + path,
      'const ADDRESS = ' + "'" + Supplier.address + "';",
      (err) => {
        if (err) {
          console.log(err)
        } else {
        }
      },
    )
    fs.appendFile(
      __dirname + path,
      '\nconst ABI = ' + JSON.stringify(Supplier.abi) + ';',
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
