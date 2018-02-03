<template>
  <div class="justify-center fixed-center flex" style="width: 25%">
    <q-card inline style="width: 100%; background-color: white">
      <q-card-media overlay-position="bottom">
        <img src="~assets/ethereum_coin.jpg">
        <q-card-title slot="overlay">
          Transaction
          <div slot="right" class="row items-center">
            <q-icon name="compare_arrows" /> Send Money
          </div>
        </q-card-title>
      </q-card-media>
      <q-card-main>
        <div class="row" style="width:100%">
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
            <q-input v-model="gas" type="number" float-label="Gas"/>
            <q-input v-model="password" type="password" float-label="Password" />
            <div class="row justify-between">
              <q-btn color="primary" @click="gasEstimate()">Estimate</q-btn>
              <q-btn color="primary" @click="sendTransaction()">Send</q-btn>
            </div>
          </div>
        </div>
      </q-card-main>
</q-card>
  </div>
</template>

<script type="text/javascript">
  import httpService from "../../services/httpService";
  import { QSelect, QInput, QBtn, Alert, QCard, QCardTitle, QCardSeparator, QCardMain, QCardActions, QIcon, QCardMedia } from "quasar";

  export default {
    name: "send-transaction",
    components:{
      QSelect,
      QInput,
      QBtn,
      Alert,
      QCard,
      QCardTitle,
      QCardSeparator,
      QCardMain,
      QCardActions,
      QIcon,
      QCardMedia
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
      gasEstimate: function() {
        httpService.gasEstimate(this.node.ip, this.sender, this.receiver, this.amount).then((response)=>{
          let gasEstimate = parseInt(response.body.result);
          Alert.create({ html: 'You need to send ' + gasEstimate + ' Gas to mine your transaction !', color:'primary' });
        });
      },
      sendTransaction: function() {
        httpService.sendMoney(this.node.ip, this.sender, this.receiver, this.amount, this.gas, 1, this.password).then((response) => {
          let transactionHash = response.body.result;
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
