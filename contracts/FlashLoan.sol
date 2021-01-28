pragma solidity ^0.6.6;
 
import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";
 
contract Flashloan is FlashLoanReceiverBase {
    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public {}
}

function flashloan(address _asset) public onlyOwner {
    bytes memory data = "";
    uint amount = 1000000000000000000;

    ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
    lendingPool.flashLoan(address(this), _asset, amount, data);
}
    
function executeOperation(
    address _reserve,
    uint256 _amount,
    uint256 _fee,
    bytes calldata _params
) external override {
    require(_amount &lt;= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

    // Your logic goes here.

    uint totalDebt = _amount.add(_fee);
    transferFundsBackToPoolInternal(_reserve, totalDebt);
}