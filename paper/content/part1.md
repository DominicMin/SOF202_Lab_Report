# Task 1: Requirement Analysis

- A: Identify the Functional (minimum 8) and Non-functional (minimum 4) requirements.

  - Section 1: Functional Requirements
    - Member registration: The system must allow that different types of uses (student, staffs, visitors, etc) can registrate an account and log in their own information.
    - Catalogue Registration: The system can let the administrator to add, update or delete the information of gym facilities (e.g. badminton court) and gears (e.g. badminton racket)
    - Booking: Members must be able to check that the facility/gear is available or not, and place their bookings as wish if there is anything available for them.
    - Conflict Prevention: The system can check whether there is an booking confliction in time or not, preventing that a singe object is booked by multiple person in the same time period.
    - Coach Assignment: System allows administrator to assign coaches to do the specific tutorials at specific times arranged.
    - Booking Cancellation: Users can cancel their reservations within a short period of time, which can let others to book later.
    - Search: Users can search for gear/facility filtered by category, time and availability.
    - Maintenance Tracking: The system must record maintenance schedules for facilities and equipment, ensuring unavailable resources are locked from booking.
  - Section 2: Non-functional Requirements
    - Security: All the sensitive data of users must be encrypted, and only can be assessed by the administrator if needed.
    - Availability: The system can be 24/7 available.
    - Performance: The searching calling time should be less than 3 seconds.
    - Data Integrity: The system must ensure data consistency under concurrent operations.(e.g. when two users try to make the same booking at the same time, only one of them should succeed)
- B: Clear the state of assumptions made

  - All the users have their own unique id.
  - Assume that all the payment for reservations happens offline.
  - The administrator is the only user who is responsible for backend data entry. The normal user do not have the permission.
  - Assume that some equipments can be booked only in some specific areas, and some others can be booked gym-wide.
