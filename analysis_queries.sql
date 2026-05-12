---Basic Queries

---Q1: Retrieve all distinct country names from the dataset. 

SELECT DISTINCT "Country Name" 
FROM "Cleaned_International_Debt_Analysis" 
ORDER BY "Country Name" ;

---Q2: Count the total number of countries available. 

SELECT COUNT(DISTINCT "Country Name") AS total_countries 
FROM "Cleaned_International_Debt_Analysis";

---Q3: Find the total number of indicators present. 

SELECT COUNT(DISTINCT "Series Name") AS total_indicators 
FROM "Cleaned_International_Debt_Analysis";

---Q4:  Display the first 10 records of the dataset. 

SELECT * FROM "Cleaned_International_Debt_Analysis" 
LIMIT 10;

---Q5: Calculate the total global debt. 

SELECT ROUND(SUM("Debt"),2) AS total_global_debt 
FROM "Cleaned_International_Debt_Analysis";

---Q6: List all unique indicator names.
SELECT DISTINCT "Series Name"
FROM "Cleaned_International_Debt_Analysis" 
ORDER BY "Series Name";

---Q7: Find the number of records for each country. 

SELECT "Country Name", COUNT(*) AS record_count
FROM "Cleaned_International_Debt_Analysis" 
GROUP BY "Country Name" 
ORDER BY"Country Name";

---Q8:Display all records where debt is greater than 1 billion USD.

SELECT 
    "Country Name",
    "Series Name",
    "Debt"
FROM "Cleaned_International_Debt_Analysis"
WHERE "Debt" > 1000000000
ORDER BY "Debt" DESC;

---Q9: Find the minimum, maximum, and average debt values. 

SELECT
    MIN("Debt") AS Minimum_Debt,
    MAX("Debt") AS Maximum_Debt,
    AVG("Debt") AS Average_Debt
FROM "Cleaned_International_Debt_Analysis";

---Q10: Count total number of records in the dataset. 

SELECT COUNT(*) AS Total_Records
FROM "Cleaned_International_Debt_Analysis";

---Intermediate Level 

---Q1: Find the total debt for each country.

SELECT  "Country Name",SUM("Debt") AS Total_Debt
FROM "Cleaned_International_Debt_Analysis"
GROUP BY "Country Name"
ORDER BY Total_Debt DESC;

---Q2: Display the top 10 countries with the highest total debt.

SELECT "Country Name", SUM("Debt") AS total_debt
FROM "Cleaned_International_Debt_Analysis" 
GROUP BY "Country Name" 
ORDER BY total_debt DESC 
LIMIT 10;

---Q3: Find the average debt per country. 

SELECT "Country Name", AVG("Debt") AS avg_debt
FROM "Cleaned_International_Debt_Analysis"  
GROUP BY "Country Name" 
ORDER BY avg_debt DESC;

---Q4: Calculate total debt for each indicator.

SELECT "Series Name", SUM("Debt") AS total_debt
FROM "Cleaned_International_Debt_Analysis"  
GROUP BY "Series Code", "Series Name"
ORDER BY total_debt DESC;

---Q5: Identify the indicator contributing the highest total debt. 

SELECT "Series Name","Series Code", SUM("Debt") AS total_debt
FROM "Cleaned_International_Debt_Analysis"  
GROUP BY "Series Name","Series Code"
ORDER BY total_debt DESC 
LIMIT 1;

---Q6: Find the country with the lowest total debt. 

SELECT "Country Name", ROUND(SUM("Debt"),2) AS total_debt
FROM "Cleaned_International_Debt_Analysis"  
GROUP BY "Country Name" 
ORDER BY total_debt ASC 
LIMIT 1;

---Q7: Calculate total debt for each country and indicator combination.

SELECT "Country Name",  "Series Name", ROUND(SUM("Debt"),2) AS total_debt
FROM "Cleaned_International_Debt_Analysis" 
GROUP BY "Country Name","Series Name"
ORDER BY total_debt DESC;

---Q8: Count how many indicators each country has. 

SELECT "Country Name", COUNT(DISTINCT "Series Code") AS indicator_count
FROM "Cleaned_International_Debt_Analysis" 
GROUP BY "Country Name" 
ORDER BY indicator_count DESC;

---Q9: Display countries whose total debt is above the global average.

SELECT "Country Name", SUM("Debt") AS total_debt
FROM "Cleaned_International_Debt_Analysis" GROUP BY "Country Name"
HAVING SUM("Debt") > (
  SELECT AVG(country_total_debt) FROM (SELECT SUM("Debt") AS country_total_debt
  FROM "Cleaned_International_Debt_Analysis" 
  GROUP BY "Country Name")
  ) 
  ORDER BY total_debt DESC;
  
---Q10: Rank countries based on total debt (highest to lowest).

SELECT "Country Name", SUM("Debt") AS total_debt,
  RANK() OVER (ORDER BY SUM("Debt") DESC) AS debt_rank
FROM "Cleaned_International_Debt_Analysis"  
GROUP BY "Country Name" 
ORDER BY debt_rank;

--- Advanced Level

---Q1: Find the top 5 indicators contributing most to global debt. 

