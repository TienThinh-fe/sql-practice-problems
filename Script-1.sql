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
