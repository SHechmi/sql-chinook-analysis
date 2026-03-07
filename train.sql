-- ===========================================
-- SQL PRACTICE - CHINOOK DATABASE
-- Author: Saifallah
-- Started: February 2026
-- ===========================================

-- ===========================================
-- SECTION 1: BASIC SELECT, WHERE, ORDER BY
-- ===========================================

-- 1. View all customers
select * 
FROM Customer;

-- 2. Get first 10 customers (names and country)
SELECT firstname, lastname, country
FROM Customer
LIMIT 10;

-- 3. Find all USA customers
SELECT firstname, lastname, country
FROM Customer
WHERE country='USA';

-- 4. Find tracks with 'Love' in the title
SELECT name, composer, unitprice
FROM Track
WHERE name LIKE '%Love%'
LIMIT 15;

-- 5. Invoices over $5, sorted by date
SELECT invoiceid, invoicedate, total
FROM Invoice
WHERE total>5
ORDER BY invoicedate;

-- 6. Check date range in Invoice table
SELECT MIN(InvoiceDate), MAX(InvoiceDate) FROM Invoice;

-- 7. Top 5 most expensive tracks
SELECT name, composer, unitprice
FROM Track
ORDER BY unitprice DESC
LIMIT 5;

-- 8. Tracks with missing composer information
SELECT name, composer
FROM Track
WHERE composer is NULL
LIMIT 20;

-- 9. Invoices between $5 and $10, sorted by total
SELECT invoiceid, customerid, total
FROM Invoice
where total BETWEEN 5 and 10
ORDER by total;

-- 10. Most recent invoices from 2013 onward
SELECT invoiceid, customerid, invoicedate, total
FROM Invoice
WHERE invoicedate >= '2013-01-01'
ORDER BY invoicedate DESC
LIMIT 10;

-- 11. Double-check date range
SELECT MIN(InvoiceDate), MAX(InvoiceDate) FROM Invoice;

-- ===========================================
-- SECTION 2: GROUP BY + COUNT + SUM
-- ===========================================
-- 12. Customers per country
SELECT country, COUNT(*) as customer_count
FROM Customer
GROUP BY country
ORDER BY customer_count DESC;

-- 13. Total sales per customer (top 10)
SELECT CustomerId, SUM(Total) as total_spent
FROM Invoice
GROUP BY CustomerId
ORDER BY total_spent DESC
LIMIT 10;

-- 14. Customers who spent > $40
SELECT CustomerId, SUM(Total) as total_spent
FROM Invoice
GROUP BY CustomerId
HAVING SUM(Total) > 40
ORDER BY total_spent DESC;

-- 14. Tracks per composer (starting with B)
SELECT Composer, COUNT(*) as track_count
FROM Track
WHERE Composer LIKE 'B%' AND Composer IS NOT NULL
GROUP BY Composer
ORDER BY track_count DESC;

-- 10. Top 5 countries by sales
SELECT BillingCountry, SUM(Total) as total_sales
FROM invoice
GROUP BY BillingCountry
ORDER BY total_sales DESC
LIMIT 5;

-- ===========================================
-- SECTION 3: JOINS
-- ===========================================

--14. Customer name + total spent (JOIN + GROUP BY)
SELECT t1.FirstName, t1.LastName, SUM(t2.Total) AS total_spent
FROM Customer t1
JOIN Invoice t2 ON t1.CustomerId = t2.CustomerId
GROUP BY t1.CustomerId
ORDER BY total_spent DESC;

-- 15. Track name + album title + artist name (3-table JOIN)
SELECT t1.Name as TRACK_NAME, t2.Title as ALBUM_Title, t3.Name as ARTIST_NAME
FROM Track t1
JOIN Album t2 ON t1.AlbumId=t2.AlbumId
JOIN Artist t3 ON t2.ArtistId=t3.ArtistId;

-- 16. Artists with more than 10 tracks (JOIN + GROUP BY + HAVING)
SELECT t1.Name as Artist_Name, count(t2.TrackId) as track_count
FROM Artist t1
JOIN Album t3 ON t1.ArtistId=t3.ArtistId
JOIN Track t2 ON t2.AlbumId=t3.AlbumId
GROUP BY t1.ArtistId
HAVING track_count > 10
ORDER BY track_count DESC;

-- 17. All artists with their album count, including artists with zero albums (LEFT JOIN)
SELECT t1.Name as Artist_Name, count(t2.AlbumId) as album_count
FROM Artist t1
LEFT JOIN Album t2 ON t1.ArtistId=t2.ArtistId
GROUP BY t1.ArtistId
ORDER BY Album_count DESC;

-- ===========================================
-- SECTION 4: SUBQUERIES
-- ===========================================

-- 18. Customers from the same country as Frank (basic subquery)
SELECT *
FROM Customer
WHERE Country = (SELECT Country FROM Customer WHERE FirstName = 'Frank');

-- 19. Same query using both first and last name for safety
SELECT *
FROM Customer
WHERE Country=(SELECT Country FROM Customer WHERE FirstName='Frank' AND LastName='Harris');

-- 20. Tracks that cost more than the average track price (subquery with AVG)
SELECT Name, UnitPrice
FROM Track
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Track);

-- 21. Customers and their invoices above $15, only for high-value customers (subquery with IN)
SELECT t1.FirstName, t1.LastName, t2.total
FROM Customer t1
JOIN Invoice t2 ON t1.CustomerId=t2.CustomerId
WHERE t1.CustomerId IN (SELECT t1.CustomerId FROM Customer t1 JOIN Invoice t2 ON t1.CustomerId=t2.CustomerId WHERE t2.Total>15) AND t2.Total>15
ORDER BY t2.Total DESC;

-- 22. Tracks belonging to the most purchased genre (nested subqueries + derived table)
SELECT t1.Name
FROM track t1,(
    SELECT t1.GenreId, COUNT(*) as genre_count
    FROM InvoiceLine t2
    JOIN Track t1 ON t1.TrackId=t2.TrackId
    GROUP BY t1.GenreId
)
WHERE genre_count = (
    SELECT MAX(genre_count) 
    FROM (
        SELECT t1.GenreId, COUNT(*) as genre_count
        FROM InvoiceLine t2
        JOIN Track t1 ON t1.TrackId=t2.TrackId
        GROUP BY t1.GenreId
    )
);
