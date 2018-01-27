<template>
  <div>
    <q-tabs v-if="block">
      <!-- Tabs - notice slot="title" -->
      <q-tab default slot="title" name="tab-1" label="Genereal" />
      <q-tab slot="title" name="tab-2" label="Transactions" />
      <q-tab slot="title" name="tab-3" label="Details" />
      <!-- Targets -->

      <!-- Tab 1 -->
      <q-tab-pane name="tab-1">
        <table class="q-table horizontal-separator">
          <thead>
            <tr>
              <th>Key</th>
              <th>Value</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="text-left" data-th="Key">Block Id</td>
              <td class="text-left" data-th="Value">{{ block.result.id }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Number of Transactions</td>
              <td class="text-left" data-th="Value">{{ block.result.transactions.length }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Difficulty</td>
              <td class="text-left" data-th="Value">{{ block.result.difficulty }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Miner Hash</td>
              <td class="text-left" data-th="Value">{{ block.result.miner }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Block Date</td>
              <td class="text-left" data-th="Value">{{ new Date(parseInt(block.result.timestamp * 1000)) }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Parent Hash</td>
              <td class="text-left" data-th="Value">{{  block.result.parentHash }}</td>
            </tr>
          </tbody>
        </table>
      </q-tab-pane>

      <!-- Tab 2 -->
      <q-tab-pane name="tab-2">
        <table v-if="block.result.transactions.length" class="q-table horizontal-separator">
          <thead>
            <tr>
              <th>From</th>
              <th>To</th>
              <th>Value</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="transaction in block.result.transactions">
              <td class="text-left" data-th="Key">{{ transaction.from }}</td>
              <td class="text-left" data-th="Value">{{ transaction.to }}</td>
              <td class="text-left" data-th="Value">{{ parseInt(transaction.value, 16) }}</td>
            </tr>
          </tbody>
        </table>
        <div v-else>
          There is 0 transation for this block
        </div>
      </q-tab-pane>

      <!-- Tab 3 -->
      <q-tab-pane name="tab-3">
                <table class="q-table horizontal-separator">
          <thead>
            <tr>
              <th>Key</th>
              <th>Value</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="text-left" data-th="Key">Gas Used</td>
              <td class="text-left" data-th="Value">{{ block.result.gasUsed }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Nounce</td>
              <td class="text-left" data-th="Value">{{ block.result.nonce }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Total Difficulty</td>
              <td class="text-left" data-th="Value">{{  block.result.totalDifficulty }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Size</td>
              <td class="text-left" data-th="Value">{{  block.result.size }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Receipts Root</td>
              <td class="text-left" data-th="Value">{{ block.result.receiptsRoot }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Uncles sha3</td>
              <td class="text-left" data-th="Value">{{ block.result.sha3Uncles }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Mix hash</td>
              <td class="text-left" data-th="Value">{{ block.result.mixHash }}</td>
            </tr>
            <tr>
              <td class="text-left" data-th="Key">Transaction Root</td>
              <td class="text-left" data-th="Value">{{  block.result.transactionsRoot }}</td>
            </tr>
          </tbody>
        </table>
      </q-tab-pane>
    </q-tabs>
  </div>
</template>

<script type="text/javascript">
import { QSideLink, QTabs, QTabPane, QTab } from 'quasar';

export default {
  name: 'dashboard',
  components: {
    QSideLink,
    QTabs,
    QTabPane,
    QTab
  },
  data: function () {
    return {
      selectedTab: 'tab-2'
    }
  },
  props: [
    'block'
  ],
  computed: {
  },
  methods: {
  },
  mounted() {
  },
  beforeDestroy() {
  }
}  
</script>

<style lang="stylus">
</style>