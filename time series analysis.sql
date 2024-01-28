



--1.Calculate Total Sales Over Time:
SELECT [Order Date], SUM([Sales]) AS TotalSales
FROM [dbo].['Timeseries_data(1)$']
GROUP BY [Order Date]
ORDER BY [Order Date];

--2.Monthly Average Sales:
SELECT FORMAT([Order Date], 'yyyy-MM') AS Month, AVG([Sales]) AS AvgSales
FROM [dbo].['Timeseries_data(1)$']
GROUP BY FORMAT([Order Date], 'yyyy-MM')
ORDER BY Month;

--3.Sales by Product Category Over Time:
SELECT [Order Date], [Category], SUM([Sales]) AS TotalSales
FROM [dbo].['Timeseries_data(1)$']
GROUP BY [Order Date], [Category]
ORDER BY [Order Date], [Category];

--4.Calculate Quarterly Sales Growth:
SELECT FORMAT([Order Date], 'yyyy-Q') AS Quarter, 
       SUM([Sales]) AS TotalSales,
       LAG(SUM([Sales])) OVER (ORDER BY FORMAT([Order Date], 'yyyy-Q')) AS PreviousQuarterSales,
       ((SUM([Sales]) - LAG(SUM([Sales])) OVER (ORDER BY FORMAT([Order Date], 'yyyy-Q'))) / LAG(SUM([Sales])) OVER (ORDER BY FORMAT([Order Date], 'yyyy-Q'))) * 100 AS SalesGrowth
FROM [dbo].['Timeseries_data(1)$']
GROUP BY FORMAT([Order Date], 'yyyy-Q')
ORDER BY Quarter;

--5.Top N Products by Sales
SELECT  top 5 [Product Name], SUM([Sales]) AS TotalSales
FROM [dbo].['Timeseries_data(1)$']
GROUP BY [Product Name]
ORDER BY TotalSales DESC

--6.Calculate Monthly Sales Growth:
SELECT FORMAT([Order Date], 'yyyy-MM') AS Month,
       SUM([Sales]) AS TotalSales,
       LAG(SUM([Sales])) OVER (ORDER BY FORMAT([Order Date], 'yyyy-MM')) AS PreviousMonthSales,
       ((SUM([Sales]) - LAG(SUM([Sales])) OVER (ORDER BY FORMAT([Order Date], 'yyyy-MM'))) / LAG(SUM([Sales])) OVER (ORDER BY FORMAT([Order Date], 'yyyy-MM'))) * 100 AS SalesGrowth
FROM [dbo].['Timeseries_data(1)$']
GROUP BY FORMAT([Order Date], 'yyyy-MM')
ORDER BY Month;

--7.Identify Seasonal Patterns using Moving Averages:
SELECT [Order Date],
       [Sales],
       AVG([Sales]) OVER (ORDER BY [Order Date] ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING) AS MovingAverage
FROM [dbo].['Timeseries_data(1)$']
ORDER BY [Order Date];

--8.Calculate Cumulative Sales Over Time:
SELECT [Order Date], 
       SUM([Sales]) OVER (ORDER BY [Order Date]) AS CumulativeSales
FROM [dbo].['Timeseries_data(1)$']
ORDER BY [Order Date];

--9.Identify Days with Abnormally High/Low Sales:
SELECT [Order Date], 
       [Sales],
       CASE 
          WHEN [Sales] > AVG([Sales]) OVER () + 2 * STDEV([Sales]) THEN 'High Sales Day'
          WHEN [Sales] < AVG([Sales]) OVER () - 2 * STDEV([Sales]) THEN 'Low Sales Day'
          ELSE 'Normal Sales Day'
       END AS SalesDayType
FROM [dbo].['Timeseries_data(1)$']
group by [Order Date],Sales
ORDER BY [Order Date]


--10.Calculate Weekly Sales Trends:
SELECT DATEPART(WEEK, [Order Date]) AS WeekNumber,
       SUM([Sales]) AS WeeklySales
FROM [dbo].['Timeseries_data(1)$']
GROUP BY DATEPART(WEEK, [Order Date])
ORDER BY WeekNumber;

--11.Exponential Moving Average (EMA) for Smoothing:
SELECT [Order Date],
       [Sales],
       AVG([Sales]) OVER (ORDER BY [Order Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SimpleMovingAverage,
       EXP(AVG(LOG([Sales] + 1)) OVER (ORDER BY [Order Date] ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) AS ExponentialMovingAverage
FROM [dbo].['Timeseries_data(1)$']
ORDER BY [Order Date];

--12.Identify Peaks and Valleys in Sales:
WITH SalesWithLagLead AS (
   SELECT [Order Date],
          [Sales],
          LAG([Sales]) OVER (ORDER BY [Order Date]) AS LagSales,
          LEAD([Sales]) OVER (ORDER BY [Order Date]) AS LeadSales
   FROM [dbo].['Timeseries_data(1)$']
)
SELECT [Order Date],
       [Sales],
       CASE 
          WHEN [Sales] > LagSales AND [Sales] > LeadSales THEN 'Peak'
          WHEN [Sales] < LagSales AND [Sales] < LeadSales THEN 'Valley'
          ELSE 'Normal'
       END AS SalesPointType
FROM SalesWithLagLead
ORDER BY [Order Date];

--13.Anomaly Detection using Z-Score:
SELECT [Order Date],
       [Sales],
       CASE 
          WHEN ABS(([Sales] - AVG([Sales]) OVER ()) / STDEV([Sales]) OVER ()) > 2 THEN 'Anomaly'
          ELSE 'Normal'
       END AS SalesAnomaly
FROM [dbo].['Timeseries_data(1)$']
ORDER BY [Order Date];

--14.Detect Outliers with Z-Score:
SELECT [Order Date],
       [Sales],
       [Sales] - AVG([Sales]) OVER () AS SalesDeviation,
       [Sales] - AVG([Sales]) OVER () / NULLIF(STDEV([Sales]) OVER (), 0) AS ZScore
FROM [dbo].['Timeseries_data(1)$']
ORDER BY [Order Date];

--15.peak or valley
WITH SalesDerivative AS (
   SELECT [Order Date],
          [Sales],
          [Sales] - LAG([Sales]) OVER (ORDER BY [Order Date]) AS SalesChange
   FROM [dbo].['Timeseries_data(1)$']
)
SELECT [Order Date],
       [Sales],
       CASE 
          WHEN SalesChange > 0 AND LEAD(SalesChange) OVER (ORDER BY [Order Date]) < 0 THEN 'Peak'
          WHEN SalesChange < 0 AND LEAD(SalesChange) OVER (ORDER BY [Order Date]) > 0 THEN 'Valley'
          ELSE 'Normal'
       END AS PeakOrValley
FROM SalesDerivative
ORDER BY [Order Date];



--16.Calculate Seasonal Index:
SELECT 
    [Order Date],
    [Sales],
    [Sales] / AVG([Sales]) OVER (PARTITION BY DATEPART(MONTH, [Order Date])) AS SeasonalIndex
FROM [dbo].['Timeseries_data(1)$']
ORDER BY [Order Date];












