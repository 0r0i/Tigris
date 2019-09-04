pragma solidity ^0.4.19;

import "./TST20Interface.sol";
import "./OracleInterface.sol";
import "./PermissionGroups.sol";
import "./SafeMath.sol";

contract CDS is PermissionGroups{
    
    using SafeMath for uint;
    
    TST20 public CLAY;
    TST20 public CUSD;
    TST20 public CCNY;
    TST20 public CKRW;
    
    ORC public USDTTC;
    ORC public CNYTTC;
    ORC public KRWTTC;
    ORC public CLAYTTC;

    struct DepositRecord {
        uint time;
        uint value;
    }
	
    mapping(address => string) acceptCollateralToken; 
    string[] public tokenList;

    mapping(address => DepositRecord) public collateralTTC;
    mapping(address => mapping(address => DepositRecord)) public collateralTokens;
 
    function addAcceptCollateralToken(address _tokenAddress, string _name) onlyAdmin public {
        require(_tokenAddress != address(0));
        if (keccak256(acceptCollateralToken[_tokenAddress]) == keccak256("")) {
            acceptCollateralToken[_tokenAddress] = _name;
            tokenList.push(_name);
        }
    }

    function isAcceptCollateralToken(address _tokenAddress) view public returns (string) {
        return acceptCollateralToken[_tokenAddress];
    }

    function() payable public{
        DepositRecord storage record = collateralTTC[msg.sender] ;
        uint newValue = recalculateDeposit(record);
        record.value = newValue.add(msg.value);
        record.time = block.timestamp;

    }

    function recalculateDeposit(DepositRecord _record) internal pure returns (uint256) {
        // base on time and value
        // and get rate from oracle

        return _record.value;
    }





}