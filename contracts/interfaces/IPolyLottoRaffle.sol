//SPDX-License-Identifier: MIT
// File: contracts/interfaces/IPolyLottoRaffle.sol
pragma solidity ^0.8.4;

interface IPolyLottoRaffle {
    enum RaffleCategory {
        BASIC,
        INVESTOR,
        WHALE
    }

    enum RaffleState {
        INACTIVE,
        WAITING_FOR_REBOOT,
        OPEN,
        PAYOUT,
        DEACTIVATED
    }

    struct RaffleStruct {
        uint256 ID; //Raffle ID
        uint256 noOfTicketsSold; // Tickets sold
        uint256 noOfPlayers;
        uint256 amountInjected;
        uint256[] winnersPayout; // Contains the % payouts of the winners
        address[] winners;
        uint256[] winningTickets; // Contains array of winning Tickets
        uint256 raffleStartTime;
        uint256 raffleEndTime;
    }

    struct RaffleData {
        uint256 ticketPrice;
        uint256 rafflePool;
        RaffleState raffleState;
    }

    /**
     * @notice Start raffle
     * @dev only callable by keeper address
     */

    function startRaffle() external;

    /**
     * @notice Buy tickets for the current lottery
     * @param _category: Raffle Category
     * @param _tickets: array of ticket numbers between 100,000 and 999,999
     * @dev Callable by users only, not contract!
     */
    function buyTickets(RaffleCategory _category, uint32[] calldata _tickets)
        external;

    /**
     * @notice gets the Winners of the current Raffle
     * @param _category: Raffle Category
     * @param _winningTicketsIDs: ticket IDs of the winning tickets
     * @dev Callable by randomGenerator contract
     */
    function getWinners(
        RaffleCategory _category,
        uint256[] calldata _winningTicketsIDs
    ) external;

    /**
     * @notice sends out winnings to the Raffle Winners
     * @param _category: Raffle Category
     * @dev Callable by keepers contract
     */
    function payoutWinners(RaffleCategory _category) external;

    /**
     * @notice rollovers user tickets, whenever a raffle is not valid
     * @param _category: Raffle Category
     * @param _deactivated: bool to show if function was called via deactivation
     * @dev Callable by keepers contracts
     */
    function rollover(RaffleCategory _category, bool _deactivated) external;

    /**
     * @notice Claim Rollover, move ticket spots to next raffle after initial raffle where tickets were bought was deactivated or rendered invalid
     * @param _category: Raffle Category
     * @dev Callable by users only, not contract
     */
    function claimRollover(RaffleCategory _category) external;

    /**
     * @notice Deactivates Raffle, can only be called if raffle is not valid
     * @dev Callable by operator
     */
    function deactivateRaffle() external;

    /**
     * @notice Activates Raffle, can only be called if raffle has been deactivated
     * @dev Callable by operator
     */
    function reactivateRaffle() external;

    /**
     * @notice Withdraw funds from raffle, if raffle has been deactivated
     * @param _category: Raffle Category
     * @dev Callable by users only, not contract!
     */
    function withdrawFundsDueToDeactivation(RaffleCategory _category) external;

    /**
     * @notice Updates Raffle Token, for tickets purchase, refunds old tokens balance to users with rollover
     * @param _newTokenAddress: new Token Address
     * @dev Callable by operator, and can be only called once.
     */
    function updateRaffleToken(address _newTokenAddress) external;

    /**
     * @notice Send backs token balances to users with rollovers.
     * @param _category: Raffle Category
     * @dev Callable by operator, and to be used when raffleToken is to be updated
     */

    function manualRefund(RaffleCategory _category) external;

    /**
     * @notice update router supplying raffle with price of token
     * @param _dexName: Name of Decentralised Exchange with liquidity pool
     * @param _routerAddress: router address of that Exchange
     * @dev Callable by operator.
     */
    function updateRouter(string memory _dexName, address _routerAddress)
        external;

    /**
     * @notice Inject funds
     * @param _category: Raffle Cateogory
     * @param _amount: amount to inject in current Raffle Token
     * @dev Callable by operator
     */
    function injectFunds(RaffleCategory _category, uint256 _amount) external;

    /**
     * @notice View current raffle id
     */
    function getRaffleID() external returns (uint256);

    /**
     * @notice View Raffle Information
     */
    function getRaffle(RaffleCategory _category, uint256 _raffleID)
        external
        returns (RaffleStruct memory);

    /**
     * @notice View general raffle information
     */
    function getRaffleData(RaffleCategory _category)
        external
        returns (RaffleData memory);

    /**
     * @notice get number of winners
     */
    function getNoOfWinners() external returns (uint256);

    /**
     * @notice returns param that shows that all raffle categories are in sync
     */
    function getRebootChecker() external returns (uint256);

    /**
     * @notice returns the raffle end time
     */
    function getRaffleEndTime() external returns (uint256);

    /**
     * @notice returns the reboot end time
     */
    function getRebootEndTime() external returns (uint256);
}
