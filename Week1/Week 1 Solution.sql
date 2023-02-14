/* 1) What is the total amount each customer spent at the restaurant?*/

select a.customer_id,sum(c.price)as amount_spent
from members a 
join sales b on a.customer_id=b.customer_id
join menu c on b.product_id=c.product_id
group by a.customer_id
order by a.customer_id;


/* 2) How many days has each customer visited the restaurant?*/

select a.customer_id,count(distinct(b.order_date))as days_visited
from members a 
join sales b on a.customer_id=b.customer_id
group by a.customer_id
order by a.customer_id;


/* 3) What was the first item from the menu purchased by each customer?*/
