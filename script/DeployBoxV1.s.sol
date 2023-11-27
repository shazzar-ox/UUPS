//  SPDX-License-Identifier: MIT

pragma solidity ~0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBoxV1 is Script {
    BoxV1 boxV1;

    function run() external returns (address) {
        address proxy = deployBox();
        return proxy;
    }

    function deployBox() public returns (address) {
        vm.startBroadcast();
        boxV1 = new BoxV1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(boxV1), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}
