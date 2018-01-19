export default {

  init(context) {
    this.http = context.http;
  },

  sendRequest() {
    this.http.get('https://httpbin.org/get').then(response =>
      {
        console.log("Refreshed! ");
        console.log(response.data);
      });
  }
}