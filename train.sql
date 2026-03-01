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
