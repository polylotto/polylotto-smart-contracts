// SPDX-License-Identifier: MIT

// // File: @openzeppelin/contracts/utils/Context.sol

pragma solidity ^0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol

pragma solidity ^0.8.0;

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(
                oldAllowance >= value,
                "SafeERC20: decreased allowance below zero"
            );
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(
                token,
                abi.encodeWithSelector(
                    token.approve.selector,
                    spender,
                    newAllowance
                )
            );
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

// File: @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol

pragma solidity ^0.8.0;

interface LinkTokenInterface {
    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining);

    function approve(address spender, uint256 value)
        external
        returns (bool success);

    function balanceOf(address owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8 decimalPlaces);

    function decreaseApproval(address spender, uint256 addedValue)
        external
        returns (bool success);

    function increaseApproval(address spender, uint256 subtractedValue)
        external;

    function name() external view returns (string memory tokenName);

    function symbol() external view returns (string memory tokenSymbol);

    function totalSupply() external view returns (uint256 totalTokensIssued);

    function transfer(address to, uint256 value)
        external
        returns (bool success);

    function transferAndCall(
        address to,
        uint256 value,
        bytes calldata data
    ) external returns (bool success);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool success);
}

// File: contracts/interfaces/IUniswapV2Router01.sol

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

// File: contracts/interfaces/IUniswapV2Router02.sol

pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

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

//Lottery Contract

pragma solidity >=0.8.0 <0.9.0;

