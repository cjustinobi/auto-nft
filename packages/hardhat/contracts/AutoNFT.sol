// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract AutoNFT is ERC721, ERC721Enumerable, ERC721URIStorage {

    address[] private customerAddresses;

    struct Product {
      string name;
      string imagePath;
      uint256 price;
    }

    Product[] public products;

    mapping(address => uint256) public purchaseCounts;

    mapping(address => bool) public userMinted;


    constructor() ERC721("Loyalty", "LTY") {
      products.push(Product("Gucci Bag", "gucci.jpg", 30000000000000000));
      products.push(Product("Zara Bag", "zara.jpg", 40000000000000000));
      products.push(Product("Nike Shoe", "nike.jpg", 50000000000000000));
    }

    function _baseURI() internal pure override returns (string memory) {
      return "https://ipfs.io/ipfs/QmdfZ1zpmKEdS3QjbYzLULhm1H1KAkDe8C5NPh9ZXu8r61/";
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
      super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
      return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
      return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
      super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function buyProduct(uint256 _productIndex) public payable {

      Product memory product = products[_productIndex];

      require(product.price == msg.value, "Incorrect product amount");

      if (!userMinted[msg.sender]) {

        uint256 tokenId = 0;
        string memory uri = "nft1.json";
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
        userMinted[msg.sender] = true;
      }


      purchaseCounts[msg.sender] ++;

      addCustomerAddress(msg.sender);
    }

    function getProducts() public view returns(Product[] memory) {
      return products;
    }

    function getTokenId() public view returns (uint256) {

      require(userMinted[msg.sender], "User has not NFT");

      // User will always have 1 token.
      uint256 tokenIndex = 0;

      return tokenOfOwnerByIndex(msg.sender, tokenIndex);

    }

    function upgradeCustomers(address _nftAddress) public {
      for (uint256 i = 0; i < customerAddresses.length; i++) {
        address customer = customerAddresses[i];

        uint256 point = purchaseCounts[customer];

        if (userMinted[customer]) {

        uint256 tokenId = ERC721Enumerable(_nftAddress).tokenOfOwnerByIndex(customer, 0);

        // Check if user can be upgraded.

        if (point < 2) {
            string memory uri = "nft1.json";
            _setTokenURI(tokenId, uri);
        } else if (point < 3) {
            string memory uri = "nft2.json";
            _setTokenURI(tokenId, uri);
        } else {
            string memory uri = "nft3.json";
            _setTokenURI(tokenId, uri);
        }

        } else {

          uint256 tokenId = 0;
          string memory uri = "nft1.json";
          _safeMint(customer, tokenId);
          _setTokenURI(tokenId, uri);
          userMinted[customer] = true;
        }
      }
    }

    function addCustomerAddress(address _address) private {
      bool exists = false;

      for (uint i = 0; i < customerAddresses.length; i++) {
        if (customerAddresses[i] == _address) {
          exists = true;
          break;
        }
      }

      if (!exists) {
        customerAddresses.push(_address);
      }
    }

}