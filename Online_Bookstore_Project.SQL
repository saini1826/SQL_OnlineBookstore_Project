drop database if exists onlineBookstore;
create database onlineBookstore;
use onlineBookstore;

drop table if exists Books;
create table Books (
     Book_ID int primary key,
     Title varchar(100),
     Author varchar(100),
     Genre varchar(100),
     Published_Year int,
     Price numeric(10,2),
     Stock int 
     );
drop table if exists Customers;
create table Customers (
     Customer_ID int primary key,
     Name varchar(100),
     Email varchar(100),
     Phone varchar(50),
     City varchar(50),
     Country varchar(100)
     );
drop table if exists Orders;
create table Orders (
     Order_ID int primary key,
     Customer_ID int references Customers(Customer_ID),
     Book_ID int references Books(Book_ID),
     Order_Date date,
     Quantity int,
     Total_Amount decimal(10,2)
     );

set foreign_key_checks=0;

-- import data 
select * from Books;
select * from Customers;
select * from Orders;

# 1) Retrieve all books in the "fiction" genue:

select * from Books
where Genre = "fiction";

# 2) find books published after the year 1950:

select * from Books
where Published_Year > 1950;

# 3) list all customers from the canada:

select * from Customers
where country = "canada";

# 4) show orders placed in November 2023:

select * from Orders
where Order_Date between "2023-11-1" and "2023-11-30";

# 5) Retrieve the total stock of books available:

select sum(Stock) as Total_stock
from Books;

# 6) find the detaild of the most expencive books:

 select * from Books 
 order by Price desc 
 limit 1;
 
 # 7) show all customers who ardered more than 1 quantity of a books:
 
 select * from Orders
 where Quantity > 1;
 
 # 8) Retrieve all orders where the total amount exceeds $20:
 
 select * from Orders 
 where Total_Amount > 20;
 
 # 9) list all genres available in the books table:
 
 select distinct Genre from Books;
 
 # 10) find the books with the lowest stock:
 
 select * from Books
 order by Stock asc
 limit 1;
 
 # 11) calculate the Total revenue generated from all orders:
 
 select sum(Total_Amount) as Total_revenue
 from Orders;
 
 # 12) Retrieve the total number of books sold for each genre:
 
 select b.Genre, sum(o.Quantity) as Total_book_sold
 from Orders o
 join Books b on o.Book_ID = b.Book_ID
 group by b.Genre;
 
 # 13) find the average price of books in the "fantasy" genre:
 
 select avg(Price) as Average_price
 from Books
 where Genre = "Fantasy";
 
 # 14) list customers who have placed at least 2 orders:
 
 select o.customer_id, c.name, count(o.order_id) as order_count
 from orders o
 join customers c on o.customer_id = c.customer_id
 group by o.customer_id, c.name
 having count(order_id) >=2;
 
 # 15) find the most frequently ordered book:
 
select o.book_id, b.title, count(o.order_id) as order_count
from orders o
join books b on o.book_id = b.book_id 
group by o.book_id, b.title
order by order_count desc
limit 1;

# 16) show the top 3 most expensive books of "fantasy" genre:

select * from Books
where genre = "Fantasy"
order by Price desc
limit 3;

# 17) Retrieve the total quantity of books sold by each author:

select b.author, sum(o.quantity) as total_books_sold
from orders o
join books b on o.book_id = b.book_id
group by b.author;

# 18) list the cities where customers who spent over $30 are located:

select distinct c.city, total_amount
from orders o
join customers c on o.customer_id = c.customer_id
where o.total_amount > 30;

# 19) find the customer who spent the most on orders:

select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o
join customers c on o.customer_id = c.customer_id 
group by c.customer_id, c.name
order by total_spent desc
limit 2;

# 20) calculate the stock remaining after fulfilling all orders:

select b.book_id, b.title, b.stock, coalesce(sum(quantity),0) as order_quantity
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id;