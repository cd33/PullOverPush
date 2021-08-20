// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/b0cf6fbb7a70f31527f36579ad644e1cf12fdf4e/contracts/utils/math/SafeMath.sol";

contract PullOverPush {
    
    using SafeMath for uint;
    mapping (address => uint) balances;
    event Credit(uint _amount);
    event Withdraw(uint _amount);
    
    function allowForPull(address _address, uint _amount) private {
        balances[_address] = balances[_address].add(_amount);
    }

    receive() external payable {
        require(msg.sender.balance >= msg.value, "Not enough funds in your wallet.");
        allowForPull(msg.sender, msg.value);
        emit Credit(msg.value);
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough funds in your balance.");
        require(address(this).balance >= _amount, "Not enough funds in your wallet to securise the transfer.");
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        payable(msg.sender).transfer(_amount);
        emit Withdraw(_amount);
    }
    
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}