contract polylottoRaffle is IPolyLottoRaffle, ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    uint256 internal currentRaffleStartTime;
    uint256 internal currentRaffleEndTime;
    uint256 internal currentRaffleRebootEndTime;

    uint256 internal raffleID;

    uint256 internal immutable raffleInterval = 2 * 1 hours;
    uint256 internal immutable resetInterval = 30 * 1 minutes;

    bytes32 internal keyHash;

    uint256 internal rebootChecker;

    uint256 public noOfWinners;
    uint256 public maxNumberTicketsPerBuy = 1000;

    address public injectorAddress;
    address public operatorAddress;
    address public treasuryAddress;
    address public randomGenerator;
    address public polylottoKeeper;

    bool internal usingPolyLottoToken;

    IERC20 public raffleToken;

    struct Router {
        string Dex;
        IUniswapV2Router02 routerAddress;
    }

    struct Transaction {
        uint256 txID;
        uint256 time;
        RaffleCategory raffleCategory;
        uint256 noOfTickets;
        string description;
    }

    struct Ticket {
        uint32 ticketNumber;
        address owner;
        bool toRollover;
    }

    //Router Details
    Router public DexRouter;

    //Maps Total ticket Record for raffle
    mapping(RaffleCategory => mapping(uint256 => Ticket)) private ticketsRecord;

    //Mapping for user tickets history
    mapping(address => mapping(RaffleCategory => mapping(uint256 => uint32[])))
        private userTicketsPerRaffle;

    //Maps Raffle category to each Raffle indexes of each Raffle, for record keeping.
    mapping(RaffleCategory => mapping(uint256 => RaffleStruct)) private raffles;

    //Map General Raffle Data
    mapping(RaffleCategory => RaffleData) private rafflesData;

    //Mapping for users that have rollover tickets, (address to rollover ticketIds)
    mapping(RaffleCategory => mapping(address => uint256[])) private rollovers;

    //Mapping to keep track of tickets
    mapping(RaffleCategory => Ticket[]) private rolloverTickets;

    //Users Transaction History
    mapping(address => Transaction[]) private userTransactionHistory;

    //Mapping of TicketIDs for each Raffle Category
    mapping(RaffleCategory => uint256) private currentTicketID;

    modifier stateCheck() {
        require(rebootChecker == 3, "Reboot check not complete");
        _;
    }
    modifier notContract() {
        require(!_isContract(msg.sender), "Contract not allowed");
        require(msg.sender == tx.origin, "Proxy contract not allowed");
        _;
    }

    modifier onlyOwnerOrInjector() {
        require(
            (msg.sender == owner()) || (msg.sender == injectorAddress),
            "Not owner or injector"
        );
        _;
    }

    modifier onlyOperator() {
        require(msg.sender == operatorAddress, "Not operator");
        _;
    }

    modifier onlyPolylottoKeeper() {
        require(msg.sender == polylottoKeeper, "Not Keeper Address");
        _;
    }

    modifier onlyRandomGenerator() {
        require(msg.sender == randomGenerator, "Not randomGenerator Address");
        _;
    }

    modifier hasRollovers(RaffleCategory _category) {
        require(
            rollovers[_category][msg.sender].length != 0,
            "You have no rollover"
        );
        _;
    }

    modifier raffleNotValid(RaffleCategory _category) {
        RaffleStruct storage _raffle = raffles[_category][raffleID];
        require(
            _raffle.noOfTicketsSold < 10 || _raffle.noOfPlayers < 5,
            "Sorry can not deactivate a valid raffle"
        );
        _;
    }

    modifier isRaffleDeactivated(RaffleCategory _category) {
        RaffleData storage _raffleData = rafflesData[_category];
        require(
            _raffleData.raffleState == RaffleState.DEACTIVATED,
            "Sorry can activate as raffle is not deactivated"
        );
        _;
    }

    modifier hasUpdatedToPolyLottoToken() {
        require(usingPolyLottoToken == false, "Token has been changed already");
        _;
    }

    event AdminTokenRecovery(address token, uint256 amount);
    event RaffleOpen(
        uint256 indexed raffleId,
        uint256 endTime,
        uint256 rebootEndTime,
        RaffleState raffleState
    );
    event TicketsPurchased(
        RaffleCategory raffleCategory,
        uint256 indexed raffleId,
        uint32[] tickets,
        uint256 rafflePool,
        uint256[] winnersPayout
    );
    event NewUserTransaction(
        uint256 txIndex,
        uint256 timestamp,
        RaffleCategory raffleCategory,
        uint256 noOfTickets
    );
    event RolloverClaimed(
        RaffleCategory raffleCategory,
        uint256 indexed raffleId,
        address buyer,
        uint32[] tickets
    );
    event RaffleEnded(
        RaffleCategory category,
        uint256 indexed raffleId,
        RaffleState raffleState
    );
    event WinnersAwarded(
        RaffleCategory raffleCategory,
        address[] winners,
        uint256 amount,
        uint256 timestamp
    );
    event LotteryInjection(
        RaffleCategory raffleCategory,
        uint256 indexed raffleId,
        uint256 injectedAmount
    );
    event NewOperatorAndTreasuryAndInjectorAddresses(
        address _operatorAddress,
        address _treasuryAddress,
        address _injectorAddress
    );
    event RaffleDeactivated(
        uint256 raffleID,
        uint256 timeStamp,
        RaffleState raffleState
    );
    event RaffleReactivated(
        uint256 raffleID,
        uint256 timeStamp,
        RaffleState raffleState
    );
    event WithdrawalComplete(uint256 raffleID, uint256 amount);

    // Initializing the contract
    constructor(
        address _raffleToken,
        uint256 _amountOfTokenPerDAI,
        uint256 _noOfWinners
    ) {
        rebootChecker = 3;
        raffleToken = IERC20(_raffleToken);
        setTicketPrice(_amountOfTokenPerDAI);
        usingPolyLottoToken = false;
        noOfWinners = _noOfWinners;
    }

    // Function to be called by the chainlink keepers that start the raffle
    function startRaffle() external override onlyPolylottoKeeper stateCheck {
        //initiating raffle
        raffleID++;

        if (usingPolyLottoToken) {
            updatePrice();
        }

        currentRaffleStartTime = block.timestamp;
        currentRaffleEndTime = currentRaffleStartTime + raffleInterval;
        currentRaffleRebootEndTime = currentRaffleEndTime + resetInterval;

        // creating raffle sessions
        RaffleCategory[3] memory categoryArray = [
            RaffleCategory.BASIC,
            RaffleCategory.INVESTOR,
            RaffleCategory.WHALE
        ];
        for (uint256 i = 0; i < categoryArray.length; i++) {
            RaffleCategory _category = categoryArray[i];
            RaffleStruct storage _raffle = raffles[_category][raffleID];
            _raffle.ID = raffleID;
            _raffle.raffleStartTime = currentRaffleStartTime;
            _raffle.raffleEndTime = currentRaffleEndTime;

            setRaffleState(_category, RaffleState.OPEN);
            updateWinnersPayouts(_category);
        }

        rebootChecker = 0;
        emit RaffleOpen(
            raffleID,
            currentRaffleEndTime,
            currentRaffleRebootEndTime,
            RaffleState.OPEN
        );
    }

    // This function sets the raffle ticket Price
    function setTicketPrice(uint256 _amountOfTokenPerDAI) internal {
        rafflesData[RaffleCategory.BASIC].ticketPrice = _amountOfTokenPerDAI;
        rafflesData[RaffleCategory.INVESTOR].ticketPrice =
            10 *
            _amountOfTokenPerDAI;
        rafflesData[RaffleCategory.WHALE].ticketPrice =
            100 *
            _amountOfTokenPerDAI;
    }

    // To help monitor the flow of the contract, this function allows the contract to change the state of each raffle
    function setRaffleState(RaffleCategory _category, RaffleState _state)
        internal
    {
        rafflesData[_category].raffleState = _state;
    }

    function getRebootEndTime() external view override returns (uint256) {
        return (currentRaffleRebootEndTime);
    }

    function getRaffleEndTime() external view override returns (uint256) {
        return (currentRaffleEndTime);
    }

    function getRaffleID() external view override returns (uint256) {
        return raffleID;
    }

    function getRaffleData(RaffleCategory _category)
        external
        view
        override
        returns (RaffleData memory raffleData)
    {
        return rafflesData[_category];
    }

    function getRaffle(RaffleCategory _category, uint256 _raffleID)
        external
        view
        override
        returns (RaffleStruct memory raffle)
    {
        return raffles[_category][_raffleID];
    }

    function getNoOfWinners() external view override returns (uint256) {
        return noOfWinners;
    }

    function getRebootChecker() external view override returns (uint256) {
        return rebootChecker;
    }

    function viewUserTickets(
        RaffleCategory _category,
        address _user,
        uint256 _raffleID
    ) external view returns (uint32[] memory) {
        return userTicketsPerRaffle[_user][_category][_raffleID];
    }

    function buyTickets(RaffleCategory _category, uint32[] calldata _tickets)
        external
        override
        notContract
        nonReentrant
    {
        require(_tickets.length != 0, "No ticket specified");
        require(_tickets.length <= maxNumberTicketsPerBuy, "Too many tickets");
        require(
            rafflesData[_category].raffleState == RaffleState.OPEN,
            "Raffle not open"
        );
        RaffleData storage _raffleData = rafflesData[_category];
        RaffleStruct storage _raffle = raffles[_category][raffleID];

        //calculate amount to transfer
        uint256 amountToTransfer = _raffleData.ticketPrice * _tickets.length;
        raffleToken.safeTransferFrom(
            address(msg.sender),
            address(this),
            amountToTransfer
        );

        //check if user has already bought ticket in current Raffle
        if (userTicketsPerRaffle[msg.sender][_category][raffleID].length == 0) {
            _raffle.noOfPlayers++;
        }

        _raffleData.rafflePool += amountToTransfer;
        storeUserTransactions(_category, _tickets.length, false);
        assignTickets(_category, _tickets);
        updateWinnersPayouts(_category);

        emit TicketsPurchased(
            _category,
            raffleID,
            _tickets,
            _raffleData.rafflePool,
            _raffle.winnersPayout
        );
    }

    function storeUserTransactions(
        RaffleCategory _category,
        uint256 _noOfTickets,
        bool _fromRollovers
    ) internal {
        uint256 txIndex = userTransactionHistory[msg.sender].length;

        Transaction memory _transaction;
        _transaction.txID = txIndex;
        _transaction.time = block.timestamp;
        _transaction.raffleCategory = _category;
        _transaction.noOfTickets = _noOfTickets;

        if (_fromRollovers) {
            _transaction.description = "Rollover";
        } else {
            _transaction.description = "Purchase";
        }

        userTransactionHistory[msg.sender].push(_transaction);

        emit NewUserTransaction(
            txIndex,
            block.timestamp,
            _category,
            _noOfTickets
        );
    }

    function assignTickets(RaffleCategory _category, uint32[] memory _tickets)
        internal
    {
        RaffleStruct storage _raffle = raffles[_category][raffleID];
        for (uint256 n = 0; n < _tickets.length; n++) {
            currentTicketID[_category]++;
            uint32 thisTicketNumber = _tickets[n];

            userTicketsPerRaffle[msg.sender][_category][raffleID].push(
                thisTicketNumber
            );

            ticketsRecord[_category][currentTicketID[_category]] = Ticket({
                ticketNumber: thisTicketNumber,
                owner: msg.sender,
                toRollover: false
            });
        }
        _raffle.noOfTicketsSold += _tickets.length;
    }

    function updateWinnersPayouts(RaffleCategory _category) internal {
        RaffleStruct storage _raffle = raffles[_category][raffleID];
        uint256 _rafflePool = rafflesData[_category].rafflePool;
        uint256 _25percent = (_rafflePool * 25) / 100;
        uint256 _15percent = (_rafflePool * 15) / 100;
        uint256 _10percent = (_rafflePool * 10) / 100;
        _raffle.winnersPayout = [_25percent, _15percent, _10percent];
    }

    function getUserTransactionCount(address _user)
        external
        view
        returns (uint256)
    {
        return userTransactionHistory[_user].length;
    }

    function getuserTransactionHistory(address _user, uint256 _txIndex)
        external
        view
        returns (Transaction memory userTransaction)
    {
        return userTransactionHistory[_user][_txIndex];
    }

    function getWinners(
        RaffleCategory _category,
        uint256[] memory _winningTicketsIDs
    ) external override onlyRandomGenerator {
        RaffleStruct storage _raffle = raffles[_category][raffleID];

        for (uint256 i = 0; i < noOfWinners; i++) {
            uint256 ticketIDsBeforeCurrentRaffle = currentTicketID[_category] -
                _raffle.noOfTicketsSold;

            uint256 currentWinningTicketID = ticketIDsBeforeCurrentRaffle +
                _winningTicketsIDs[i];

            _raffle.winningTickets[i] = ticketsRecord[_category][
                currentWinningTicketID
            ].ticketNumber;

            _raffle.winners[i] = ticketsRecord[_category][
                currentWinningTicketID
            ].owner;
        }

        setRaffleState(_category, RaffleState.PAYOUT);
        emit RaffleEnded(_category, raffleID, RaffleState.PAYOUT);
    }

    function payoutWinners(RaffleCategory _category)
        external
        override
        onlyPolylottoKeeper
    {
        RaffleStruct storage _raffle = raffles[_category][raffleID];
        RaffleData storage _raffleData = rafflesData[_category];
        uint256 amountPaidOut;

        for (uint256 i = 0; i < noOfWinners; i++) {
            raffleToken.safeTransfer(
                _raffle.winners[i],
                _raffle.winnersPayout[i]
            );
            _raffleData.rafflePool -= _raffle.winnersPayout[i];
            amountPaidOut += _raffle.winnersPayout[i];
        }

        //Send half of remaining to Treasury
        raffleToken.safeTransfer(
            treasuryAddress,
            ((_raffleData.rafflePool) / 2)
        );

        setRaffleState(_category, RaffleState.WAITING_FOR_REBOOT);
        rebootChecker++;
        emit WinnersAwarded(
            _category,
            _raffle.winners,
            amountPaidOut,
            block.timestamp
        );
    }

    /**
     * @notice Set operator, treasury, and injector addresses
     * @dev Only callable by owner
     * @param _operatorAddress: address of the operator
     * @param _treasuryAddress: address of the treasury
     * @param _injectorAddress: address of the injector
     */
    function setOperatorAndTreasuryAndInjectorAddresses(
        address _operatorAddress,
        address _treasuryAddress,
        address _injectorAddress
    ) external onlyOwner {
        require(_operatorAddress != address(0), "Cannot be zero address");
        require(_treasuryAddress != address(0), "Cannot be zero address");
        require(_injectorAddress != address(0), "Cannot be zero address");

        operatorAddress = _operatorAddress;
        treasuryAddress = _treasuryAddress;
        injectorAddress = _injectorAddress;

        emit NewOperatorAndTreasuryAndInjectorAddresses(
            _operatorAddress,
            _treasuryAddress,
            _injectorAddress
        );
    }

    /**
     * @notice Set keeper address
     * @dev Only callable by operator
     * @param _keeperAddress: address of the keeper
     * @param _randomGenerator: address of the randomGenerator
     */
    function setKeeperAndRandomGeneratorAddress(
        address _keeperAddress,
        address _randomGenerator
    ) external onlyOperator {
        polylottoKeeper = _keeperAddress;
        randomGenerator = _randomGenerator;
    }

    function injectFunds(RaffleCategory _category, uint256 _amount)
        external
        override
        onlyOwnerOrInjector
    {
        require(
            rafflesData[_category].raffleState == RaffleState.OPEN,
            "Raffle not open"
        );

        raffleToken.safeTransferFrom(
            address(msg.sender),
            address(this),
            _amount
        );

        raffles[_category][raffleID].amountInjected += _amount;

        emit LotteryInjection(_category, raffleID, _amount);
    }

    function rollover(RaffleCategory _category, bool _deactivated)
        external
        override
        onlyPolylottoKeeper
    {
        _rollover(_category, _deactivated);
    }

    function _rollover(RaffleCategory _category, bool _deactivated) internal {
        RaffleStruct storage _raffle = raffles[_category][raffleID];
        if (!_deactivated) {
            setRaffleState(_category, RaffleState.WAITING_FOR_REBOOT);
            rebootChecker++;
        }
        if (_raffle.noOfTicketsSold < 0) {
            return;
        }
        uint256 noOfTicketsBeforeThisRaffle = currentTicketID[_category] -
            _raffle.noOfTicketsSold;
        for (uint256 i = 1; i <= _raffle.noOfTicketsSold; i++) {
            uint256 _thisTicketID = noOfTicketsBeforeThisRaffle + i;
            address player = ticketsRecord[_category][_thisTicketID].owner;
            ticketsRecord[_category][_thisTicketID].toRollover = true;
            rollovers[_category][player].push(_thisTicketID);
            rolloverTickets[_category].push(
                ticketsRecord[_category][_thisTicketID]
            );
        }
    }

    function viewUserRollovers(RaffleCategory _category, address _user)
        external
        view
        returns (uint256 ticketsToRollover)
    {
        // rollovers[_category][_user].length;
        uint256[] memory ticketIDs = rollovers[_category][_user];

        uint256 noOfTicketsToRollover;

        for (uint256 n; n < ticketIDs.length; n++) {
            uint256 _thisTicketID = ticketIDs[n];

            Ticket memory _ticket = ticketsRecord[_category][_thisTicketID];

            if (!_ticket.toRollover) {
                continue;
            }

            noOfTicketsToRollover++;
        }

        return noOfTicketsToRollover;
    }

    function claimRollover(RaffleCategory _category)
        external
        override
        notContract
        hasRollovers(_category)
        nonReentrant
    {
        require(
            rafflesData[_category].raffleState == RaffleState.OPEN,
            "Raffle not open"
        );
        uint256[] memory ticketIDs = rollovers[_category][msg.sender];
        uint32[] memory ticketsToRollover = new uint32[](ticketIDs.length);
        uint256 noOfTicketsToRollover;

        for (uint256 n; n < ticketIDs.length; n++) {
            uint256 _thisTicketID = ticketIDs[n];

            Ticket storage _ticket = ticketsRecord[_category][_thisTicketID];

            if (!_ticket.toRollover) {
                continue;
            }

            currentTicketID[_category]++;

            userTicketsPerRaffle[msg.sender][_category][raffleID].push(
                _ticket.ticketNumber
            );

            ticketsRecord[_category][currentTicketID[_category]] = Ticket({
                ticketNumber: _ticket.ticketNumber,
                owner: msg.sender,
                toRollover: false
            });

            ticketsToRollover[n] = (_ticket.ticketNumber);
            noOfTicketsToRollover++;

            _ticket.toRollover = false;
        }

        if (noOfTicketsToRollover > 0) {
            storeUserTransactions(_category, noOfTicketsToRollover, true);
            emit RolloverClaimed(
                _category,
                raffleID,
                msg.sender,
                ticketsToRollover
            );
        }
        //initialise empty array
        uint256[] memory empty;

        //overwrite mapping
        rollovers[_category][msg.sender] = empty;
    }

    function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount)
        external
        onlyOperator
    {
        require(_tokenAddress != address(raffleToken), "Cannot be USDC token");

        IERC20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);

        emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
    }

    function deactivateRaffle()
        external
        override
        onlyOperator
        raffleNotValid(RaffleCategory.BASIC)
        raffleNotValid(RaffleCategory.INVESTOR)
        raffleNotValid(RaffleCategory.WHALE)
    {
        RaffleCategory[3] memory categoryArray = [
            RaffleCategory.BASIC,
            RaffleCategory.INVESTOR,
            RaffleCategory.WHALE
        ];

        for (uint256 i = 0; i < categoryArray.length; i++) {
            _rollover(categoryArray[i], true);
            setRaffleState(categoryArray[i], RaffleState.DEACTIVATED);
        }

        rebootChecker = 0;
        currentRaffleEndTime = 0;
        currentRaffleRebootEndTime = 0;

        emit RaffleDeactivated(
            raffleID,
            block.timestamp,
            RaffleState.DEACTIVATED
        );
    }

    function reactivateRaffle()
        external
        override
        onlyOperator
        isRaffleDeactivated(RaffleCategory.BASIC)
        isRaffleDeactivated(RaffleCategory.INVESTOR)
        isRaffleDeactivated(RaffleCategory.WHALE)
    {
        RaffleCategory[3] memory categoryArray = [
            RaffleCategory.BASIC,
            RaffleCategory.INVESTOR,
            RaffleCategory.WHALE
        ];
        for (uint256 i = 0; i < categoryArray.length; i++) {
            RaffleCategory _category = categoryArray[i];
            setRaffleState(_category, RaffleState.WAITING_FOR_REBOOT);
        }
        rebootChecker = 3;

        emit RaffleReactivated(
            raffleID,
            block.timestamp,
            RaffleState.WAITING_FOR_REBOOT
        );
    }

    function withdrawFundsDueToDeactivation(RaffleCategory _category)
        external
        override
        notContract
        isRaffleDeactivated(_category)
        hasRollovers(_category)
        nonReentrant
    {
        RaffleData memory _raffleData = rafflesData[_category];

        uint256 noOfTicketsToRefund;

        uint256[] memory ticketIDs = rollovers[_category][msg.sender];

        for (uint256 n; n < ticketIDs.length; n++) {
            uint256 _thisTicketID = ticketIDs[n];

            Ticket storage _ticket = ticketsRecord[_category][_thisTicketID];

            if (!_ticket.toRollover) {
                continue;
            }

            noOfTicketsToRefund++;

            _ticket.toRollover = false;
        }

        if (noOfTicketsToRefund > 0) {
            uint256 amount = noOfTicketsToRefund * _raffleData.ticketPrice;
            raffleToken.safeTransfer(msg.sender, amount);
            emit WithdrawalComplete(raffleID, amount);
        }

        //initialise empty array
        uint256[] memory empty;

        //overwrite mapping
        rollovers[_category][msg.sender] = empty;
    }

    // Function to change the contract address of the token.
    function updateRaffleToken(address _newTokenAddress)
        external
        override
        onlyOperator
        isRaffleDeactivated(RaffleCategory.BASIC)
        isRaffleDeactivated(RaffleCategory.INVESTOR)
        isRaffleDeactivated(RaffleCategory.WHALE)
        hasUpdatedToPolyLottoToken
    {
        require(
            raffleToken.balanceOf(address(this)) == 0,
            "Token cannot be changed, remove all previous balance of old token"
        );
        raffleToken = IERC20(_newTokenAddress);
        usingPolyLottoToken = true;
    }

    // Initiate Manual Refund
    function manualRefund(RaffleCategory _category)
        external
        override
        onlyOperator
        isRaffleDeactivated(_category)
    {
        RaffleData memory _data = rafflesData[_category];
        Ticket[] storage _rolloverTickets = rolloverTickets[_category];

        for (uint256 n; n < _rolloverTickets.length; n++) {
            Ticket storage _ticket = _rolloverTickets[n];

            if (!_ticket.toRollover) {
                continue;
            }
            raffleToken.safeTransfer(_ticket.owner, _data.ticketPrice);
            _ticket.toRollover = false;
        }
    }

    // Function to get update price of token against DAI

    function updatePrice() internal {
        address[] memory tokens = new address[](2);
        //dai token
        tokens[0] = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
        //raffle token
        tokens[1] = address(raffleToken);

        // to get how many raffle tokens we get for 1 usdc token
        uint256[] memory amounts = DexRouter.routerAddress.getAmountsOut(
            1 ether,
            tokens
        );
        // update the price
        setTicketPrice(amounts[1]);
    }

    // Function to update Router Details

    function updateRouter(string memory _dexName, address _routerAddress)
        external
        override
        onlyOperator
    {
        require(_routerAddress != address(0), "Cannot be zero address");
        DexRouter.Dex = _dexName;
        DexRouter.routerAddress = IUniswapV2Router02(_routerAddress);
    }

    /**
     * @notice Check if an address is a contract
     */

    function _isContract(address _addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }

    //Contract Parameters
    // Create three Raffle categories
    // Basic category -- $1
    // Investor category -- $10
    // Whale category -- $100

    // Duration -- Every 2 days
    // For testnet every 3 hour
    // For testnet payout happens every 1 hour

    // Payouts -- Automatically
    // Contract gets -- 50%
    // 1 Winner -- 25%
    // 2 Winner -- 15%
    // 3 Winner -- 10%

    // let signer = ethersProvider.getSigner();
    // let contract = new ethers.Contract(address, abi, signer.connectUnchecked());
    // let tx = await contract.method();

    // // this will return immediately with tx.hash and tx.wait property

    // console.log("Transaction hash is ", tx.hash);
    // let receipt = await tx.wait();

    //Odds of Winning is increased by the number of tickets a person buys, but it does not guarantee winning,
    // as the randomness is generated randomly using the chainlink vrf and not with any existing variable in the contract

    // Users are given indexes for each tixcket bought, a mapping to store the each user to a ticket id.
    // So after the raffle is drawn lucky index number for raffle is chosen and the winners are awarded
    // Since there are 3 winners raffles will be drawn thrice.
    // first winner is the first person 25%
    // second is the 2nd person 15%
    // third is the 3rd person 10%
    // This is done by using the keccak function to alter the random value gotten from the vrf request.

    //The random values gotten for each Raffle are just basically indexes which are then looked up in the user-ticket mapping

    //PHASE TWO, Using keepers to automate the payout
}
