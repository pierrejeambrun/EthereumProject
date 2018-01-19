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
  getBlockNumber(ip) {
    var data = this.prepareRequestBody("eth_blockNumber", []);
    return this.http.post('http://' + ip + ":8545", data);
  }
}