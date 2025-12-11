create table Books (
Book_ID	serial	PRIMARY KEY,
Title	varchar(100),
Author	varchar(100),	
Genre	varchar(100),	
Published_Year	INT	,
Price	NUMERIC(10,2),	
Stock	INT	
)

create table customers (
Customer_ID	SERIAL	PRIMARY KEY,
Name	VARCHAR(100),	
Email	VARCHAR(100),	
Phone	VARCHAR(100),	
City	VARCHAR(100),	
Country	VARCHAR(100)	
)

create table orders(
Order_ID SERIAL	PRIMARY KEY,
Customer_ID	INT	REFERENCES CUSTOMERS(CUSTOMER_ID),
Book_ID	INT REFERENCES BOOKS(BOOK_ID),
Order_Date	DATE,	
Quantity INT,	
Total_Amount NUMERIC(10,2)	
)


select * from orders

-- Retrieve all books in fiction genre
select * from books where genre = 'Fiction'

-- Find Books published after the year 1950
select * from books where published_year > 1950

-- list all customers from Canada
select * from customers where Country = 'Canada'

-- show orders placed in November 2023
select * from orders  where extract(year from order_date) = 2023

-- Retrieve total stock of books available
select sum(stock) as total_stock from books

-- Find details of the most expensive book
select * from books order by price desc limit 1

-- show all customers who ordered more than 1 quantity of a book
select * from orders where quantity > 1

-- Retrieve all orders whre total amount exceed 20 dollars
select * from orders where total_amount > 20

--  list all genres available in books table
select distinct genre from books

-- find the book with the lowest stock
select * from books order by stock limit 1

-- calculate total revenue generated from all orders
select sum(total_amount) as revenue from orders

--Retrieve total number of books sold by each genre
select books.genre, sum(orders.quantity) as total_books 
from books join orders
on books.book_id = orders.book_id
group by genre 

--FInd the average price of books in the 'fantasy' genre
select avg(price) as avg_price from books
where genre = 'Fantasy'

--list customers who have placed at least2 orders
select customers.customer_id, customers.name, count(orders.order_id) as order_count
from orders join customers
on orders.customer_id = customers.customer_id
group by customers.customer_id
having count(order_id) >=2

-- find the most frequently ordered book
with cte1 as (select orders.book_id, books.title, count(orders.order_id) as order_frequency,
dense_rank() over (order by count(orders.order_id) desc) as rnk
from books join orders
on books.book_id = orders.book_id
group by orders.book_id, books.title
order by order_frequency desc) 

select cte1.book_id, cte1.title, cte1.order_frequency from cte1
where rnk = 1

-- show the top 3 most expensive books of 'Fantasy' genre
with cte1 as (select book_id, title, price, dense_rank() over (order by price desc) as rnk from books
where genre = 'Fantasy')
select cte1.book_id, cte1.title, cte1.price from cte1 where rnk  <=3

-- Retrieve total quantity of books sold by each author
select books.author, sum(orders.quantity) as qty_sold from books
join orders on orders.book_id = books.book_id
group by books.author

-- list the cities where customers who spent over 3o dollars are located
select customers.customer_id, customers.city , sum(orders.total_amount) as spent
from orders join customers
on orders.customer_id = customers.customer_id
group by customers.customer_id
having sum(orders.total_amount)> 30

-- find the customer who spent the most on orders
select customers.customer_id , sum(orders.total_amount) as spent
from orders join customers
on orders.customer_id = customers.customer_id
group by customers.customer_id
order by spent desc

-- calculate the stock remaining after fulfilling the orders

with cte1  as (select books.book_id, books.stock, sum(orders.quantity) as total_sold
from books join orders
on books.book_id = orders.book_id
group by books.book_id)
select cte1.book_id, cte1.stock - cte1.total_sold as remaining_stock from cte1 









