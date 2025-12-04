// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract SGT is ERC20 {

    uint256 public constant MAX_SUPPLY = 100_000_000 * 1e18;

    constructor(address distributionManager) ERC20("GLOW", "GLT") {
        _mint(distributionManager, MAX_SUPPLY);
    }
}