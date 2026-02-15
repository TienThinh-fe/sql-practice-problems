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