<script setup>
import { onMounted, ref } from 'vue'

import { connect } from '@argent/get-starknet'

import {} from '@argent/get-starknet'

import ContractInterface from '../contracts/secretNumber.json'

let starknet = null

// Let the user pick a wallet (on button click)
// const starknet = connect()

// or try to connect to an approved wallet silently (on mount probably)
// const starknet = connect({ showList: false })

defineProps({
  msg: String,
})

const count = ref(0)
const walletConnected = ref(false)
const userNum = ref(0)

const savedNumber = ref(0)

const CONTRACT_ADDRESS =
  '0x07955c619cb22d08ece120ef4f5faa531318ac9934018ef28fdae9284b831b4d'

const saveNumber = async () => {
  try {
    const trxDetails = await starknet.account.execute(
      {
        contractAddress: CONTRACT_ADDRESS,
        entrypoint: 'save_number',
        calldata: [userNum.value],
      }
      // undefined,
      // { maxFee: 0 }
    )
    console.log('trxDetails', trxDetails)
  } catch (error) {
    console.error(error)
  }
}

const getUserNumber = async () => {
  try {
    const res = await starknet.provider.callContract(
      {
        contractAddress: CONTRACT_ADDRESS,
        entrypoint: 'get_number',
      }
      // undefined,
      // {}
    )
    console.log('res', res)
    savedNumber.value = Number(`${res.result[0]}`)
  } catch (error) {
    console.error(error)
  }
}

const connectWallet = async () => {
  starknet = await connect()
  console.log('startknet >>', starknet)

  if (!starknet) {
    throw Error(
      'User rejected wallet selection or silent connect found nothing'
    )
  }

  // (optional) connect the wallet
  await starknet.enable()

  // Check if connection was successful
  if (starknet.isConnected) {
    console.log('starknet connected')
    walletConnected.value = true
    // If the extension was installed and successfully connected, you have access to a starknet.js Signer object to do all kinds of requests through the user's wallet contract.
    // starknet.account.execute({  })
    getUserNumber()
  } else {
    console.log('starknet wallet not connected')
    // In case the extension wasn't successfully connected you still have access to a starknet.js Provider to read starknet states and sent anonymous transactions
    // starknet.provider.callContract( ... )
  }
}
</script>

<template>
  <h3>Save your number</h3>

  <button type="button" @click="connectWallet" v-if="!walletConnected">
    Connect wallet
  </button>
  <div class="" v-else>
    <input type="number" name="" id="" v-model="userNum" />
    <button type="button" @click="saveNumber" v-if="walletConnected">
      Save number
    </button>

    <p>Your saved number is: {{ savedNumber }}</p>
  </div>
</template>

<style scoped>
a {
  color: #42b983;
}
</style>
