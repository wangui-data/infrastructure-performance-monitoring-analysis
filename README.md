# infrastructure-performance-monitoring-analysis

# Data Center Infrastructure & Operations

**MySQL** · **Excel** · **EDA**· **Power BI** · **DAX** · **Power Query** · **Data Modeling** · **Business Intelligence**

---
## 📖 Project Overview

A data-center operational performance and infrastructure monitoring dataset. This dataset represents a data-center operations environment where multiple clients use computing infrastructure, while telemetry data is collected to monitor infrastructure utilization, energy consumption, thermal conditions, and system health.


---

# 🎯 Business Problem

The Data Centre wants to understand **how efficiently and reliably the data centers/assets are operating, and which clients, assets, or conditions are driving high energy consumption, performance issues, or system alerts**

The analysis focuses on five key business areas.


### 1️⃣ Client Performance Analysis

How are the clients performing over time?

* Which industries (e.g., Fintech, Healthcare, Media) make up the largest share of our customer base?
* What percentage of our clients belong to the 'Enterprise' Company_Size?
* Which Contract_Tier, Premium vs. Standard, is consuming the most compute power (Avg_CPU_Utilization_Pct)?
* How does client contract tier (Contract_Tier) affect the average workload/CPU utilization placed on data center assets?
* Which Industry generates the highest number of average System_Alerts per day?
* Which Industry accounts for the highest total power consumption (Power_Consumed_kWh)?

---

### 2️⃣ Asset Utilization & Operational Health

Are our assets being properly utilized?

* Which asset models consume the most power?
* How many total hardware assets are currently marked as 'Decommissioned' versus 'Online' in Dim_Asset?
* Which specific server racks (Asset_ID) are pulling power that exceeds their rated Capacity_kW?
* What is the total Power_Consumed_kWh broken down by Asset_Model? (Do newer models consume less power?)
* Which Asset_Model runs at the highest average thermal reading (Thermal_Reading_C), and does it correlate with high CPU utilization?
  
---

### 3️⃣ Infrastructure Telemetry & Industry Analysis

How are the business operations performing over time?

* Which Industry accounts for the highest total power consumption (Power_Consumed_kWh)?
* Who are the top 10 clients (Client_ID) generating the most system alerts (System_Alerts) across all their operational assets?
* What is the month-over-month trend for total power consumption across the entire data center?
* What are the maximum and minimum Thermal_Reading_C in the dataset? Are there any impossible temperatures (e.g., below 0°C or above 100°C) that indicate broken sensors?

---

### 4️⃣ Regional & Portfolio Efficiency

* Are clients in the 'Nairobi East' region running their servers hotter (higher average Thermal_Reading_C) than clients in 'Mombasa'?
* What is the total power consumption per HQ_Region (e.g., Nairobi East, Nairobi West, Kigali, Mombasa, Dar es Salaam)?
* Which regional clients experience the highest average number of system alerts per telemetry log?
  
---

### 5️⃣ Risk & Maintenance Monitoring

* Can you list the Client_ID and Company_Size of any client whose average CPU utilization is above 85% and has generated more than 2 system alerts?
* Which client-asset combinations are generating the highest total volume of System_Alerts?
* What percentage of total telemetry records register both high thermal readings (>30°C) and active system alerts (>0)?

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


# 🧹 Data Preparation

---

# ❓ Key Business Questions

## ⚡ Energy efficiency

* What is the total power consumed?
* Average power consumption
* Power consumption by client
* Power consumption by asset
* Power consumption by asset model
* Power consumption by region
* Power consumption over time
* Power consumption relative to asset capacity

---

## 🖥️ Infrastructure utilization

* Which assets are operating near their capacity?
* Are particular clients consistently consuming high capacity?
* Which assets are severely underutilized?

---

## 🌡️ Performance and thermal conditions

* Does higher CPU utilization lead to higher power consumption?
* Does higher power consumption correspond with higher temperatures?
* At what temperature do system alerts become more common?

---

## 🚨 System reliability/alerts

* How many alerts occurred?
* Which assets generated the most alerts?
* Which clients experienced the most alerts?
* Which asset models have the highest alert rate?
* Are alerts associated with high temperatures?
* Are alerts associated with high CPU utilization?
* Are older assets generating more alerts?

---


---

👤 Author

Wangui Esther

Data Analyst | Excel | MySQL | Power BI | Business Intelligence | Data Visualization

