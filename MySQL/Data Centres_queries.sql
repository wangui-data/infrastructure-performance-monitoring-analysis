USE data_upload;
-- CREATE TABLE statements
CREATE TABLE Dim_Client (
Client_ID INT PRIMARY KEY,
Company_Size VARCHAR(100),
Industry VARCHAR(255),
Contract_Tier VARCHAR(100),
HQ_Region VARCHAR(100)
);
CREATE TABLE Dim_Asset (
Asset_ID INT PRIMARY KEY,
Asset_Model VARCHAR(100),
Capacity_kW INT,
Installation_Date DATE,
Operational_Status VARCHAR(100)
);
CREATE TABLE Fact_Infrastructure_Telemetry (
Telemetry_ID INT PRIMARY KEY,
Date_ID INT,
Client_ID INT,
Asset_ID INT,
Power_Consumed_kWh DECIMAL(10,2) NULL,
Avg_CPU_Utilization_Pct DECIMAL(5,1) NULL,
Thermal_Reading_C DECIMAL(5,1) NULL,
System_Alerts INT NULL
);

--  Which industries make up the largest share of our customer base?
SELECT
    Industry,
    COUNT(DISTINCT Client_ID) AS Client_Count,
    ROUND(
        COUNT(DISTINCT Client_ID) * 100.0 /
        (SELECT COUNT(DISTINCT Client_ID) FROM Dim_Client),
        2
    ) AS Percentage_of_Client_Base
FROM Dim_Client
GROUP BY Industry
ORDER BY Client_Count DESC;

-- What percentage of our clients belong to the 'Enterprise' Company_Size?
SELECT 
    Company_Size,
    COUNT(Client_ID) AS Client_Count,
    ROUND(COUNT(Client_ID) * 100.0 / SUM(COUNT(Client_ID)) OVER (), 2) AS Pct_Total
FROM Dim_Client
GROUP BY Company_Size;

-- Which Contract_Tier, Premium vs. Standard, is consuming the most compute power (Avg_CPU_Utilization_Pct)?
SELECT
    Contract_Tier,
    COUNT(DISTINCT Client_ID) AS Client_Count
FROM dim_client
WHERE Contract_Tier IN ('Premium', 'Standard')
GROUP BY Contract_Tier;

-- How does client contract tier (Contract_Tier) affect the average workload/CPU utilization placed on data center assets?
SELECT
    c.Contract_Tier,
    AVG(t.Avg_CPU_Utilization_Pct) AS Avg_CPU_Utilization
FROM dim_client c
JOIN Fact_Infrastructure_Telemetry t
    ON c.Client_ID = t.Client_ID
GROUP BY c.Contract_Tier
ORDER BY Avg_CPU_Utilization DESC;

-- Which Industry generates the highest number of average System_Alerts per day?
SELECT 
    c.Industry,
    ROUND(SUM(t.System_Alerts) * 1.0 / COUNT(DISTINCT t.date_id), 2) AS Avg_Alerts_Per_Day
FROM Dim_Client c
JOIN Fact_Infrastructure_Telemetry t ON c.Client_ID = t.Client_ID
GROUP BY c.Industry
ORDER BY Avg_Alerts_Per_Day DESC;

-- Which Industry accounts for the highest total power consumption (Power_Consumed_kWh)?
SELECT
    c.Industry,
    SUM(t.Power_Consumed_kWh) AS Total_Power_Consumed
FROM dim_client c
JOIN Fact_Infrastructure_Telemetry t
    ON c.Client_ID = t.Client_ID
GROUP BY c.Industry
ORDER BY Total_Power_Consumed DESC;

-- Which asset models consume the most power?
SELECT
    a.Asset_Model,
    SUM(t.Power_Consumed_kWh) AS Total_Power_Consumed
FROM dim_asset a
JOIN Fact_Infrastructure_Telemetry t
    ON a.Asset_ID = t.Asset_ID
GROUP BY a.Asset_Model
ORDER BY Total_Power_Consumed DESC;

