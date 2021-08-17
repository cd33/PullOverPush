pragma solidity 0.8.0;

contract PullOverPush {
    
    mapping (address => uint) balances;
    event Credit(uint _amount);
    event Withdraw(uint _amount);
    
    function allowForPull(address _address, uint _amount) private {
        balances[_address] += _amount;
    }

    function pull() public payable {
        require(msg.sender.balance >= msg.value, "Not enough funds in your wallet.");
        allowForPull(msg.sender, msg.value);
        emit Credit(msg.value);
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough funds in your balance.");
        require(address(this).balance >= _amount, "Not enough funds in your wallet to securise the transfer.");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdraw(_amount);
    }
    
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    function getMsgSenderBalance() public view returns (uint) {
        return msg.sender.balance;
    }
}
