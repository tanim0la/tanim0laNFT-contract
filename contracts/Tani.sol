// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract TaniNFT is ERC721, Ownable {
    string public baseURIextended;

    uint public totalSupply;
    uint public maxSupply;

    bool public notPaused;
    bool public revealed;

    address[] public addresses;

    mapping(address => bool) public minted;
    mapping(address => bool) public wl;

    bytes32 public root;

    constructor(uint _maxSupply) ERC721("Tanim0la NFT", "tanim0la") {
        maxSupply = _maxSupply;
    }

    function MintNft(bytes32[] memory proof) public {
        require(notPaused, "MINT IS PAUSED!!!");
        require(isValid(proof, keccak256((abi.encodePacked(msg.sender)))), "ADDRESS NOT WHITELISTED!!!");
        require(totalSupply < maxSupply, "MINTED OUT!!!");
        require(!minted[msg.sender], "MINTED ALREADY!!!");

        minted[msg.sender] = true;
        _safeMint(msg.sender, totalSupply);
        totalSupply++;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (revealed) {
            return super.tokenURI(tokenId);
        } else {
            return _baseURI();
        }
    }

    function setBaseURI(string memory _baseUri) external onlyOwner {
        baseURIextended = _baseUri;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURIextended;
    }

    function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
        return MerkleProof.verify(proof, root, leaf);
    }

    function setRoot(bytes32 _root) public onlyOwner {
        root = _root;
    }

    function pausable() public onlyOwner {
        notPaused = !notPaused;
    }

    function setRevealed() public onlyOwner {
        revealed = true;
    }

    function joinWl() public {
        require(!wl[msg.sender], "ALREADY WHITELISTED!!!");
        require(totalSupply < maxSupply, "WHITELIST CLOSED!!!");

        wl[msg.sender] = true;
        addresses.push(msg.sender);
    }

    function getAddresses() public view returns (address[] memory) {
        return addresses;
    }
}
