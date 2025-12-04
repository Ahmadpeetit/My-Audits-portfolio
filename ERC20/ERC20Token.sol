// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "./IERC20Token.sol";

contract ERC20Token {
   string name;
   string symbol;
   uint256 decimals;
   uint256 totalSupply; 
   uint256 maxMint = 1_000_000e18;
   uint256 minMint = 10e18;
   uint256 minDeposit = 10e18;

   event Deposit(address indexed _to, uint256 _amount);
   event Transfer(address indexed  _from, address indexed  _to, uint256 _amount);
   event Mint(address indexed  _to, uint256 amount);
   event Transferfrom(address indexed _from, address indexed  _to, uint256 _amount);
   event Burn(address indexed  _from, address indexed  to, uint256 _amount);
   event Withdraw(address _from, address _to, uint256 _amount);

   mapping (address => uint256) public  balances;

   mapping (address => mapping(address => uint256)) public allownces;

   constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _totalSupply) {
      name = _name;
      symbol = _symbol;
      decimals = _decimals;
      totalSupply = _totalSupply;   
   }

   function balanceOf(address _user) external view returns(uint256 balance) {
      return balances[_user];
   }

   function deposit(address _to, uint256 _amount)  external payable  returns (bool success) {
        require(_to != address(0), "can not deposit to address zero");
        if(_amount > 0 && _amount >= minDeposit) {
          balances[_to] += _amount;
          emit Deposit(_to, _amount);
          return true;
        }
   }

   function transfer(address _from, address _to, uint256 _amount) external returns(bool success) {
     require(balances[msg.sender] >= _amount && _amount  > 0, "no sufficient balance");
     if(_from != address(0) && _to != address(0)){
         balances[_from] -= _amount;
         balances[_to] += _amount;
         emit Transfer(_from, _to, _amount);
     }
     return true;
   }

   function transferFrom(address _from, address _to, uint256 _amount) external payable returns(bool success) {
       require(allownces[_from][_to] >= _amount && _amount > 0, "transfer from failed");
       allownces[_from][_to] -=_amount;
       balances[_from] -= _amount;
       balances[_to] += _amount;
       emit Transferfrom(_from, _to, _amount);
       return true;
   }

   function approve(address  _spender, uint256 _value) external  returns(bool success) {
        require(balances[msg.sender] >= _value && _spender != address(0));
         allownces[msg.sender][_spender] = _value;
        return true;
   }

   function allowances(address _owner, address _spender) external view returns(uint256 remaining) {
       return allownces[_owner][_spender];
   }

   function mint(address _to, uint256 amount)  external  returns(uint256) {
       require(_to != address(0) && amount > 0, "can not mint to addres(0)");
       if(amount > minMint && amount <= maxMint) {    
         balances[msg.sender] += amount;
       emit Mint(_to, amount);
       }
         return amount;
   }

   function burn(address _from,  uint256 _amount) external {
      require(balances[msg.sender] >= _amount && _amount > 0, "can not burn from adress(0)");  
      balances[_from] -= _amount;
      emit Burn(_from, address(0), _amount);
   } 
  
  function withdraw(address _from, address _to, uint256 _amount) external payable returns (bool success) {
     require(balances[_from] >= _amount, "not enough balance");
     balances[_from] -= _amount;
     payable(_to).transfer(_amount); 
     emit Withdraw(_from, _to, _amount); 
     return true;
    
  }

               //REENTRANCY ATTACT


/*function name() external view returns(string memory) {
    return name;
}

   function symbol() external view returns(string memory) {
     return symbol;
   }

   function decimals() external view returns(uint256) {
     return decimals;
   }

   function totalSupply() external view returns(uint256) {
     return totalSupply;
   }
    */

}

