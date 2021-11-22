<template>
  <div class="App">
    <div class="container">
      <div class="header-container">
        <p class="header gradient-text">My NFT Collection</p>
        <p class="sub-text">Each unique. Each beautiful. Discover your NFT today.</p>
        <template v-if="!currentAccount">
          <NotConnected :connectWallet="connectWallet" />
        </template>
        <template v-else>
          <button @click="askContractToMintNft" class="cta-button connect-wallet-button">Mint NFT</button>
        </template>
      </div>
      <div class="footer-container">
        <!-- <img alt="Twitter Logo" class="twitter-logo" :src="twitterLogo" /> -->
        <a
          class="footer-text"
          :href="twitterLink"
          target="_blank"
          rel="noreferrer"
        >{{ `built on @${twitterHandle}` }}</a>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { ethers } from 'ethers'
// import twitterLogo from '../static/twitter-logo.svg';
// @ts-ignore
import NotConnected from '../components/NotConnected.vue'
import NFT from '../utils/NFT.json'

const TWITTER_HANDLE = '_buildspace';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = '';
const TOTAL_MINT_COUNT = 50;

export default Vue.extend({
  data: () => ({
    currentAccount: null,
    twitterHandle: TWITTER_HANDLE,
    twitterLink: TWITTER_LINK,
    openseaLink: OPENSEA_LINK,
    totalMintCount: TOTAL_MINT_COUNT,
  }),
  methods: {
    async checkIfWalletConnected() {
      // @ts-ignore
      const { ethereum } = window

      if (!ethereum) {
        console.log('Make sure you have Metamask!')
        return
      }

      const accounts = await ethereum.request({ method: 'eth_accounts' })

      if (accounts.length !== 0) {
        const account = accounts[0]
        console.log('Found an authorised account: ', account)
        this.currentAccount = account
      } else {
        console.log('No accounts found')
      }
    },
    async connectWallet() {
      try {
        // @ts-ignore
        const { ethereum } = window;

        if (!ethereum) {
          alert("Get MetaMask!");
          return;
        }

        /*
        * Fancy method to request access to account.
        */
        const accounts = await ethereum.request({ method: "eth_requestAccounts" });

        /*
        * Boom! This should print out public address once we authorize Metamask.
        */
        console.log("Connected", accounts[0]);
        this.currentAccount = accounts[0];
      } catch (error) {
        console.log(error)
      }
    },
    async askContractToMintNft() {
      const CONTRACT_ADDRESS = "0xFa3C9DC7339520D5e29720cC4805F974A89DcD53";
      try {
        // @ts-ignore
        const { ethereum } = window;

        if (ethereum) {
          const provider = new ethers.providers.Web3Provider(ethereum);
          const signer = provider.getSigner();
          const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, NFT.abi, signer);

          console.log("Going to pop wallet now to pay gas...")
          let nftTxn = await connectedContract.make();

          console.log("Mining...please wait.")
          await nftTxn.wait();
          console.log(nftTxn)

          console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);

        } else {
          console.log("Ethereum object doesn't exist!");
        }
      } catch (error) {
        console.log(error)
      }
    }
  },
  mounted() {
    this.checkIfWalletConnected()
  },
  components: {
    NotConnected: NotConnected
  }
})
</script>