SELECT "Series Name", SUM("Debt") AS total_debt,
ROUND(SUM("Debt")*100.0/(SELECT SUM("Debt") FROM "Cleaned_International_Debt_Analysis"),2) AS pct
FROM "Cleaned_International_Debt_Analysis" 
GROUP BY "Series Name","Series Code" 
ORDER BY total_debt DESC 
LIMIT 5;

---Q2: Calculate percentage contribution of each country to total global debt.

SELECT "Country Name", ROUND(SUM("Debt"),2) AS total_debt,
ROUND(SUM("Debt")*100.0/(SELECT SUM("Debt") FROM "Cleaned_International_Debt_Analysis"),2) AS pct
FROM "Cleaned_International_Debt_Analysis" 
GROUP BY "Country Name" 
ORDER BY pct DESC;

---Q3: Identify the top 3 countries for each indicator based on debt.

SELECT *
FROM (
    SELECT 
        "Country Name",
        "Series Name",
        SUM("Debt") AS total_debt,
        RANK() OVER (
            PARTITION BY "Series Name"
            ORDER BY SUM("Debt") DESC
        ) AS rank_no
    FROM "Cleaned_International_Debt_Analysis"
    GROUP BY "Country Name", "Series Name"
) ranked_data
WHERE rank_no <= 3
ORDER BY "Series Name", rank_no;

---Q4: Find the difference between maximum and minimum debt for each country.
SELECT "Country Name", ROUND(MAX("Debt"),2) AS max_debt,
  ROUND(MIN("Debt"),2) AS min_debt,
  ROUND(MAX("Debt")-MIN("Debt"),2) AS debt_range
FROM "Cleaned_International_Debt_Analysis" 
GROUP BY "Country Name" 
ORDER BY debt_range DESC;

---Q5: Create a view for the top 10 countries with highest debt.
CREATE VIEW top10_debt_countries AS
SELECT "Country Name", "Country Code", ROUND(SUM("Debt"),2) AS total_debt
FROM "Cleaned_International_Debt_Analysis"  
GROUP BY "Country Name", "Country Code"
ORDER BY total_debt DESC LIMIT 10;
--- Veiwing top10_debt_countries
SELECT * FROM top10_debt_countries;

---Q6: Categorize countries into: o High Debt o Medium Debt o Low Debt (based on thresholds)
WITH ct AS (SELECT "Country Name", SUM("Debt") AS total_debt
  FROM "Cleaned_International_Debt_Analysis" GROUP BY "Country Name"),
t AS (SELECT AVG(total_debt)*0.5 AS low_t, AVG(total_debt)*1.5 AS high_t FROM ct)
SELECT ct."Country Name", ROUND(ct.total_debt,2) AS total_debt,
  CASE WHEN ct.total_debt >= t.high_t THEN 'High Debt'
       WHEN ct.total_debt >= t.low_t THEN 'Medium Debt'
       ELSE 'Low Debt' END AS category
FROM ct, t ORDER BY ct.total_debt DESC;

---Q7: Use window functions to calculate cumulative debt per country.
SELECT "Country Name", "Series Name", ROUND("Debt",2) AS debt,
  ROUND(SUM("Debt") OVER (
    PARTITION BY "Country Name" 
	ORDER BY "Debt" DESC),2) AS cumulative_debt
FROM "Cleaned_International_Debt_Analysis" ORDER BY "Country Name", "Debt" DESC
;
---Q8: Find indicators where average debt is higher than overall average debt.

SELECT "Series Name","Series Code", ROUND(AVG("Debt"),2) AS avg_indicator_debt,
  (SELECT ROUND(AVG("Debt"),2) FROM "Cleaned_International_Debt_Analysis") AS overall_avg
FROM "Cleaned_International_Debt_Analysis" GROUP BY "Series Name","Series Code"
HAVING AVG("Debt") > (SELECT AVG("Debt") FROM "Cleaned_International_Debt_Analysis")
ORDER BY avg_indicator_debt DESC;

---Q9: Identify countries contributing more than 5% of global debt. 
SELECT "Country Name", ROUND(SUM("Debt"),2) AS total_debt,
  ROUND(SUM("Debt")*100.0/(SELECT SUM("Debt") FROM "Cleaned_International_Debt_Analysis"),2) AS pct
FROM "Cleaned_International_Debt_Analysis" GROUP BY "Country Name"
HAVING   SUM("Debt") * 100.0 / (SELECT SUM("Debt") FROM "Cleaned_International_Debt_Analysis"
    ) > 5 ORDER BY pct DESC;

---Q10: Find the most dominant indicator (highest contribution) for each country.
WITH ci AS (
  SELECT "Country Name", "Series Name", "Debt",
    ROW_NUMBER() OVER (PARTITION BY "Country Name" ORDER BY "Debt" DESC) AS rn
  FROM "Cleaned_International_Debt_Analysis"
)
SELECT "Country Name", "Series Name" AS dominant_indicator,
  ROUND("Debt",2) AS max_debt
FROM ci WHERE rn = 1 ORDER BY max_debt DESC;




select * from "Cleaned_International_Debt_Analysis";