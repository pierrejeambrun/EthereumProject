pragma solidity ^0.4.0;

contract MultiSig {

  /****
    Here is specified the owner logic part of the smart contract.
    Owner = who mined it and has administrations rights.
    Owners = who has rights to sign transactions
  ****/

  address private _owner;
  mapping (address => uint8) _owners;

  modifier isOwner(){
    require(msg.sender == owner);
    _;
  }

  modifier validOwner(){
    require(msg.sender == owner || _owners[msg.sender]==1);
    _;
  }

  function addOwner(address owner) isOwner public {
    _owners[owner] = 1;
  }

  function removeOwner(address owner) isOwner public {
    _owners[owner] = 0;
  }

  /*****
    Here is defined the transaction logic.
    Transaction structures, creation, pending queue administration, etc...
  *****/

  //Minimum number of signatures needed for validation of a transaction.
  uint constant MIN_SIGNATURES = 2;


  struct Transaction {
    address from;
    address to;
    uint amount;
    uint32 signatureCount;
    mapping (address => uint8) signatures;
  }

  //Current transaction id to be added in pool
  uint private currentTransactionId;

  //Mapping of transaction id to transaction object
  mapping (uint => Transaction) private _transactions;
  //Array of pending transactions.
  uint[] private _pendingTransactions;

  //Constructor of the SC.
  function multiSigWallet() public {
    _owner = msg.sender;
    currentTransactionId = 0;
  }

  function createTransaction(address to, uint amount) validOwner public {
    //TODO : Need to control if amount is valid here

    
  }
}
