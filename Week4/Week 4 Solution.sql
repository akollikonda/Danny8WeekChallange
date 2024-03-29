
select * from data_bank.customer_nodes;

select * from data_bank.regions;

-- How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) AS unique_nodes
FROM data_bank.customer_nodes;

-- What is the number of nodes per region?
select region_id,count( node_id) from data_bank.customer_nodes group by region_id;

--How many customers are allocated to each region?
select region_id,count(distinct customer_id) from data_bank.customer_nodes group by region_id;

