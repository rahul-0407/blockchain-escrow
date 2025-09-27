//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Booking.sol";
import "./HelperConfig.s.sol";

contract DeployBooking is Script {
    function run() public {
        HelperConfig helper = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helper.getConfig();

        address owner = block.chainid == 31337 ? msg.sender : config.contractOwner;

        vm.startBroadcast();
        TourismEscrow escrow = new TourismEscrow();
        vm.stopBroadcast();
    }
}
