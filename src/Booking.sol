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
        uint256 indexed bookingId,
        address tourist,
        address provider,
        uint256 indexed amount
    );
    event ServiceDelivered(uint256 indexed bookingId);
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

    function markDelivered(uint256 _bookingId) external{
        Booking storage booking = bookings[_bookingId];
        require(msg.sender==booking.provider,"Not authorised");
        require(booking.status == Status.Pending, "Booking not pending");

        booking.status = Status.Delivered;

        (bool success, ) = payable(booking.provider).call{value:booking.amount}("");
        require(success, "Payment failed");

        emit PaymentReleased(_bookingId, booking.provider, booking.amount);
        emit ServiceDelivered(_bookingId);
    }

    function cancelBooking(uint256 _bookingId) external{
        Booking storage booking = bookings[_bookingId];
        require(msg.sender==booking.tourist,"Not authorised");
        require(booking.status == Status.Pending, "Booking not pending");

        booking.status = Status.Cancelled;

        (bool success, ) = payable(booking.tourist).call{value:booking.amount}("");
        require(success, "Payment failed");

        emit BookingCancelled(_bookingId, booking.tourist);
    }

    function getBooking(uint256 _bookingId) external view returns (Booking memory) {
        return bookings[_bookingId];
    }
}
