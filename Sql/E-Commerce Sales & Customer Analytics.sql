


-- data analysis

--1 What are the top 5 most selling products by quantity? --
-- Какие 5 товаров продаются лучше всего по количеству?

select  top 5 product_name,sum(quantity) as sum_quantity
from sales
where status = 'delivered'
group by product_name
order by sum_quantity desc;

 --2 Which products are most frequently cancelled? --
 --Какие товары отменяют чаще всего?

select top 5 product_name,
	   count(*) as count_of_cancelled
from sales
where status = 'cancelled'
group by product_name --or product_category  --We can use product_category if we need category of product
order by count_of_cancelled desc;

 --3 What times of the day has the highest number of purchases? --
 --В какое время суток совершается наибольшее количество покупок?

	select
		case 
			when datepart(hour,time_of_purchase) between 6 and 11 then 'Morning'
			when datepart(hour,time_of_purchase) between 12 and 17 then 'Afternoon'
			when datepart(hour,time_of_purchase) between 18 and 23 then 'Evening'
			else 'Night'
		end as time_of_day,
count(*) as total_order
from sales
group by 
		case 
			when datepart(hour,time_of_purchase) between 6 and 11 then 'Morning'
		    when datepart(hour,time_of_purchase) between 12 and 17 then 'Afternoon'
			when datepart(hour,time_of_purchase) between 18 and 23 then 'Evening'
			else 'Night'
		end 
 order by total_order desc;

 --4 Who are the top 5 highest spending customers? --
 --Кто входит в топ-5 клиентов с наибольшими тратами?

select top 5 customer_id,
			 customer_name,
			 sum(price * quantity) as total_spending
from sales
where status = 'delivered'
group by customer_name,customer_id
order by total_spending desc;

-- 5 Which product categories generate the highest revenue? --
-- Какие категории товаров приносят наибольшую выручку?

select product_category,
	   sum(price * quantity) as revenue
from sales
WHERE status = 'delivered'
group by product_category
order by revenue desc;


-- 6 What is the return/cancellation rate per product category? --
--Каков процент возвратов/отмен по каждой категории товаров?
SELECT
    product_category,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'returned' THEN 1 ELSE 0 END) AS returned_orders,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    
    -- Умножаем на 100.0 для получения точных процентов с дробной частью:
    CAST(SUM(CASE WHEN status = 'returned' THEN 100.0 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2)) AS returned_rate,
    CAST(SUM(CASE WHEN status = 'cancelled' THEN 100.0 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2)) AS cancellation_rate
FROM sales
GROUP BY product_category
ORDER BY product_category desc;


-- 7 What is the preferred payment mode? --
-- Какой способ оплаты является наиболее предпочитаемым?

select payment_mode,
       count(*) as total_count
from sales
group by payment_mode
order by total_count desc

-- 8 How does age group affect purchasing behaviour? --
--Как возрастная группа влияет на покупательское поведение?

select round(sum(quantity * price),1) as total,age_group
from(
select
case  
    when customer_age between 18 and 25 then '18-25'
    when customer_age between 26 and 35 then '26-35'
    when customer_age between 36 and 50 then '36-50'
    else '51+'
end as age_group,
quantity,price
from sales) as t 
group by age_group
order by total desc;


-- 9 What is the monthly sales trend? --
-- Какова динамика продаж по месяцам?


select month(purchase_date) as sales_month,
	   year(purchase_date) as sales_year,
	   sum(price * quantity) as sum_of_sales
from sales
group by month(purchase_date),
	     year(purchase_date) 
order by sales_year asc,
		 sales_month asc