-- How many total hardware assets are currently marked as 'Decommissioned' versus 'Online' in Dim_Asset?
SELECT 
    Operational_Status,
    COUNT(Asset_ID) AS Total_Assets
FROM Dim_Asset
WHERE Operational_Status IN ('Decommissioned', 'Online')
GROUP BY Operational_Status;

-- Which specific server racks (Asset_ID) are pulling power that exceeds their rated Capacity_kW?
SELECT 
    a.Asset_ID,
    a.Capacity_kW,
    MAX(t.Power_Consumed_kWh) AS Peak_Observed_Power_kW
FROM Dim_Asset a
JOIN Fact_Infrastructure_Telemetry t ON a.Asset_ID = t.Asset_ID
GROUP BY a.Asset_ID, a.Capacity_kW
HAVING MAX(t.Power_Consumed_kWh) > a.Capacity_kW;

--  What is the total Power_Consumed_kWh broken down by Asset_Model? (Do newer models consume less power?)
SELECT 
    a.Asset_Model,
    MIN(a.Installation_Date) AS Earliest_Install_Date,
    SUM(t.Power_Consumed_kWh) AS Total_Power_kWh,
    ROUND(AVG(t.Power_Consumed_kWh), 2) AS Avg_Power_Per_Log
FROM Dim_Asset a
JOIN Fact_Infrastructure_Telemetry t ON a.Asset_ID = t.Asset_ID
GROUP BY a.Asset_Model
ORDER BY Total_Power_kWh DESC;

-- Which Asset_Model runs at the highest average thermal reading (Thermal_Reading_C), and does it correlate with high CPU utilization?
SELECT
    a.Asset_Model,
    AVG(t.Thermal_Reading_C) AS Avg_Temperature,
    AVG(t.Avg_CPU_Utilization_Pct) AS Avg_CPU
FROM dim_asset a
JOIN Fact_Infrastructure_Telemetry t
    ON a.Asset_ID = t.Asset_ID
GROUP BY a.Asset_Model
ORDER BY Avg_Temperature DESC;

-- Which Industry accounts for the highest total power consumption (Power_Consumed_kWh)?
SELECT
    c.Industry,
    SUM(t.Power_Consumed_kWh) AS Total_Power_Consumed
FROM dim_client c
JOIN Fact_Infrastructure_Telemetry t
    ON c.Client_ID = t.Client_ID
GROUP BY c.Industry
ORDER BY Total_Power_Consumed DESC;

-- Who are the top 10 clients (Client_ID) generating the most system alerts (System_Alerts) across all their operational assets?
SELECT
    c.Client_ID,
    SUM(t.System_Alerts) AS Total_Alerts
FROM dim_client c
JOIN Fact_Infrastructure_Telemetry t
    ON c.Client_ID = t.Client_ID
GROUP BY c.Client_ID
ORDER BY Total_Alerts DESC
LIMIT 10;

-- What is the month-over-month trend for total power consumption across the entire data center?
SELECT 
    DATE('month', Date_ID) AS Consumption_Month,
    SUM(Power_Consumed_kWh) AS Total_Power_kWh,
    LAG(SUM(Power_Consumed_kWh)) OVER (ORDER BY DATE_TRUNC('month', Date_ID)) AS Prior_Month_kWh,
    ROUND(
        (SUM(Power_Consumed_kWh) - LAG(SUM(Power_Consumed_kWh)) OVER (ORDER BY DATE_TRUNC('month', Date_ID))) 
        * 100.0 / NULLIF(LAG(SUM(Power_Consumed_kWh)) OVER (ORDER BY DATE_TRUNC('month', Date_ID)), 0), 2
    ) AS MoM_Growth_Pct
FROM Fact_Infrastructure_Telemetry
GROUP BY DATE_TRUNC('month', Date_ID)
ORDER BY Consumption_Month ASC;

