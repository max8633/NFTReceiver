// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {NoUseful, HW_Token, NFTReceiver} from "../src/ERC721andReceiver.sol";

contract EREC721andReceiverTest is Test{

    NoUseful public NoUsefulContract;
    HW_Token public HWTContract;
    NFTReceiver public NFTContract;
    address user1;

    function setUp() public{
        NoUsefulContract = new NoUseful();
        HWTContract = new HW_Token();
        NFTContract = new NFTReceiver(address(NoUsefulContract), address(HWTContract));
        user1 = makeAddr("user1");
    }

    function test_sender_get_originalNFT_and_NONFT() public{
        vm.startPrank(user1);
        NoUsefulContract.mint(user1, 10);
        NoUsefulContract.setApprovalForAll(address(NFTContract), true);
        NoUsefulContract.safeTransferFrom(user1, address(NFTContract), 10);

        assertEq(NoUsefulContract.balanceOf(user1), 1);
        assertEq(HWTContract.balanceOf(user1), 1);

        vm.stopPrank();
    }
}