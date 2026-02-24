--q1
select * from shipper s 

--q2
select c.category_name as "Category Name" , c.description as "Description" from category c 

--q3
select e.first_name as "First Name", e.last_name as "Last Name", e.hire_date as "Hire Date" 
from employee e 
where e.title = 'Sales Representative'

--q4
select e.first_name as "First Name", e.last_name as "Last Name", e.hire_date as "Hire Date" 
from employee e 
where e.title = 'Sales Representative' and e.country = 'USA'

--q5
select * from "order" o 
where o.employee_id = 5

--q6
select s.supplier_id, s.contact_name, s.contact_title 
from supplier s 
where s.contact_title != 'Marketing Manager'

--q7
select p.product_id, p.product_name
from product p 
where p.product_name ilike '%queso%'

--q8
select o.order_id, o.customer_id, o.ship_country from "order" o 
--where o.ship_country = 'France' or o.ship_country = 'Belgium'
where o.ship_country in ('France', 'Belgium')

--q9
select o.order_id, o.customer_id, o.ship_country from "order" o
where o.ship_country in ('Brazil', 'Mexico', 'Argentina', 'Venezuela')

--q10
select e.first_name, e.last_name, e.title, e.birth_date
from employee e 
order by birth_date 

--q11
select e.first_name, e.last_name, e.title, to_char(e.birth_date, 'YYYY-MM-DD') as "DateOnlyBirthDate"
from employee e 
order by birth_date 

--q12
select e.first_name, e.last_name, concat(e.first_name, ' ', e.last_name) as "Full Name"
from employee e 

--q13
select od.order_id, od.product_id, od.unit_price, od.quantity, (od.unit_price * od.quantity) as "TotalPrice"
from order_detail od
order by od.order_id, od.product_id 

--q14
select count(c.customer_id) as "TotalCustomers"
from customer c 

--q15
-- select o.order_date as "FirstOrder"
-- from "order" o 
-- order by o.order_date 
-- limit 1

SELECT MIN(o.order_date) as "FirstOrder"
FROM "order" o

--q16
--select distinct c.country 
--from customer c 
--order by c.country 

select c.country
from customer c 
group by c.country 
order by c.country 

--q17
select c.contact_title , count(c.contact_title) as "TotalContactTitle"
from customer c 
group by c.contact_title 
order by "TotalContactTitle" desc

--q18
select p.product_id, p.product_name, s.company_name 
from supplier s 
join product p on s.supplier_id = p.supplier_id 
-- group by p.product_id, p.product_name, s.company_name // not needed because product_id is unique 
order by p.product_id 

--q19
select o.order_id, to_char(o.order_date, 'yyyy-mm-dd'), s.company_name
from "order" o 
join shipper s on o.ship_via = s.shipper_id 
where o.order_id < 10300

-- intermediate problems

--q20
select c.category_name, count(p.product_id) as "TotalProducts"
from category c
join product p on p.category_id = c.category_id 
group by c.category_name 
order by "TotalProducts" desc

--q21
select c.country, c.city, count(c.customer_id) as "TotalCustomer"
from customer c 
group by c.country, c.city 
order by "TotalCustomer" desc

--q22
select p.product_id, p.product_name, p.unit_in_stock, p.reorder_level
from product p 
where p.unit_in_stock < p.reorder_level 
order by p.product_id 

--q23
select p.product_id, p.product_name, p.unit_in_stock, p.units_on_order, p.reorder_level, p.discontinued 
from product p 
where p.unit_in_stock + p.units_on_order <= p.reorder_level and p.discontinued = 0
order by p.product_id 

--q24
select c.customer_id, c.company_name, c.region
from customer c 
order by 
	c.region is null asc, -- null last order
	c.region, -- alphabetical order on region column
	c.customer_id -- alphabetical order on customer_id column
	
