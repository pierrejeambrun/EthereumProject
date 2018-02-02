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
  formatHex(number) {
    return "0x" + number.toString(16);
  },
  // Miner
  startMiner(ipAddress) {
    var data = this.prepareRequestBody("miner_start", []);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },
  isMining(ipAddress) {
    var data = this.prepareRequestBody("eth_mining", []);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },
  setEtherBase(ipAddress, accountAddress) {
    var data = this.prepareRequestBody("miner_setEtherbase", [accountAddress]);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },

  // State
  getBlockNumber(ipAddress) {
    var data = this.prepareRequestBody("eth_blockNumber", []);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },
  getBlockByNumber(ipAddress, blockId) {
    var data = this.prepareRequestBody("eth_getBlockByNumber", [this.formatHex(blockId), true]);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },
  getPendingTransactions(ipAddress) {
    var data = this.prepareRequestBody("txpool_content", []);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },

  // Account
  createNewAccount(ipAddress, password) {
    var data = this.prepareRequestBody("personal_newAccount", [password]);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },
  getBalance(ipAddress, accountAddress, blockId) {
    if (blockId == null) {
      blockId = "latest";
    } else {
      if (typeof blockId == "number") {
        blockId = this.formatHex(blockId);
      }
    }
    var data = this.prepareRequestBody("eth_getBalance", [accountAddress, blockId]);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },
  gasEstimate(ipAddress, fromAddress, toAddress, value) {
    let params = {
      from: fromAddress,
      to: toAddress,
      value: this.formatHex(value)
    }
    var data = this.prepareRequestBody("eth_estimateGas", [params]);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },
  listAccounts(ipAddress) {
    var data = this.prepareRequestBody("personal_listAccounts", []);
    return this.http.post('http://' + ipAddress + ":8545", data);
  },
  sendMoney(ipAddress, fromAddress, toAddress, value, gas, gasPrice, password) {
    let params = {
      from: fromAddress,
      to: toAddress,
      value: this.formatHex(value),
      gas: this.formatHex(gas),
      gasPrice: this.formatHex(gasPrice)
    }
    var data = this.prepareRequestBody("personal_sendTransaction", [params, password]);
    return this.http.post('http://' + ipAddress + ":8545", data);
  }
}