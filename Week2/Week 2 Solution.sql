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


/* B. Runner and Customer Experience*/

/*1) How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)*/

select 
	extract(week from registration_date) as week_num,
    count(*) as runners_joined 
from runners 
group by week_num
order by week_num;

/*2) What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?*/

with time_taken_to_pick as(select 
	distinct co.order_id,
    ro.runner_id,
    timediff(ro.pickup_time,co.order_time) as time_taken
from customer_orders co
right join runner_orders ro on co.order_id=ro.order_id
where timediff(ro.pickup_time,co.order_time) is not null)
select runner_id, avg(time_taken)/60 time_in_min from time_taken_to_pick group by runner_id order by runner_id;

/*3) Is there any relationship between the number of pizzas and how long the order takes to prepare?*/

with cte as(
select c.order_id, count(c.order_id) as PizzaCount, round((timestampdiff(minute, order_time, pickup_time))) as Avgtime
from customer_orders as c
inner join runner_orders as r
on c.order_id = r.order_id
where distance != 0 
group by c.order_id,Avgtime)
select PizzaCount, avg(Avgtime)
from cte
group by PizzaCount;

/*4) What was the average distance travelled for each customer?*/

select 
	c.customer_id, 
	avg(r.distance) avg_distance
from customer_orders as c
inner join runner_orders as r
on c.order_id = r.order_id
group by c.customer_id;

/*5) What was the difference between the longest and shortest delivery times for all orders?*/

select max(duration)-min(duration) as diff from runner_orders where duration not like "null"; 

/*6) What was the average speed for each runner for each delivery and do you notice any trend for these values?*/

select runner_id,avg((distance/duration))as avg_speed from runner_orders group by runner_id;

/*7) What is the successful delivery percentage for each runner?*/

select 
	runner_id,
    avg(case when (cancellation = 'Restaurant Cancellation') or (cancellation = 'Customer Cancellation') then 0
         else 1
	end)*100 as delievery_percentage
from runner_orders
group by runner_id;
