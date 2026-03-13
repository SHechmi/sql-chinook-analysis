-- ===========================================
-- SQL ANALYSIS - CHINOOK MUSIC STORE
-- Author: Saifallah
-- Started: February 2026
-- ===========================================


-- ===========================================
-- SECTION 1: SALES & REVENUE ANALYSIS
-- ===========================================

-- 1. Top 5 revenue-generating countries
SELECT BillingCountry, SUM(total) as total_invoice
FROM invoice 
GROUP BY BillingCountry
ORDER BY total_invoice DESC
LIMIT 5;

-- 2. Average order value per country (sorted by highest average)
SELECT BillingCountry, ROUND(AVG(total),2) as average
FROM invoice 
GROUP BY BillingCountry
ORDER BY average DESC;

-- 3. Total revenue per year
SELECT strftime('%Y',InvoiceDate) as year, SUM(total) as revenue
FROM Invoice
GROUP BY year
ORDER BY revenue DESC;

-- 4. Best performing months across all years
SELECT strftime('%m',InvoiceDate) as month, ROUND(SUM(Total),2) revenue_m
FROM Invoice
GROUP BY month
ORDER BY revenue_m DESC;


-- ===========================================
-- SECTION 2: CUSTOMER ANALYSIS
-- ===========================================

-- 5. Top 10 customers by total spending
SELECT t1.LastName, t1.FirstName, SUM(t2.total) as total_spending
FROM Customer t1
JOIN invoice t2 ON t1.CustomerId=t2.CustomerId
GROUP BY t1.CustomerId
ORDER BY total_spending DESC
LIMIT 10;

-- 6. Customer segmentation: VIP (>$40), Regular ($20-$40), Low (<$20)
SELECT t1.FirstName, t1.LastName, SUM(t2.total) as total_spent,
    CASE
        WHEN SUM(t2.total) >40 THEN 'VIP'
        WHEN SUM(t2.total) BETWEEN 20 AND 40 THEN 'REGULAR'
        ELSE 'LOW'
    END AS Rank
FROM Customer t1
JOIN Invoice t2 ON t1.CustomerId=t2.CustomerId
GROUP BY t1.CustomerId
ORDER BY total_spent DESC;

-- 7. Number of customers per country
SELECT Country, count(*) as NumberOfCustomers
FROM Customer
GROUP BY Country
ORDER BY NumberOfCustomers DESC;

-- 8. Customers who made no purchase since 2024 (inactive customers)
SELECT t1.LastName, t1.FirstName, t2.InvoiceDate
FROM Customer t1
LEFT JOIN Invoice t2 ON t1.CustomerId=t2.CustomerId 
    AND strftime('%Y',t2.InvoiceDate) >= '2024'
WHERE t2.CustomerId IS NULL
GROUP BY t1.CustomerId;


-- ===========================================
-- SECTION 3: MUSIC CATALOG ANALYSIS
-- ===========================================

-- 9. Revenue generated per genre (sorted by highest)
SELECT t4.Name, ROUND(SUM(t2.Total),2) as total_revenue
FROM Track t1
JOIN Genre t4 ON t4.GenreId=t1.GenreId
JOIN InvoiceLine t3 ON t1.TrackId=t3.TrackId
JOIN Invoice t2 ON t2.InvoiceId=t3.InvoiceId
GROUP BY t1.GenreId 
ORDER BY total_revenue DESC;

-- 10. Artists with the most tracks in the catalog
SELECT t1.name, COUNT(*) as NbTrack
FROM Track t2
JOIN ALBUM t3 ON t2.AlbumId=t3.AlbumId
JOIN Artist t1 ON t1.ArtistId=t3.ArtistId
GROUP BY t1.ArtistId
ORDER BY NbTrack DESC;

-- 11. Albums with the most tracks
SELECT t1.Title, Count(t2.TrackId) as track_count
FROM track t2
JOIN Album t1 ON t1.AlbumId=t2.AlbumId
GROUP BY t1.AlbumId
ORDER BY track_count DESC;


-- ===========================================
-- SECTION 4: TIME-BASED ANALYSIS
-- ===========================================

-- 12. Year-over-year revenue trend
SELECT strftime('%Y',InvoiceDate) as Year, SUM(Total) as revenue
FROM Invoice
GROUP BY Year
ORDER BY Year DESC;

-- 13. Revenue by quarter (Q1/Q2/Q3/Q4)
SELECT ROUND(SUM(Total),2) as total_revenue, 
    CASE 
        WHEN strftime('%m',InvoiceDate) IN ('01','02','03') THEN 'Q1'
        WHEN strftime('%m',InvoiceDate) IN ('04','05','06') THEN 'Q2'
        WHEN strftime('%m',InvoiceDate) IN ('07','08','09') THEN 'Q3'
        WHEN strftime('%m',InvoiceDate) IN ('10','11','12') THEN 'Q4'
    END AS quarter
FROM Invoice
GROUP BY quarter
ORDER BY total_revenue DESC;

-- 14. Best performing month per year (using subquery + derived table)
SELECT Year, Month, MAX(total_revenue) as peak_revenue
FROM (
    SELECT strftime('%Y',InvoiceDate) as Year, 
           strftime('%m',InvoiceDate) as Month, 
           SUM(Total) as total_revenue
    FROM Invoice
    GROUP BY Month, year
)
GROUP BY Year
ORDER BY Year;
