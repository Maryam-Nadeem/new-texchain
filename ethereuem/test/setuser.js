const AdminUser = require('../contracts/AdminUserartufact');
const{abi,bytecode}= AdminUser;
const ganache = require('ganache-cli');
const assert = require('assert');
const truffleAssert = require('truffle-assertions')
var Contract = require('web3-eth-contract');
const Web3= require('web3');
const { before } = require('mocha');
const web3= new Web3(ganache.provider());

let accounts;
// let factory;
// let campaignaddress;
 let campaign;
let contract;
let user_contract;
let acc1;
let owner;
// beforeEach (async ()=>{
//     accounts = await new web3.eth.getAccounts();
//    console.log('attempting to deploy from', accounts[0]);
  
//   factory = await new web3.eth.Contract(Registration.abi)
//      .deploy({data: Registration.bytecode})
//     .send({from: accounts[0], gas: '1000000' });

   
   
   

// })

// describe('Campaigns', ()=>{
//   // console.log(JSON.parse(compiledCampaign.metadata).output.abi )
  
//     it('start to end testing ',async()=>{
       
// //console.log(web3.eth.getBalance(accounts[1]).then(console.log));
//         let balance= await web3.eth.getBalance(accounts[1]);
//         console.log(balance);
//         balance= web3.utils.fromWei(balance.toString(), 'ether');
//         console.log(balance);
//         balance= parseFloat(balance);
//        console.log(balance);

//         assert(balance>103);

//     })
// });

before("contract", async () => {
    
   // console.log(contract.address)
    accounts = await new web3.eth.getAccounts();
    user_contract = new web3.eth.Contract(
        JSON.parse(abi),
         '0x796D553883BC23Cc823257F9aE61835C4cdE48B1' );
    console.log(accounts)
})

describe('contract',()=>{
    it('should register a new user', async () => {

        let balance= await web3.eth.getBalance(accounts[0]);
        console.log(user_contract._address);
        assert.ok(user_contract._address);
    })
    it('create item',async()=>{
        acc1= accounts[1];
            campaign= await user_contract.methods.authorizeCaller(accounts[1]).send({
                from: accounts[0], gas:'1000000'
            }).then(receipt=> {console.log(receipt)});
            assert.strictEqual(user_contract.methods.isUser(acc1),'true')
    })
    it('owner',async ()=>{
        owner=accounts[0];
        campaign= await user_contract.methods.isOwner().call();
        assert.strictEqual(lastaccess,owner)
    })
})
