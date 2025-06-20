Markdown

# [SQL PRACTICING]

---

## Table of Contents

- [1. Introduction](#1-introduction)
- [2. Features](#2-features)
- [3. Getting Started](#3-getting-started)
    - [3.1. Prerequisites](#31-prerequisites)
    - [3.2. Installation](#32-installation)
- [4. Usage](#4-usage)
- [5. Examples](#5-examples)

---

## 1. Introduction

This repository is showcasing my journey and solutions through a series of hands-on SQL challenges. Each challenge is designed to highlight my ability to apply fundamental and advanced SQL concepts to real-world data problems. Explore the solutions to see how I leverage SQL to query, manipulate, and analyze data effectively, demonstrating my practical skills in database interaction and problem-solving.

## 2. Features

- Demonstrated SQL Proficiency: Each challenge solution clearly illustrates my understanding and application of specific SQL concepts.
- Structured Skill Showcase: Organized by key SQL topics, making it easy to navigate and assess particular areas of expertise.
- Practical Problem-Solving: Solutions to real-world data scenarios, reflecting my ability to translate requirements into efficient SQL queries.
- Comprehensive Concept Coverage: From basic SELECT statements to complex JOINs and Subqueries, a wide range of SQL skills are demonstrated.

## 3. Getting Started

This section guides you on how to set up your environment to review the SQL challenge solutions on your local machine.

### 3.1. Prerequisites

To execute and verify the SQL files used in these challenges, you will need to have MySQL installed on your system.

- [MySQL Workbench](https://dev.mysql.com/downloads/workbench/) (>= Version 8.0.41)

### 3.2. Installation

Follow these steps to clone the repository and access the challenge solutions-

```bash
# Clone this repository
git clone https://github.com/Cebulva/sql_practicing.git

# Navigate into the cloned repository directory
cd sql_practicing

# Navigate into the Challenges directory where the SQL files are located
cd Challenges
```
### 4. Usage

Once you have MySQL installed and have navigated to the Challenges directory, you can explore each challenge's .sql file. Each file contains the SQL queries I wrote to solve the given problem. You can run these scripts against your local MySQL instance to see the results firsthand and understand my approach.

To run a challenge's SQL script using the MySQL command-line client:
```bash
# First, log in to your MySQL server (you might need to specify host, port, and password)
mysql -u your_username -p

# Then, within the MySQL client, ensure you are using the correct database or create one.
# For example, to use a database named 'sql_challenges_db':
# USE sql_challenges_db;

# To execute a challenge file (replace 'sql_challenges_1.sql' with the actual file name you want to run):
# SOURCE 'sql_challenges_1.sql';
```
### 5. Examples

The Challenges directory contains structured SQL files, each focusing on a specific set of concepts. Click on any challenge below to see a brief description and a direct link to its solution file.

<details>
<summary>Challenge 1: SELECT, FROM, AS, and DISTINCT</summary>
<br>
This challenge focuses on the foundational SQL commands for basic data retrieval. It demonstrates how to select specific columns, define the source table, alias columns for readability, and retrieve unique values.
<br>
<a href="Challenges/sql_challenges_1.sql">View Challenge 1 Code</a>
</details>

<details>
<summary>Challenge 2: WHERE, AND, OR, and NOT</summary>
<br>
This section explores conditional data filtering using the `WHERE` clause combined with logical operators (`AND`, `OR`, `NOT`) to narrow down results based on specific criteria.
<br>
<a href="Challenges/sql_challenges_2.sql">View Challenge 2 Code</a>
</details>

<details>
<summary>Challenge 3: ORDER BY and LIMIT & Aggregations – COUNT, SUM, MIN, MAX, and AVG</summary>
<br>
This challenge demonstrates how to sort query results using `ORDER BY`, restrict the number of rows with `LIMIT`, and perform powerful data summarization using aggregation functions like `COUNT`, `SUM`, `MIN`, `MAX`, and `AVG`.
<br>
<a href="Challenges/sql_challenges_3.sql">View Challenge 3 Code</a>
</details>

<details>
<summary>Challenge 4: LIKE, IN, and BETWEEN</summary>
<br>
Here, I showcase the use of `LIKE` for pattern matching, `IN` for matching against a list of values, and `BETWEEN` for checking if values fall within a specified range.
<br>
<a href="Challenges/sql_challenges_4.sql">View Challenge 4 Code</a>
</details>

<details>
<summary>Challenge 5 & Bonus 1: GROUP BY and HAVING</summary>
<br>
This section delves into grouping rows that have the same values into summary rows using `GROUP BY`, and then filtering those groups with the `HAVING` clause.
<br>
<a href="Challenges/sql_challenges_5.sql">View Challenge 5 & Bonus 1 Code</a>
<a href="Challenges/sql_challenges_bonus_1.sql">View Challenge 5 Bonus Code</a>
</details>

<details>
<summary>Challenge 6: JOINs</summary>
<br>
A comprehensive demonstration of various `JOIN` types (e.g., `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`) to combine data from multiple related tables.
<br>
<a href="Challenges/sql_challenges_6.sql">View Challenge 6 Code</a>
</details>

<details>
<summary>Challenge 7 & Bonus 2: CASE</summary>
<br>
This challenge illustrates the use of the `CASE` statement for implementing conditional logic directly within SQL queries, allowing for different outputs based on specified conditions.
<br>
<a href="Challenges/sql_challenges_7.sql">View Challenge 7 Code</a>
<a href="Challenges/sql_challenges_bonus_2.sql">View Challenge 7 Bonus Code</a>
</details>

<details>
<summary>Challenge 8: Subqueries</summary>
<br>
Explore the power of `Subqueries`, where the result of one query is used as input for another, enabling complex data retrieval and manipulation.
<br>
<a href="Challenges/sql_challenges_8.sql">View Challenge 8 Code</a>
</details>

<details>
<summary>Challenge 9: Functions</summary>
<br>
This section demonstrates the application of various SQL built-in functions (e.g., string, numeric, date, and time functions) to process and transform data.
<br>
<a href="Challenges/sql_challenges_9.sql">View Challenge 9 Code</a>
</details>

<details>
<summary>Challenge 10: Maths</summary>
<br>
This final challenge focuses on using SQL for mathematical operations and calculations within queries, from basic arithmetic to more complex numerical manipulations.
<br>
<a href="Challenges/sql_challenges_10.sql">View Challenge 10 Code</a>
</details>
