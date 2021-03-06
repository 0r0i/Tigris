pragma solidity ^0.4.19;

import "./PermissionGroups.sol";
import "./OracleInterface.sol";
import "./SafeMath.sol";

contract DataCalendar is PermissionGroups{

    using SafeMath for uint;

    uint public constant SECONDS_PER_DAY = 86400;

    string public name = "DataCalendar";
    Oracle public sourceOracle;
    mapping(uint => uint) public dailyData; 	// timestamp/86400 => value
    uint public minDate;
    uint public maxDate;


    uint public constant OFFSET_ZERO = 3;
    uint public offset = 4; // if 4, the current data will be saved to yesterday record.

    /* set name of oracle */
    function setName(string _name) onlyAdmin public {
        name = _name;
    }

    function setOffset(uint _offset) onlyAdmin public {
        offset = _offset;
    }

    /* set sourceOracle */
    function setSourceOracle(address _addr) onlyAdmin public {
    	require(_addr != address(0));
    	sourceOracle = Oracle(_addr);
    }

    function updateRecord() onlyOperator public {
    	uint date = now.div(SECONDS_PER_DAY).add(OFFSET_ZERO).sub(offset);    
	if (dailyData[date] != 0){
    		return;
    	}
    	dailyData[date] = sourceOracle.getLatestValue();
    	maxDate = date;
    	if (minDate == 0){
    		minDate = date;
    	}
    }

    function getValue(uint _start, uint _end) public view returns (uint) {
    	uint start = _start.div(SECONDS_PER_DAY);
    	uint end = _end.div(SECONDS_PER_DAY);

    	if (start < minDate) {
    		start = minDate;
    	}
    	if (end > maxDate) {
    		end  = maxDate;
    	}

    	uint sum = 0;
    	for (uint i = start+1; i <= end; i++){
    		sum = sum.add(dailyData[i]);
    	}
    	return sum;
    }

    function replaceValue(uint _time, uint _value) onlyOperator public {
    	uint date = _time.div(SECONDS_PER_DAY);
    	dailyData[date] = _value;
    	if (date > maxDate ) {
    		maxDate = date;
    	}
    }

}    
