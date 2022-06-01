//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IRandomNumberGenerator {
    /**
     * Requests randomness from vrf
     */
    function getWinningTickets(uint8 _category) external;

    /**
     * View latest raffle Id numbers
     */
    function viewLatestRaffleId() external view returns (uint256);
}
