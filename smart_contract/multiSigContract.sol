pragma solidity ^0.4.0;

contract MultiSigEvents {
  event DepositingFunds(address from, uint amount);
  event TransactionCreated(address from, address to, uint amount, uint transactionId);
  event TransactionCompleted(address from, address to, uint amount, uint transactionId);
  event TransactionSigned(address by, uint transactionId);
}

contract MultiSig is MultiSigEvents {

  /****
    Here is specified the owner logic part of the smart contract.
    Owner = who mined it and has administrations rights.
    Owners = who has rights to sign transactions
  ****/

  address private _owner;
  //Public for debug purposes only, remove before deploying
  public mapping (address => uint8) _owners;

  modifier isOwner(){
    require(msg.sender == _owner);
    _;
  }

  modifier validOwner(){
    require(msg.sender == _owner || _owners[msg.sender]==1);
    _;
  }

  function addOwner(address owner) isOwner public {
    _owners[owner] = 1;
  }

  function removeOwner(address owner) isOwner public {
    _owners[owner] = 0;
  }

  function() public payable {
    DepositingFunds(msg.sender, msg.value);
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
  function MultiSig() public {
    _owner = msg.sender;
    currentTransactionId = 0;
    _owners[msg.sender]=1;
  }

  function createTransaction(address to, uint amount) validOwner public {
    //TODO : Need to control if amount is valid here
    uint disTransactionId = currentTransactionId;
    currentTransactionId +=1;
    Transaction memory transaction;
    transaction.from = msg.sender;
    transaction.to = to;
    transaction.amount = amount;
    transaction.signatureCount = 0;
    _transactions[disTransactionId] = transaction;
    _pendingTransactions.push(disTransactionId);
    TransactionCreated(transaction.from, transaction.to, transaction.amount, disTransactionId);
  }

  function signTransaction(uint id) validOwner public {
    //TODO : add creator cannot sign transaction and transaction.from cannot be null and if already signed cannot sign again
    Transaction storage toSign = _transactions[id];
    toSign.signatureCount+=1;
    toSign.signatures[msg.sender]=1;

    if (toSign.signatureCount >= MIN_SIGNATURES) {
      toSign.to.transfer(toSign.amount);
      //delete the transaction
      deleteTransaction(id);
      TransactionCompleted(toSign.from, toSign.to, toSign.amount, id);
    }
  }

  //add delete transaction function
  //Care, implement splicing arrays to suppress from pendingTransactions
  function deleteTransaction(uint id) validOwner public {
    Transaction storage toDelete = _transactions[id];
    //You can only delete your transactions if you are not admin of the contract
    if ((msg.sender != toDelete.from) && (msg.sender != _owner)) {
      throw;
    }

    /****
      Start implementing splice
    ****/
    //delete from pendingTransactions arrays
    uint8 replace = 0; //detected the transaction to kill?

    for (uint i=0; i < _pendingTransactions.length; i++){
      if (replace==1){
        //if we found the transaction to suppress, we move all instances a step earlier
        _pendingTransactions[i-1] = _pendingTransactions[i];
      } else if (_pendingTransactions[i] == id){
        replace = 1;
      }
    }
    delete _pendingTransactions[_pendingTransactions.length-1];
    _pendingTransactions.length--;

    //Delete from transactions mapping
    delete _transactions[id];
  }
  /****
    End implementing splice
  ****/

  //Wallet Balance function
  function walletBalance() constant public returns (uint){
    return address(this).balance;
  }




  /**********
  For debug purposes only, remove everything once the contract is over.
  ***********/

  function getTransactionSignaturesCount(uint id) validOwner public returns (uint){
    return _transactions[id].signatureCount;
  }

  function getTransactionSignatures(uint id) validOwner public returns (uint){
    return _transactions[id].signatures[msg.sender];
  }
}
