<template>
  <div class="justify-center flex" style="width: 70%; margin-left: 15%">
    <q-card inline style="width: 45%; background-color: white">
      <q-card-media overlay-position="bottom">
        <img src="~assets/ethereum_coin.jpg">
        <q-card-title slot="overlay">
          Transaction
          <div slot="right" class="row items-center" style="color: white">
            <q-icon name="monetization_on" /> Send Money
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
    <q-card inline style="width: 45%; background-color: white;">
      <q-card-media overlay-position="bottom">
        <img src="~assets/ethereum_coin.jpg">
        <q-card-title slot="overlay">
          Account Balance
          <div slot="right" class="row items-center" style="color: white">
            <q-icon name="account balance" /> Balance
          </div>
        </q-card-title>
      </q-card-media>
      <q-card-main style="overflow: auto">
       <table class="q-table horizontal-separator loose">
          <thead>
            <tr>
              <th>Account</th>
              <th>Balance</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(value, key) in balances">
              <td class="text-left" data-th="Account">{{ key }}</td>
              <td class="text-left" data-th="Balance">{{ value }}</td>
            </tr>
          </tbody>
        </table>
      </q-card-main>
    </q-card>
  </div>
</template>

<script type="text/javascript">
  import httpService from "../../services/httpService"
  import { QSelect, QInput, QBtn, Alert, QCard, QCardTitle, QCardSeparator, QCardMain, QCardActions, QIcon, QCardMedia } from "quasar"

  export default {
    name: "send-money",
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
    data: function() {
      return {
        node: this.$store.state.selectedNode,
        sender: null,
        receiver: null,
        amount: null,
        gas: null,
        password: null,
        accountList: [],
        alert: null,
        balances: {},
        timer: null
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
          this.fetchBalances();
        });
      },
      gasEstimate: function() {
        httpService.gasEstimate(this.node.ip, this.sender, this.receiver, this.amount).then((response)=>{
          let gasEstimate = parseInt(response.body.result, 16);
          this.clearAlerts();
          this.alert = Alert.create({ html: 'You need to send ' + gasEstimate + ' Gas to mine your transaction !', color:'primary' });
        });
      },
      sendTransaction: function() {
        httpService.sendMoney(this.node.ip, this.sender, this.receiver, this.amount, this.gas, 1, this.password).then((response) => {
          let transactionHash = response.body.result;
          this.clearAlerts();
          this.alert = Alert.create({ html:'Your transaction has successfully been added to the pool. Hash : ' + transactionHash, color:'primary' });
        }, (error) => {
          Alert.create({ html:'Your transaction could not be added to the pool. Please check you sent enough gas or that your connection is working' });
        });
      },
      clearAlerts: function () {
        if (this.alert != null) {
          this.alert.dismiss();
        }
      },
      fetchBalances: function() {
        console.log("Fetching balances");
        for (let account of this.accountList) {
          httpService.getBalance(this.node.ip, account.value, "latest").then((response) => {
            this.balances[account.value] = parseInt(response.body.result, 16);
            this.$forceUpdate();
          });
        }
      }
    },
    beforeMount() {
      this.createdListAccounts();
      if (this.timer == null) {
        this.timer = setInterval(() => this.fetchBalances(), 2000);
      }
    },
    destroyed() {
      this.clearAlerts();
      clearInterval(this.timer);
    }
  }
</script>

<style lang="stylus">

</style>
