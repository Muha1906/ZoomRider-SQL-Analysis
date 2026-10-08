SHOW TABLES;

-- Part 1: Look at the data TO see 1st 10 row
SELECT * FROM trips LIMIT 10;


-- Q1.  How many rows are in the trips table?
SELECT count(*) As total_trips
from trips;


-- Q2.  Show the 5 longest completed trips.
SELECT trip_id, 
    city, 
    distance_km, 
    fare
FROM trips
WHERE status = 'Completed'
ORDER BY distance_km DESC
LIMIT 5;

-- ==========================================================================
-- Part 2: Count by a group
-- ==========================================================================

-- Q3.  How many trips happened in each city?
-- Q3: Trips by City
SELECT city, COUNT(*) AS total_trips
FROM trips
GROUP BY city
ORDER BY total_trips DESC;

-- Q3 Note: The city name is inconsistent.
-- Some city names appears with different spellings or extra spaces.


-- ***==========================================================================***
-- Part 3: Clean the data
-- ***==========================================================================***
-- Q4a: Fint the Duplicate Trips
SELECT 
    customer_id,
    driver_id,
    trip_date,
    fare,
    MIN(trip_id) AS first_trip_id,
    MAX(trip_id) AS duplicate_trip_id,
    COUNT(*) AS copies
FROM trips
GROUP BY customer_id, driver_id, trip_date, fare
HAVING COUNT(*) > 1;

-- Q4b.  How many Completed trips have a missing fare?
SELECT count(*) as missing_fares
from trips
WHERE status = 'Completed'
and fare is NULL;


-- Q5.  Fix the data
-- for remove extra spaces from city column
Update trips
set city = Trim(city);

-- correct spellings
Update trips
set city = 'Kampala'
where city = 'Kampla';

Update trips
set city = 'Nairobi'
where city = 'Nairobbi';

Update trips
set city = 'Port Harcourt'
where city = 'Port-Harcourt';


Update trips
set city = 'Port Harcourt'
where city = 'PH';

-- delete duplicate rows
Delete from trips
where trip_id in (299,300);


-- To check again Q3 query after cleaning
SELECT city, COUNT(*) AS total_trips
FROM trips
GROUP BY city
ORDER BY total_trips DESC;


-- ***================================================================***
-- Part 4: Find the answers (use the clean data)
-- ***================================================================***

-- Q6.  Revenue by City.
SELECT 
    city,
    COUNT(*) as total_trips,
    SUM(fare) as Revenue,
    round(avg(fare),2) as average_fare
from trips
where status = 'Completed'
group by city
order by revenue DESC;

-- Q7.  Revenue by Month
SELECT 
    DATE_FORMAT(trip_date, '%Y-%m') as month,
    COUNT(*) as total_trips,
    SUM(fare) as Revenue
from trips
where status = 'Completed'
group by  DATE_FORMAT(trip_date, '%Y-%m')
order by month;


-- ***================================================================***
-- Part 5: Join two tables
-- ***================================================================***

-- Q8.  Revenue by Vehicle Type
-- Q8: Revenue by Vehicle Type
SELECT
    d.vehicle_type,
    COUNT(*) AS total_trips,
    SUM(t.fare) AS revenue
FROM trips t
INNER JOIN drivers d
    ON t.driver_id = d.driver_id
WHERE t.status = 'Completed'
GROUP BY d.vehicle_type
ORDER BY revenue DESC;



-- ***================================================================***
-- Bonus questions (extra marks)
-- ***================================================================***

-- Q9.  Which customers have never booked a trip?
SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN trips t
    ON c.customer_id = t.customer_id
WHERE t.trip_id IS NULL;


-- Q10: Top 3 Customers by Spending
SELECT
    c.customer_name,
    SUM(t.fare) AS total_spend,
    COUNT(*) AS total_trips
FROM customers c
INNER JOIN trips t
    ON c.customer_id = t.customer_id
WHERE t.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spend DESC
LIMIT 3;


-- ***==============================================================***
-- Message to the Manager
-- ***==============================================================***

-- Message:
-- ZoomRide should invest more in lagos city because it generated the highest revenue of  218890.00 from 93 completed trips.
-- I found problem such as duplicate trips and inconsistenct city name Which could make revenue and trip counts inaccurate.
-- Before making a big decision, i would like to know the operation costs and profit for each city.




