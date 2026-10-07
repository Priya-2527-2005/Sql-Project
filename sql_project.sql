create database hotel_reservation_db;

use hotel_reservation_db;

create table guests (
    guest_id varchar(10) primary key,
    guest_name varchar(100) not null,
    city varchar(50) not null,
    guest_type varchar(20) not null,
    preferred_room_type varchar(30),
    loyalty_tier varchar(20),
    account_since date not null
);

create table hotels (
    hotel_id varchar(10) primary key,
    hotel_name varchar(100) not null,
    city varchar(50) not null,
    star_rating int not null,
    total_rooms int not null,
    opened_date date not null
);

create table rooms (
    room_id varchar(10) primary key,
    hotel_id varchar(10) not null,
    room_type varchar(30) not null,
    floor_number int not null,
    max_occupancy int not null,
    price_per_night decimal(10,2) not null,
    is_active boolean not null default true,
    foreign key (hotel_id) references hotels(hotel_id)
);

create table staff (
    staff_id varchar(10) primary key,
    staff_name varchar(100) not null,
    hire_date date not null,
    rating decimal(3,2),
    department varchar(50) not null,
    is_active boolean not null default true
);

create table bookings (
    booking_id varchar(10) primary key,
    guest_id varchar(10) not null,
    hotel_id varchar(10) not null,
    booking_date date not null,
    room_type_requested varchar(30) not null,
    booking_channel varchar(30) not null,
    nights_booked int not null,
    total_amount decimal(10,2) not null,
	foreign key (guest_id) references guests(guest_id),
	foreign key (hotel_id) references hotels(hotel_id)
);

create table stays (
    stay_id varchar(10) primary key,
    booking_id varchar(10) not null,
    room_id varchar(10) not null,
    staff_id varchar(10) not null,
    check_in_date date,
    check_out_date date,
    status varchar(20) not null,
    nights_stayed int not null,
    service_requests int not null,
    stay_duration_hrs decimal(10,2) not null,
	foreign key (booking_id) references bookings(booking_id),
	foreign key (room_id) references rooms(room_id),
	foreign key (staff_id) references staff(staff_id)
);

show tables;
select count(*) as total_guests
from guests;

select count(*) AS total_hotels
from hotels;

select count(*) AS total_rooms
from rooms;

drop table stays;

select count(*) AS total_staff
from staff;

select count(*) AS total_bookings
from bookings;


describe stays;

select count(*) AS total_stays
from stays;


-- Sprint 3

-- 1. What is the total number of guests?
select count(*) AS total_guests
from guests;

-- 2. What is the total number of bookings?
select count(*) AS total_bookings
from bookings;

-- 3. What is the total number of stays?
select count(*) as total_stays
from stays;

-- 4. What are the different room types available?
select distinct room_type
from rooms;

-- 5. How many staff members are currently active?
select count(*) as active_staff
from staff
where is_active = 1;

-- 6. What are the different booking channels?
select distinct booking_channel
from bookings;

-- 7. What is the total booking amount across all bookings?
select sum(total_amount) AS total_booking_amount
from bookings;

-- 8. What is the average nights booked per booking?
select avg(nights_booked) AS average_nights_booked
from bookings;

-- Sprint 4: Objective-Based Analysis
-- 4.1 Understand Booking Demand

-- Which hotels receive the most bookings?
select hotel_id, count(*) as total_bookings
from bookings
group by hotel_id
order by total_bookings desc;

-- Which booking channels generate the most bookings?
select booking_channel, count(*) as total_bookings
from bookings
group by booking_channel
order by total_bookings desc;

-- Which room types are requested most frequently?
select room_type_requested, COUNT(*) AS total_bookings
from bookings
GROUP BY room_type_requested
ORDER BY total_bookings DESC;

-- How does booking demand change over time?
select year(booking_date) as booking_year, count(*) as total_bookings
from bookings
group by booking_year
order by booking_year;

-- Which hotels generate the highest booking revenue?
select hotel_id, sum(total_amount) as total_revenue
from bookings
group by hotel_id
order by total_revenue desc;

-- 4.2 Understand Guest Booking Behaviour

-- Compare guests based on the number of bookings they make.
select guest_id, count(*) as total_bookings
from bookings
group by guest_id
order by total_bookings desc;

