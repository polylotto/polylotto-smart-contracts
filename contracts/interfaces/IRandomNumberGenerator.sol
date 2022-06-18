//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IRandomNumberGenerator {
    /**
     * Requests randomness from vrf
     */
    function getWinningTickets(uint8 _category) external;

    /**
     * Views random result
     */
    function viewRandomResult(uint8 _category)
        external
        view
        returns (uint256[] memory);

    /**
     * View latest raffle Id numbers
     */
    function viewLatestRaffleId() external view returns (uint256);
}
