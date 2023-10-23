// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

//0x7c28E6B101d464Fe78C1b660FbaC72dcf1AeFe72
contract NoUseful is ERC721 {
    //EOA should mint token and call safeTransferFrom in this ERC721 contract first.
    constructor() ERC721("NoUseful Token", "NUT") {}

    function mint(address _to, uint256 _tokenId) external {
        _mint(_to, _tokenId);
    }
}

//0x48D88Bd99c814c51BEE2c3E98Eec27ADbe20Fa08
contract HW_Token is ERC721 {
    //1. create a ERC721 token with name = "" symbol = ""
    //2. Write a mint function to mint the static ERC721 token.
    //3. The NFT is always return the same metadata. pls check the homework description.
    constructor() ERC721("Dont send NFT to me", "NONFT") {}

    uint256 tId = 1;

    function mint(address to) public{
        uint256 _tokenId;
        _tokenId = tId;
        _mint(to, tId);
        _tokenId++;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return baseURI;
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://QmPpM63wjy6vrGEzWEuEinCuFnn45NuLK9T9x342Eskko8";
    }
}

//0x3279b25B5D446aeDEA9b1FA6f13A9D4904815809
contract NFTReceiver is IERC721Receiver {

    address NoUsefulContract;
    address HWTokenContract;

    constructor(address _NoUsefulContract, address _HWTokenContract){
        NoUsefulContract = _NoUsefulContract;
        HWTokenContract = _HWTokenContract;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) public returns (bytes4) {
        //1. Check the msg.sender(NoUseful contract) is same as your HW_Token.
        //2. If not, please transfer the NoUseful token back to the original owner.
        //3. and also mint HW_Token for the original owner.

        if ( msg.sender != HWTokenContract){
            ERC721(NoUsefulContract).transferFrom(address(this), from, tokenId);
            (bool success, ) = HWTokenContract.call(abi.encodeWithSignature("mint(address)", from));
            require(success,"mint HW_Token fail");
            return this.onERC721Received.selector;
        }
        else return this.onERC721Received.selector;
    }
}