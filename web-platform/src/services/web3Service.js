var Web3 = require('web3');

var mockGraph = require("../assets/data/blockChainNodes.json");

var web3 = new Web3(new Web3.providers.HttpProvider("http://" + mockGraph.nodes[0].ip + ":8545"));

export default {
  retrieveVulnerableContract(contractAddress) {
    var ABI = require("../../../smart_contract/baseVulnerableContract.json");
    var contract = web3.eth.contract(ABI);
    contract = contract.at(contractAddress);
    return contract;
  }
}