--q25
select o.ship_country, round(avg(o.freight), 4) as "AverageFreight"
from "order" o 
group by o.ship_country 
order by "AverageFreight" desc
limit 3

--q26
select o.ship_country, round(avg(o.freight), 4) as "AverageFreight"
from "order" o 
--where extract(year from o.order_date) = 2015
--where o.order_date between '2015-01-01' and '2015-12-31' => this one won't work because using BETWEEN '2015-01-01' and '2015-12-31' misses orders on Dec 31st after midnight (e.g., 2015-12-31 14:30:00).
where o.order_date >= '2015-01-01' and o.order_date < '2016-01-01'
group by o.ship_country 
order by "AverageFreight" desc
limit 3

--q27

--q28
select o.ship_country, round(avg(o.freight), 4) as "AverageFreight"
from "order" o 
where o.order_date >= (select max(order_date) - interval '12 months' from "order")
-- interval '12 months': PostgreSQL duration type, subtracts 12 calendar months from a date/timestamp
-- Other examples: interval '1 year', interval '30 days', interval '2 hours 30 minutes'
group by o.ship_country 
order by "AverageFreight" desc
limit 3

--q29
select e.employee_id, e.last_name, o.order_id, p.product_name, od.quantity 
from employee e 
join "order" o on o.employee_id = e.employee_id
join order_detail od on o.order_id = od.order_id 
join product p on od.product_id = p.product_id 
order by o.order_id, p.product_id 

--q30
select c.customer_id, o.order_id 
from customer c 
left join "order" o on c.customer_id = o.customer_id 
where o.order_id is null
order by c.customer_id 

--q31
select c.customer_id
from customer c
left join "order" o on c.customer_id = o.customer_id and o.employee_id = 4
where o.order_id is null

--select c.customer_id
--from customer c
--where c.customer_id not in (
--    select o.customer_id 
--    from "order" o 
--    where o.employee_id = 4
--)

-- advanced problems

