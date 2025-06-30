Create Database Uber_data;
Create table data_1(`Request id` INT PRIMARY KEY,	`Pickup point` VARCHAR(50),`Driver id` INT,
Status VARCHAR(50),	`Day of week` VARCHAR(50),`Pickup timestamp` TIME,	`Drop timestamp` TIME,`Time of Day` VARCHAR(50),Hour INT);

load data infile "D:/uber_data_cld.csv"
into table data_1
fields terminated by','
enclosed by '"'
Lines terminated by '\n'
ignore 1 lines
(`Request id`,`Pickup point`,`Driver id`,Status,`Day of week`,`Pickup timestamp`,`Drop timestamp`,`Time of Day`,Hour)
set `Request id` = NULLIF(`Request id`, '');

select count(*) from data_1;

select * from data_1
limit 100;

SELECT `Time of Day` ,COUNT(`Request id`) AS `TOTAL REQUESTS`
FROM data_1
GROUP BY `Time of Day`
ORDER BY `TOTAL REQUESTS` DESC;

SELECT `Time of Day` ,COUNT(`Request id`)`TOTAL REQUESTS`, Status
FROM data_1
GROUP BY `Time of Day` ,Status
ORDER BY `TOTAL REQUESTS`, Status;

SELECT `Time of Day`, COUNT(`Request id`)`TOTAL REQUESTS`,
SUM(CASE WHEN Status= 'Trip Completed' THEN 1 ELSE 0 END) AS Completed,
SUM(CASE WHEN Status != 'Trip Completed' THEN 1 ELSE 0 END) AS Supply_gap
FROM data_1
GROUP BY `Time of Day`
ORDER BY Supply_gap desc;

SELECT 
  `Time of Day`,
  SUM(CASE WHEN `Status` = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
  SUM(CASE WHEN `Status` = 'No Cars Available' THEN 1 ELSE 0 END) AS No_Cars
FROM data_1
GROUP BY `Time of Day`
ORDER BY Cancelled DESC;

SELECT `Pickup point`, COUNT(`Request Id`) AS TOTAL_REQUESTS
FROM data_1
GROUP BY `Pickup point`
ORDER BY `Pickup point`, TOTAL_REQUESTS DESC;

SELECT `Pickup point`,COUNT(`Request Id`) AS TOTAL_REQUESTS,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled,
       SUM(CASE WHEN Status != 'Trip Completed' THEN 1 ELSE 0 END) AS `Supply_gap`
FROM data_1
GROUP BY `Pickup point`
ORDER BY `Pickup point`,TOTAL_REQUESTS DESC;

SELECT COUNT(`Request id`) AS REQ_COUNT,
Hour,
		SUM(CASE WHEN Status != 'Trip Completed' THEN 1 ELSE 0 END) AS `Supply_gap`
From data_1
GROUP BY Hour
ORDER BY Hour ASC;

-- Detailed analysis(overall)
SELECT COUNT(`Request id`) AS REQ_COUNT,
`Day of Week`,Hour,`Time of Day`,
		SUM(CASE WHEN Status != 'Trip Completed' THEN 1 ELSE 0 END) AS `Supply_gap`,
        SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled,
        SUM(CASE WHEN Status= "Trip Completed" THEN 1 ELSE 0 END) AS TRIPS_COMPLETED
From data_1
GROUP BY `Day of Week`,Hour, `Time of Day`
ORDER BY `Day of week` asc,Hour asc;

SELECT `Time of Day`, 
       COUNT(*) AS Total,
       SUM(CASE WHEN `Status` = 'Trip Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN `Status` != 'Trip Completed' THEN 1 ELSE 0 END) AS Failed
FROM data_1
GROUP BY `Time of Day`;

SELECT `Pickup point`, `Status`, COUNT(`Status`) AS C
FROM data_1
GROUP BY `Pickup point`, `Status`;

SELECT `Hour`, COUNT(*) AS Completed
FROM data_1
WHERE `Status` = 'Trip Completed'
GROUP BY `Hour`
ORDER BY `Hour`;


SELECT COUNT(*) AS No_Driver_Assigned
FROM data_1
WHERE `Driver id` = 0;

SELECT COUNT(*) AS No_Drop_Recorded
FROM data_1
WHERE `Drop timestamp`=0;

