CREATE DATABASE airline_analytics_db;
USE airline_analytics_db;

CREATE TABLE flight_data (
    Airline VARCHAR(50),
    Journey_Date DATE,
    Journey_Day VARCHAR(15),
    Journey_Month VARCHAR(15),
    Flight_Time_Slot VARCHAR(20),
    Source VARCHAR(50),
    Destination VARCHAR(50),
    Route VARCHAR(255),
    Airports_Visited INT,
    Route_Type VARCHAR(20),
    Departure_Time TIME,
    Arrival_Time TIME,
    Arrival_Day VARCHAR(15),
    Duration VARCHAR(20),
    Total_Stops INT,
    Additional_Info VARCHAR(100),
    Price INT,
    Duration_Minutes INT,
    Extra_Baggage_Payment DECIMAL(10,2)
);

SHOW TABLES;
DESCRIBE flight_data;
SHOW CREATE TABLE flight_data;
SHOW VARIABLES LIKE 'local_infile';

ALTER TABLE flight_data
MODIFY COLUMN Extra_Baggage_Payment VARCHAR(5);
DROP TABLE flight_data;

-- Q1. Display all records from the flight_data table.
SELECT * FROM flight_data;

-- Q2. Count the total number of flights available in the dataset.
SELECT COUNT(*) AS Total_Flights
FROM flight_data;

-- Q3. Show all unique airlines.
SELECT DISTINCT Airline
FROM flight_data;

-- Q4. Display all flights departing from Banglore.
SELECT * FROM flight_data
WHERE Source='Banglore';
    
-- Q5. Display all flights arriving at Delhi, New Delhi.
SELECT * FROM flight_data
WHERE Destination IN ('Delhi', 'New Delhi');

-- Q6. Display all two-stop flights.
SELECT * FROM flight_data
WHERE Route_Type='Two Stops';

-- Q7. Display the table structure.
DESCRIBE flight_data;

-- Q8. Display the top 10 most expensive flights.
SELECT * FROM flight_data
ORDER BY Price DESC
LIMIT 10;

-- Q9. Display the top 10 cheapest flights.
SELECT * FROM flight_data
ORDER BY Price ASC
LIMIT 10;

-- Q10. Find the airline that generated the highest revenue.
SELECT Airline, SUM(Price) AS Total_Revenue
FROM flight_data
GROUP BY Airline
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Q11. Find the busiest airline based on the total number of flights operated.
SELECT Airline, COUNT(*) AS Total_Flights
FROM flight_data
GROUP BY Airline
ORDER BY Total_Flights DESC
LIMIT 1;

-- Q12. Rank all airlines based on total revenue generated.
SELECT Airline, SUM(Price) AS Total_Revenue
FROM flight_data
GROUP BY Airline
ORDER BY Total_Revenue DESC;

-- Q13. Which routes generate the highest revenue.
SELECT Route, SUM(Price) AS Revenue
FROM flight_data
GROUP BY Route
ORDER BY Revenue DESC;

-- Q14. Which routes have the highest passenger demand.
SELECT Route, COUNT(*) AS Flights
FROM flight_data
GROUP BY Route
ORDER BY Flights DESC;

-- Q15. Which source airport contributes the highest revenue.
SELECT Source, SUM(Price) AS Revenue
FROM flight_data
GROUP BY Source
ORDER BY Revenue DESC
LIMIT 1;

-- Q16. Which destination receives the highest number of flights.
SELECT Destination, COUNT(*) AS Flights
FROM flight_data
GROUP BY Destination
ORDER BY Flights DESC
LIMIT 1;

-- Q17. Which city has the highest average ticket fare.
SELECT Destination, ROUND(AVG(Price),2) AS Avg_Fare
FROM flight_data
GROUP BY Destination
ORDER BY Avg_Fare DESC;

-- Q18. Which weekday generates maximum revenue.
SELECT Journey_Day, SUM(Price) AS Revenue
FROM flight_data
GROUP BY Journey_Day
ORDER BY Revenue DESC
LIMIT 1;