-- Identify guests with a higher total booking amount.
select guest_id, sum(total_amount) as total_booking_amount
from bookings
group by guest_id
order by total_booking_amount desc;

-- Compare guest activity across hotels.
select hotel_id, count(distinct guest_id) as unique_guests
from bookings
group by hotel_id
order by unique_guests desc;

-- Look at differences between Individual and Corporate guests.
select g.guest_type,
       count(b.booking_id) as total_bookings,
       count(distinct b.guest_id) as unique_guests,
       sum(b.total_amount) as total_booking_amount
from guests g
join bookings b on g.guest_id = b.guest_id
where g.guest_type in ('Individual', 'Corporate')
group by g.guest_type;

-- Examine guest booking patterns over time.
select year(booking_date) as booking_year,
       count(*) as total_bookings,
       count(distinct guest_id) as unique_guests
from bookings
group by year(booking_date)
order by booking_year;

-- 4.3 Evaluate Stay Performance

-- Compare stay outcomes across different hotels.
select b.hotel_id, count(s.stay_id) as completed_stays
from bookings b
join stays s
    on b.booking_id = s.booking_id
where s.status = 'Checked-out'
group by b.hotel_id
order by completed_stays desc;

-- Examine stay duration.
select status,
       round(avg(nights_stayed), 2) as avg_nights_stayed,
       round(avg(stay_duration_hrs), 2) as avg_duration_hrs
from stays
group by status
order by avg_duration_hrs desc;

-- Compare stay outcomes by status — Checked-out, No-show, Cancelled, In-progress.
select status,
    COUNT(*) AS total_stays
from stays
GROUP BY status
ORDER BY total_stays DESC;

-- Identify hotels with higher booking activity or poorer outcomes.
select b.hotel_id,
       count(s.stay_id) as poor_outcome_stays
from bookings b
join stays s
    on b.booking_id = s.booking_id
where s.status in ('Cancelled', 'No-show')
group by b.hotel_id
order by poor_outcome_stays desc;

-- Compare stay performance over time.
select year(s.check_in_date) as stay_year, s.status,
       count(*) as total_stays
from stays s
where s.check_in_date is not null
group by year(s.check_in_date), s.status
order by stay_year, total_stays desc;

-- 4.4 Understand Staff and Room Performance

-- Compare the number of stays handled by staff members.
select staff_id,
       count(stay_id) as total_stays_handled
from stays
group by staff_id
order by total_stays_handled desc;
-- Compare staff performance across stay outcomes.
select staff_id, status,
       count(stay_id) as total_stays
from stays
group by staff_id, status
order by staff_id, total_stays desc;

-- Examine stay duration across staff members.
select staff_id,
       round(avg(nights_stayed), 2) as avg_nights_stayed,
       round(avg(stay_duration_hrs), 2) as avg_duration_hrs
from stays
group by staff_id
order by avg_duration_hrs desc;

-- Compare room usage across different room types.
select r.room_type,
       count(s.stay_id) as total_stays
from rooms r
join stays s
    on r.room_id = s.room_id
group by r.room_type
order by total_stays desc;

-- Look at stay performance across different rooms.
select r.room_id, r.room_type,
       count(s.stay_id) as completed_stays
from rooms r
join stays s
    on r.room_id = s.room_id
where s.status = 'Checked-out'
group by r.room_id, r.room_type
order by completed_stays desc;

-- 4.5 Identify Booking and Stay Problems

-- Examine which bookings resulted in cancellations or no-shows.
select
    b.hotel_id,
    s.status,
    count(s.stay_id) as total_problem_stays
from bookings b
join stays s
    on b.booking_id = s.booking_id
where s.status in ('Cancelled', 'No-show')
group by b.hotel_id, s.status
order by total_problem_stays desc;
-- Identify common stay statuses and problem patterns.
select status,
       count(*) as total_stays
from stays
group by status
order by total_stays desc;

-- Compare stay performance for bookings with high service request counts.
select status,
       count(*) as total_stays,
       round(avg(service_requests), 2) as avg_service_requests
from stays
where service_requests > 2
group by status
order by total_stays desc;

-- Examine whether certain hotels experience more booking problems.
select b.hotel_id,
       count(s.stay_id) as problem_bookings
from bookings b
join stays s
    on b.booking_id = s.booking_id
where s.status in ('Cancelled', 'No-show')
group by b.hotel_id
order by problem_bookings desc;