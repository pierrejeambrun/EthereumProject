pragma solidity ^0.4.0;

/**********
 This is the base for a vulnerable contract as was HackParity.
 A contract, a library and a payable method that delegates call to the library any method that is not matched
 To use delegateCall, the library address must be hardcoded
***********/

contract TestLibrary {
    
    address _owner;
    
    event reached();
    event reachedInit(address);
    
    function init(address _from) public {
        reachedInit(_from);
        //this._owner = _from;
    }
    
    function canIReachThis() public {
       reached();
       //return true;
    }
}

contract VulnerableContract {
    event tryInit(address);
    //Declaration of the event that will be used.
    event yesItWasCalled();

    //Ici mettre l'adresse de la librairie minée au préalable
    address constant _library = 0x0dcd2f752394c41875e259e00bb44fd505297caf;
    
    address _owner ;
    
    function formatFName(string fName) private returns (bytes32) {
        bytes32 result = keccak256(fName);
        //Call byte4 pour tronquer le hash, sinon les params sont modifiés
        return bytes4(result);
    }
    
    function formatAddress(address fAddr) private returns (bytes32) {
        bytes32 result = keccak256(fAddr);
        return result;
    }
    
    //Constructor of the wallet. Delegates the initialisation of _owner to the library
    function VulnerableContract() public {
        tryInit(msg.sender);
        _library.delegatecall(formatFName("init(address)"), msg.sender);
    }
    
    function getOwner() view public returns (address) {
        return _owner;
    }
    
    function getAddressLib() pure public returns (address) {
        return _library;    
    }
    
    // gets called when no other function matches
    function() payable public {
        //If I get sent some cash (wallet logic)
        if (msg.value > 0) {
            //Do something
        }
        
        //Error here in delegateCall, still trying to find what it is
        else if (msg.data.length > 0) {
            //Delegate call to some library
            yesItWasCalled();
            //Below commented is call to canIReachThis method of the librairy which fires an event and later will do the logic.
            //_library.delegatecall(keccak256("canIReachThis()"));
            _library.delegatecall(msg.data);
        }
    } 
}

/**********
 Intermediary created only for testing in solidity browser and the Javascript VM.
 Do not use in environments with blockchain running. For that use your console to send transactions.
***********/

contract intermediary {
    address constant _myContract = 0xdc04977a2078c8ffdf086d618d1f961b6c546222;
    
    function sendDataToPayable(string _data) public returns (bool) {
        _myContract.delegatecall(keccak256(_data));
    }
}