-- Q19. Which departure slot earns the highest revenue.
SELECT Flight_Time_Slot, SUM(Price) AS Revenue
FROM flight_data
GROUP BY Flight_Time_Slot
ORDER BY Revenue DESC;

-- Q20. Do direct flights charge more than connecting flights.
SELECT Route_Type, ROUND(AVG(Price),2) AS Avg_Price
FROM flight_data
GROUP BY Route_Type
ORDER BY Avg_Price DESC;

-- Q21. Does flight duration influence ticket price.
SELECT Duration_Minutes, ROUND(AVG(Price),2) AS Avg_Price
FROM flight_data
GROUP BY Duration_Minutes
ORDER BY Duration_Minutes DESC;

-- Q22. How many passengers purchase extra baggage.
SELECT Extra_Baggage_Payment, COUNT(*) AS Total_Flights
FROM flight_data
GROUP BY Extra_Baggage_Payment;

-- Q23. Which airlines operate the most overnight flights.
SELECT Airline, COUNT(*) AS Overnight_Flights
FROM flight_data
WHERE Arrival_Day='Next Day'
GROUP BY Airline
ORDER BY Overnight_Flights DESC;

ALTER TABLE flight_data
RENAME COLUMN Arrival_Day TO Arrival_Date;

-- Q24. Which airlines operate the highest number of next-day arrival flights.
SELECT Airline, COUNT(*) AS Next_Day_Flights
FROM flight_data
WHERE Arrival_Date > Journey_Date
GROUP BY Airline
ORDER BY Next_Day_Flights DESC;

-- Q25. How many flights arrive on the same day vs the next day.
SELECT
	CASE
        WHEN Arrival_Date = Journey_Date THEN 'Same Day'
        ELSE 'Next Day'
    END AS Arrival_Status,
    COUNT(*) AS Total_Flights
FROM flight_data
GROUP BY Arrival_Status
ORDER BY Arrival_Status DESC;

-- Q26. Which airlines operate the most overnight flights.
SELECT Airline, COUNT(*) AS Overnight_Flights
FROM flight_data
WHERE Arrival_Date > Journey_Date
GROUP BY Airline
ORDER BY Overnight_Flights DESC;

-- Q27. Calculate each airline's contribution (%) to the total number of flights.
SELECT Airline, COUNT(*) AS Total_Flights,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM flight_data),2) AS Flight_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Flight_Percentage DESC;

-- Q28. Calculate each airline's contribution (%) to the total revenue.
SELECT Airline, SUM(Price) AS Total_Revenue,
ROUND(SUM(Price) * 100.0 / (SELECT SUM(Price) FROM flight_data),2) AS Revenue_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Revenue_Percentage DESC;

-- Q29. Which routes should Air India increase flight frequency on.
SELECT Route, COUNT(*) AS Flights, SUM(Price) AS Revenue,
ROUND(AVG(Price),2) AS Avg_Fare
FROM flight_data
GROUP BY Route
ORDER BY Revenue DESC, Flights DESC;

-- Q30. Which airline earns the highest revenue per flying minute.
SELECT Airline, SUM(Price) AS Total_Revenue, SUM(Duration_Minutes) AS Total_Flying_Time,
ROUND(SUM(Price)/SUM(Duration_Minutes),2) AS Revenue_Per_Minute
FROM flight_data
GROUP BY Airline
ORDER BY Revenue_Per_Minute DESC;

-- Q31. Which month has the highest demand.
SELECT Journey_Month, COUNT(*) AS Flights
FROM flight_data
GROUP BY Journey_Month
ORDER BY Flights DESC
LIMIT 1;

