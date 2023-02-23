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

with dates_rank as (select a.customer_id,order_date,b.product_id,b.product_name,
	dense_rank() over (partition by a.customer_id order by order_date) as r
    from sales a 
join menu b on a.product_id=b.product_id)
select customer_id, product_name from dates_rank where r=1;

/* 4) What is the most purchased item on the menu and how many times was it purchased by all customers? */

select b.product_name, count(*) 
from sales a
join menu b on a.product_id=b.product_id
group by b.product_name order by count(*) desc limit 1;

/* 5) Which item was the most popular for each customer?*/

with popularity_rank as (select a.customer_id,
	b.product_name,
    count(b.product_name) as product_count,
    rank() over (partition by a.customer_id order by count(a.customer_id) desc) as r
from sales a
join menu b on a.product_id=b.product_id
group by a.customer_id,b.product_name)
select customer_id, product_name as most_popular_item from popularity_rank where r=1;

/* 6) Which item was purchased first by the customer after they became a member?*/

with first_date as(select a.customer_id,min(b.order_date) as first_order
	from members a
    join sales b on a.customer_id=b.customer_id
    join menu c on b.product_id=c.product_id
    where b.order_date>=a.join_date
    group by a.customer_id
    order by a.customer_id)
select fd.customer_id,m.product_name 
	from first_date fd
    join sales s on fd.customer_id=s.customer_id
    join menu m on s.product_id=m.product_id
    where s.order_date=fd.first_order
    order by fd.customer_id;
    
 /* 7) Which item was purchased just before the customer became a member?*/
 
 with last_date as(select a.customer_id,max(b.order_date) as last_order
	from members a
    join sales b on a.customer_id=b.customer_id
    join menu c on b.product_id=c.product_id
    where b.order_date<a.join_date
    group by a.customer_id
    order by a.customer_id)
select ld.customer_id,m.product_name 
	from last_date ld
    join sales s on ld.customer_id=s.customer_id
    join menu m on s.product_id=m.product_id
    where s.order_date=ld.last_order
    order by ld.customer_id;

/* 8) What is the total items and amount spent for each member before they became a member? */

select mem.customer_id,
	count(distinct s.product_id) as product_count,
	sum(price) as amount_spent
	from members mem 
    join sales s on mem.customer_id=s.customer_id 
    join menu m on s.product_id=m.product_id
    where s.order_date<=mem.join_date
    group by mem.customer_id
    order by mem.customer_id;
    
/* 9) If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?*/

select s.customer_id,
	sum(case when m.product_name="sushi" then m.price*20
    else m.price*10
    end) as points
	from sales s 
    join menu m on s.product_id=m.product_id
    group by s.customer_id;
    
/* 10) In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?*/
