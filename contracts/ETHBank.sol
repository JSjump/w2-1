//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract ETHBank {
    address payable owner;

    mapping(address => uint256) balances;

    bool flag = false;

    constructor() {
        owner = payable(msg.sender);
    }

    // 此为一种转账方式，通过自己编写的deposit函数
    function deposit() public payable {
        // 外部调用tX.  携带的msg.value 自动转入合约 。 不需要像下面这样 指明传入合约地址
        // (bool res,) = address(this).call{value:msg.value}('');
        // if(res){
        balances[msg.sender] += msg.value;
        // }
    }

    // 另一种 则设置 receive fallback 函数 直接接受

    // 取现
    function withdraw(uint256 _num) public payable noReEntrace {
        require(tx.origin == msg.sender); // 只能外部账户调用,不能合约调用

        require(
            _num <= balances[msg.sender],
            "withdraw amount must lt balances"
        );

        balances[msg.sender] -= _num;
        (bool res, ) = payable(msg.sender).call{value: _num}(""); // 通过call转账容易被reentrace攻击 ,被调用的外部智能合约代码（被转账的合约）将享有所有剩余的gas。 transfer 2,300 gas
        console.log("res", res);
        if (res == false) {
            // 字符串字面常量 .  只能包含可打印的ASCII字符，这意味着他是介于0x1F和0x7E之间的字符
            // string memory errMessage = "excute error";
            // Unicode 字面常量.  字符串文字只能包含ASCII，而Unicode文字（以关键字unicode为前缀）可以包含任何有效的UTF-8序列。  汉字等属于utf-8
            string memory errMessage = unicode"执行错误";
            // 十六进制字面常量。 以关键字 hex 打头，后面紧跟着用单引号或双引号引起来的字符串（例如，hex"001122FF" ）。 字符串的内容必须是一个十六进制的字符串，它们的值将使用二进制表示
            //  string memory errMessage = hex"00112233";
            revert(errMessage);
        }
    }

    // 查看银行余额
    function getBankBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 查看个人余额
    function getOwnerBalance(address _owner) public view returns (uint256) {
        //  错误处理及异常 require,assert, try catch, revert。 require assert 检查条件并在条件不满足时抛出异常
        // assert 函数只能用于检查内部错误，检查不变量
        // try/catch 外部调用的失败用try/catch捕获
        require(_owner != address(0x0), "_owner must be valid"); // 判断地址是否为空
        return balances[_owner];
    }

    // 销毁
    function selfdestructContract() public payable {
        selfdestruct(owner);
    }

    // 判断一个账户是否合约账户
    function isContract(address _addr) public view returns (uint256) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size;
    }

    // 防止重入
    modifier noReEntrace() {
        require(!flag, unicode"禁止重入");
        flag = true;
        _;
        flag = false;
    }
}