--  What are the maximum and minimum Thermal_Reading_C in the dataset? Are there any impossible temperatures (e.g., below 0°C or above 100°C) that indicate broken sensors?
SELECT 
    MIN(Thermal_Reading_C) AS Min_Temp,
    MAX(Thermal_Reading_C) AS Max_Temp,
    SUM(CASE WHEN Thermal_Reading_C < 0 OR Thermal_Reading_C > 100 THEN 1 ELSE 0 END) AS impossible_temp_Count
FROM Fact_Infrastructure_Telemetry;

-- Are clients in the 'Nairobi East' region running their servers hotter (higher average Thermal_Reading_C) than clients in 'Mombasa'?
SELECT 
    c.HQ_Region,
    ROUND(AVG(t.Thermal_Reading_C), 2) AS Avg_Thermal_Temp
FROM Dim_Client c
JOIN Fact_Infrastructure_Telemetry t ON c.Client_ID = t.Client_ID
WHERE c.HQ_Region IN ('Nairobi East', 'Mombasa')
GROUP BY c.HQ_Region;

-- What is the total power consumption per HQ_Region (e.g., Nairobi East, Nairobi West, Kigali, Mombasa, Dar es Salaam)?
SELECT
    c.HQ_Region,
    SUM(t.Power_Consumed_kWh) AS Total_Power_Consumed
FROM dim_client c
JOIN Fact_Infrastructure_Telemetry t
    ON c.Client_ID = t.Client_ID
GROUP BY c.HQ_Region
ORDER BY Total_Power_Consumed DESC;

-- Which regional clients experience the highest average number of system alerts per telemetry log?
SELECT
    c.HQ_Region,
    SUM(t.System_Alerts) AS Total_Alerts,
    COUNT(t.Telemetry_ID) AS Telemetry_Logs,
    ROUND(
        SUM(t.System_Alerts) * 1.0 /
        COUNT(t.Telemetry_ID),
        4
    ) AS Alerts_Per_Telemetry_Log
FROM dim_client c
JOIN Fact_Infrastructure_Telemetry t
    ON c.Client_ID = t.Client_ID
GROUP BY c.HQ_Region
ORDER BY Alerts_Per_Telemetry_Log DESC;

-- Client_ID and Company_Size of any client whose average CPU utilization is above 85% and has generated more than 2 system alerts?
SELECT 
    c.Client_ID,
    c.Company_Size,
    ROUND(AVG(t.Avg_CPU_Utilization_Pct), 2) AS Avg_CPU_Pct,
    SUM(t.System_Alerts) AS Total_Alerts
FROM Dim_Client c
JOIN Fact_Infrastructure_Telemetry t ON c.Client_ID = t.Client_ID
GROUP BY c.Client_ID, c.Company_Size
HAVING AVG(t.Avg_CPU_Utilization_Pct) > 85 
   AND SUM(t.System_Alerts) > 2;
   
-- Which client-asset combinations are generating the highest total volume of System_Alerts?
SELECT
    c.Client_ID,
    c.Industry,
    a.Asset_ID,
    a.Asset_Model,
    SUM(t.System_Alerts) AS Total_Alerts
FROM Fact_Infrastructure_Telemetry t
JOIN dim_client c
    ON t.Client_ID = c.Client_ID
JOIN dim_asset a
    ON t.Asset_ID = a.Asset_ID
GROUP BY
    c.Client_ID,
    c.Industry,
    a.Asset_ID,
    a.Asset_Model
ORDER BY Total_Alerts DESC;

-- What percentage of total telemetry records register both high thermal readings (>30°C) and active system alerts (>0)?
SELECT
    COUNT(*) AS Total_Telemetry_Records,

    SUM(
        CASE
            WHEN Thermal_Reading_C > 30
             AND System_Alerts > 0
            THEN 1
            ELSE 0
        END
    ) AS High_Temp_And_Alert_Records,

    ROUND(
        SUM(
            CASE
                WHEN Thermal_Reading_C > 30
                 AND System_Alerts > 0
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Percentage
FROM Fact_Infrastructure_Telemetry;

