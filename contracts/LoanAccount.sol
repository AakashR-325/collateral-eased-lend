// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {LendingPool} from "./LendingPool.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Loan {
    using SafeMath for uint256;
    LendingPool private pool;

    address private immutable usdcAddress =
        0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8;
    address public immutable daiAddress =
        0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357;
    address public immutable linkAddress =
        0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5;

    address[3] public assets = [usdcAddress, daiAddress, linkAddress];

    IERC20 private usdc;

    mapping(address => uint256) public userToFunded;
    mapping(address => address) public tokenToPriceFeed;

    address public owner;
    uint256 immutable minSolvencyRatio;

    constructor(address _owner, uint256 _minSolvencyRatio) {
        usdc = IERC20(usdcAddress);
        owner = _owner;
        minSolvencyRatio = _minSolvencyRatio;
        tokenToPriceFeed[
            usdcAddress
        ] = 0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E;
        tokenToPriceFeed[
            daiAddress
        ] = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;
        tokenToPriceFeed[
            linkAddress
        ] = 0xc59E3633BAAC79493d908e63626716e204A45EdF;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "sender isn't the owner");
        _;
    }

    modifier solventAfter() {
        _;
        require(
            getSolvencyRatio() >= minSolvencyRatio,
            "Not solvent after the transaction"
        );
    }

    function fund(uint256 _amount) external onlyOwner {
        usdc.transferFrom(msg.sender, address(this), _amount);
        userToFunded[msg.sender] += _amount;
    }

    function withdraw(uint256 _amount) external solventAfter {
        require(
            userToFunded[msg.sender] >= _amount,
            "Not enough funds to withdraw"
        );
        usdc.transfer(msg.sender, _amount);
        userToFunded[msg.sender] -= _amount;
    }

    function borrow() external solventAfter {}

    function repay() external {}

    //function trade(address _tokenAddress) external payable{}
    //function liquidate() external {}

    function getSolvencyRatio() public view returns (uint256 solvencyRatio) {
        uint256 debt = pool.userToBorrows(msg.sender);
        uint256 totalAccountValue = getTotalAccountValue();
        solvencyRatio = totalAccountValue.mul(100).div(debt);
    }

    function getTotalAccountValue() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < assets.length; i++) {
            total += IERC20(assets[i]).balanceOf(address(this)).mul(
                uint256(getTokenPrice(i))
            );
        }
        return total;
    }

    function getTokenPrice(uint256 _index) internal view returns (int) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            tokenToPriceFeed[assets[_index]]
        );
        (
            ,
            /* uint80 roundID */ int price /* uint startedAt */ /* uint timeStamp */ /* uint80 answeredInRound */,
            ,
            ,

        ) = priceFeed.latestRoundData();

        return price;
    }
}
