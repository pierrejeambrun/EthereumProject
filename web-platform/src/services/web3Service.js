var Web3 =require('web3');

console.log(Web3);

let web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));


let smart_contracts = [];


export default {
  init(context) {
    this.http = context.http;
  },
  prepareRequestBody(method, params) {
    return {
      jsonrpc: "2.0",
      method: method,
      params: params,
      id: 2
    }
  },
  sendContract(jsonInterface) {
    console.log("I'm in the service and I'm ok");
    console.log(jsonInterface);
    //let new_SC =  web3.eth.contract(jsonInterface);
    //this.smart_contracts.push(new_SC);
    //return new_SC;
  }
}
