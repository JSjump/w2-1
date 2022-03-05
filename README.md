ok 定向培训课程 第二周 第一节

- 编写⼀个 Bank 合约：
- 通过 Metamask 向 Bank 合约转账 ETH
- 在 Bank 合约记录每个地址转账⾦额
- 编写 Bank 合约 withdraw(), 实现提取出所有的 ETH

  1.ETHBank 合约 实现 eth 存取，针对 withdraw 的 call 调用做了 防 reEntrace 攻击， 以及 是否合约账户等判断

  2.Attack.sol 重入攻击文件

  答案： 1.合约部署地址：
  https://goerli.etherscan.io/address/0x7a76B226B72DfadB2a92cDB2aE4E42358a4dF41c#code

  2.通过 metamask 向 Bank 合约转账 eth
  转账记录：https://goerli.etherscan.io/tx/0xe62821a1bb0d990e960f935df3c425c801fe1f0834cefeb1e9f11058ace42860
  ![metamask](https://github.com/JSjump/w2-1/blob/master/imgs/1.png?raw=true)
