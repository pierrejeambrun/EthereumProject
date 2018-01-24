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
