// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Booking.sol";

contract BookingTest is Test {
    event BookingCreated(uint256 indexed bookingId, address tourist, address provider, uint256 indexed amount);
    event ServiceDelivered(uint256 indexed bookingId);
    event BookingCancelled(uint256 indexed bookingId, address refundedTo);
    event PaymentReleased(uint256 indexed bookingId, address to, uint256 amount);

    TourismEscrow booking;

    address public TOURIST = makeAddr("tourist");
    address public PROVIDER = makeAddr("provider");

    function setUp() public {
        booking = new TourismEscrow();
        vm.deal(TOURIST, 10 ether);
        vm.deal(PROVIDER, 1 ether);
    }

    function testCreateBookinngEmitEvent() public {
        vm.prank(TOURIST);

        vm.expectEmit(true, true, false, true);
        emit BookingCreated(1, TOURIST, PROVIDER, 1 ether);

        booking.createBooking{value: 1 ether}(PROVIDER);

        TourismEscrow.Booking memory b = booking.getBooking(1);

        assertEq(b.tourist, TOURIST);
        assertEq(b.provider, PROVIDER);
        assertEq(b.amount, 1 ether);
        assertEq(uint256(b.status), uint256(TourismEscrow.Status.Pending));
    }

    function testCreateBookingRevertsIfNoPayment() public {
        vm.prank(TOURIST);
        vm.expectRevert("Payment must be > 0");
        booking.createBooking{value: 0}(PROVIDER);
    }

    function testConfirmCompletionSuccess() public {
        vm.prank(TOURIST);
        booking.createBooking{value: 1 ether}(PROVIDER);

        uint256 providerBalanceBefore = PROVIDER.balance;
        vm.prank(PROVIDER);
        vm.expectEmit(true, false, false, true);
        emit ServiceDelivered(1);

        booking.markDelivered(1);

        TourismEscrow.Booking memory b = booking.getBooking(1);
        assertEq(uint256(b.status), uint256(TourismEscrow.Status.Delivered));

        assertEq(PROVIDER.balance, providerBalanceBefore + 1 ether);
    }

    function testConfirmCompletionEmitEvent() public {
        vm.prank(TOURIST);
        booking.createBooking{value: 1 ether}(PROVIDER);

        uint256 providerBalanceBefore = PROVIDER.balance;
        vm.prank(PROVIDER);
        vm.expectEmit(true, false, false, true);
        emit PaymentReleased(1, PROVIDER, 1 ether);

        booking.markDelivered(1);

        TourismEscrow.Booking memory b = booking.getBooking(1);
        assertEq(uint256(b.status), uint256(TourismEscrow.Status.Delivered));

        assertEq(PROVIDER.balance, providerBalanceBefore + 1 ether);
    }

    function testmarkDeliveredRevertsIfNotPending() public {
        vm.prank(TOURIST);
        booking.createBooking{value: 1 ether}(PROVIDER);

        // Tourist cancels first
        vm.prank(TOURIST);
        booking.cancelBooking(1);

        vm.prank(PROVIDER);
        vm.expectRevert("Booking not pending");
        booking.markDelivered(1);
    }

    function testmarkDeliveredRevertIfNotProvider() public {
        vm.prank(TOURIST);
        booking.createBooking{value: 1 ether}(PROVIDER);

        vm.prank(TOURIST);
        vm.expectRevert("Not authorised");
        booking.markDelivered(1);
    }

    function testCancelBookingSuccess() public {
        vm.prank(TOURIST);
        booking.createBooking{value: 1 ether}(PROVIDER);

        uint256 touristBalanceBefore = TOURIST.balance;

        vm.prank(TOURIST);
        vm.expectEmit(true, false, false, true);
        emit BookingCancelled(1, TOURIST);

        booking.cancelBooking(1);

        TourismEscrow.Booking memory b = booking.getBooking(1);
        assertEq(uint256(b.status), uint256(TourismEscrow.Status.Cancelled));

        assertEq(TOURIST.balance, touristBalanceBefore + 1 ether);
    }

    function testCancelBookingRevertsIfNotTourist() public {
        vm.prank(TOURIST);
        booking.createBooking{value: 1 ether}(PROVIDER);

        vm.prank(PROVIDER);
        vm.expectRevert("Not authorised");
        booking.cancelBooking(1);
    }

    function testCancelBookingRevertsIfNotPending() public {
        vm.prank(TOURIST);
        booking.createBooking{value: 1 ether}(PROVIDER);

        vm.prank(PROVIDER);
        booking.markDelivered(1);

        vm.prank(TOURIST);
        vm.expectRevert("Booking not pending");
        booking.cancelBooking(1);
    }

    function testGetBookingReturnsCorrectDetails() public {
        vm.prank(TOURIST);
        booking.createBooking{value: 2 ether}(PROVIDER);

        TourismEscrow.Booking memory b = booking.getBooking(1);

        assertEq(b.tourist, TOURIST);
        assertEq(b.provider, PROVIDER);
        assertEq(b.amount, 2 ether);
        assertEq(uint256(b.status), uint256(TourismEscrow.Status.Pending));
    }
}
