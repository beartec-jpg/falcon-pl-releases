# DRAFT, not published: Falcon Testnet Transparency Report, 21 October 2026

## Summary
Falcon runs a public test network with bridges to Bitcoin (testnet4) and Ethereum. Both bridges work end to end on test networks. Neither is live on mainnet, and none is planned yet. The Bitcoin bridge is designed so that no single party, Falcon included, can take user funds. It shouldn't be called proven non-custodial until an outside review and a multi-party key ceremony are complete.

## Network
1. Release 2.9.75 is running on all nine active validator seats. It is signed, published and available through the public installer, which has been checked with both a fresh install and an upgrade.
2. 2.9.75 combines the Bitcoin and Ethereum bridge changes and switches the new Bitcoin testnet4 bridge on at ledger block 730,000, expected around 27 to 28 October.
3. Outside node operators need to upgrade before that block.

## Bitcoin bridge (testnet4)
What's built: users deposit test bitcoin and receive the matching amount on Falcon. Withdrawals pay test bitcoin back out. If anything stalls, built-in refund and timeout paths return the funds. Independent operators front each payout and claim it back afterwards. If an operator makes a false claim, anyone can publish a "Disprove" transaction that blocks the claim and takes the operator's bond.

What has been shown to work:
1. **Full private test network (regtest):** every path passed, including an honest deposit and withdrawal, a false claim disproved with the cheating operator's bond fully taken (100% slash), and a cheating claim challenged.
2. **Public Bitcoin testnet4:** a real deposit, a refund, an honest operator payout and a stall timeout all completed on-chain.
3. **Falcon's public signet:** a cheating operator was caught by a Disprove transaction and both of its payouts were refused. The transactions can be seen at https://signet.falcon-fpl.com.
4. **Safety rules:** a deposit is refused unless every operator's presigned transactions are recorded on the Falcon ledger first. A claim that gets stuck can be refunded.
5. **Operator software:** it's running on three operators. Each one's Disprove sender is connected to the public signet node at signet.falcon-fpl.com:38333.

Still to do on testnet: after activation, a real deposit made through the website. Until that passes, the Bridge page stays switched off.

## Ethereum bridge
1. ETH and USDC deposits mint on Falcon automatically through one shared signing account, with a lock so only one mint runs at a time.
2. **Incident, 19 to 20 October:** during the 2.9.74 restarts, most seats lost the minting account's key, and two user deposits (640 USDC and 0.08 ETH) went unminted for about 31 hours. Both were minted by hand on 20 October and no funds were lost. The permanent fix makes each seat save its keys so they survive a restart, and it ships in 2.9.75.
3. An hourly automatic check now looks for any unminted deposit. It was corrected on 21 October.
4. **Known gap:** that check doesn't yet cover the newest deposit contract (V3). The fix is pending.

## Test funds
Operators are funded from public testnet4 faucets. Several faucets were unreliable this month: two weren't paying out and one kept failing its captcha. Top-ups are flowing again from coinfaucet.eu, CypherFaucet and eternitybits.

## What's still needed before mainnet
1. An independent outside security review.
2. A multi-party key ceremony, so no single party holds the setup secrets.
3. Confirmation that the largest Disprove transactions, close to Bitcoin's block size limit, can be reliably mined, for example through a mining-pool service.
4. Connecting the operator registry to the Falcon ledger, so anyone can join as an operator without approval.

Until these are done, the Bitcoin bridge is working and trust-minimised in design, but not yet independently proven non-custodial.
