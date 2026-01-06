# ⚽ FC 25 Database Benchmark: PostgreSQL vs MongoDB

A comparative analysis between **Relational (SQL)** and **Document (NoSQL)** databases applied to a complex football scouting dataset.

This project explores data modeling strategies, integrity constraints, and query performance differences between **PostgreSQL** and **MongoDB**, simulating a real-world Data Engineering and Backend Development scenario.

---

## 🎯 Project Objectives

1.  **Complex Data Modeling:** Comparing Normalization (Star Schema) vs. Nested Document structures.
2.  **ETL & Data Cleaning:** Solving real-world raw data inconsistencies (e.g., Primary Key collisions).
3.  **Benchmarking:** Measuring performance on critical operations (Massive Joins, Text Search, Array Aggregations).

---

## 🛠️ Tech Stack

* **RDBMS:** PostgreSQL 16
* **NoSQL:** MongoDB 7.0
* **Data Source:** FC 25 Players Dataset (~17,000+ players, Male & Female)
* **Tools:** pgAdmin 4, MongoDB Compass

---

## 🚀 Key Features & Solved Challenges

### 1. Advanced ETL & Data Cleaning
The raw dataset presented a critical **Primary Key Collision** between male and female player databases (IDs reset to zero for female players).
* **Problem:** Merging datasets caused ID duplication (e.g., ID `3` existed for both a male and a female player).
* **Solution:** Implemented a conditional **ID Offsetting logic** in SQL during the staging phase.
* **Result:** Successfully preserved 100% of the dataset (17k records) by shifting female IDs to a new range (`ID + 1,000,000`), ensuring referential integrity.

### 2. Many-to-Many Relationships
Handling complex attributes like *Playstyles* and *Alternative Positions*.
* **PostgreSQL:** Implemented via **Junction Tables** (`player_playstyles`) with composite `UNIQUE` constraints to prevent duplication.
* **MongoDB:** Leveraged **Native Arrays**, eliminating the need for expensive Joins and reducing read latency.

### 3. Polymorphic Data Structures
* **Scenario:** Goalkeepers (GK) possess entirely different attributes compared to Outfield players.
* **NoSQL Modeling:** Utilized a polymorphic pattern where the `goalkeeping` object exists only in relevant documents, optimizing storage and schema flexibility.

---

## 📂 Repository Structure

```text
├── Mongodb/                 # MongoDB Scripts
│   ├── import_pipeline.js   # JSON transformation pipeline
│   └── queries.js           # NoSQL Benchmark queries
├── Postgresql/              # SQL Scripts
│   ├── 01_data_import.sql   # Data import procedure
│   ├── 02_schema.sql        # DDL: Table creation and constraints
│   ├── 03_ETL.sql           # ETL: Data cleaning, offsetting, and population
│   └── 04_queries.sql       # Benchmark: The 9 test queries
├── assets/                  # ER Diagrams, Benchmark file, presentation, images
├── data/                    # Raw Dataset sample
└── README.md                # Project Documentation
