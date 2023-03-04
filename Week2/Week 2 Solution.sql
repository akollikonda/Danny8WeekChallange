/* A. Pizza Metrics */

/* 1) How many pizzas were ordered?*/

select 
  count(pizza_id) as pizzas_ordered 
 from customer_orders;

/* 2) How many unique customer orders were made?*/

select 
  count(distinct order_id) as unique_customer_orders 
 from customer_orders;

/* 3) How many successful orders were delivered by each runner?*/

select 
	runner_id, 
	count(order_id) as successful_orders 
from runner_orders 
where cancellation is null or cancellation like ""
group by runner_id
order by runner_id;
    
/* 4) How many of each type of pizza was delivered?*/

select 
	pizza_id,
  count(order_id) as num_of_pizzas
from customer_orders
group by pizza_id;
  
/* 5) How many Vegetarian and Meatlovers were ordered by each customer?*/

select 
	customer_id,
    sum(case when pizza_name='Meatlovers' then 1
    else 0 
    end) as Meatlovers,
    sum(case when pizza_name='Vegetarian' then 1
    else 0 
    end) as Vegetarian
from customer_orders co 
join pizza_names pn on co.pizza_id=pn.pizza_id
group by customer_id;

/* 6) What was the maximum number of pizzas delivered in a single order?*/

select 
	order_id, 
  count(pizza_id) as Max_pizzas_delievered
from customer_orders 
group by order_id 
order by count(pizza_id) desc 
limit 1;

/* 7) For each customer, how many delivered pizzas had at least 1 change and how many had no changes?*/

select 
	customer_id,
    sum(case when (exclusions = '' or  exclusions is null ) and (extras = '' or  extras is null) then 1 else 0 end) as no_extras,
    sum(case when (exclusions <> '' and  exclusions is not null ) or  (extras <> '' and  extras is not null)then 1 else 0 end) as atleast_one_extra
from customer_orders
group by customer_id;

/* 9) What was the total volume of pizzas ordered for each hour of the day?*/

select 
	extract(HOUR from order_time) as hour_of_day,
    count(*) as pizzas_ordered 
from customer_orders 
group by hour_of_day
order by hour_of_day;

/* 10) What was the volume of orders for each day of the week?*/

select 
	extract(day from order_time) as day_of_week,
    count(*) as pizzas_ordered 
from customer_orders 
group by day_of_week
order by day_of_week;


