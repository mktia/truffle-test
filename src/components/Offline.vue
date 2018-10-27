<template>
  <div class="app">
    <h2>POST YOUR IDEA</h2>
    <p v-if="account">アカウント: {{account}}</p>
    <p v-if="!account">アカウントが見つからないよ</p>
    <input v-model="newIdea" type="text" name="" value="" placeholder="なんか書いてみたら？">
    <button @click="postIdea">投稿</button>
    <ul>
      <li class="idea-box" v-for="idea in ideas">
        {{idea}}
      </li>
    </ul>
    <p v-if="contractAddress">コントラクトアドレス: {{contractAddress}}</p>
    <p v-if="!contractAddress">コントラクトアドレスが見つからないよ</p>
  </div>
</template>

<script>
// local
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../../build/contracts/IdeaFactory.json'
const IdeaFactory = contract(artifacts)

export default {
  name: 'Offline',
  data () {
    return {
      contractAddress: null,
      account: null,
      newIdea: null,
      ideas: [],
      instance: null
    }
  },
  created () {
    if (typeof web3 !== 'undefined') {
      // eslint-disable-next-line
      web3 = new Web3(web3.currentProvider)
    } else {
      console.warn("No web3 detected. Falling back to http://127.0.0.1:7545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask")

      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      // eslint-disable-next-line
      web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:7545'))
    }

    // eslint-disable-next-line
    IdeaFactory.setProvider(web3.currentProvider)

    // eslint-disable-next-line
    web3.eth.getCoinbase()
      .then((coinbase) => {
        IdeaFactory.defaults({from: coinbase})
      })

    // eslint-disable-next-line
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
    })

    IdeaFactory.deployed()
      .then((instance) => {
        var event = instance.NewIdea()
        event.watch((error, result) => console.log(result.args.content))
      })
  },
  mounted () {
    IdeaFactory.deployed()
      .then((instance) => {
        this.instance = instance
        this.instance.getIdeaCount()
          .then((count) => {
            for (var i = 0; i < count.toString(10); i++) {
              this.instance.getIdea(i)
                .then((idea) => this.ideas.unshift(idea))
            }
          })
      })
  },
  methods: {
    postIdea () {
      return IdeaFactory.deployed()
        .then((instance) => {
          this.instance = instance
          this.instance.comeUpWithIdea(this.newIdea)
            .then((id) => {
              this.instance.getIdea(id)
                .then((idea) => this.ideas.unshift(idea))
            })
        })
        .catch((error) => {
          console.error(error)
        })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