-- Q32. Which airlines operate the highest percentage of overnight flights.
SELECT Airline,
    SUM(CASE WHEN Arrival_Date > Journey_Date THEN 1 ELSE 0 END) AS Overnight_Flights,
    COUNT(*) AS Total_Flights,
    ROUND(SUM(CASE WHEN Arrival_Date > Journey_Date THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) 
    AS Overnight_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Overnight_Percentage DESC;

-- Q33. Which source-destination pair generates the highest revenue.
SELECT Source, Destination, SUM(Price) AS Revenue
FROM flight_data
GROUP BY Source, Destination
ORDER BY Revenue DESC
LIMIT 1;

-- Q34. Which airline operates the highest percentage of direct flights.
SELECT Airline, 
SUM(CASE WHEN Route_Type = 'Direct' THEN 1 ELSE 0 END) AS Direct_Flights,
COUNT(*) AS Total_Flights,
ROUND(SUM(CASE WHEN Route_Type = 'Direct' THEN 1 ELSE 0 END)*100.0 / COUNT(*),2) AS DirectFlight_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY DirectFlight_Percentage DESC;

-- Q35. For each airline, calculate the percentage of flights that are overnight flights.
SELECT Airline,
SUM(CASE WHEN Arrival_Date > Journey_Date THEN 1 ELSE 0 END) AS Overnight_Flights,
COUNT(*) AS Total_Flights,
ROUND(SUM(CASE WHEN Arrival_Date > Journey_Date THEN 1 ELSE 0 END)*100.0 / COUNT(*),2) 
AS OvernightFlight_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY OvernightFlight_Percentage DESC;

-- Q36. Which airline has the highest percentage of flights requiring extra baggage payment. 
SELECT Airline, 
SUM(CASE WHEN Extra_Baggage_Payment = 'Yes' THEN 1 ELSE 0 END) AS Baggage_Payment_Paid,
ROUND(SUM(CASE WHEN Extra_Baggage_Payment = 'Yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*),2) 
AS PaidBaggage_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY PaidBaggage_Percentage DESC
LIMIT 1;

-- Q37. Which airline has the highest percentage of premium-priced flights. 
SELECT Airline, 
SUM(CASE WHEN Price > 10000 THEN 1 ELSE 0 END) AS Premium_Priced_Flights,
COUNT(*) AS Total_Flights,
ROUND(SUM(CASE WHEN Price > 10000 THEN 1 ELSE 0 END)*100.0 / COUNT(*),2) AS PremiumPriced_Flight_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY PremiumPriced_Flight_Percentage DESC;

-- Q38. Does Air India charge more for direct flights or connecting flights. 
SELECT Route_Type, ROUND(AVG(Price),2) AS Avg_Price
FROM flight_data
WHERE Airline='Air India'
GROUP BY Route_Type
ORDER BY Avg_Price DESC;

-- Q39. Which airline is overcharging compared to the market average.
SELECT Airline, ROUND(AVG(Price),2) AS Avg_Price,
CASE WHEN ROUND(AVG(Price),2) > (SELECT ROUND(AVG(Price),2) FROM flight_data) THEN 'Yes' ELSE 'No' END 
AS Overcharging_Status
FROM flight_data
GROUP BY Airline
ORDER BY Avg_Price DESC;

-- Q40. If Air India could add capacity to only three routes next quarter, which routes should be prioritized based on demand, revenue and average fare.
SELECT Route, COUNT(*) AS Total_Flights,
SUM(Price) AS Total_Revenue,
ROUND(AVG(Price),2) AS Average_Fare
FROM flight_data
WHERE Airline = 'Air India'
GROUP BY Route
ORDER BY Total_Revenue DESC, Total_Flights DESC, Average_Fare DESC
LIMIT 3;

-- Q41: Executive Airline Performance Dashboard Query.
SELECT Airline, COUNT(*) AS Flights, SUM(Price) AS Revenue,
ROUND(AVG(Price),2) Avg_Fare, ROUND(AVG(Duration_Minutes),2) Avg_Duration,
ROUND(SUM(CASE WHEN Route_Type='Direct' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) Direct_Flight_Percentage,
ROUND(SUM(CASE WHEN Arrival_Date>Journey_Date THEN 1 ELSE 0 END)*100.0/COUNT(*),2) Overnight_Flight_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Revenue DESC;

-- Market Share Analysis
-- Which airlines dominate the market based on flight operations.
SELECT Airline,
ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM flight_data),2) AS Market_Share_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Market_Share_Percentage DESC;

-- Revenue Share Analysis
-- Which airlines contribute the highest share of total revenue.
SELECT Airline,
ROUND(SUM(Price)*100.0/(SELECT SUM(Price) FROM flight_data),2) AS Revenue_Share_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Revenue_Share_Percentage DESC;

-- Pricing Strategy
-- Which airlines follow a premium pricing strategy.
SELECT Airline, ROUND(AVG(Price),2) AS Average_Fare,
CASE WHEN AVG(Price) > (SELECT AVG(Price) FROM flight_data) THEN 'Premium Pricing' ELSE 'Competitive Pricing' END 
AS Pricing_Strategy
FROM flight_data
GROUP BY Airline
ORDER BY Average_Fare DESC;  

-- Overall commercial and operational performance of the airline industry based on key business KPIs.
SELECT
    COUNT(*) AS Total_Flights,
    SUM(Price) AS Total_Revenue,
    ROUND(AVG(Price),2) AS Average_Ticket_Fare,
    ROUND(AVG(Duration_Minutes),2) AS Average_Flight_Duration_Minutes,
    COUNT(DISTINCT Airline) AS Total_Airlines,
    COUNT(DISTINCT Route) AS Total_Routes
FROM flight_data;

-- Commercial Revenue Analysis
SELECT Airline, COUNT(*) AS Total_Flights, SUM(Price) AS Total_Revenue,
ROUND(AVG(Price),2) AS Average_Fare, 
ROUND(SUM(Price)*100.0/(SELECT SUM(Price) FROM flight_data),2) AS Revenue_Share_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Total_Revenue DESC;

-- Demand & Market Share Analysis
SELECT Airline, COUNT(*) AS Total_Flights,
ROUND(COUNT(*) * 100.0/(SELECT COUNT(*) FROM flight_data),2) AS Market_Share_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Total_Flights DESC;

-- Pricing Strategy Analysis
SELECT
    Airline, COUNT(*) AS Flights,
    SUM(CASE WHEN Price > 10000 THEN 1 ELSE 0 END) AS Premium_Flights,
    SUM(CASE WHEN Price <= 10000 THEN 1 ELSE 0 END) AS Economy_Flights,
    ROUND(SUM(CASE WHEN Price > 10000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Premium_Flight_Percentage,
    ROUND(SUM(CASE WHEN Price <= 10000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Economy_Flight_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Premium_Flight_Percentage DESC;

-- Operational Performance Analysis
SELECT
    Airline,
    ROUND(AVG(Duration_Minutes),2) AS Avg_Duration,
    ROUND(SUM(CASE WHEN Route_Type='Direct' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS Direct_Flight_Percentage,
    ROUND(SUM(CASE WHEN Arrival_Date>Journey_Date THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS Overnight_Flight_Percentage
FROM flight_data
GROUP BY Airline
ORDER BY Avg_Duration DESC;


SET SQL_SAFE_UPDATES = 0;
UPDATE flight_data
SET Route = REPLACE(Route, ' ? ', ' → ');
SET SQL_SAFE_UPDATES = 1;

-- Network & Route Intelligence
SELECT
    REPLACE(Route, ' ? ', ' → ') AS Route,
    COUNT(*) AS Total_Flights,
    SUM(Price) AS Total_Revenue,
    ROUND(AVG(Price),2) AS Average_Fare
FROM flight_data
GROUP BY Route
ORDER BY
    Total_Revenue DESC,
    Total_Flights DESC,
    Average_Fare DESC;
