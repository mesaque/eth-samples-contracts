pragma solidity >=0.5.11 <0.7.0;

contract MappingStructureExample{
    
    struct Payment {
        uint amount;
        uint timestamps;
    }
    struct Balance {
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }
    
    mapping(address => Balance) public balanceReceived;
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function sendMoney() public payable{
        balanceReceived[msg.sender].totalBalance += msg.value;
        
        Payment memory payment = Payment(msg.value, now);
        
        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numPayments] = payment;
        balanceReceived[msg.sender].numPayments++;
        
    }
    
    function withDrawAllMoney( address payable _to ) public {
        
        uint balanceToSend = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer( balanceToSend );
    }
    
    function withDrawMoney( address payable _to, uint _amount ) public {
        require(balanceReceived[msg.sender].totalBalance >= _amount, "not enough founds");
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }
    
}
