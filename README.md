# Hotel Reservation Database -- SQL Analysis

## Project Overview

This project uses SQL to manage and analyze hotel reservation data. It
explores booking demand, guest booking behaviour, stay outcomes, and
staff and room performance to support data-driven decisions in hotel
operations.

## Objectives

-   Create a relational database for hotel reservation operations.
-   Analyze booking volume, booking channels, requested room types, and
    revenue.
-   Understand guest activity and compare Individual and Corporate
    guests.
-   Evaluate stay statuses, duration, cancellations, and no-shows.
-   Compare staff workloads and room usage.

## Tools and Technologies

-   **SQL**
-   **MySQL** (the script uses MySQL-compatible syntax such as `YEAR()`,
    `SHOW TABLES`, and `DESCRIBE`)

## Database Structure

The database is named `hotel_reservation_db` and contains six tables:

  -----------------------------------------------------------------------
  Table                               Purpose
  ----------------------------------- -----------------------------------
  `guests`                            Guest details, city, guest type,
                                      room preference, loyalty tier, and
                                      account start date

  `hotels`                            Hotel details, location, star
                                      rating, room count, and opening
                                      date

  `rooms`                             Room type, floor, occupancy,
                                      nightly price, and active status

  `staff`                             Staff details, hire date, rating,
                                      department, and active status

  `bookings`                          Booking dates, guest and hotel
                                      references, channel, requested room
                                      type, nights, and amount

  `stays`                             Stay details, room and staff
                                      references, check-in/out dates,
                                      status, nights stayed, service
                                      requests, and duration
  -----------------------------------------------------------------------

Primary keys identify records. Foreign keys connect rooms to hotels,
bookings to guests and hotels, and stays to bookings, rooms, and staff.

## Analysis Covered

### 1. Basic Database Checks

-   Count guests, hotels, rooms, staff, bookings, and stays.
-   List available room types and booking channels.
-   Calculate total booking amount and average nights booked.
-   Identify active staff.

### 2. Booking Demand

-   Rank hotels by booking volume and revenue.
-   Compare booking channels and requested room types.
-   Review booking volume by year.

### 3. Guest Booking Behaviour

-   Rank guests by number of bookings and total booking amount.
-   Compare unique guests across hotels.
-   Compare booking activity and revenue for Individual and Corporate
    guests.
-   Track booking patterns over time.

### 4. Stay Performance

-   Compare checked-out stays across hotels.
-   Calculate average nights stayed and average stay duration by status.
-   Compare stay outcomes such as Checked-out, No-show, Cancelled, and
    In-progress.
-   Review stay outcomes over time.

### 5. Staff and Room Performance

-   Compare stays handled by staff members.
-   Review staff stay outcomes and average stay duration.
-   Compare usage across room types and individual rooms.

### 6. Booking and Stay Problems

-   Identify cancellations and no-shows by hotel.
-   Review stay-status patterns.
-   Compare outcomes for stays with more than two service requests.

## How to Run

1.  Install and open MySQL Workbench or another MySQL-compatible SQL
    client.
2.  Open the `.sql` file.
3.  Connect to your MySQL server.
4.  Review the script before running it.
5.  Execute the database and table creation statements first, then run
    the analysis queries.
6.  Review the result grids for each query.

## Important Note

The SQL script contains `DROP TABLE stays;`. If you run the entire
script from top to bottom, this statement deletes the `stays` table and
later queries that use it will fail unless the table is recreated.
Comment out or remove that statement before a full run, unless dropping
the table is intentional.

## Repository Contents

-   `*.sql` --- SQL script containing database/table creation statements
    and analysis queries.
-   `README.md` --- Project overview, schema summary, analysis scope,
    and setup instructions.

## Conclusion

This project demonstrates the use of SQL DDL and DML concepts, primary
and foreign keys, filtering, aggregation, grouping, sorting, joins, and
date-based analysis to extract insights from hotel reservation data.
