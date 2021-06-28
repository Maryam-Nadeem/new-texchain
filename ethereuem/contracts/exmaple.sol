// SPDX-License-Identifier: GPL-3.0
 pragma experimental ABIEncoderV2;
pragma solidity >=0.4.20;

 //import "../TexOwner.sol";
 
 
 contract AdminUser{
     
         //add fabric treatementt denim treatment like stone washing, sand washing, enzyme wash, acid wash, sandblasting, river wash, whiskers and vintage look.
        address public lastAccess;
        address public owner;
        uint public creationTime;
        bytes32 a;
        //mapping (uint=> items) itemlist;
       
       
        mapping(address => User) private usersdetail;
        address[] private userindex;
        uint count = userindex.length;
        mapping(address => uint8) authorizedCaller;

        
        
        constructor() public {
            owner = msg.sender;
              creationTime = block.timestamp;
            authorizedCaller[msg.sender] = 1;
            emit AuthorizedCaller(msg.sender);
         }
 
         struct User{
            string us_name;
            string password;
            address Createdby;
            uint creationTime;
            uint index;
            string email;
            string location;
            uint role;
    
         }
         struct Userroles{
             uint us_roles;
         }
         uint256 token;
         mapping(address=>uint) public us_role;
         mapping(bytes32 => User) idmap;
         
        

        event OwnershipRenounced(address indexed previousOwner);
        event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
        event AuthorizedCaller(address caller);
        event DeAuthorizedCaller(address caller);
        event LogNewUser   (address indexed _userAddress, uint index,string  name, string password,string email,uint userrole,bytes32 _hash);
        event LogUpdateUser(address indexed _userAddress, uint index,  string email, string location, string password);
        event ProduceByFarmer(uint upc);         //1

        
        modifier onlyAuthCaller(){
            lastAccess = msg.sender;
            require(authorizedCaller[msg.sender] == 1);
            _;
        }
        
        modifier Onlyowner(){
            require( msg.sender==owner);
            _;
        }
        function transferOwnership( address newOwner) public Onlyowner{
            require(newOwner != address(0));
            emit OwnershipTransferred(owner, newOwner);
            owner = newOwner;
        }
        
        function renounceOwnership() public {
            emit OwnershipRenounced(owner);
            owner = address(0);
        }
        
         function isOwner() public view returns (bool) {
            return msg.sender == owner;
        }
         function isUser(address _userAddress)public view  returns(bool isIndeed) {
            if(userindex.length == 0) return false;
            return (userindex[usersdetail[_userAddress].index] == _userAddress);
      }
         
         function authorizeCaller(address _caller) public Onlyowner returns(bool) 
        {
            authorizedCaller[_caller] = 1;
            emit AuthorizedCaller(_caller);
            return true;
        }
        
        /* deauthorize caller */
        function deAuthorizeCaller(address _caller) public Onlyowner returns(bool) 
        {
            authorizedCaller[_caller] = 0;
            emit DeAuthorizedCaller(_caller);
            return true;
        }
        
     
        function setUser(address _userAddress, string memory us_name, string memory password, string memory  email, string memory location,uint   role) public Onlyowner returns(uint index) {
            //require(authorizedCaller[msg.sender]==1);
            //authorizedCaller[msg.sender] = 0;
            //require(authorizedCaller[msg.sender]==0);
            
            require(isUser(_userAddress)==false); 
            
            usersdetail[_userAddress].Createdby = msg.sender;
            usersdetail[_userAddress].creationTime= block.timestamp;
            usersdetail[_userAddress].us_name=us_name;
            usersdetail[_userAddress].password=password;
            usersdetail[_userAddress].email=email;
            usersdetail[_userAddress].location=location;
            usersdetail[_userAddress].role=role;
            us_role[_userAddress]= role;
            
            userindex.push(_userAddress);
            usersdetail[_userAddress].index = userindex.length-1;
            a= sha256(abi.encodePacked(_userAddress,us_name,location,password,email,role));
            idmap[a]=usersdetail[_userAddress];
            
           emit  LogNewUser(
            _userAddress, 
            usersdetail[_userAddress].index, 
            us_name,
            password,
            email, 
            us_role[_userAddress],
            a
            );
            
             return (userindex.length-1);
        }
         function getUserCount() public view returns(uint index) {
            return userindex.length;
            }
            
            
        //  function getUser(address _userAddress) public  returns ( bytes32  a,
        //                                                             string memory us_name,
        //                                                               string memory password,
        //                                                               string memory  email,
        //                                                               address _Createdby,
        //                                                               uint  role)
        //     {
        //         require(isUser(_userAddress)==true);
                
        //         User memory details = usersdetail[_userAddress];
                
        //         a= sha256(abi.encodePacked(details.us_name, details.password,details.email, details.Createdby,details.creationTime));
                 
        //         idmap[a]=usersdetail[_userAddress];
        //         return (a,details.us_name, details.password,details.email,details.Createdby,us_role[_userAddress]);
        //     }   
            
        function getdata(bytes32 transactionhash) public view returns(User memory used){
             return (idmap[transactionhash]);
            
        }
        function updateUser(address _userAddress, string memory email, string memory location, string memory password) public returns(bool success) {
            
            require(isUser(_userAddress)==true) ; 
            usersdetail[_userAddress].email = email;
            usersdetail[_userAddress].location = location;
            usersdetail[_userAddress].password = password;
            emit LogUpdateUser(
            _userAddress, 
            usersdetail[_userAddress].index,
            email,
            location,
            password
            );
            return true;
        }   
 
     
 }
    library Roles {
      struct Role {
        mapping (address => bool) bearer;
      }
    
      /**
       * @dev give an account access to this role
       */
      function add(Role storage role, address _userAddress) internal {
        require(_userAddress != address(0));
        require(!has(role, _userAddress));
    
        role.bearer[_userAddress] = true;
      }
    
      /**
       * @dev remove an account's access to this role
       */
      function remove(Role storage role, address _userAddress) internal {
        require(_userAddress != address(0));
        require(has(role, _userAddress));
    
        role.bearer[_userAddress] = false;
      }
    
      /**
       * @dev check if an account has this role
       * @return bool
       */
      function has(Role storage role, address _userAddress)
        internal
        view
        returns (bool)
      {
        require(_userAddress != address(0));
        return role.bearer[_userAddress];
      }
    }
     
     
 contract Supplier{
     
      using Roles for Roles.Role;
    uint public creationTime;
      // Define 2 events, one for Adding, and other for Removing
      event SupplierAdded(address indexed account);
      event SupplierRemoved(address indexed account);
    
      // Define a struct 'farmers' by inheriting from 'Roles' library, struct Role
      Roles.Role private suppliers;
    
      // In the constructor make the address that deploys this contract the 1st farmer
      constructor() public {
        _addSupplier(msg.sender);
        creationTime = block.timestamp;
    
      }
    
      // Define a modifier that checks to see if msg.sender has the appropriate role
      modifier onlySupplier() {
        require(isSupplier(msg.sender));
        _;
      }
    
      // Define a function 'isFarmer' to check this role
      function isSupplier(address _userAddress) public view returns (bool) {
        return suppliers.has(_userAddress);
      }
    
      // Define a function 'addFarmer' that adds this role
      function addSupplier(address _userAddress) public onlySupplier {
        _addSupplier(_userAddress);
      }
    
      // Define a function 'renounceFarmer' to renounce this role
      function renounceSupplier() public {
        _removeSupplier(msg.sender);
      }
    
      // Define an internal function '_addFarmer' to add this role, called by 'addFarmer'
      function _addSupplier(address _userAddress) internal {
        suppliers.add(_userAddress);
        emit SupplierAdded(_userAddress);
      }
    
      // Define an internal function '_removeFarmer' to remove this role, called by 'removeFarmer'
      function _removeSupplier(address _userAddress) internal {
        suppliers.remove(_userAddress);
        emit SupplierRemoved(_userAddress);
      }

 }
         contract Manufacturer {
             
             
          using Roles for Roles.Role;
          
          // Define 2 events, one for Adding, and other for Removing
          event ManufacturerAdded(address indexed _userAddress);
          event ManufacturerRemoved(address indexed _userAddress);
          address manuowner;
          bytes32 hash;
         
          
          // Define a struct 'distributors' by inheriting from 'Roles' library, struct Role
          Roles.Role private distributors;
        event LogNewUser   (address indexed _userAddress, uint index);

          address[] private userindex;
    
          // In the constructor make the address that deploys this contract the 1st distributor
          constructor() public {
              manuowner =msg.sender;
            _addDistributor(msg.sender);
          }
        modifier onlyManufacturer(){
            require(msg.sender == manuowner);
            _;
        }
          // Define a modifier that checks to see if msg.sender has the appropriate role
          modifier onlyDistributor() {
            require(isDistributor(msg.sender));
            _;
          }
        
          // Define a function 'isDistributor' to check this role
          function isDistributor(address account) public view returns (bool) {
              
            return distributors.has(account);
          }
          
    //       function isMerch(address _userAddress)public view  returns(bool isIndeed) {
    //         if(userindex.length == 0) return false;
    //         return (userindex[merch[_userAddress].index] == _userAddress);
    //   }
    //   function isEmp(address _userAddress)public view  returns(bool isIndeed) {
    //         if(userindex.length == 0) return false;
    //         return (userindex[emp[_userAddress].index] == _userAddress);
    //   }
      
    //     function addMerchandizer(address _userAddress)public onlyManufacturer {
           
    //       require(isMerch(_userAddress)==false);
           
    //         merch[_userAddress].Createdby=msg.sender;
           
    //         merch[_userAddress].merch_id=merch_id;
    //         merch_id =merch_id+1;
    //         map[merch_id]=_userAddress;
    //         userindex.push(_userAddress);
    //                 emit LogNewUser   (_userAddress,merch_id );

    //         merch[_userAddress].index = userindex.length-1;
           
    //     }
    //      function getMerch(uint id) public view returns(address ){
    //          return (map[id]);
            
    //     }
        
    //     function addEmployee(address _userAddress )public onlyManufacturer {
           
    //       require(isEmp(_userAddress)==false);
    //         hash =  sha256(abi.encodePacked(_userAddress,emp_id));
    //         emp[_userAddress].Createdby=msg.sender;
            
    //         emp[_userAddress].emp_id=emp_id;
    //         empmap[hash]=emp[_userAddress];
    //         emp_id =emp_id+1;
    //          emit LogNewUser   (_userAddress,emp_id);
    //         userindex.push(_userAddress);
    //         emp[_userAddress].index = userindex.length-1;
            
    //     }
        
    // Define a function 'addDistributor' that adds this role
          function addDistributor(address account) public onlyDistributor {
            _addDistributor(account);
          }
        
          // Define a function 'renounceDistributor' to renounce this role
          function renounceDistributor() public {
            _removeDistributor(msg.sender);
          }
        
          // Define an internal function '_addDistributor' to add this role, called by 'addDistributor'
          function _addDistributor(address account) internal {
            distributors.add(account);
            emit ManufacturerAdded(account);
          }
        
          // Define an internal function '_removeDistributor' to remove this role, called by 'removeDistributor'
          function _removeDistributor(address account) internal {
            distributors.remove(account);
            emit ManufacturerRemoved(account);
          }
        }
   contract Brand {
      using Roles for Roles.Role;
      // Define 2 events, one for Adding, and other for Removing
      event ConsumerAdded(address indexed account);
      event ConsumerRemoved(address indexed account);
    
      // Define a struct 'consumers' by inheriting from 'Roles' library, struct Role
      Roles.Role private consumers;
      // In the constructor make the address that deploys this contract the 1st consumer
      constructor() public {
        //_addConstructor(msg.sender);
        _addConsumer(msg.sender);
      }
    
      // Define a modifier that checks to see if msg.sender has the appropriate role
      modifier onlyBrand() {
        require(isBrand(msg.sender));
        _;
      }
    
      // Define a function 'isConsumer' to check this role
      function isBrand(address account) public view returns (bool) {
        return consumers.has(account);
      }
    
      // Define a function 'addConsumer' that adds this role
      function addBrand(address account) public onlyBrand {
        _addConsumer(account);
      }
    
      // Define a function 'renounceConsumer' to renounce this role
      function renounceConsumer(address account) public {
        _removeConsumer(account);
      }
    
      // Define an internal function '_addConsumer' to add this role, called by 'addConsumer'
      function _addConsumer(address account) internal {
        consumers.add(account);
        emit ConsumerAdded(account);
      }
    
      // Define an internal function '_removeConsumer' to remove this role, called by 'removeConsumer'
      function _removeConsumer(address account) internal {
        consumers.remove(account);
        emit ConsumerRemoved(account);
      }
}      
  contract Supplychain is Supplier, Manufacturer, Brand{
           
          // Define a variable called 'upc' for Universal Product Code (UPC),12 digit codes. 
        uint  upc;
        uint productupc;
        uint productsku;
        
        // Define a variable called 'sku' for Stock Keeping Unit (SKU),string of alpha and numeric,unique to the companies ,8 digit
        uint  sku;
        uint placeholder; // Block number place holder
        address owner;
        // Define a public mapping 'items' that maps the UPC to an Item.
        mapping (uint => Item) items;
        mapping (uint => Denim) products;
        mapping (uint256 =>Denim[])  public idToProof;
        
         // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash,
        // that track its journey through the supply chain -- to be sent from DApp.
        mapping (uint => Txblocks) itemsHistory;
        mapping (address=>address[]) public merhmap;
        mapping(address=>mapping(address=>uint)) public mechsupquantity;
        // Define enum 'State' with the following values:
        enum State
        {
        ProduceBySupplier,         // 0
        ForSaleBySupplier,         // 1
        PurchasedByManufacturer,  // 2
        ShippedBySupplier,         // 3
        ReceivedByManufacturer,   // 4
        ProcessedByManufacturer,  // 5
        PackagedByManufacturer,    // 6
        ForSaleByManufacturer,    // 7
        PurchasedByBrand,         // 8
        ShippedByManufacturer,    // 9
        ReceivedByBrand// 10
        }
       
        struct Item {
            uint    sku;                    // Stock Keeping Unit (SKU)
            uint    upc;                    // Universal Product Code (UPC), generated by the Farmer, goes on the package, can be verified by the Consumer
            uint creationTime;
            address ownerID;                // Metamask-Ethereum address of the current owner as the product moves through 8 stages
            address originsupplierID;         // Metamask-Ethereum address of the Farmer // ADDED PAYABLE
            string  originsupplierName;         // Farmer Name
            string  originsupplierLatitude;     // Farm Latitude
            string  originsupplierLongitude;    // Farm Longitude
            uint    productID;              // Product ID potentially a combination of upc + sku
            uint    productPrice;           // Product Price
            uint quantity;
            string dye;// indigo
            State   itemState;// Product State as represented in the enum above
            string materialtype; 
            address merchandizerid;
            address manufacturerID;          // Metamask-Ethereum address of the Distributor
            address brandID;             // Metamask-Ethereum address of the Consumer // ADDED payable
        }
        
        struct Denim {
            string gramenttype;
            string treatements;
            uint productupc;
            address ownerID;
            State productstate;
            uint productsku;
            address brandID;
            uint[] empID;
            uint creationTime;
            address manufacturerID;
            address merchandizerid;
            uint ShipmnetAgent;
            uint[]  machine_id;
            uint[] itemsUPC;

        }

       
        struct Txblocks {
            uint FTD; // blockfarmerToDistributor
            uint RTC; // blockRetailerToConsumer
            uint PM;//blockpurchsetoprocess
            uint PPA;//blockprocesstopacakge
          }
          
         State constant defaultState = State.ProduceBySupplier;
        event LogProductDetails(uint[] _upc, uint[] _machineid, uint[] _employeeid);
        event logNewItem   (uint _upc,uint upc, address employee, string  _originsupplierName, string  _originsupplierLatitude, string  _originsupplierLongitude,string  _materialtype, uint _price, string  _dye, uint256 hash );
        event lognewPurchse   (uint _upc,uint time,   address _merch,uint _quantity, address originsupplierID, uint256 FTD);
        event QuantityLesserThanRequired(uint upc);
        event ProduceBySupplier(uint upc);         //1
        event ForSaleBySupplier(uint upc); //2
        event PurchasedByManufacturer(uint upc);  //3
        event ShippedBySupplier(uint upc);         //4
        event ReceivedByManufacturer(uint upc);   //5
        event ProcessedByManufacturer(uint upc);  //6
        event PackagedByManufacturer(uint upc);   //7
        event ForSaleByManufacturer(uint upc);    //8
        event PurchasedByBrand(uint upc);     //13
        event ShippedByManufacturer(uint upc);    //10
        event ReceivedByBrand(uint upc);     //13
        
        modifier forSaleBySupplier(uint _upc) {
        require(items[_upc].itemState == State.ForSaleBySupplier);
        _;
        }
        modifier producedBySupplier(uint _upc) {
        require(items[_upc].itemState == State.ProduceBySupplier);
        _;
        }
        modifier verifyCaller (address _userAddress) {
        require(msg.sender == _userAddress);
        _;
        }
        modifier purchasedByManufacturer(uint _upc) {
        require(items[_upc].itemState == State.PurchasedByManufacturer);
        _;
        }
        
        modifier shippedBySupplier(uint _upc) {
        require(items[_upc].itemState == State.ShippedBySupplier);
        _;
        }
        
        modifier receivedByManufacturer(uint _upc) {
        require(items[_upc].itemState == State.ReceivedByManufacturer);
        _;
        }
        
        modifier processByManufacturer(uint _upc) {
        require(products[_upc].productstate == State.ProcessedByManufacturer);
        _;
        }
        
        modifier packagedByManufacturer(uint _upc) {
        require(products[_upc].productstate == State.PackagedByManufacturer);
        _;
        }
        modifier forSaleByManufacturer(uint _upc) {
        require(products[_upc].productstate  == State.ForSaleByManufacturer);
        _;
  }


      modifier shippedByManufacturer(uint _upc) {
        require(products[_upc].productstate  == State.ShippedByManufacturer);
        _;
      }
    
      
      modifier purchasedByBrand(uint _upc) {
        require(products[_upc].productstate  == State.PurchasedByBrand);
        _;
      }
            constructor () public  {
            owner=msg.sender;
            sku = 1;
            upc = 1;
            productupc=1;
            productsku=1;
        }
                   // allows you to convert an address into a payable address
         
        function itemBySupplier(uint _upc, string memory _originsupplierName, string memory _originsupplierLatitude, string memory _originsupplierLongitude,string memory _materialtype, uint _price, string memory _dye) public
        onlySupplier() // check address belongs to farmerRole
        {
        
        address manufacturerID; // Empty distributorID address
        address brandID; // Empty consumerID address
        
        Item memory newProduce; // Create a new struct Item in memory
        newProduce.sku = sku;  // Stock Keeping Unit (SKU)
        newProduce.upc = _upc; // Universal Product Code (UPC), generated by the Farmer, goes on the package, can be verified by the Consumer
        newProduce.ownerID = msg.sender;  // Metamask-Ethereum address of the current owner as the product moves through 8 stages
        newProduce.originsupplierID = msg.sender; // Metamask-Ethereum address of the Farmer
        newProduce.originsupplierName = _originsupplierName;  // Farmer Name
        newProduce.originsupplierLatitude = _originsupplierLatitude; // Farm Latitude
        newProduce.originsupplierLongitude = _originsupplierLongitude;  // Farm Longitude
        newProduce.productID = _upc+sku;  // Product ID
        newProduce.productPrice = _price;  // Product Price
        newProduce.creationTime = block.timestamp;
        newProduce.dye = _dye;
        newProduce.materialtype = _materialtype;
        newProduce.itemState = defaultState; // Product State as represented in the enum above
        
        newProduce.manufacturerID = manufacturerID; // Metamask-Ethereum address of the Distributor
        newProduce.brandID = brandID; // Metamask-Ethereum address of the Consumer // ADDED payable
        
        items[_upc] = newProduce; // Add newProduce to items struct by upc
         Txblocks memory txBlock; // create new txBlock struct
        txBlock.FTD = placeholder; // assign placeholder values
        txBlock.RTC = placeholder;
        itemsHistory[_upc] = txBlock; // add txBlock to itemsHistory mapping by upc
        
           emit logNewItem   ( _upc, 0,address(0),_originsupplierName,   _originsupplierLatitude,  _originsupplierLongitude,  _materialtype, _price,  _dye,0);
        
        // Increment sku
        sku = sku + 1;
        
        // Emit the appropriate event
        emit ProduceBySupplier(_upc);
        
        
        
        }
        
        function sellItemBySupplier(uint _upc, uint _price) public
        onlySupplier() // check msg.sender belongs to farmerRole
        producedBySupplier(_upc) // check items state has been produced
        verifyCaller(items[_upc].ownerID) // check msg.sender is owner
        {
        items[_upc].itemState = State.ForSaleBySupplier;
        items[_upc].productPrice = _price;
        emit ForSaleBySupplier(_upc);
        }
        
        function purchaseItemByManufacturer(uint _upc, address _merchandizerId, uint _quantity) public  
        onlyDistributor() // check msg.sender belongs to distributorRole
        forSaleBySupplier(_upc) // check items state is for ForSaleByFarmer
        {
        // transfer funds from distributor to farmer
        items[_upc].ownerID = msg.sender; // update owner
        items[_upc].manufacturerID = msg.sender; // update distributor
        items[_upc].quantity =_quantity;
        items[_upc].itemState = State.PurchasedByManufacturer; // update state
        
        merhmap[_merchandizerId].push(items[_upc].originsupplierID);
        mechsupquantity[_merchandizerId][items[_upc].originsupplierID]=_quantity;
        itemsHistory[_upc].FTD = block.number; // add block number
        // idToProof[items[_upc].FTD]="proof1";
        emit lognewPurchse   (_upc,block.timestamp, _merchandizerId, _quantity,items[_upc].originsupplierID,itemsHistory[_upc].FTD);
        
        emit PurchasedByManufacturer(_upc);
        
        
        //0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
        //0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
        //0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
        //0x617F2E2fD72FD9D5503197092aC168c91465E7f2
        }
        
        function shippedItemBySupplier(uint _upc) public 
        onlySupplier() // check msg.sender belongs to FarmerRole
        purchasedByManufacturer(_upc)
        verifyCaller(items[_upc].originsupplierID) // check msg.sender is originFarmID
        {
            // items[_upc].quantity =_quantity;
        items[_upc].itemState = State.ShippedBySupplier; // update state
        emit lognewPurchse(_upc,block.timestamp,address(0),0,address(0),0);
        emit ShippedBySupplier(_upc);
        }
        
        function receivedItemByManufacturer(uint _upc, uint quantity, address _merchandizerId) public
        onlyDistributor() // check msg.sender belongs to DistributorRole
        shippedBySupplier(_upc)
        verifyCaller(items[_upc].ownerID) // check msg.sender is owner
        {
            if(mechsupquantity[_merchandizerId][items[_upc].originsupplierID]< quantity)
            {
                emit QuantityLesserThanRequired(quantity);
                
            }
        items[_upc].itemState = State.ReceivedByManufacturer; // update state
       mechsupquantity[_merchandizerId][items[_upc].originsupplierID]=quantity;

        emit lognewPurchse(_upc,block.timestamp,address(0),0,address(0),0);
        emit ReceivedByManufacturer(_upc);
        }
        
        
        function processedItemByManufacturer(uint _upc,uint[] memory _machine, uint _productupc, address _merchandizerId,string memory _treatements , uint[] memory _empaddress) public
        onlyDistributor() // check msg.sender belongs to DistributorRole
        receivedByManufacturer(_upc)
        verifyCaller(items[_upc].ownerID) // check msg.sender is owner
        {
            address brandID;
        Denim memory product;
        product.brandID=brandID;
        product.productupc=_productupc;
        product.treatements=_treatements;
        product.machine_id=_machine;
        product.empID=_empaddress;
        product.ownerID=msg.sender;
        product.manufacturerID=msg.sender;
        product.creationTime=block.timestamp;
        product.merchandizerid = _merchandizerId;
        products[_productupc]=product;
        uint256 batchno= uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        
        idToProof[batchno].push(product);

        
        itemsHistory[_productupc].PM = block.number; // add block number
        items[_upc].itemState = State.ProcessedByManufacturer; // update state
        products[_productupc].productstate= State.ProcessedByManufacturer;
        emit logNewItem   ( _productupc, _upc, _merchandizerId,  _treatements,'null','null','null',0,'null',batchno);
        product.productsku=product.productsku+1;

        emit ProcessedByManufacturer(_productupc);
        }
        
        function ProductDetails(uint[] memory _upc, uint _productupc,uint[] memory machineid, uint[] memory employeeid)
        public {
            products[_productupc].machine_id=machineid;
        products[_productupc].empID=employeeid;
        products[_productupc].itemsUPC=_upc;
       emit LogProductDetails(products[_productupc].machine_id,products[_productupc].itemsUPC, products[_productupc].empID);
        }
        function packageItemByDistributor(uint _productupc,uint256 _batchno) public
        onlyDistributor() // check msg.sender belongs to DistributorRole
        processByManufacturer(_productupc)
        verifyCaller(products[_productupc].ownerID) // check msg.sender is owner
        {
        
        products[_productupc].productstate= State.PackagedByManufacturer;
        idToProof[_batchno].push(  products[_productupc]);
        itemsHistory[_productupc].PPA = block.number; // add block number
        emit PackagedByManufacturer(_productupc);
        }
        
        function sellItemByDistributor(uint _productupc,uint256 _batchno) public
        onlyDistributor() // check msg.sender belongs to DistributorRole
        packagedByManufacturer(_productupc)
        verifyCaller(products[_productupc].manufacturerID) // check msg.sender is owner
        {
        
        products[_productupc].productstate= State.ForSaleByManufacturer;
        idToProof[_batchno].push(  products[_productupc]);
        emit logNewItem(_productupc,0,address(0),"null","null",'null','null',0,'null',_batchno);
        emit ForSaleByManufacturer(_productupc);
        }
        function purchaseItemByBrand(uint _upc,uint _productupc) public 
       onlyBrand() // check msg.sender belongs to ConsumerRole
        forSaleByManufacturer(_productupc)
        {
        products[_productupc].brandID = msg.sender;
        items[_upc].brandID=msg.sender;
        products[_productupc].ownerID = msg.sender;
        products[_productupc].productstate = State.PurchasedByBrand;
        itemsHistory[_productupc].RTC = block.number;
        emit lognewPurchse(_productupc,block.timestamp,products[_productupc].brandID,0,address(0),0);
        emit PurchasedByBrand(_productupc);
        }
        function shippedItemByDistributor(uint _productupc ,uint _shipmentAgent) public
        onlyDistributor() // check msg.sender belongs to DistributorRole
        purchasedByBrand(_productupc)
        verifyCaller(products[_productupc].manufacturerID) // check msg.sender is distributorID
        {
            products[_productupc].ShipmnetAgent=_shipmentAgent;
        products[_productupc].productstate = State.ShippedByManufacturer;
        emit lognewPurchse(_productupc,block.timestamp,address(0),_shipmentAgent,address(0),0);
        emit ShippedByManufacturer(_productupc);
        }
        
        function fetchItemBufferOne(uint _upc) public view returns
        (
        uint    itemSKU,
        uint    itemUPC,
        address ownerID,
        address originSupplierID,
        string memory  originSupplierName,
        string memory originSupplierLatitude,
        string memory originSupplierLongitude,
        uint price,
        uint creationtime
        )
        {
        // Assign values to the 8 parameters
        Item memory item = items[_upc];
    
        return (item.sku,
          item.upc,
          item.ownerID,
         item.originsupplierID,
          item.originsupplierName,
          item.originsupplierLongitude,
          item.originsupplierLatitude,
          item.productPrice,
          item.creationTime
        );
  }
      function fetchItemBufferTwo(uint _upc) public view returns
        (
        uint    itemSKU,
        uint    itemUPC,
        uint    productID,
        State   itemState,
        address manufacturerID,
        address brandID,
        address merchandizerid
        )
        {
          // Assign values to the 9 parameters
        Item memory item = items[_upc];
    
        return
        (
          item.sku,
          item.upc,
          item.productID,
          item.itemState,
          item.manufacturerID,
          item.brandID,
          item.merchandizerid
        );

  }
   function fetchItemBufferThree(uint _productupc) public view returns
        (
        uint    itemSKU,
        uint    itemUPC,
        address manufacturerID,
        address brandID,
        address merchandizerid,
        string memory treatement,
        State   itemState,
        uint[] memory empID,
        uint[] memory machine_id,
        uint time
        )
        {
          // Assign values to the 9 parameters
        Denim memory product = products[_productupc];
    
        return
        (
          product.productsku,
          product.productupc,
          product.manufacturerID,
          product.brandID,
          product.merchandizerid,
          product.treatements,
          product.productstate,
          product.empID,
          product.machine_id,
          product.creationTime
          
    
        );

  }
    function fetchitemHistory(uint _upc, uint _productupc) public view returns
        (
          uint blockSupplierToDistributor,
          uint blockManufacturerToBrand,
          uint blockpurchsetoprocess,
          uint blockprocesstopacakge
        )
        {
          // Assign value to the parameters
          Txblocks memory txblock = itemsHistory[_upc];
          return
          (
            txblock.FTD,
            txblock.RTC,
            itemsHistory[_productupc].PM,
            itemsHistory[_productupc].PPA
    
          );
    
        }



   }