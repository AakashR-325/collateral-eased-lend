// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract LendingPool {
    using Math for uint256;

    mapping(address => uint256) userToDeposit;
    mapping(address => uint256) userToBorrows;
    mapping(address => uint256) depositTimestamp;
    mapping(address => uint256) borrowTimestamp;

    uint256 public constant DEPOSIT_INTEREST_RATE = 5;
    uint256 public constant BORROW_INTEREST_RATE = 8;
    uint256 public totalDeposits;
    uint256 public totalBorrows;

    address private immutable usdcAddress =
        0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8;

    IERC20 private usdc;

    constructor() {
        usdc = IERC20(usdcAddress);
    }

    modifier canOnlyDepositAtOnce() {
        require(
            userToDeposit[msg.sender] == 0,
            "already deposited once , withdraw to deposit again"
        );
        _;
    }

    modifier hasBorrowed() {
        require(
            userToBorrows[msg.sender] != 0,
            "Can't repay since there are no borrows"
        );
        _;
    }

    function deposit(uint256 _amount) external canOnlyDepositAtOnce {
        userToDeposit[msg.sender] += _amount;
        usdc.transferFrom(msg.sender, address(this), _amount);
        depositTimestamp[msg.sender] = block.timestamp;
        totalDeposits += _amount;
    }

    function withdraw() external {
        uint256 interest = interestOnDeposit(
            userToDeposit[msg.sender],
            block.timestamp - depositTimestamp[msg.sender]
        );
        uint256 totalWithdraw = userToDeposit[msg.sender] + interest;
        usdc.transfer(msg.sender, totalWithdraw);
        userToDeposit[msg.sender] = 0;
        depositTimestamp[msg.sender] = 0;
        totalDeposits -= totalWithdraw;
    }

    function borrow(uint256 _amount) external {
        require(
            totalDeposits > _amount,
            "Not enough balance in pool to borrow"
        );
        usdc.transfer(msg.sender, _amount);
        userToBorrows[msg.sender] += _amount;
        borrowTimestamp[msg.sender] = block.timestamp;
        totalBorrows += _amount;
    }

    function repay(uint256 _amount) external hasBorrowed {
        uint256 interest = interestOnBorrow(
            userToBorrows[msg.sender],
            block.timestamp - borrowTimestamp[msg.sender]
        );
        uint256 totalRepay = userToBorrows[msg.sender] + interest;
        usdc.transferFrom(msg.sender, address(this), _amount);
        userToBorrows[msg.sender] = totalRepay - _amount;
        borrowTimestamp[msg.sender] = block.timestamp;
        totalBorrows -= _amount;
    }

    function interestOnDeposit(
        uint256 _amount,
        uint256 timeElapsed
    ) internal pure returns (uint256 interest) {
        interest = Math.mulDiv(
            _amount * timeElapsed,
            DEPOSIT_INTEREST_RATE,
            100
        );
    }

    function interestOnBorrow(
        uint256 _amount,
        uint256 timeElapsed
    ) internal pure returns (uint256 interest) {
        interest = Math.mulDiv(
            _amount * timeElapsed,
            DEPOSIT_INTEREST_RATE,
            100
        );
    }

    function approveUSDC(uint256 _amount) external {
        usdc.approve(address(this), _amount);
    }

    function getAllowance() external view returns (uint256 allowance) {
        allowance = usdc.allowance(msg.sender, address(this));
    }

    function getBalance() external view returns (uint256 balance) {
        balance = usdc.balanceOf(address(this));
    }
}
