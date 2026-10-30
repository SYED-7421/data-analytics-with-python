-- ============================================================
--  ASSIGNMENT 09 — Joins & Group By
--  Database : BikeStores
--  Topics   : INNER / LEFT / RIGHT / FULL OUTER JOIN,
--             multi-table joins, aggregate functions,
--             GROUP BY, HAVING
-- ============================================================


-- ============================================================
--  Question 1 — INNER JOIN
-- ============================================================
select 
p.product_name,
b.brand_name,
p.list_price
from production.products p
inner join production.brands b 
    on b.brand_id = p.brand_id
order by 
    b.brand_name asc,
    p.list_price desc;


-- ============================================================
--  Question 2 — Joining Three Tables
-- ============================================================
select 
p.product_name,
b.brand_name,
c.category_name,
p.model_year
from production.products p
inner join production.brands b 
    on b.brand_id = p.brand_id
inner join production.categories c 
    on c.category_id = p.category_id
where p.list_price > 1000;


-- ============================================================
--  Question 3 — LEFT JOIN
-- ============================================================

-- Part a:
select 
    c.first_name,
    c.last_name,
    c.city,
    o.order_id,
    o.order_date
from sales.customers c
left join sales.orders o 
    on o.customer_id = c.customer_id
order by o.order_id asc;

-- Part b:
select 
    c.first_name,
    c.last_name,
    c.city,
    o.order_id,
    o.order_date
from sales.customers c
left join sales.orders o 
    on o.customer_id = c.customer_id
where o.order_id is null;


-- ============================================================
--  Question 4 — RIGHT JOIN & FULL OUTER JOIN
-- ============================================================

-- Part a:
select 
    s.store_name,
    st.first_name,
    st.last_name
from sales.staffs st
right join sales.stores s 
    on s.store_id = st.store_id;

-- Part b:
select 
    p.product_name,
    s.quantity
from production.products p
full outer join production.stocks s 
    on s.product_id = p.product_id
where s.product_id is null;


-- ============================================================
--  Question 5 — Multi-Table Join (Order Details)
-- ============================================================
select 
o.order_id,
o.order_date,
c.first_name + ' ' + c.last_name as customer_name,
p.product_name,
oi.quantity,
oi.quantity * oi.list_price * (1 - oi.discount) as line_total
from sales.orders o
inner join sales.customers c 
    on c.customer_id = o.customer_id
inner join sales.order_items oi 
    on oi.order_id = o.order_id
inner join production.products p 
    on p.product_id = oi.product_id
order by 
    o.order_id,
    p.product_name;


-- ============================================================
--  Question 6 — Aggregate Functions
-- ============================================================
select 
count(*) as total_products,
min(list_price) as lowest_price,
max(list_price) as highest_price,
round(avg(list_price), 2) as average_price
from production.products;


-- ============================================================
--  Question 7 — GROUP BY
-- ============================================================

-- Part a:
select 
c.category_name,
count(p.product_id) as product_count
from production.products p
inner join production.categories c 
    on c.category_id = p.category_id
group by c.category_name
order by product_count desc;

-- Part b:
select 
b.brand_name,
p.model_year,
round(avg(p.list_price), 2) as avg_list_price
from production.products p
inner join production.brands b 
    on b.brand_id = p.brand_id
group by 
    b.brand_name,
    p.model_year
order by 
    b.brand_name,
    p.model_year;


-- ============================================================
--  Question 8 — GROUP BY with Joins
-- ============================================================

-- Part a:
select 
c.customer_id,
c.first_name + ' ' + c.last_name as full_name,
count(o.order_id) as total_orders
from sales.customers c
inner join sales.orders o 
    on o.customer_id = c.customer_id
group by 
    c.customer_id,
    c.first_name,
    c.last_name
order by total_orders desc;

-- Part b:
select 
    s.store_name,
    sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
from sales.orders o
inner join sales.order_items oi 
    on oi.order_id = o.order_id
inner join sales.stores s 
    on s.store_id = o.store_id
group by s.store_name
order by total_revenue desc;


-- ============================================================
--  Question 9 — HAVING
-- ============================================================

-- Part a:
select 
b.brand_name,
count(p.product_id) as product_count
from production.brands b
inner join production.products p 
    on p.brand_id = b.brand_id
group by b.brand_name
having count(p.product_id) > 20;

-- Part b:
select 
c.first_name + ' ' + c.last_name as full_name,
count(o.order_id) as total_orders
from sales.customers c
inner join sales.orders o 
on o.customer_id = c.customer_id
group by 
 c.customer_id,
c.first_name,
c.last_name
having count(o.order_id) >= 3;

-- Part c (answer as a comment):
-- WHERE filters individual rows BEFORE grouping happens.
-- HAVING filters groups AFTER GROUP BY, so it can use aggregate
-- functions like COUNT(), SUM(), AVG(). WHERE cannot use them.


-- ============================================================
--  Question 10 — Combined Challenge
-- ============================================================
select top 5
    p.product_name,
    c.category_name,
    sum(oi.quantity) as total_quantity_sold,
    sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
from sales.order_items oi
inner join sales.orders o 
    on o.order_id = oi.order_id
inner join production.products p 
    on p.product_id = oi.product_id
inner join production.categories c 
    on c.category_id = p.category_id
where o.order_status = 4
group by 
    p.product_name,
    c.category_name
order by total_quantity_sold desc;