// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/GLOW.sol";
import "../src/TokenDistributionManager.sol";
import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

contract GLOWTEST is Test {

    GLOW public glow;
    VestingWallet public vestingCommunity;     // community
    VestingWallet public vestingInvestors;    // investors
    VestingWallet public vestingFoundation;    // foundation
    VestingWallet public vestingTreasury;    // treasury
    TokenDistributionManager public tokenDistributionManager;

    address public owner;
    address public community;
    address public investors;
    address public foundation;
    address public treasury;
    address public initialLiquidity;
    uint64 constant month = 60*60*24*30;
    uint64 constant year = 60*60*24*365;

    function setUp() public {
        owner = vm.addr(7);

        vm.startPrank(owner);
        community = vm.addr(1);
        investors = vm.addr(2);
        foundation = vm.addr(3);
        treasury = vm.addr(4);
        initialLiquidity = vm.addr(5);

        tokenDistributionManager = new TokenDistributionManager(owner);

        vm.stopPrank();
    }

    function test() public {
        vm.startPrank(owner);

        /**
            TokenDistribution을 통해, execute하여 GLOW 생성, 각 vestingWallet 생성 및 토큰 분배
        */

        tokenDistributionManager.execute(
            community,
            investors,
            foundation,
            treasury,
            initialLiquidity
        );

        glow = GLOW(tokenDistributionManager.glow());

        vestingCommunity = VestingWallet(tokenDistributionManager.vestingCommunity());
        vestingInvestors = VestingWallet(tokenDistributionManager.vestingInvestors());
        vestingFoundation = VestingWallet(tokenDistributionManager.vestingFoundation());
        vestingTreasury = VestingWallet(tokenDistributionManager.vestingTreasury());

        console.log("vestingCommunity: ", address(vestingCommunity));
        console.log("vestingCommunity Balance: ", glow.balanceOf(address(vestingCommunity)));

        console.log("vestingInvestors: ", address(vestingInvestors));
        console.log("vestingInvestors Balance: ", glow.balanceOf(address(vestingInvestors)));

        console.log("vestingFoundation: ", address(vestingFoundation));
        console.log("vestingFoundation Balance: ", glow.balanceOf(address(vestingFoundation)));

        console.log("vestingTreasury: ", address(vestingTreasury));
        console.log("vestingTreasury Balance: ", glow.balanceOf(address(vestingTreasury)));

        // year == lockup끝나는날, year + month == 30/730 금액을 받을 수 있음
        vm.warp(year * 1 + month);  

        vestingInvestors.releasable(address(glow));
        vestingInvestors.release(address(glow)); // 616438108567381586640956 [6.164e23]
    }
}