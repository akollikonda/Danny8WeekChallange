/* A. Pizza Metrics */

/* 1) How many pizzas were ordered?*/

select count(pizza_id) as pizzas_ordered from customer_orders;

/* 2) How many unique customer orders were made?*/

select count(distinct order_id) as unique_customer_orders from customer_orders;
