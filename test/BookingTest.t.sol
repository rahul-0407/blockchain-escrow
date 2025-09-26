// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import "forge-std/Test.sol";
// import "../src/Booking.sol";

// contract BookingTest is Test {
//     event BookingCreated(
//         uint256 indexed bookingId,
//         address tourist,
//         address provider,
//         uint256 amount
//     );
//     event BookingCompleted(uint256 indexed bookingId);
//     event BookingCancelled(uint256 indexed bookingId);

//     Booking booking;

//     address public TOURIST = makeAddr("tourist");
//     address public PROVIDER = makeAddr("provider");

//     function setUp() public {
//         booking = new Booking();
//         vm.deal(TOURIST, 10 ether);
//         vm.deal(PROVIDER, 1 ether);
//     }

//     // ------------------- CREATE BOOKING -------------------
//     function testCreateBookingEmitsEvent() public {
//         vm.prank(TOURIST);

//         vm.expectEmit(true, true, true, true);
//         emit BookingCreated(1, TOURIST, PROVIDER, 1 ether);

//         booking.createBooking{value: 1 ether}(PROVIDER);

//         (
//             address tourist,
//             address provider,
//             uint256 amount,
//             Booking.Status status
//         ) = booking.getBooking(1);

//         assertEq(tourist, TOURIST);
//         assertEq(provider, PROVIDER);
//         assertEq(amount, 1 ether);
//         assertEq(uint(status), uint(Booking.Status.Completed));
//     }

//     function testCreateBookingRevertsIfNoPayment() public {
//         vm.prank(TOURIST);
//         vm.expectRevert("Payment required");
//         booking.createBooking{value: 0}(PROVIDER);
//     }

//     // ------------------- CONFIRM COMPLETION -------------------
//     // function testConfirmCompletionSuccess() public {
//     //     // Tourist books
//     //     vm.prank(TOURIST);
//     //     booking.createBooking{value: 1 ether}(PROVIDER);

//     //     uint256 providerBalanceBefore = PROVIDER.balance;

//     //     // Tourist confirms completion
//     //     vm.prank(TOURIST);
//     //     vm.expectEmit(true, false, false, true);
//     //     emit BookingCompleted(1);

//     //     booking.confirmCompletion(1);

//     //     (, , , Booking.Status status) = booking.getBooking(1);
//     //     assertEq(uint(status), uint(Booking.Status.Completed));

//     //     assertEq(PROVIDER.balance, providerBalanceBefore + 1 ether);
//     // }

//     // function testConfirmCompletionRevertsIfNotTourist() public {
//     //     vm.prank(TOURIST);
//     //     booking.createBooking{value: 1 ether}(PROVIDER);

//     //     vm.prank(PROVIDER);
//     //     vm.expectRevert("Only tourist can confirm");
//     //     booking.confirmCompletion(1);
//     // }

//     // function testConfirmCompletionRevertsIfNotPending() public {
//     //     vm.prank(TOURIST);
//     //     booking.createBooking{value: 1 ether}(PROVIDER);

//     //     // Tourist cancels first
//     //     vm.prank(TOURIST);
//     //     booking.cancelBooking(1);

//     //     vm.prank(TOURIST);
//     //     vm.expectRevert("Booking not pending");
//     //     booking.confirmCompletion(1);
//     // }

//     // ------------------- CANCEL BOOKING -------------------
//     // function testCancelBookingSuccess() public {
//     //     vm.prank(TOURIST);
//     //     booking.createBooking{value: 1 ether}(PROVIDER);

//     //     uint256 touristBalanceBefore = TOURIST.balance;

//     //     vm.prank(TOURIST);
//     //     vm.expectEmit(true, false, false, true);
//     //     emit BookingCancelled(1);

//     //     booking.cancelBooking(1);

//     //     (, , , Booking.Status status) = booking.getBooking(1);
//     //     assertEq(uint(status), uint(Booking.Status.Cancelled));

//     //     assertEq(TOURIST.balance, touristBalanceBefore + 1 ether);
//     // }

//     // function testCancelBookingRevertsIfNotTourist() public {
//     //     vm.prank(TOURIST);
//     //     booking.createBooking{value: 1 ether}(PROVIDER);

//     //     vm.prank(PROVIDER);
//     //     vm.expectRevert("Only tourist can cancel");
//     //     booking.cancelBooking(1);
//     // }

//     // function testCancelBookingRevertsIfNotPending() public {
//     //     vm.prank(TOURIST);
//     //     booking.createBooking{value: 1 ether}(PROVIDER);

//     //     // Confirm completion first
//     //     vm.prank(TOURIST);
//     //     booking.confirmCompletion(1);

//     //     vm.prank(TOURIST);
//     //     vm.expectRevert("Booking not pending");
//     //     booking.cancelBooking(1);
//     // }

//     // ------------------- GET BOOKING -------------------
//     function testGetBookingReturnsCorrectDetails() public {
//         vm.prank(TOURIST);
//         booking.createBooking{value: 2 ether}(PROVIDER);

//         (
//             address tourist,
//             address provider,
//             uint256 amount,
//             Booking.Status status
//         ) = booking.getBooking(1);

//         assertEq(tourist, TOURIST);
//         assertEq(provider, PROVIDER);
//         assertEq(amount, 2 ether);
//         assertEq(uint(status), uint(Booking.Status.Completed));
//     }
// }
