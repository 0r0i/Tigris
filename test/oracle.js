var USDTTC = artifacts.require("./ORACLE.sol");

contract('ORACLE', function() {
	var eth = web3.eth;
  var owner = eth.accounts[0];
  var operator = eth.accounts[1];

  var CLAYReserveAddress = "0x018043e33dab6434d22c998c43f1dff47fbbccbf";
  // pk = 52b9b455143c8fbb1a8e9ef3e2452a24bb196c86efc8a44f69fc7ad9ccced823
 	var user = '0x48449ccfb77fc86707c9757009ca7be343902e3f';
 	//pk = a9e9cb65e35cf7a52a13b285b3eb54cda5a5a04c6cf47dd18e38637533d10f28

  var initalCUSD = 0 * 10 **18;
  var validBlockLen = 21; // about one minutes
  var contractName = "USDTTC";

	it("get admin",async () =>  {
        const ut = await USDTTC.deployed();
        admin = await ut.admin.call()
        assert.equal(admin, owner, "equal")
  });

  it("admin set operator",async () =>  {
        const ut = await USDTTC.deployed();
        await ut.addOperator(operator, {from:owner});
        operators = await ut.getOperators.call();
        assert.equal(operators[0], operator, "equal");
  });

  it("admin set name",async () =>  {
        const ut = await USDTTC.deployed();
        await ut.setName(contractName, {from:owner});
        name = await ut.name.call();
        assert.equal(contractName, name, "equal");
  });


  it("admin set valid length",async () =>  {
        const ut = await USDTTC.deployed();
        await ut.setValidBlockLength(validBlockLen, {from:operator});
        validLen = await ut.validBlockLength.call();
        assert.equal(validBlockLen, validLen, "equal");
  });
});
