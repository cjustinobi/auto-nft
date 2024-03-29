import { providers, Contract } from 'ethers'
import axios  from 'axios'
import { priceToWei } from './helpers'
import JustinNFT from '../AutoNFT.json'

export const contractAddress = '0xB711A451516ED7cC4427f8D8a94093aEC62C60c7'

export async function getContract() {

  let auctionContract

  try {
    const { ethereum } = window

    const provider = new providers.Web3Provider(ethereum)
    const signer = provider.getSigner()
    auctionContract = new Contract(contractAddress, JustinNFT.abi, signer)

  } catch (error) {
    console.log("ERROR:", error)
  }
  return auctionContract
}

export const createNFT = async (NFTURI, price) => {
  try {
    const contract = await getContract()
    const res = await contract.createNFT(NFTURI, price)
    return await res.wait()
  } catch (e) {
    console.log(e)
  }
}

export const buyProduct = async (index, price) => {

  try {
    const contract = await getContract()
    let res = await contract.buyProduct(index, {value: priceToWei(price)})
    res = await res.wait()
    console.log('bidd ', res)
    return res

  } catch (e) {
    console.log(e)
    console.log('e here', e)
  }
}

export const getProducts = async () => {

  try {
    const contract = await getContract()
    return await contract.getProducts()

  } catch (e) {
    console.log(e)
  }
}

export const getNFT = async () => {

  try {
    let NFT = undefined
    const contract = await getContract()
    const tokenId = await contract.getTokenId()
    if (tokenId) {
      const tokenURI = await contract.tokenURI(tokenId)
      NFT = await getNFTMeta(tokenURI)
    }
    return NFT

  } catch (e) {
    console.log(e)
  }
}

export const getNFTMeta = async URI => {
  try {
    return (await axios.get(URI)).data
  } catch (e) {
    console.log({ e })
  }
}


