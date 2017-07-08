pragma solidity ^0.4.8;
 
// ----------------------------------------------------------------------------------------------
// Sample fixed supply token contract
// Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
// ----------------------------------------------------------------------------------------------
 
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/issues/20
contract ERC20Interface {
    // Get the total token supply
    function totalSupply() constant returns (uint256 totalSupply);
 
    // Get the account balance of another account with address _owner
    function balanceOf(address _owner) constant returns (uint256 balance);
 
    // Send _value amount of tokens to address _to
    function transfer(address _to, uint256 _value) returns (bool success);
 
    // Send _value amount of tokens from address _from to address _to
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
 
    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    // this function is required for some DEX functionality
    function approve(address _spender, uint256 _value) returns (bool success);
 
    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
 
    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
 
    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
 
contract MicroFinanceToken is ERC20Interface {
    string public constant symbol = "Micro Finance Token";
    string public constant name = "MFT";
    uint8 public constant decimals = 18;
    uint256 _totalSupply = 8000;
    
    // Owner of this contract
    address public owner;

    uint leasingPeriod;

    struct Farmer {
      address id;
      uint start;
      uint end;
    }

    struct Coop {
      bytes32 name;
      uint balance;
      uint start;
      uint end;
    }
    
    Coop coop;
    
    Farmer[] farmers;
 
    // Balances for each account
    mapping(address => uint256) balances;

    //Track time of use
    mapping(address => uint) usage;

    event vehicleStarted(address farmer);
 
    // Owner of account approves the transfer of an amount to another account
    mapping(address => mapping (address => uint256)) allowed;
 
    // Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
 
    // Constructor
    function MicroFinanceToken(address[] farmersList, uint totalBalance, bytes32 coopName, 
      uint contractLeasingPeriod) {
        owner = msg.sender;

        uint start = block.timestamp;
        coop.name = coopName;
        coop.balance = totalBalance;
        coop.start = start;
        coop.end = start;
        leasingPeriod = contractLeasingPeriod;

        for (uint i=0; i<farmersList.length; i++) {
          uint balance = totalBalance / farmers.length;

          balances[farmersList[i]] = balance;
          farmers.push(Farmer({id: farmersList[i], start: start, end:start}));
        }
    }

    function startVehicle() {
      if (block.timestamp < leasingPeriod && balances[msg.sender] > 0) {
        vehicleStarted(msg.sender);
      }
    }

    function stopVehicle() {
      uint cost = (block.timestamp - usage[msg.sender])/60;
      balances[msg.sender] -= cost;
    }
 
    // What is the balance of a particular account?
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
 
    // Transfer the balance from owner's account to another account
    function transfer(address _to, uint256 _amount) returns (bool success) {
        if (balances[msg.sender] >= _amount 
            && _amount > 0
            && balances[_to] + _amount > balances[_to]) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

}
