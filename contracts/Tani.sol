// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract TaniNFT is ERC721, Ownable {
    string public baseURIextended;

    uint256 private id = 5000;
    uint256 public constant maxSupply = 5000;

    bool public notPaused;
    bool private revealed;

    mapping(address => bool) private minted;
    mapping(address => bool) private wl;

    bytes32 public root;

    constructor() ERC721("Tanim0la NFT", "tanim0la") {}

    function MintNft(bytes32[] memory proof) public {
        address _sender = msg.sender;
        require(notPaused, "MINT IS PAUSED!!!");
        require(isValid(proof, keccak256((abi.encodePacked(_sender)))), "ADDRESS NOT WHITELISTED!!!");
        unchecked{require(id > 0, "MINTED OUT!!!");}
        require(!minted[_sender], "MINTED ALREADY!!!");

        minted[_sender] = true;
        unchecked {
            _mint(_sender, id);
            id--;
        }

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

    function pausable(bool _state) public onlyOwner {
        notPaused = _state;
    }

    function setRevealed() public onlyOwner {
        revealed = true;
    }

    function joinWl() public {
        address _sender = msg.sender;
        require(!wl[_sender], "ALREADY WHITELISTED!!!");
        unchecked {require(id > 0, "WHITELIST CLOSED!!!");}
        wl[_sender] = true;
    }

    function totalMinted() external view returns (uint256){
        return maxSupply-id;
    }
}
