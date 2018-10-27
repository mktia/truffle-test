<template>
  <div class="app">
    <h2>POST YOUR IDEA</h2>
    <p v-if="account">アカウント: {{account}}</p>
    <p v-if="!account">アカウントが見つからないよ</p>
    <input v-model="newIdea" type="text" name="" value="" placeholder="なんか書いてみたら？">
    <button @click="postIdea">投稿</button>
    <ul>
      <li v-for="idea in ideas">
        {{idea.content}}
      </li>
    </ul>
    <p v-if="contractAddress">コントラクトアドレス: {{contractAddress}}</p>
    <p v-if="!contractAddress">コントラクトアドレスが見つからないよ</p>
  </div>
</template>

<script>
/* eslint-disable */
const Web3 = require('web3')

const json = require('../../build/contracts/IdeaFactory.json')
const address = '0xf86ed6781b020b00a6b0ba0f8c6d8e08c8e59be6'
// eslint-disable-next-line
const IdeaFactory = web3.eth.contract(json.abi).at(address)

export default {
  name: 'Online',
  data () {
    return {
      contractAddress: address,
      account: null,
      newIdea: null,
      ideas: []
    }
  },
  created () {
    if (typeof web3 !== 'undefined') {
      web3 = new Web3(web3.currentProvider)
    } else {
      console.warn("No web3 detected. Falling back to http://127.0.0.1:7545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask")

      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      web3 = new Web3('http://127.0.0.1:7545')
    }

    // IdeaFactory.setProvider(web3.currentProvider)
    /*
    web3.eth.getCoinbase()
      .then((coinbase) => {
        IdeaFactory.defaults({from: coinbase})
      })*/

    web3.eth.getAccounts((error, accounts) => {
      if (error != null) {
        console.error(error)
        this.message = 'There was an error fetching your accounts. Do you have Metamask, Mist installed or an Ethereum node running? If not, you might want to look into that.'
        return
      }
      if (accounts.length === 0) {
        this.message = 'Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.'
        return
      }
      this.account = accounts[0]
      this.contractAddress = address
    })
  },
  methods: {
    postIdea () {
      /*
      return IdeaFactory.comeUpWithIdea(this.newIdea)
        .then(() => {
          IdeaFactory.getIdeaCount()
            .then((count) => {
              for (var i = 0; i < count; i++) {
                IdeaFactory.getIdea()
                  .then((idea) => {
                    this.ideas.push(idea)
                  })
              }
            })
        })
        .catch((error) => {
          console.error(error)
        })*/
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
