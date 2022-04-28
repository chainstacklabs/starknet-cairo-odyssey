## Smart contracts with Cairo

### Cairo basics

- wtf is felt
- storage variables, read and write
- arrays, how to create one and return it
- mappings
- function types: @view and @external

### A basic contract with Nile

## Front end and dApps

There is a starknet.js library for the frontend that injects a starknet object similar to `window.ethereum`. In addition, the or "get-starknet" `npm i get-starknet`

```js
import {getStartknet} from "@argent/get-starknet"

const starknet = getStarknet({showModal: true})

const [userAccountAddress] = await starknet.enable({showModal: true})

if(starknet.isConnected){
  //if connected, we can interact with contracts and sign transactions
  starknet.signer.invokeFunction({...})
}else{
  // we can still use the provider to query the blockchain
  starknet.provider.callContract(...)
}

```