--q32
-- WHERE vs HAVING:
-- WHERE filters rows BEFORE grouping (e.g., only 2016 orders)
-- HAVING filters groups AFTER aggregation (e.g., only totals >= 10000)
-- Flow: FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
select c.customer_id, c.company_name, o.order_id, round(sum(od.quantity * od.unit_price), 2) as "TotalOrderAmount"
from customer c
join "order" o on o.customer_id = c.customer_id 
join order_detail od on o.order_id = od.order_id 
where extract(year from o.order_date) = 2016 -- filters rows before grouping
group by c.customer_id, o.order_id, c.company_name  
having sum(od.quantity * od.unit_price) >= 10000 -- filters aggregated results (can't use alias here)
order by "TotalOrderAmount" desc

--q33
select c.customer_id, c.company_name, round(sum(od.quantity * od.unit_price), 2) as "TotalAmount"
from customer c
join "order" o on o.customer_id = c.customer_id 
join order_detail od on o.order_id = od.order_id 
where extract(year from o.order_date) = 2016
group by c.customer_id, c.company_name  
having sum(od.quantity * od.unit_price) >= 15000
order by "TotalAmount" desc

--q34
select 
	c.customer_id, 
	c.company_name, 
	sum(od.quantity * od.unit_price)  as "TotalsWithoutDiscount", 
	sum(od.quantity * od.unit_price * (1 - od.discount))  as "TotalsWithDiscount"
from customer c
join "order" o on o.customer_id = c.customer_id 
join order_detail od on o.order_id = od.order_id 
where extract(year from o.order_date) = 2016
group by c.customer_id, c.company_name  
having sum(od.quantity * od.unit_price * (1 - od.discount)) >= 10000
order by "TotalsWithDiscount" desc

--q35
--select o.employee_id, o.order_id , o.order_date 
--from "order" o 
--where date_part('day', o.order_date) = date_part('day', (date_trunc('month', o.order_date) + interval '1 month - 1 day'))

select o.employee_id, o.order_id, o.order_date 
from "order" o 
where date_trunc('month', o.order_date) != date_trunc('month', o.order_date + interval '1 day')
order by o.employee_id, o.order_id

--q36
select od.order_id, count(*) as "TotalOrderDetails"
from order_detail od  
group by od.order_id 
order by "TotalOrderDetails" desc
limit 10
-- https://www.postgresql.org/docs/current/sql-select.html#SQL-LIMIT

--q37
select o.order_id 
from "order" o 
order by random() 
limit (select round(count(*) * 0.02) from "order")
-- LIMIT requires a constant value, not an aggregate
-- => we cannot do it like this: limit round(count(*) * 0.02)

--q38
select od.order_id
from order_detail od
inner join order_detail od2 on od.order_id = od2.order_id 
where od.product_id < od2.product_id and od.quantity = od2.quantity and od.quantity >= 60

-- select od.order_id
-- from order_detail od
-- where od.quantity >= 60
-- group by od.order_id, od.quantity
-- having count(*) > 1  -- more than 1 product with same quantity
-- order by od.order_id

--q39
select od.order_id, od.product_id, od.unit_price, od.quantity, od.discount 
from order_detail od
where od.order_id in (
    -- reuse q38 logic to find qualifying orders
	select od.order_id
	from order_detail od
	inner join order_detail od2 on od.order_id = od2.order_id 
	where od.product_id < od2.product_id and od.quantity = od2.quantity and od.quantity >= 60
)
order by od.order_id, od.product_id

-- Using Common Table Expression (CTE)
with potential_problem_orders as (
    select order_id
    from order_detail
    where quantity >= 60
    group by order_id, quantity
    having count(*) > 1
)
select od.order_id, od.product_id, od.unit_price, od.quantity, od.discount 
from order_detail od
where od.order_id in (select order_id from potential_problem_orders)
order by od.order_id, od.product_id

--q40
-- with bug
select
    order_detail.order_id
    ,product_id
    ,unit_price
    ,quantity
    ,discount
from order_detail
    join (
        select distinct -- solution 1: add distinct to avoid duplication on joining
            order_id
        from order_detail
        where quantity >= 60
        group by order_id, quantity
        having count(*) > 1
    ) potential_problem_orders
    on potential_problem_orders.order_id = order_detail.order_id
--group by order_detail.order_id, order_detail.quantity, order_detail.product_id --solution 2: using group by
order by order_id, product_id

--q41
select o.order_id, o.order_date, o.required_date, o.shipped_date 
from "order" o 
where o.required_date <= o.shipped_date 

--q42
select e.employee_id, e.last_name, count(*) as "TotalLateOrders"
from "order" o 
join employee e 
	on o.employee_id = e.employee_id 
where o.required_date <= o.shipped_date 
group by e.employee_id, e.last_name 
order by "TotalLateOrders" desc

--q43
with all_orders_per_employee as (
    select e.employee_id, count(*) as "AllOrders"
    from employee e 
	join "order" o 
		on o.employee_id = e.employee_id 
	group by e.employee_id 
)
select e.employee_id, e.last_name, count(*) as "TotalLateOrders", aoe."AllOrders" 
from "order" o 
join employee e 
	on o.employee_id = e.employee_id 
join all_orders_per_employee aoe
	on o.employee_id = aoe.employee_id 
where o.required_date <= o.shipped_date 
group by e.employee_id, e.last_name, aoe."AllOrders"
order by e.employee_id

--q44
with all_late_orders_per_employee as (
    select e.employee_id, count(*) as "LateOrders"
    from employee e 
	join "order" o 
		on o.employee_id = e.employee_id 
	where o.required_date <= o.shipped_date 
	group by e.employee_id 
)
select e.employee_id, e.last_name, count(*) as "AllOrders", aloe."LateOrders"  
from "order" o 
join employee e 
	on o.employee_id = e.employee_id 
left join all_late_orders_per_employee aloe
	on o.employee_id = aloe.employee_id 
group by e.employee_id, e.last_name, aloe."LateOrders" 
order by e.employee_id

--q45
with all_late_orders_per_employee as (
    select e.employee_id, count(*) as "LateOrders"
    from employee e 
	join "order" o 
		on o.employee_id = e.employee_id 
	where o.required_date <= o.shipped_date 
	group by e.employee_id 
)
-- coalesce(arg1, arg2, ...) returns the first non-null argument.
select 
	e.employee_id, 
	e.last_name, 
	count(*) as "AllOrders", 
	coalesce(aloe."LateOrders", 0)
from "order" o 
join employee e 
	on o.employee_id = e.employee_id 
left join all_late_orders_per_employee aloe
	on o.employee_id = aloe.employee_id 
group by e.employee_id, e.last_name, aloe."LateOrders" 
order by e.employee_id

--q46
with all_late_orders_per_employee as (
    select e.employee_id, count(*) as "LateOrders"
    from employee e 
	join "order" o 
		on o.employee_id = e.employee_id 
	where o.required_date <= o.shipped_date 
	group by e.employee_id 
)
select 
	e.employee_id, 
	e.last_name, 
	count(*) as "AllOrders", 
	coalesce(aloe."LateOrders", 0) as "LateOrders",
	coalesce(aloe."LateOrders", 0)::decimal / count(*) as "PercentLateOrders"
from "order" o 
join employee e 
	on o.employee_id = e.employee_id 
left join all_late_orders_per_employee aloe
	on o.employee_id = aloe.employee_id 
group by e.employee_id, e.last_name, aloe."LateOrders" 
order by e.employee_id

--q47
with all_late_orders_per_employee as (
    select e.employee_id, count(*) as "LateOrders"
    from employee e 
	join "order" o 
		on o.employee_id = e.employee_id 
	where o.required_date <= o.shipped_date 
	group by e.employee_id 
)
select 
	e.employee_id, 
	e.last_name, 
	count(*) as "AllOrders", 
	coalesce(aloe."LateOrders", 0) as "LateOrders",
	round(coalesce(aloe."LateOrders", 0)::decimal / count(*), 2) as "PercentLateOrders"
from "order" o 
join employee e 
	on o.employee_id = e.employee_id 
left join all_late_orders_per_employee aloe
	on o.employee_id = aloe.employee_id 
group by e.employee_id, e.last_name, aloe."LateOrders" 
order by e.employee_id

--q48, q49
select 
	c.customer_id, 
	c.company_name, 
	sum(od.quantity * od.unit_price) as "TotalOrderAmount",
	case 
	    when sum(od.quantity * od.unit_price) < 1000 then 'Low'
	    when sum(od.quantity * od.unit_price) < 5000 then 'Medium'
	    when sum(od.quantity * od.unit_price) < 10000 then 'High'
	    else 'Very High'
	end as "CustomerGroup"
from customer c
join "order" o on o.customer_id = c.customer_id 
join order_detail od on o.order_id = od.order_id 
where extract(year from o.order_date) = 2016
group by c.customer_id, c.company_name
order by c.customer_id

--q50
-- Goal: Show percentage of customers in each group (Low, Medium, High, Very High)
-- 
-- Why we need OVER() window function:
-- Problem: In a GROUP BY query, aggregate functions only see rows within their own group.
--          count(*) returns count per group, but we need the TOTAL count across ALL groups
--          to calculate percentage.
--
-- Without OVER(): count(*) / sum(count(*)) would fail because sum(count(*)) 
--                 would just equal count(*) within each group = always 1.
--
-- With OVER():    sum(count(*)) over() computes the sum across the ENTIRE result set,
--                 not just the current group. The empty OVER() means "all rows".
--
-- Execution flow:
-- 1. GROUP BY groups rows by "CustomerGroup"
-- 2. count(*) computes count within each group (e.g., Low=10, Medium=25, High=20, Very High=26)
-- 3. sum(count(*)) over() adds up ALL group counts (10+25+20+26 = 81)
-- 4. Division gives percentage: 10/81, 25/81, 20/81, 26/81
with grouped_customers as (
	select 
		c.customer_id, 
		c.company_name, 
		sum(od.quantity * od.unit_price) as "TotalOrderAmount",
		case 
		    when sum(od.quantity * od.unit_price) < 1000 then 'Low'
		    when sum(od.quantity * od.unit_price) < 5000 then 'Medium'
		    when sum(od.quantity * od.unit_price) < 10000 then 'High'
		    else 'Very High'
		end as "CustomerGroup"
	from customer c
	join "order" o on o.customer_id = c.customer_id 
	join order_detail od on o.order_id = od.order_id 
	where extract(year from o.order_date) = 2016
	group by c.customer_id, c.company_name
)
select 
	"CustomerGroup", 
	count(*) as "TotalInGroup", 
	-- count(*) = customers in THIS group
	-- sum(count(*)) over() = total customers across ALL groups (window function)
	count(*)::decimal / sum(count(*)) over() as "PercentageInGroup"
from grouped_customers
group by "CustomerGroup"
order by "TotalInGroup" desc

--q51
--non-equi JOIN
with customer_totals as (
    select 
        c.customer_id, 
        c.company_name, 
        sum(od.quantity * od.unit_price) as "TotalOrderAmount"
    from customer c
    join "order" o on o.customer_id = c.customer_id 
    join order_detail od on o.order_id = od.order_id 
    where extract(year from o.order_date) = 2016
    group by c.customer_id, c.company_name
)
select 
    customer_id,
    company_name,
    "TotalOrderAmount",
	cgt.customer_group_name 
from customer_totals ct
join customer_group_threshold cgt 
	on ct."TotalOrderAmount" >= cgt.range_bottom 
	and ct."TotalOrderAmount" < cgt.range_top 
order by customer_id

--q52
select c.country 
from customer c 
union
--Use the UNION to combine result sets of two queries and return distinct rows.
--Use the UNION ALL to combine the result sets of two queries but retain the duplicate rows.
select s.country 
from supplier s 
order by country

--q53
-- ISSUE: Joining raw tables creates many duplicate rows before DISTINCT eliminates them.
-- Example: If USA has 10 customers and 3 suppliers, the join produces 10×3 = 30 rows,
-- then DISTINCT collapses them to 1. This is inefficient.
-- 
-- BETTER APPROACH: Get distinct countries from each table FIRST, then join:
-- select s.country as "SupplierCountry", c.country as "CustomerCountry"
-- from (select distinct country from supplier) s
-- full join (select distinct country from customer) c 
--     on s.country = c.country 
-- order by coalesce(s.country, c.country)

-- select distinct s.country as "SupplierCountry", c.country as "CustomerCountry"
-- from customer c 
-- full join supplier s 
-- 	on c.country = s.country 
-- order by "SupplierCountry", "CustomerCountry"

select s.country as "SupplierCountry", c.country as "CustomerCountry"
from (select distinct country from supplier) s
full join (select distinct country from customer) c 
		on s.country = c.country
order by coalesce(s.country, c.country)
-- NOTE: COALESCE in ORDER BY would ensure proper alphabetical sorting 
-- regardless of which column has NULL 

--q54
with all_countries as (
	select country from customer c 
	union
	select country from supplier s 
)
select
	ac.country,
	count(distinct s.supplier_id) as "TotalSuppliers",
    count(distinct c.customer_id) as "TotalCustomers"
from all_countries ac
left join supplier s on s.country = ac.country 
left join customer c on c.country = ac.country 
group by ac.country
order by ac.country 

--q55
-- ROW_NUMBER() window function:
-- Assigns sequential integers (1, 2, 3...) to rows within each partition.
-- PARTITION BY: Divides rows into groups (here: by ship_country)
-- ORDER BY: Determines the numbering order within each partition (here: by order_date)
-- Result: Each country's orders are numbered 1, 2, 3... by date
-- WHERE rank = 1: Gets the first (earliest) order per country
with summary as (
	select 
		o.ship_country, 
		o.customer_id, 
		o.order_id, 
		o.order_date,
		row_number() over(partition by o.ship_country order by o.order_date) as rank
	from "order" o 
	order by o.ship_country, o.order_date, o.order_id 
) 
select s.ship_country, s.customer_id, s.order_id, s.order_date 
from summary s
where "rank" = 1


--q56
-- GOAL: Find customers who made more than 1 order within 5 days
-- This helps sales team identify customers who could batch orders to save freight costs

-- =============================================================================
-- STEP 1: Start simple - look at orders for ONE customer
-- =============================================================================
-- Pick a customer (e.g., 'ANTO') and see their orders
-- Columns: customer_id, order_id, order_date
-- Filter: WHERE customer_id = 'ANTO'
-- Sort by: order_date

select o.customer_id, o.order_id, o.order_date 
from "order" o 
where o.customer_id = 'ANTO'
order by o.order_date 


-- =============================================================================
-- STEP 2: Self-join to COMPARE two orders from the same customer
-- =============================================================================
-- A SELF-JOIN joins a table to itself using two aliases (o1, o2)
-- Structure:
--     FROM "order" o1          -- first copy (the "initial" order)
--     JOIN "order" o2          -- second copy (the "next" order)  
--       ON o1.customer_id = o2.customer_id   -- match by same customer
--
-- Try for ANTO: SELECT columns from both o1 and o2
-- Notice: You'll see duplicates like (A,B) and (B,A), plus self-matches

select 
	o.customer_id, 
	o.order_id as "InitialOrderID", 
	to_char(o.order_date, 'YYYY-MM-DD') as "InitialOrderDate",
	o2.order_id as "NextOrderID",
	to_char(o2.order_date, 'YYYY-MM-DD') as "NextOrderDate"
from "order" o 
join "order" o2
	on o.customer_id = o2.customer_id 
where o.customer_id = 'ANTO'
order by o.order_date 


-- =============================================================================
-- STEP 3: Remove unwanted pairs
-- =============================================================================
-- Problem: duplicates (A,B) and (B,A) + self-matches (A,A)
-- Solution: Add WHERE o2.order_date > o1.order_date
--           This ensures second order comes AFTER first (removes both issues)
select 
	o.customer_id, 
	o.order_id as "InitialOrderID", 
	to_char(o.order_date, 'YYYY-MM-DD') as "InitialOrderDate",
	o2.order_id as "NextOrderID",
	to_char(o2.order_date, 'YYYY-MM-DD') as "NextOrderDate"
from "order" o 
join "order" o2
	on o.customer_id = o2.customer_id 
where 
	o.customer_id = 'ANTO' and
	o2.order_date > o.order_date 
order by o.order_date 


-- =============================================================================
-- STEP 4: Calculate days between and filter to 5 days
-- =============================================================================
-- PostgreSQL: (date2 - date1) returns integer days
-- Add to SELECT: (o2.order_date - o1.order_date) as days_between
-- Add to WHERE: (o2.order_date - o1.order_date) <= 5

select 
	o.customer_id, 
	o.order_id as "InitialOrderID", 
	to_char(o.order_date, 'YYYY-MM-DD') as "InitialOrderDate",
	o2.order_id as "NextOrderID",
	to_char(o2.order_date, 'YYYY-MM-DD') as "NextOrderDate",
	(o2.order_date::date - o.order_date::date) as "DaysBetween"
from "order" o 
join "order" o2
	on o.customer_id = o2.customer_id 
where 
--	o2.order_date > o.order_date and
--  issue: if compare by date => missing same date orders
--  fix: compare id because id is sequential
	o.order_id < o2.order_id and
	(o2.order_date::date - o.order_date::date) <= 5
order by o.customer_id, o.order_date


--q57
-- GOAL: Same as q56 (orders within 5 days) but using WINDOW FUNCTIONS instead of self-join
-- This approach uses LEAD() to look at the "next" order for each customer

-- =============================================================================
-- WHY 69 ROWS vs 71 ROWS? (Important!)
-- =============================================================================
-- Self-join (q56): Pairs EVERY order with EVERY other order within 5 days
-- Window LEAD:     Pairs each order with ONLY the IMMEDIATE NEXT order
--
-- Example: Customer ERNSH has orders on Jan 13, Jan 15, Jan 19 (all within 6 days)
--
--   Self-join finds:
--     (Jan 13 → Jan 15) = 2 days ✓
--     (Jan 13 → Jan 19) = 6 days ✗ (> 5 days)
--     (Jan 15 → Jan 19) = 4 days ✓
--     Total: 2 pairs
--
--   Window LEAD finds:
--     Jan 13 → next is Jan 15 = 2 days ✓
--     Jan 15 → next is Jan 19 = 4 days ✓
--     Total: 2 pairs (same in this case)
--
-- But if orders are: Jan 10, Jan 12, Jan 14 (all within 5 days of each other)
--   Self-join: (Jan 10→12), (Jan 10→14), (Jan 12→14) = 3 pairs
--   LEAD:      (Jan 10→12), (Jan 12→14) = 2 pairs (misses Jan 10→14)
--
-- LEAD only sees CONSECUTIVE orders, not all combinations!

-- =============================================================================
-- STEP 1: Understand LEAD() window function
-- =============================================================================
-- LEAD(column, n) looks ahead n rows and returns that value
-- LEAD(order_date, 1) = get the NEXT row's order_date
-- Must use with OVER(PARTITION BY ... ORDER BY ...)
--
-- Syntax:
--   LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date)
--   ↑ look ahead 1 row    ↑ within each customer, ordered by date


