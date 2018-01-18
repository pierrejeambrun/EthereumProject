# README

### Prerequisite
If your node is supposed to be mining, you need to have at least 4GB of RAM of the local machine running your node

### Launch your private blochain
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

Launch your private blockchain
```shell
geth --nodiscover --datadir data/db --networkid 15 --rpc --rpcapi personal,web3,eth,accounts,admin,miner,net,txpool --identity block1 --rpccorsdomain "*" --rpcaddr <ip> --mine --gasprice "1"
```

