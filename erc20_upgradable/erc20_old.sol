pragma solidity ^0.4.24;

contract ERC20 {
    mapping(address => uint256) public balances;
    mapping(address => mapping (address => uint256)) public allowed;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    bool public stopped;

    uint256 private constant MAX_UINT256 = 2**256 -1;

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Stop();

    constructor(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
        stopped = false;
        owner = msg.sender;
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(!stopped);
        require(balances[msg.sender] >= _value);
        require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(!stopped);
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value);
        require(_from == _to || balances[_to] <= MAX_UINT256 -_value);
        require(allowance >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(
        address _owner
    ) public view returns (uint256) {
        return balances[_owner];
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool) {
        require(!stopped);
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    function stop()
        public
    {
        require(msg.sender == owner);
        stopped = true;
        emit Stop();
    }
}
