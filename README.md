# infrastructure-performance-monitoring-analysis

# Data Center Infrastructure & Operations

**MySQL** · **Excel** · **EDA**· **Power BI** · **DAX** · **Power Query** · **Data Modeling** · **Business Intelligence**

---
## 📖 Project Overview

This project analyzes data center infrastructure and operational performance using client, asset, and telemetry data.

The analysis focuses on:

- Energy consumption
- CPU utilization
- Thermal conditions
- System alerts
- Asset operational status
- Client and regional performance

The goal is to identify patterns that may indicate high infrastructure utilization, unusual energy consumption, thermal issues, or increased system alert activity.

---

# 🎯 Business Problem

The Data Centre wants to understand **how efficiently and reliably the data centers/assets are operating, and which clients, assets, or conditions are driving high energy consumption, performance issues, or system alerts**

The analysis focuses on five key business areas.

### ⚡ Energy Consumption

- What is the total power consumption?
- Which clients consume the most energy?
- Which asset models consume the most energy?
- How does power consumption change over time?
- How does energy consumption vary by region?

### 🖥️ Infrastructure Utilization

- What is the average CPU utilization?
- Which contract tiers have the highest CPU utilization?
- Which clients have the highest infrastructure utilization?
- Which assets operate at high CPU utilization?

### 🌡️ Thermal Performance

- What are the minimum, maximum, and average thermal readings?
- Which asset models have the highest average thermal readings?
- Which regions have the highest average thermal readings?
- Is higher CPU utilization associated with higher thermal readings?
- Are there potentially abnormal temperature readings?

### 🚨 System Reliability

- How many system alerts were recorded?
- Which clients generate the most alerts?
- Which assets generate the most alerts?
- Which asset models experience the most alerts?
- Are system alerts associated with high CPU utilization or elevated thermal readings?

### 🌍 Regional Performance

- Which regions consume the most energy?
- Which regions have the highest CPU utilization?
- Which regions have the highest thermal readings?
- Which regions experience the most system alerts?

---

# 🚀 Project Objectives

✔ Perform data quality checks on `Thermal_Reading_C` and identify potentially faulty sensor readings.

✔ Analyze hardware asset status by comparing `Online` and `Decommissioned` assets.

✔ Calculate the proportion of clients classified as `Enterprise`.

✔ Identify industries with the highest average daily system alerts.

✔ Analyze power consumption by `Asset_Model` and evaluate energy efficiency across newer and older models.

✔ Compare server thermal performance across the `Nairobi East` and `Mombasa` regions.

✔ Compare average CPU utilization across `Premium` and `Standard` contract tiers.

✔ Identify high-utilization clients with average CPU utilization above 85% and more than 2 system alerts.

✔ Detect server racks where power consumption exceeds rated `Capacity_kW`.

✔ Analyze month-over-month changes in total data-center power consumption.

✔ Create reusable SQL queries for data extraction, filtering, aggregation and analysis.

✔ Develop reusable DAX measures and calculated metrics in Power BI.

✔ Build an interactive Power BI dashboard to visualize operational performance and identify potential infrastructure issues.

---

# 🛠 Tools Used

| Tool             | Purpose                                             |
| ---------------- | --------------------------------------------------- |
| **Excel**        | Exploratory Data Analysis                           |
| **MySQL**      | Extracting raw data and profiling your metrics      |
| **Power Bi**     | Data modeling, visualization, dashboard development |
| **GitHub**       | Project documentation and portfolio presentation    |


---
# 📂 Dataset Overview

The Data Centre dataset contains multiple tables representing different aspects of the performance operations.

The project uses three main tables:

### `Client`

The table tells you who the data center customer is.

| Column           | Description                         |
| ---------------- | ----------------------------------- |
| `Client_ID`      | unique client                       |
| `Company_Size`   | the size of the company             |
| `Industry`       | healthcare, fintech, media, etc.    |
| `Contract_Tier`  | contract identifier                 |
| `HQ_Region`      | where the company is headquartered  |

---

### `Asset`

This describes the physical/technical infrastructure.

| Column                  | Description               |
| ----------------------- | ------------------------- |
| `Asset_ID`              | Unique asset identifier   |
| `Asset_Model`           | Type/model of asset       |
| `Capacity_kW`           | How much power it is designed to handle        |
| `Installation_Date`     | How old it is          |
| `Operational_Status`    | is it operating    |

---

### `Infrastructure_Telemetry`

It contains measurements over time. This is where you can actually **measure performance and operational behavior over time**.

| Column                  | Description               |
| ----------------------- | ------------------------- |
| `Telemetry ID`              | Unique observation   |
| `Date ID`           | When the measurement occurred      |
| `Client_ID`           | Unique client identifier        |
| `Asset_ID`     | Unique asset identifier          |
| `Power_Consumed_kWh`    | Energy/power usage    |
| `Avg_CPU_Utilization_Pct`     | How heavily the system is being used          |
| `Thermal_Reading_C`    | Temperature   |
| `Asset_ID`     | How old it is          |
| `System_Alerts`    | Whether an issue/alert occurred    |

---
# 🏗️ Data Model

The Power BI model uses a star-schema structure.

```text
                 Dim_Date
                     |
                     |
                     ↓
       Fact_Infrastructure_Telemetry
              /                 \
             ↓                   ↓
        Dim_Client          Dim_Asset

---

# 🧹 Data Preparation

The data preparation process included:

Reviewing data types
Checking missing values
Checking duplicate identifiers
Validating client and asset IDs
Converting date fields
Checking CPU utilization ranges
Checking thermal readings
Reviewing asset status values
Creating the date dimension for Power BI

---

# 🔎 Analysis

### Energy

Analysis includes:

Total power consumption
Average power consumption
Power consumption by client
Power consumption by asset
Power consumption by asset model
Power consumption by region
Monthly power consumption

### Utilization

Analysis includes:

Average CPU utilization
CPU utilization by contract tier
CPU utilization by client
CPU utilization by asset
High-utilization assets

### Thermal Conditions

Analysis includes:

Minimum temperature
Maximum temperature
Average temperature
Temperature by asset model
Temperature by region
Potentially abnormal readings
Reliability

### Analysis includes:

Total system alerts
Alerts by client
Alerts by asset
Alerts by asset model
Alerts by industry
Alerts by region

---

# 📐 Key KPI Definitions
|KPI	        | Definition|
|-------------|------------|
|Total Power Consumption	| Sum of Power_Consumed_kWh |
|Average Power Consumption |	Average Power_Consumed_kWh per telemetry record |
|Average CPU Utilization |	Average Avg_CPU_Utilization_Pct |
|Average Thermal Reading |	Average Thermal_Reading_C |
|Total System Alerts | Sum of System_Alerts |
|Alert Rate	| System alerts relative to telemetry observations |
|Online Asset Count	| Number of assets with Operational_Status = Online |
|Decommissioned Asset Count |	Number of assets with Operational_Status = Decommissioned|

---


---



---

👤 Author

Wangui Esther

Data Analyst | Excel | MySQL | Power BI | Business Intelligence | Data Visualization

