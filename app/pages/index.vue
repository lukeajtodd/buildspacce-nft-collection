<template>
  <div class="App">
    <div class="container">
      <div class="header-container">
        <p class="header gradient-text">My NFT Collection</p>
        <p class="sub-text">Each unique. Each beautiful. Discover your NFT today.</p>
        <template v-if="true">
          <NotConnected />
        </template>
      </div>
      <div class="footer-container">
        <!-- <img alt="Twitter Logo" class="twitter-logo" :src="twitterLogo" /> -->
        <a
          class="footer-text"
          :href="twitterLink"
          target="_blank"
          rel="noreferrer"
        >{{`built on @${twitterHandle}`}}</a>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
// import twitterLogo from '../static/twitter-logo.svg';
import NotConnected from '../components/NotConnected.vue'

const TWITTER_HANDLE = '_buildspace';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = '';
const TOTAL_MINT_COUNT = 50;

export default Vue.extend({
  data: () => ({
    twitterHandle: TWITTER_HANDLE,
    twitterLink: TWITTER_LINK,
    openseaLink: OPENSEA_LINK,
    totalMintCount: TOTAL_MINT_COUNT,
  }),
  components: {
    NotConnected: NotConnected
  }
})
</script>
