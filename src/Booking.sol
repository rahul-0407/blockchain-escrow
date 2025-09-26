// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TourismEscrow {
    enum Status {
        Pending,
        Delivered,
        Cancelled
    }

    struct Booking {
        address tourist;
        address provider;
        uint256 amount;
        Status status;
    }

    uint256 public bookingCount;
    mapping(uint256 => Booking) public bookings;

    event BookingCreated(
        uint256 bookingId,
        address tourist,
        address provider,
        uint256 amount
    );
    event ServiceDelivered(uint256 bookingId);
    event BookingCancelled(uint256 bookingId, address refundedTo);
    event PaymentReleased(uint256 bookingId, address to, uint256 amount);

    function createBooking(address _provider) external payable returns (uint256) {
        require(msg.value > 0, "Payment must be > 0");

        bookingCount++;
        bookings[bookingCount] = Booking({
            tourist: msg.sender,
            provider: _provider,
            amount: msg.value,
            status: Status.Pending
        });

        emit BookingCreated(bookingCount, msg.sender, _provider, msg.value);
        return bookingCount;
    }

    function getBooking(uint256 _bookingId) external view returns (Booking memory) {
        return bookings[_bookingId];
    }
}
