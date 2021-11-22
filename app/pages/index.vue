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

interface BaseComponentData {
  connectedContract: ethers.Contract | null
  currentAccount: string | null
  twitterHandle: string
  twitterLink: string
  openseaLink: string
  totalMintCount: number
}

export default Vue.extend({
  data(): BaseComponentData {
    return {
      connectedContract: null,
      currentAccount: null,
      twitterHandle: TWITTER_HANDLE,
      twitterLink: TWITTER_LINK,
      openseaLink: OPENSEA_LINK,
      totalMintCount: TOTAL_MINT_COUNT,
    }
  },
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
    async verifyRinkebyNetwork() {
      // @ts-ignore
      const { ethereum } = window

      if (!ethereum) {
        console.log('Make sure you have Metamask!')
        return
      }

      const network = await ethereum.request({ method: 'eth_chainId' })

      if (network !== '0x4') {
        console.log('Make sure you are on the Rinkeby network!')
        return
      }
    },
    async connectWallet() {
      await this.verifyRinkebyNetwork()
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
    configureConnectedContract() {
      // @ts-ignore
      const { ethereum } = window
      const CONTRACT_ADDRESS = "0x2FC3E8d35C3D2798221ED7d601DE6Ee77257D0BF"

      if (!ethereum) {
        console.log("Ethereum object doesn't exist!")
        return false
      }

      if (this.connectedContract) {
        return this.connectedContract
      } else {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();

        this.connectedContract = new ethers.Contract(CONTRACT_ADDRESS, NFT.abi, signer)
        if (this.connectedContract) {
          this.connectedContract.on("NewNFTMinted", (from, tokenId) => {
            console.log(from, tokenId.toNumber())
            alert(`Hey there! We've minted your NFT. It may be blank right now. It can take a max of 10 min to show up on OpenSea. Here's the link: <https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}>`)
          })
        }
      }
    },
    async askContractToMintNft() {
      try {
        await this.configureConnectedContract()

        if (!this.connectedContract) {
          console.log("Contract not connected!")
          return
        }

        console.log("Going to pop wallet now to pay gas...")
        let nftTxn = await this.connectedContract.make();

        console.log("Mining...please wait.")
        await nftTxn.wait();
        console.log(nftTxn)

        console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);
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
