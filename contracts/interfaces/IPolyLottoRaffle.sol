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
        TICKETS_DRAWN,
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
        bool rollover;
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
     * @notice updates the price of the tickets
     * @param _amountOfTokenPerStable: Max no of token that can be gotten from one stable coin
     * @dev Callable by price updater contract only!
     */
    function setTicketPrice(uint256 _amountOfTokenPerStable) external;

    /**
     * @notice Buy tickets for the current lottery
     * @param _category: Raffle Category
     * @param _tickets: array of ticket numbers between 100,000 and 999,999
     * @dev Callable by users only, not contract!
     */
    function buyTickets(RaffleCategory _category, uint32[] calldata _tickets)
        external;

    /**
     * @notice Gets the Winners of the current Raffle
     * @param _category: Raffle Category
     * @dev Callable by keepers contract
     */
    function getWinners(RaffleCategory _category) external;

    /**
     * @notice Sets the raffle state to tickets drawn
     * @param _category: Raffle Category
     * @param _drawCompleted: boolean to tell contract when draw has finis
     * @dev Callable by randomGenerator contract
     */
    function setRaffleAsDrawn(RaffleCategory _category, bool _drawCompleted)
        external;

    /**
     * @notice sends out winnings to the Raffle Winners
     * @param _category: Raffle Category
     * @dev Callable by keepers contract
     */
    function payoutWinners(RaffleCategory _category) external;

    /**
     * @notice Rolls over user tickets, whenever a raffle is not valid
     * @param _category: Raffle Category
     * @dev Callable by keepers contracts
     */
    function rollover(RaffleCategory _category) external;

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
     * @notice  Changes the contract address of Raffle Token.
     * @param _newTokenAddress: new Token Address
     * @dev Callable by operator, and can be only called once.
     */
    function updateRaffleToken(address _newTokenAddress) external;

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
    function getRaffleID() external view returns (uint256);

    /**
     * @notice View Raffle Information
     */
    function getRaffle(RaffleCategory _category, uint256 _raffleID)
        external
        view
        returns (RaffleStruct memory);

    /**
     * @notice View general raffle information
     */
    function getRaffleData(RaffleCategory _category)
        external
        view
        returns (RaffleData memory);

    /**
     * @notice get number of winners
     */
    function getNoOfWinners() external view returns (uint256);

    /**
     * @notice returns param that shows that all raffle categories are in sync
     */
    function getRebootChecker() external view returns (uint256);

    /**
     * @notice returns param that shows if a random request has been made in a raffle category
     * @param _category: raffle category
     */
    function getRandomGenChecker(RaffleCategory _category)
        external
        view
        returns (bool);

    /**
     * @notice returns the raffle end time
     */
    function getRaffleEndTime() external view returns (uint256);

    /**
     * @notice returns the reboot end time
     */
    function getRebootEndTime() external view returns (uint256);
}
