

USE audiobook;
#FIRST QUERY
#List all the customer’s names, dates, and products or services used/booked/rented/bought by these customers in a range of two dates.
SELECT concat(c.first_name, ' ', c.last_name) AS 'Client Name', bo.date AS 'Purchase Date', b.title AS 'Book  Title' ,
concat(a.first_name, ' ', a.last_name) as 'Author'
FROM client c, book_order bo, invoice i , book b, author a 
WHERE c.client_id = i.client_id AND bo.invoice_id = i.invoice_id AND bo.book_id = b.book_id and b.author_id = a.author_id
AND bo.date BETWEEN '2018-09-07' AND '2021-06-30';

#SECOND QUERY 
#List the best three customers/products/services/places (we decided that best costumer would be the one with most books bought from us )
SELECT concat(c.first_name, ' ', c.last_name) AS 'Client Name', i.books_bought AS 'Books Purchased'
FROM CLIENT c, invoice i
WHERE c.client_id = i.client_id
ORDER BY i.books_bought DESC
LIMIT 3;

#THIRD QUERY 
#Get the average amount of sales/bookings/rents/deliveries for a period that involves 2 or more years where a year is 365 days and a month 30 days

SELECT concat(min(bo.date), ' - ', max(bo.date)) AS PeriodOfSales, 
	   concat(round(sum(b.price-(b.price*(d.discount_percentage/100))),2),'€') AS 'TotalSales(euros)' ,
       concat(round(sum(b.price-(b.price*(d.discount_percentage/100)))/(datediff(max(bo.date), min(bo.date))/365), 2),'€') AS YearlyAverage,
       concat(round(sum(b.price-(b.price*(d.discount_percentage/100)))/(datediff(max(bo.date), min(bo.date))/30), 2),'€') AS MonthlyAverage
FROM client c, book_order bo, book b, invoice i, discount d
WHERE c.client_id = i.client_id AND bo.invoice_id = i.invoice_id AND bo.book_id = b.book_id AND b.discount_id = d.discount_id;
	   
#FOURTH QUERY 
#Get the total sales/bookings/rents/deliveries by geographical location (city/country)
select concat(round(sum(b.price-(b.price*(d.discount_percentage/100))),2),'€') AS Sales, l.city as city, l.country as country
from book b
left join discount d on b.discount_id = d.discount_id 
join book_order bo on b.book_id=bo.book_id
join invoice i on bo.invoice_id=i.invoice_id
join client c on c.client_id=i.client_id
join location l on c.location_id=l.location_id
group by country, city;


#FIFTH QUERY,
#List all the locations where products/services were sold, and the product has customer’s ratings
select concat(loc.street, ' ', loc.city, ' ',  loc.postal_code, ', ', loc.country) AS 'Location Detais', re.rating as Rating,
b.title as 'Book Title', cat.category as 'Book Category'
from location loc
join client c on c.location_id=loc.location_id 
join review re on c.client_id=re.client_id
join book b on re.book_id=b.book_id
join book_order bo on b.book_id = bo.book_id
join book_category bc on b.book_id = bc.book_id
join category cat on bc.category_id = cat.category_id ;




