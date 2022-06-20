-- INTERMEDIATE PROBLEMS

-- 20. Categories, and the total products in each category
/*
   For this problem, we’d like to see the total number of products in each
   category. Sort the results by the total number of products, in descending
   order.
*/      

select 
      c.Category_Name , 
      count(p.product_id) as Total_Products
from categories as c
    left join Products p 
        on  c.category_id = p.category_id
group by c.category_name
order by Total_Products desc;

-- 21. Total customers per country/city
-- In the Customers table, show the total number of customers per Country and City.

select 
      City ,
      Country ,
      count(customer_id) as TotalCustomers
from customers
group by city,country;

-- 22. Products that need reordering
/* 
   What products do we have in our inventory that should be reordered?
   For now, just use the fields UnitsInStock and ReorderLevel, where
   UnitsInStock is less than the ReorderLevel, ignoring the fields
   UnitsOnOrder and Discontinued.
   Order the results by ProductID.
*/

select 
      Product_ID,
      Product_Name,
      Units_In_Stock,
      Reorder_Level
from products
where units_in_stock < reorder_level;
       
-- 23. Products that need reordering, continued
/*
   Now we need to incorporate these fields—UnitsInStock, UnitsOnOrder,
   ReorderLevel, Discontinued—into our calculation. We’ll define
   “products that need reordering” with the following:
   UnitsInStock plus UnitsOnOrder are less than or equal to
   ReorderLevel
   The Discontinued flag is false (0).
*/

select 
      Product_ID,
      Product_Name,
      Units_In_Stock,
      Reorder_Level
from products
where (units_in_stock + units_on_order) <= reorder_level and discontinued = 0;

-- 24. Customer list by region
/*
   A salesperson for Northwind is going on a business trip to visit
   customers, and would like to see a list of all customers, sorted by
   region, alphabetically.
   However, he wants the customers with no region (null in the Region
   field) to be at the end, instead of at the top, where you’d normally find
   the null values. Within the same region, companies should be sorted by
   CustomerID.
*/

select 
     Customer_ID , Company_Name ,Region     
from customers
order by 
    case
         when Region is NULL then 1 else 0 
	end 
     ,region ,customer_id;

-- 25. High freight charges
/*
   Some of the countries we ship to have very high freight charges. We'd
   like to investigate some more shipping options for our customers, to be
   able to offer them lower freight charges. Return the three ship countries
   with the highest average freight overall, in descending order by average
   freight.
*/

select 
      Ship_Country,
      avg(freight) as Average_Freight
from orders
group by ship_country
order by Average_freight desc limit 3;

-- 26. High freight charges - 2015
/*
   We're continuing on the question above on high freight charges. Now,
   instead of using all the orders we have, we only want to see orders from
   the year 2015.
*/

select 
      Ship_Country, 
      avg(freight) as Average_Freight
from orders
where order_date >= '2015-01-01' and order_date<='2015-01-01'
group by Ship_country 
order by Average_Freight desc;

-- 27. High freight charges with between
/*
   Another (incorrect) answer to the problem above is this:
   Select Top 3
   ShipCountry,AverageFreight = avg(freight)
   From Orders
   Where OrderDate between '1/1/2015' and '12/31/2015'
   Group By ShipCountry
   Order By AverageFreight desc;
   Notice when you run this, it gives Sweden as the ShipCountry with the
   third highest freight charges. However, this is wrong - it should be
   France.
   What is the OrderID of the order that the (incorrect) answer above is missing?
*/

select 
       Order_ID,
	   avg(freight) as Average_Freight
from orders
where order_date between '2015-01-01' and '2015-12-31'
group by order_id
order by average_freight desc;

-- 28. High freight charges - last year
/*
   We're continuing to work on high freight charges. We now want to get
   the three ship countries with the highest average freight charges. But
   instead of filtering for a particular year, we want to use the last 12
   months of order data, using as the end date the last OrderDate in Orders.
*/

select 
      Ship_Country,
      avg(Freight) as Average_Freight
from orders
where order_date <= last_day(max(Order_Date) - interval 12 month) 
group by ship_country
order by Average_Freight desc;

-- 29. Inventory list
/*
   We're doing inventory, and need to show information like the below, for
   all orders. Sort by OrderID and Product ID.*/
/*
   select 
      Employee_Id ,
      Last_Name,
      Order_ID,
      Product_Name
      count(Product_ID) as Quantity
from */

select    
      e.Employee_Id ,
      e.Last_Name,
      o.Order_ID,
      p.Product_Name,
	  Quantity
from employees as e                  
	left join orders as o                    
        on e.employee_id = o.employee_id      
	left join order_details as od
        on o.order_id = od.order_id
	left join products as p
        on od.product_id = p.product_id
order by o.order_Id , p.product_id;
 
-- 30. Customers with no orders
-- There are some customers who have never actually placed an order. Show these customers.

Select
	 customers.Customer_ID as Customer_ID_With_No_Orders
from customers 
    left join orders 
        on customers.customer_ID = orders.Customer_ID
where orders.customer_ID is NULL;

-- 31. Customers with no orders for EmployeeID 4
/*
   One employee (Margaret Peacock, EmployeeID 4) has placed the most
   orders. However, there are some customers who've never placed an order
   with her. Show only those customers who have never placed an order
   with her.
*/

select 
      customers.customer_id as Customer_ID
from customers
    left join orders 
         on customers.customer_id = orders.customer_id 
            and orders.employee_id = 4
where orders.customer_id is null  ;

