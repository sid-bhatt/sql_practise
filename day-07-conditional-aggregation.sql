# Day 7 – Customer Order Analysis (Conditional Aggregation)

**Difficulty:** Intermediate  
**Database:** MySQL 8  
**Topics:** CASE WHEN, SUM(), COUNT(), GROUP BY, HAVING, CTEs

## Problem Statement

You are given an `Orders` table containing customer orders with different amounts and statuses (`Completed` or `Cancelled`).

Write a SQL query to identify customers who satisfy all the following conditions:

1. Have placed at least one Completed order.
2. Have placed at least one Cancelled order.
3. Have total Completed revenue greater than total Cancelled revenue.

Return the following columns:

- `CustomerID`
- `CompletedRevenue`
- `CancelledRevenue`
- `CompletedTotalOrder`

## Sample Table

```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    Amount DECIMAL(10,2),
    Status VARCHAR(20)
);

INSERT INTO Orders VALUES
(1, 101, 200, 'Completed'),
(2, 101, 300, 'Completed'),
(3, 101, 50, 'Cancelled'),
(4, 102, 100, 'Completed'),
(5, 102, 150, 'Cancelled'),
(6, 103, 400, 'Completed'),
(7, 104, 120, 'Completed'),
(8, 104, 80, 'Cancelled'),
(9, 104, 50, 'Completed'),
(10, 105, 50, 'Completed'),
(11, 105, 50, 'Cancelled');
```

## Expected Output

| CustomerID | CompletedRevenue | CancelledRevenue | CompletedTotalOrder |
|---|---:|---:|---:|
| 101 | 500 | 50 | 2 |
| 104 | 170 | 80 | 2 |

## Solution

```sql
WITH OrderSummary AS (
    SELECT
        CustomerID,

        SUM(
            CASE
                WHEN Status = 'Completed' THEN Amount
                ELSE 0
            END
        ) AS CompletedRevenue,

        SUM(
            CASE
                WHEN Status = 'Cancelled' THEN Amount
                ELSE 0
            END
        ) AS CancelledRevenue,

        COUNT(
            CASE
                WHEN Status = 'Completed' THEN 1
            END
        ) AS CompletedTotalOrder

    FROM Orders
    GROUP BY CustomerID

    HAVING CompletedRevenue > 0
       AND CancelledRevenue > 0
)

SELECT
    CustomerID,
    CompletedRevenue,
    CancelledRevenue,
    CompletedTotalOrder
FROM OrderSummary
WHERE CompletedRevenue > CancelledRevenue;
```

## Key Concepts Learned

### 1. Conditional Aggregation

`CASE WHEN` allows us to apply conditions inside aggregate functions.

```sql
SUM(CASE WHEN Status = 'Completed' THEN Amount ELSE 0 END)
```

Calculates the total amount for Completed orders.

### 2. COUNT() vs SUM()

- `SUM()` adds numerical values.
- `COUNT()` counts non-NULL values.

To count only Completed orders:

```sql
COUNT(CASE WHEN Status = 'Completed' THEN 1 END)
```

**Important:** Avoid `ELSE 0` in this COUNT expression because zero is also a non-NULL value and will be counted.

### 3. WHERE vs HAVING

- `WHERE` filters individual rows before grouping.
- `HAVING` filters groups after `GROUP BY`.

### 4. Common SQL Pattern

Conditional aggregation is useful when multiple metrics need to be calculated from different categories within the same table.

Examples:
- Completed vs Cancelled revenue
- Successful vs Failed transactions
- Active vs Inactive users
- Sales by payment method

## Complexity

- Time Complexity: O(n) for aggregation, assuming a single scan of the table.
- Space Complexity: O(k) for grouping, where k is the number of distinct customers.

## Practice Status

- [x] Conditional SUM()
- [x] Conditional COUNT()
- [x] GROUP BY
- [x] HAVING
- [x] CTE
- [x] Final filtering using WHERE
