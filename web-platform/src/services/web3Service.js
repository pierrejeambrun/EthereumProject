var Web3 = require('web3');

export default {
  init(defaultIp) {
    this.web3 = new Web3(new Web3.providers.HttpProvider("http://" + defaultIp + ":8545"));    
  },
  retrieveVulnerableContract(contractAddress) {
    var ABI = require("../../../smart_contract/baseVulnerableContract.json");
    var contract = this.web3.eth.contract(ABI);
    contract = contract.at(contractAddress);
    return contract;
  }
}