-- =============================================================================
-- STEP 2: Create a CTE that adds "NextOrderDate" column
-- =============================================================================
-- Use WITH to create a CTE named something like "order_with_next"
-- SELECT: customer_id, order_id, order_date, and LEAD() as next_order_date
-- PARTITION BY: customer_id (so LEAD looks within same customer)
-- ORDER BY: order_date (so "next" means chronologically next)

with order_with_next as (
	select 
		o.customer_id,
		to_char(o.order_date, 'YYYY-MM-DD') as "OrderDate",
		to_char(lead(o.order_date, 1) over (partition by o.customer_id order by o.order_date), 'YYYY-MM-DD') as "NextOrderDate"
	from "order" o 
)


-- =============================================================================
-- STEP 3: Query the CTE and calculate days between
-- =============================================================================
-- SELECT from your CTE
-- Calculate: (next_order_date - order_date) as days_between
-- Filter WHERE days_between <= 5
-- Note: LEAD returns NULL for the last order (no next order), so those rows
--       will be excluded automatically when you filter

with order_with_next as (
	select 
		o.customer_id,
		to_char(o.order_date, 'YYYY-MM-DD') as "OrderDate",
		to_char(lead(o.order_date, 1) over (partition by o.customer_id order by o.order_date), 'YYYY-MM-DD') as "NextOrderDate"
	from "order" o 
)
select
	own.customer_id,
	own."OrderDate" ,
	own."NextOrderDate",
	(own."NextOrderDate"::date - own."OrderDate"::date) as "DaysBetween"
from order_with_next own
where (own."NextOrderDate"::date - own."OrderDate"::date) <= 5

-- =============================================================================
-- STEP 4: Compare results with q56
-- =============================================================================
-- Run both q56 and q57, notice the row count difference
-- To investigate: query ERNSH's orders and trace through both approaches
