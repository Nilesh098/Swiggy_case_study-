use swiggy_case_study;

-- checking the food table
select * from food ;

-- delivery_partner
select * from  delivery_partner;

-- menu
select * from menu ;

-- order_details
select * from order_details;

-- restaurants
select * from restaurants;

-- users
select * from users;

--  1. Find customers who have never ordered

select  name 
from users 
where user_id not in ( select user_id from orders );


-- 2. Average Price/dish

select f.f_id , f.f_name , round( avg(price), 2) as Average_price
from menu u 
join food f 
on u.f_id =f.f_id
group by f_id;


/* 3.1. Find the top restaurant in terms of the 
    number of orders for a given month  */

select r.r_name ,monthname(o.date) as month_name,
count(*) as total_count
from restaurants r
join orders o 
on r.r_id = o.r_id 
where monthname(date) like "July" 
group by r.r_id
order by total_count desc
limit 1;


/* 3.2. Find the top restaurant in terms of the 
    number of orders for all month  */

select monthname(o.date) as month_name, r.r_name ,count(*) as total_orders
from restaurants r
join orders o
on r.r_id =o.r_id
group by 1,2
order by 3 desc
limit 3;

-- 4. restaurants with monthly sales greater than x for 
 -- let say our x value is 500

select r.r_name,sum(o.amount) as revenue 
from orders as o
join restaurants r
on o.r_id=r.r_id
where monthname(date) like "June"
group by o.r_id
having revenue >500 ; 
 
/* 5. Show all orders with order details for a 
	particular customer in a particular date range*/
 
 select o.order_id ,r.r_name ,f.f_name
 from orders o
 join restaurants r 
 on o.r_id =r.r_id
 join order_details od
 on o.order_id=od.order_id
 join food f
 on f.f_id =od.f_id
 where user_id =(select user_id from users where name like "Ankit")
 and date between '2022-06-10' and '2022-07-10';
 
 -- 6. Find restaurants with max repeated customers 
 
 
select r.r_name, count(*) as Loyal_customer
from(
		 select  r_id ,user_id ,count(*) as Visit 
		 from orders
		 group by r_id ,user_id
		 having Visit >1) t
join restaurants r 
on r.r_id =t.r_id
group by t.r_id 
order by Loyal_customer desc 
limit 1;

-- 7. Month over month revenue growth of swiggy

select month_name ,((revenue-prev)/prev) /100 as revenue_growth
from (
with sales as(
			select  monthname(date) as month_name ,sum(amount) as revenue
			from orders 
			group by 1
			order by month(date)
            )

select month_name ,revenue , lag(revenue,1)  
over (order by revenue ) as prev
from sales) t; 