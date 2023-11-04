# Q1: Who is the senior most employee, find name and job title 
select first_name , title, hire_date from employee
order by hire_date 
limit 1;

# Q2: Which countries have the most Invoices? */
select billing_country, count(invoice_id) as `count of invoices` from invoice
group by billing_country
order by count(invoice_id) desc;


/* Q3: What are top 3 values of total invoice? */
select invoice_id, total from invoice
order by total desc
limit 3;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
select billing_city, sum(total) as `invoice total` from invoice
group by billing_city
order by sum(total) desc limit 1;


/* Q6(A): We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
select i.billing_country, (il.unit_price*il.quantity) as purchase_amount, g.name from invoice i inner join invoice_line il using (invoice_id)
inner join track t using(track_id) inner join genre g using(genre_id) 
group by i.billing_country
order by purchase_amount desc;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
select c.customer_id, c.first_name, sum(i.total) as money_spent from customer c inner join invoice i on c.customer_id = i.customer_id
group by c.customer_id 
order by money_spent desc
limit 1;

/* 1.Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A */
select c.email, c.first_name, c.last_name, g.name from customer c inner join invoice i using(customer_id) inner join invoice_line il using (invoice_id)
inner join track t using(track_id) inner join genre g using(genre_id) 
where g.name = "Rock" and c.email like "a%"
group by c.email
order by c.email;


/* 2. Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands */
select a.name, count(t.track_id) as track_count from artist a inner join album al using(artist_id) inner join track t using(album_id) inner join genre g using(genre_id)
where g.name like "Rock"
group by a.artist_id
limit 10;


/*3. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. 
Order by the song length with the
longest songs listed first */
select name , concat(round(milliseconds/1000,2)," K") as `length in millisec` from track 
where milliseconds > (select avg(milliseconds) as average_length from track)
order by milliseconds desc;


/* 1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent */
set sql_mode = "";
select concat(c.first_name," ",c.last_name) as `customer Name`, a.name as `artist name`, sum(il.unit_price*il.quantity) as `total spent`
from customer c inner JOIN invoice i ON i.customer_id = c.customer_id
inner JOIN invoice_line il ON il.invoice_id = i.invoice_id
inner JOIN track t ON t.track_id = il.track_id
inner join album al using(album_id)
inner join artist a using(artist_id)
group by `customer Name`
order by `total spent` desc, `customer Name`;


/* 2. We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres */


/* 3. Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount */
select `customer name`, country , amount_spent from
(select concat(c.first_name," ",c.last_name) as `customer Name`, c.country as country , 
sum(i.total) as amount_spent, row_number()over(partition by c.country order by sum(i.total) desc) as row_num
from customer c inner join invoice i using(customer_id)
group by `customer Name`
order by amount_spent desc) as rnk 
where row_num = 1;


select c.country as country, concat(c.first_name," ",c.last_name) as `customer Name`, SUM(i.TOTAL) as `amount spent`, 
row_number()over(partition by c.country order by sum(i.total) desc) as row_num
from customer c inner join invoice i using (customer_id)
group by `customer Name`
order by `amount spent` desc;












