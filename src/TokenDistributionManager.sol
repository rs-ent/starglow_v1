// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./SGT.sol";
import "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

contract TokenDistributionManager {

    event CreatedContracts(address sgt, address vestingCommunity, address vestingInvestors, address vestingFoundation, address vestingTreasury);

    SGT public sgt;
    VestingWallet public vestingCommunity;
    VestingWallet public vestingInvestors;
    VestingWallet public vestingFoundation;
    VestingWallet public vestingTreasury;

    address public owner;
    address public community;
    address public investors;
    address public foundation;
    address public treasury;
    bool public executed;
    uint64 constant MONTH = 60*60*24*30;
    uint64 constant YEAR = 60*60*24*365;
    
    constructor(address _owner) {
        require(_owner != address(0), "Invalid Owner");

        owner = _owner;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Not Owner");
        
        _;
    }

    function execute(address _community, address _investors, address _foundation, address _treasury, address _initialLiquidity) external onlyOwner {
        require(!executed, "Already Executed");
        require(_community != address(0), "Invalid Community");
        require(_investors != address(0), "Invalid Investors");
        require(_foundation != address(0), "Invalid Foundation");
        require(_treasury != address(0), "Invalid Treasury");
        require(_initialLiquidity != address(0), "Invalid InitialLiquidity");

        uint64 currentTime = uint64(block.timestamp);
        community = _community;
        investors = _investors;
        foundation = _foundation;
        treasury = _treasury;
        
        sgt = new SGT(address(this));
        vestingCommunity = new VestingWallet(community, currentTime + YEAR, YEAR * 4);
        vestingInvestors = new VestingWallet(investors, currentTime + YEAR, YEAR * 2);
        vestingFoundation = new VestingWallet(foundation, currentTime + YEAR, YEAR * 2);
        vestingTreasury = new VestingWallet(treasury, currentTime + MONTH * 3, YEAR * 3);
        
        executed = true;

        sgt.transfer(address(vestingCommunity), 54_600_000 * 1e18);
        sgt.transfer(address(vestingInvestors), 15_000_000 * 1e18);
        sgt.transfer(address(vestingFoundation), 10_000_000 * 1e18);
        sgt.transfer(address(vestingTreasury), 10_000_000 * 1e18);
        sgt.transfer(_initialLiquidity, 10_400_000 * 1e18);
        require(sgt.balanceOf(address(this)) == 0, "Manager Balance Not Zero");

        emit CreatedContracts(address(sgt), address(vestingCommunity), address(vestingInvestors), address(vestingFoundation), address(vestingTreasury));
    }

    function renounce() external onlyOwner {
        require(executed, "Not Executed Yet");

        owner = address(0);
    }
}