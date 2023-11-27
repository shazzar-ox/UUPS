// SPDX-License-Identifier: MIT

pragma solidity ~0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployBoxV1} from "../script/DeployBoxV1.s.sol";
import {Upgreadable} from "../script/Upgradeable.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployAndUpgradeTest is Test {
    DeployBoxV1 deployer;
    Upgreadable upgrader;
    address proxy;
    BoxV2 boxV2;
    address public owner = makeAddr("owner");

    // from my understanding proxies like erc20  can be ihnerites.. erc1967... which is a proxy standard
    // to make a contract upgradeable we can just inherit those contracts from popenzeppelin...
    // data called on the imlementation contracts are saved on the proxy
    // thus implementtaion contracts cannout have constructors... since contsturcturs can be done via the initialize function

    function setUp() external {
        deployer = new DeployBoxV1();
        upgrader = new Upgreadable();
        proxy = deployer.run(); // this points to boxV1..
    }

    function testUpgrades() public {
        boxV2 = new BoxV2();
        upgrader.upgradeBox(proxy, address(boxV2));
        uint256 expectedValue = 2;
        uint256 actualValue = BoxV2(proxy).version();
        assertEq(expectedValue, actualValue);

        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }
}
