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
