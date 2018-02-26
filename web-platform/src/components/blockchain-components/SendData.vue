<template>
  <div class="justify-center flex" style="width: 70%; margin-left: 15%">
    <q-card inline style="width: 45%; background-color: white">
      <q-card-media overlay-position="bottom">
        <img src="~assets/solidity_data.png">
        <q-card-title slot="overlay">
          Call a Smart Contract
          <div slot="right" class="row items-center" style="color: white">
            <q-icon name="compare_arrows" /> Send Data
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
            <q-input v-model="receiver" @change="retrieveVulnerableContract()" type="text" float-label="Receiver"/>
            <q-input v-model="data" type="text" float-label="Data"/>
            <q-input v-model="gas" type="number" float-label="Gas"/>
            <q-input v-model="password" type="password" float-label="Password" />
            <div class="row justify-between">
              <div></div>
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
  import web3Service from "../../services/web3Service";

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
        data: null,
        gas: null,
        password: null,
        accountList: [],
        alert: null,
        balances: {},
        originalOwner: "",
        ownerEvent: null
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
        });
      },
      sendTransaction: function() {
        httpService.contactSmartContract(this.node.ip, this.sender, this.receiver, this.data, this.gas, 1, this.password).then((response) => {
          let transactionHash = response.body.result;
          this.clearAlerts();
          this.alert = Alert.create({ html: 'Your transaction has successfully been added to the pool. Hash : ' + transactionHash, color:'primary' });
          console.log(response);
        }, (error) => {
          this.clearAlerts();
          this.alert = Alert.create({ html: 'Your transaction could not be added to the pool. Please check you sent enough gas or that your connection is working' });
        });
      },
      clearAlerts: function () {
        if (this.alert != null) {
          this.alert.dismiss();
        }
      },
      retrieveVulnerableContract: function() {
        if (this.receiver == null || this.receiver == "") {
          return;
        }
        var contract = web3Service.retrieveVulnerableContract(this.receiver);
        contract._owner((error, result) => {
          if (!error) {
            this.originalOwner = result;
          } else {
            this.clearAlerts();
            this.alert = Alert.create({ html: 'SmartContract unreachable, please verify the Address', color:'primary' })
          }
        });
        this.ownerEvent = contract.changingOwner();
        this.ownerEvent.watch((error, result) => {
          if (!error) {
            this.clearAlerts();
            let newOwner = result.args[""]
            this.alert = Alert.create({ html: 'Owner changed from: ' + this.originalOwner + "<br>" + "to: " + newOwner });
            this.originalOwner = newOwner;
          }
        });
      }
    },
    beforeMount() {
      this.createdListAccounts();
    },
    destroyed() {
      this.clearAlerts();
      this.ownerEvent = null;
    }
  }
  //0x19ab453c000000000000000000000000ba4fde2b368a721995fe3a693789a9a7a4e0f79f
</script>
<style lang="stylus">

</style>
