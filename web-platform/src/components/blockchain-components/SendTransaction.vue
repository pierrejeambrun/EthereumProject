<template>
  <div class="justify-center flex">
    <div class="row" style="width:30%">
      <div style="width: 100%">
        <q-select
          float-label="Sender"
          v-model="sender"
          :options="accountList"
        />
        <q-select
          float-label="Receiver"
          v-model="receiver"
          :options="accountList"
        />
        <q-input v-model="amount" type="number" float-label="Amount"/>
        <q-input v-model="gas" type="number" float-label="Gas Amount"/>
        <q-input v-model="password" type="password" float-label="Password" />
        <div class="row justify-between">
          <q-btn color="primary" @click="gasEstimate(node.ip, sender, receiver, amount)">Gas Estimate</q-btn>
          <q-btn color="primary" @click="sendTransaction(node.ip, sender, receiver, amount, gas, password)">Send the transaction</q-btn>
        </div>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
  import httpService from "../../services/httpService";
  import { QSelect, QInput, QBtn, Alert } from "quasar";

  export default {
    name: "send-transaction",
    components:{
      QSelect,
      QInput,
      QBtn,
      Alert
    },
    data: function(){
      return {
        node: this.$store.state.selectedNode,
        sender: null,
        receiver: null,
        amount: null,
        gas: null,
        password: null,
        accountList: []
      }
    },
    methods: {
      createdListAccounts: function() {
        httpService.listAccounts(this.node.ip).then((response)=> {
          let rawAccounts = response.body.result;
          let temp = [];
          for (let account of rawAccounts) {
            temp.push({value: account, label: account});
          }
          this.accountList = temp;
        })
      },
      gasEstimate: function(ip, sender, receiver, amount) {
        httpService.gasEstimate(ip, sender, receiver, amount).then((response)=>{
          let amount=response.body.result;
          Alert.create({ html: 'You need to send ' + parseInt(amount, 16) + ' Gas to mine your transaction !', color:'primary' });
        });
      },
      sendTransaction: function(ip, sender, receiver, amount, gas, password) {
        httpService.sendMoney(ip, sender, receiver, amount, gas, 1, password).then((response) => {
          let transactionHash= response.body.result;
          Alert.create({ html:'Your transaction has successfully been added to the pool. Hash : ' + transactionHash, color:'primary' });
        }, (error) => {
          Alert.create({ html:'Your transaction could not be added to the pool. Please check you sent enough gas or that your connection is working' });
        });
      }
    },
    beforeMount() {
      this.createdListAccounts();
    }
  }
</script>

<style lang="stylus">

</style>
