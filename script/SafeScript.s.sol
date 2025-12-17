// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import "forge-std/Test.sol";
import "../src/GLOW.sol";
import "../src/TokenDistributionManager.sol";
import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

contract SafeScript is Script {

    TokenDistributionManager public tokenDistributionManager;

    function run() public {
        uint256 deployerPrivatekey = vm.envUint("PRIVATE_KEY");
        address community = 0x23E9EB0cf83fED08b86768bD6046c9c526D8a571;
        address investors = 0xebE261C8C5C8AC997A9B313d01FFCa9FBADAD3E9;
        address foundation = 0x9f95c3D9E5aD043e0d6462CEA9D46074f26Cb374;
        address treasury = 0x93B729cB6efCAA1DE4A8Fb8e961c5D2c09A2c3Cb;
        address initialLiquidity = 0x424B72C72b690d9ebcB8BB1CBc4daF5D71B2BD6A;

        vm.startBroadcast(deployerPrivatekey);

        tokenDistributionManager = new TokenDistributionManager(msg.sender);
        tokenDistributionManager.execute(community, investors, foundation, treasury, initialLiquidity);

        console.log("GLOW: ", address(tokenDistributionManager.glow()));
        console.log("vesitngCommunity: ", address(tokenDistributionManager.vestingCommunity()));
        console.log("vestingInvestors: ", address(tokenDistributionManager.vestingInvestors()));
        console.log("vestingFoundation: ", address(tokenDistributionManager.vestingFoundation()));
        console.log("vestingTreasury: ", address(tokenDistributionManager.vestingTreasury()));
        console.log("initialLiquidity: ", initialLiquidity);
    }
}