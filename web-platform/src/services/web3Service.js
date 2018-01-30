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
  //Compile une string et renvoie l'objet smart contract compilé prêt à l'utilisation
  compile(code){
    var output=solc.compileStandardWrapper({
      sources : {
        "mycontract":
          {
            content: code
          }
      }
    }, 1);
    console.log(output.contracts);
    return output;
  }
}
