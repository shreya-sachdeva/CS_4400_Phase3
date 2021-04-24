/*
CS4400: Introduction to Database Systems
Spring 2021
Phase III Template
Team 103
Shreya Sachdeva (ssachdeva31)
Ayush Jain (ajain434)
Parshva Shah (pshah380)


Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/

-- ID: 2a
-- Author: asmith457
-- Name: register_customer
DROP PROCEDURE IF EXISTS register_customer;
DELIMITER //
CREATE PROCEDURE register_customer(
	   IN i_username VARCHAR(40),
       IN i_password VARCHAR(40),
	   IN i_fname VARCHAR(40),
       IN i_lname VARCHAR(40),
       IN i_street VARCHAR(40),
       IN i_city VARCHAR(40),
       IN i_state VARCHAR(2),
	   IN i_zipcode CHAR(5),
       IN i_ccnumber VARCHAR(40),
	   IN i_cvv CHAR(3),
       IN i_exp_date DATE
)
BEGIN

-- Type solution below
if length(i_zipcode) = 5 and length(i_password) >= 8 then
insert into USERS (Username, Pass, FirstName, Lastname, Street, City, State, Zipcode) 
values (i_username, MD5(i_password), i_fname, i_lname, i_street, i_city, i_state, i_zipcode);
end if;
if i_username in (select username from Users) AND i_username not in (select username from employee) then
insert into CUSTOMER (username, ccnumber, cvv, exp_date) values (i_username, i_ccnumber, i_cvv, i_exp_date);
end if;
-- End of solution

END //
DELIMITER ;


-- ID: 2b
-- Author: asmith457
-- Name: register_employee
DROP PROCEDURE IF EXISTS register_employee;
DELIMITER //
CREATE PROCEDURE register_employee(
	   IN i_username VARCHAR(40),
       IN i_password VARCHAR(40),
	   IN i_fname VARCHAR(40),
       IN i_lname VARCHAR(40),
       IN i_street VARCHAR(40),
       IN i_city VARCHAR(40),
       IN i_state VARCHAR(2),
       IN i_zipcode CHAR(5)
)
BEGIN

-- Type solution below
if length(i_zipcode) = 5 and length(i_password) >= 8 and i_username not in (select username from Users) and length(i_state) = 2 
and i_fname is not null and i_lname is not null and i_street is not null and i_city is not null then
insert into USERS (username, pass, firstname, lastname, street, city, state, zipcode) 
values (i_username, MD5(i_password), i_fname, i_lname, i_street, i_city, i_state, i_zipcode);
end if;
insert into employee (Username) value (i_username);
-- End of solution
END //
DELIMITER ;

-- ID: 4a
-- Author: asmith457
-- Name: admin_create_grocery_chain
DROP PROCEDURE IF EXISTS admin_create_grocery_chain;
DELIMITER //
CREATE PROCEDURE admin_create_grocery_chain(
        IN i_grocery_chain_name VARCHAR(40)
)
BEGIN
	
-- Type solution below
	insert ignore into chain (ChainName) value (i_grocery_chain_name);
-- End of solution
END //
DELIMITER ;

-- ID: 5a
-- Author: ahatcher8
-- Name: admin_create_new_store
DROP PROCEDURE IF EXISTS admin_create_new_store;
DELIMITER //
CREATE PROCEDURE admin_create_new_store(
    	IN i_store_name VARCHAR(40),
        IN i_chain_name VARCHAR(40),
    	IN i_street VARCHAR(40),
    	IN i_city VARCHAR(40),
    	IN i_state VARCHAR(2),
    	IN i_zipcode CHAR(5)
)
BEGIN
-- Type solution below
	INSERT INTO STORE (ChainName, StoreName, Street, City, State, Zipcode)
    VALUES ( i_chain_name, i_store_name, i_street, i_city, i_state , i_zipcode );
-- End of solution
END //
DELIMITER ;


-- ID: 6a
-- Author: ahatcher8
-- Name: admin_create_drone
DROP PROCEDURE IF EXISTS admin_create_drone;
DELIMITER //
CREATE PROCEDURE admin_create_drone(
	   IN i_drone_id INT,
       IN i_zip CHAR(5),
       IN i_radius INT,
       IN i_drone_tech VARCHAR(40)
)
BEGIN
-- Type solution below

	SET @zip = (Select Zipcode FROM STORE WHERE i_zip = Zipcode);
    if i_drone_tech in (select username from drone_tech) and i_zip in (select zipcode from users where i_drone_tech = username) then 
	insert into DRONE (ID,DroneStatus,Zip,Radius,DroneTech) values (i_drone_id,"Available",@zip,i_radius,i_drone_tech);
    end if;
-- End of solution
END //
DELIMITER ;


-- ID: 7a
-- Author: ahatcher8
-- Name: admin_create_item
DROP PROCEDURE IF EXISTS admin_create_item;
DELIMITER //
CREATE PROCEDURE admin_create_item(
        IN i_item_name VARCHAR(40),
        IN i_item_type VARCHAR(40),
        IN i_organic VARCHAR(3),
        IN i_origin VARCHAR(40)
)
BEGIN
-- Type solution below
	if i_organic = "Yes" or i_organic = "No" then
	insert into item (ItemName, ItemType, Origin, Organic) values (i_item_name,i_item_type,i_origin,i_organic); 
    end if;
	#INSERT INTO item (ItemName, ItemType, Organic, Origin) values (i_item_name,i_item_type,i_organic,i_origin)  where i_item_type in("Dairy","Bakery","Meat","Produce","Personal Care","Paper Goods","Beverages","Other");
-- End of solution
END //
DELIMITER ;


-- ID: 8a
-- Author: dvaidyanathan6
-- Name: admin_view_customers
DROP PROCEDURE IF EXISTS admin_view_customers;
DELIMITER //
CREATE PROCEDURE admin_view_customers(
	   IN i_first_name VARCHAR(40),
       IN i_last_name VARCHAR(40)
)
BEGIN
-- Type solution below 
	drop table if exists admin_view_customers_result;
    
    if (i_first_name is not null and i_last_name is not null) then 
	create table admin_view_customers_result(Username varchar(40), FullName varchar(80), Address varchar(200));
    insert into admin_view_customers_result
	select Username, concat(firstname," ", lastname) as FullName , concat(street, ", ",city, ", ", state, " ",zipcode) as Address from Users
    where i_first_name = firstname and i_last_name = lastname;
    
    elseif (i_first_name is null and i_last_name is not null) then
    create table admin_view_customers_result(Username varchar(40), FullName varchar(80), Address varchar(200));
    insert into admin_view_customers_result
	select Username, concat(firstname," ", lastname) as FullName , concat(street, ", ",city, ", ", state, " ",zipcode) as Address from Users
    where i_last_name = lastname;
    
	elseif (i_first_name is not null and i_last_name is null) then
    create table admin_view_customers_result(Username varchar(40), FullName varchar(80), Address varchar(200));
    insert into admin_view_customers_result
	select Username, concat(firstname," ", lastname) as FullName , concat(street, ", ",city, ", ", state, " ",zipcode) as Address from Users
    where i_first_name = firstname;
    
	else 
    create table admin_view_customers_result(Username varchar(40), FullName varchar(80), Address varchar(200));
    insert into admin_view_customers_result
	select Username, concat(firstname," ", lastname) as FullName , concat(street, ", ",city, ", ", state, " ",zipcode) as Address from Users
    where username in (select username from customer);
    end if;

-- End of solution
END //
DELIMITER ;


-- ID: 9a
-- Author: dvaidyanathan6
-- Name: manager_create_chain_item
DROP PROCEDURE IF EXISTS manager_create_chain_item;
DELIMITER //
CREATE PROCEDURE manager_create_chain_item(
        IN i_chain_name VARCHAR(40),
    	IN i_item_name VARCHAR(40),
    	IN i_quantity INT, 
    	IN i_order_limit INT,
    	IN i_PLU_number INT,
    	IN i_price DECIMAL(4, 2)
)
BEGIN
-- Type solution below
IF i_chain_name IN (SELECT ChainName FROM CHAIN) AND i_item_name IN (SELECT ItemName FROM ITEM) THEN
IF i_quantity > 0 AND i_order_limit > 0 AND i_price > 0 AND i_PLU_number > 0 THEN
IF (SELECT COUNT(*) FROM CHAIN_ITEM WHERE (PLUNumber = i_PLU_number AND  ChainName = i_chain_name) OR (ChainName = i_chain_name AND ChainItemName = i_item_name)) = 0 THEN 
    INSERT INTO CHAIN_ITEM (ChainItemName, ChainName, PLUNumber, Orderlimit, Quantity, Price) 
	VALUES (i_item_name, i_chain_name, i_PLU_number, i_order_limit, i_quantity, i_price);

END IF;
END IF;
END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 10a
-- Author: dvaidyanathan6
-- Name: manager_view_drone_technicians
DROP PROCEDURE IF EXISTS manager_view_drone_technicians;
DELIMITER //
CREATE PROCEDURE manager_view_drone_technicians(
	   IN i_chain_name VARCHAR(40),
       IN i_drone_tech VARCHAR(40),
       IN i_store_name VARCHAR(40)
)
BEGIN
-- Type solution below
	drop table if exists manager_view_drone_technicians_result;
	create table manager_view_drone_technicians_result(Username varchar(40), FullName varchar(80), Location varchar(80));
      
	if (i_drone_tech is not null and i_store_name is not null) then 
    insert into manager_view_drone_technicians_result
	select users.Username, concat(firstname," ", lastname) as FullName , storename as Location 
	from Users join Drone_tech on users.username = Drone_tech.username where i_drone_tech = users.username and i_chain_name=chainname and i_store_name = storename;
    
	elseif (i_drone_tech is null and i_store_name is not null) then 
    insert into manager_view_drone_technicians_result
	select users.Username, concat(firstname," ", lastname) as FullName , storename as Location 
	from Users join Drone_tech on users.username = Drone_tech.username where i_chain_name=chainname and i_store_name = storename;
    
	elseif (i_drone_tech is not null and i_store_name is null) then 
    insert into manager_view_drone_technicians_result
	select users.Username, concat(firstname," ", lastname) as FullName , storename as Location 
	from Users join Drone_tech on users.username = Drone_tech.username where i_drone_tech = users.username and i_chain_name=chainname;
    
	else 
    insert into manager_view_drone_technicians_result
	select users.Username, concat(firstname," ", lastname) as FullName , storename as Location 
	from Users join Drone_tech on users.username = Drone_tech.username where i_chain_name = chainname;
    end if;

-- End of solution
END //
DELIMITER ;




-- ID: 11a
-- Author: vtata6
-- Name: manager_view_drones
DROP PROCEDURE IF EXISTS manager_view_drones;
DELIMITER //
CREATE PROCEDURE manager_view_drones(
	   IN i_mgr_username varchar(40), 
	   IN i_drone_id int, drone_radius int
)
BEGIN
-- Type solution below	   
DROP TABLE IF EXISTS manager_view_drones_result;
    CREATE TABLE manager_view_drones_result(     
	ID INT NOT NULL, 
    Operator VARCHAR(40) NOT NULL,
	Radius INT NOT NULL,
    Zip char(5) NOT NULL,
    DroneStatus VARCHAR(20) NOT NULL);

IF drone_radius IS NULL THEN 
SET @rad = 0;
ELSE 
SET @rad = drone_radius;
END IF;

IF i_mgr_username in (SELECT Username FROM Manager) THEN
SET @chain = (SELECT ChainName FROM Manager WHERE Username = i_mgr_username);

IF i_drone_id IS NULL THEN
INSERT INTO manager_view_drones_result SELECT ID, DroneTech AS Operator, Radius, Zip, Dronestatus FROM (Drone as d JOIN DRONE_TECH as t ON d.DroneTech = t.Username) WHERE Radius >= @rad AND t.ChainName = @chain;  
ELSE
INSERT INTO manager_view_drones_result SELECT ID, DroneTech AS Operator, Radius, Zip, Dronestatus FROM (Drone as d JOIN DRONE_TECH as t ON d.DroneTech = t.Username) WHERE Radius >= @rad AND t.ChainName = @chain AND ID = i_drone_id;  
END IF; 

END IF;

-- End of solution
END //
DELIMITER ;

-- ID: 12a
-- Author: vtata6
-- Name: manager_manage_stores
DROP PROCEDURE IF EXISTS manager_manage_stores;
DELIMITER //
CREATE PROCEDURE manager_manage_stores(
	   IN i_mgr_username varchar(50), 
	   IN i_storeName varchar(50), 
	   IN i_minTotal int, 
	   IN i_maxTotal int
)
BEGIN
-- Type solution below
IF i_mgr_username in (SELECT Username FROM Manager) THEN
	SET @chain = (SELECT ChainName FROM Manager WHERE Username = i_mgr_username);
    
    drop table if exists manager_manage_stores_result1;
    create table manager_manage_stores_result1(
    Storename varchar(40), 
    Address varchar(200), 
    orders varchar(500), 
    total varchar(500)
    );
    
    IF i_storeName IS NULL THEN
    
    insert into manager_manage_stores_result1


	SELECT s.StoreName as Storename, concat(s.street, " ",s.city, ", ", s.state, " ",s.zipcode) as Address, COUNT(DISTINCT o.ID) as Orders, sum(c.quantity * ci.price) as Total FROM STORE as s 
    left JOIN drone_tech as t ON s.Storename = t.StoreName AND t.ChainName = @chain -- join drone techs to use for employees
    left JOIN drone as d ON d.DroneTech = t.Username --  join drones to get drone IDs for orders, connect w username of drone tech
    left JOIN orders as o ON o.DroneID = d.ID
    left JOIN contains as c ON o.ID = c.OrderID
    left JOIN chain_item as ci on c.itemname = ci.chainitemname and c.chainname = ci.chainname
	where ci.chainname = @chain 
    GROUP BY t.Storename, Address, t.chainname;

	elseif i_storename in (SELECT storename from store where chainname = @chain) then 
    insert into manager_manage_stores_result1
	SELECT s.StoreName as Storename, concat(s.street, " ",s.city, ", ", s.state, " ",s.zipcode) as Address, COUNT(DISTINCT o.ID) as Orders, sum(c.quantity * ci.price) as Total FROM STORE as s 
    left JOIN drone_tech as t ON s.Storename = t.StoreName AND t.ChainName = @chain -- join drone techs to use for employees
    left JOIN drone as d ON d.DroneTech = t.Username --  join drones to get drone IDs for orders, connect w username of drone tech
    left JOIN orders as o ON o.DroneID = d.ID
    left JOIN contains as c ON o.ID = c.OrderID
    left JOIN chain_item as ci on c.itemname = ci.chainitemname and c.chainname = ci.chainname
	where ci.chainname = @chain and t.storename = i_storename 
    GROUP BY t.Storename, Address, t.chainname ;

end if;
    
	drop table if exists manager_manage_stores_result;
    create table manager_manage_stores_result(
    StoreName varchar(40), 
    Address varchar(200), 
    Orders varchar(500), 
    Employees varchar(500),
    Total varchar(500)
    );
    
    insert into manager_manage_stores_result 
    select m.storename as Storename , address  as Address, orders as Orders, e.employees AS Employees, Total as Total from manager_manage_stores_result1 as m
    JOIN (SELECT Count(distinct username)+1 as Employees, storename FROM drone_tech where chainname = @chain and storename in (SELECT s.StoreName as Storename FROM STORE as s 
    JOIN drone_tech as t ON s.Storename = t.StoreName AND t.ChainName = @chain 
    JOIN drone as d ON d.DroneTech = t.Username 
    JOIN orders as o ON o.DroneID = d.ID)
 group by storename) as e ON m.storename = e.storename
    where (m.total > i_minTotal or i_minTotal is null) and (m.total < i_maxTotal or i_maxTotal is null);
  
END IF;
    
-- End of solution
END //
DELIMITER ;



-- ID: 13a
-- Author: vtata6
-- Name: customer_change_credit_card_information
DROP PROCEDURE IF EXISTS customer_change_credit_card_information;
DELIMITER //
CREATE PROCEDURE customer_change_credit_card_information(
	   IN i_custUsername varchar(40), 
	   IN i_new_cc_number varchar(19), 
	   IN i_new_CVV int, 
	   IN i_new_exp_date date
)
BEGIN
-- Type solution below
IF i_custUsername IN (SELECT Username FROM Customer) AND i_new_exp_date > CURDATE() AND LENGTH(i_new_cc_number) = 19 THEN
	UPDATE Customer
    SET CcNumber = i_new_cc_number, 
	CVV = i_new_CVV , 
	EXP_DATE = i_new_exp_date
    
    WHERE Username = i_custUsername;
END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 14a
-- Author: ftsang3
-- Name: customer_view_order_history
DROP PROCEDURE IF EXISTS customer_view_order_history;
DELIMITER //
CREATE PROCEDURE customer_view_order_history(
	   IN i_username VARCHAR(40),
       IN i_orderid INT
)
BEGIN
-- Type solution below

	drop table if exists customer_view_order_history_result;
    create table customer_view_order_history_result(
    total_amount varchar(50),
    total_items int, 
    orderdate date, 
    droneID int, 
    dronetech varchar(40), 
    orderstatus varchar(40));
    
    if i_username in (select customerusername from orders where id = i_orderid) then
    INSERT INTO customer_view_order_history_result
    select sum(c.quantity * ci.price), sum(c.quantity), o.OrderDate, o.DroneID, d.DroneTech, o.orderstatus 
    from contains as c join chain_item as ci on c.itemname = ci.chainitemname and c.chainname = ci.chainname
    join orders as o on o.id = c.orderid
    join drone as d on d.id = o.droneid
    where i_username = o.customerusername and i_orderid = o.id;
    
--     else
--     INSERT INTO customer_view_order_history_result
--     values(null,null,null,null,null,null);
    end if;


-- End of solution
END //
DELIMITER ;

-- ID: 15a
-- Author: ftsang3
-- Name: customer_view_store_items
DROP PROCEDURE IF EXISTS customer_view_store_items;
DELIMITER //
CREATE PROCEDURE customer_view_store_items(
	   IN i_username VARCHAR(40),
       IN i_chain_name VARCHAR(40),
       IN i_store_name VARCHAR(40),
       IN i_item_type VARCHAR(40)
)
BEGIN
-- Type solution below
drop table if exists customer_view_store_items_result;
create table customer_view_store_items_result(
	chainitemname varchar(40),
    orderlimit int);

if i_item_type in ("ALL", "All", "all", null) then 
insert into customer_view_store_items_result 
(select chain_item.chainitemname, chain_item.orderlimit from 
chain_item inner join item on chain_item.chainitemname = item.itemname 
inner join store on chain_item.chainname = store.chainname
where store.zipcode = (select zipcode from users where i_username = username) and i_chain_name = store.chainname and i_store_name = store.storename);

else 
insert into customer_view_store_items_result 
(select chain_item.chainitemname, chain_item.orderlimit from chain_item inner join item on chain_item.chainitemname = item.itemname inner join store on chain_item.chainname = store.chainname 
where store.zipcode = (select zipcode from users where i_username = username) and i_chain_name = store.chainname and i_store_name = store.storename and i_item_type = item.itemtype);
end if;
-- End of solution
END //
DELIMITER ;

-- ID: 15b
-- Author: ftsang3
-- Name: customer_select_items
DROP PROCEDURE IF EXISTS customer_select_items;
DELIMITER //
CREATE PROCEDURE customer_select_items(
	    IN i_username VARCHAR(40),
    	IN i_chain_name VARCHAR(40),
    	IN i_store_name VARCHAR(40),
    	IN i_item_name VARCHAR(40),
    	IN i_quantity INT
)
BEGIN
-- Type solution below
IF i_username in (select username from customer) and i_item_name in (select chainitemname FROM chain_item WHERE chainname = i_chain_name) then
SET @zip = (select zipcode from users where username = i_username) ;

if i_store_name in (select storename from store where chainname = i_chain_name and zipcode = @zip) then
if i_quantity < (SELECT quantity FROM chain_item WHERE chainname = i_chain_name and chainitemname = i_item_name) then

-- if an order is underway aka if there is an w status creating with username as given
if (SELECT ID FROM orders where customerusername = i_username and orderstatus LIKE 'Creating') IS NULL THEN -- order doesnt exist yet, create order
SET @new_ID = (SELECT max(ID)+1 from orders);
INSERT into orders value (@new_ID, 'Creating', CURDATE(), i_username, NULL); 

end if;
SET @ID = (SELECT ID from orders where orderstatus LIKE 'Creating' and customerusername = i_username);
SET @plu = (SELECT plunumber FROM chain_item WHERE chainname = i_chain_name AND chainitemname = i_item_name);

INSERT INTO CONTAINS VALUE (@ID, i_item_name, i_chain_name, @plu, i_quantity);

end if;
end if;
end if;
-- End of solution
END //
DELIMITER ;
         
-- ID: 16a
-- Author: jkomskis3
-- Name: customer_review_order
DROP PROCEDURE IF EXISTS customer_review_order;
DELIMITER //
CREATE PROCEDURE customer_review_order(
	   IN i_username VARCHAR(40)
)
BEGIN
-- Type solution below

drop table if exists customer_review_order_result;
create table customer_review_order_result(
	ItemName varchar(40),
    Quantity int,
    Price varchar(50));

insert into customer_review_order_result
(select c.ItemName, c.Quantity, ci.price from contains as c
 join orders as o on c.orderid = o.id 
 join chain_item as ci on ci.chainitemname = c.itemname and ci.chainname = c.chainname 
where i_username = o.customerusername and c.orderid = o.id and o.orderstatus = "creating");

-- End of solution
END //
DELIMITER ;


-- ID: 16b
-- Author: jkomskis3
-- Name: customer_update_order
DROP PROCEDURE IF EXISTS customer_update_order;
DELIMITER //
CREATE PROCEDURE customer_update_order(
	   IN i_username VARCHAR(40),
       IN i_item_name VARCHAR(40),
       IN i_quantity INT
)
BEGIN
-- Type solution below

if i_quantity > 0 then 
update contains
set quantity = i_quantity 
where itemname = i_item_name and orderid = (select id from orders where customerusername = i_username and orderstatus = "creating" and droneid is null);

else
delete from contains
where itemname = i_item_name and orderid = (select id from orders where customerusername = i_username and orderstatus = "creating" and droneid is null);
end if;

-- End of solution
END //
DELIMITER ;


-- ID: 17a
-- Author: jkomskis3
-- Name: customer_update_order
DROP PROCEDURE IF EXISTS drone_technician_view_order_history;
DELIMITER //
CREATE PROCEDURE drone_technician_view_order_history(
        IN i_username VARCHAR(40),
    	IN i_start_date DATE,
    	IN i_end_date DATE
)
BEGIN
-- Type solution below

	drop table if exists drone_technician_view_order_history_result;
    create table drone_technician_view_order_history_result(
		order_id varchar(40),
        operator varchar(40),
        i_date DATE,
        drone_id varchar(40),
        status varchar(40),
        total varchar(40));
        
	insert into drone_technician_view_order_history_result
    select o.id as ID, concat(u.firstname, " ", u.lastname) as Operator, o.orderdate as Date, o.droneid as 'Drone ID', o.orderstatus as Status, sum(c.quantity * ci.price) as Total from orders as o
    left outer join drone as d on o.droneid = d.id 
    left outer join contains as c on o.id = c.orderid
    left outer join chain_item as ci on c.itemname = ci.chainitemname and c.chainname = ci.chainname
    left outer join customer as cu on cu.username = o.customerusername
    left outer join users as u on d.dronetech = u.username
    left outer join drone_tech as dt on d.dronetech = dt.username
    left outer join store as s on dt.storename = s.storename and dt.chainname = s.chainname
    where (o.orderdate between i_start_date and i_end_date) and (i_username in (select username from drone_tech)) 
    and o.customerusername in (select o.customerusername from contains as c join orders as o on c.orderid = o.id where chainname in (select chainname from drone_tech where username = i_username) and customerusername in (select username from users where zipcode = (select zipcode from users where username = i_username)) group by o.id)
    group by o.id;
    
-- End of solution
END //
DELIMITER ;

-- ID: 17b
-- Author: agoyal89
-- Name: dronetech_assign_order
DROP PROCEDURE IF EXISTS dronetech_assign_order;
DELIMITER //
CREATE PROCEDURE dronetech_assign_order(
	   IN i_username VARCHAR(40),
       IN i_droneid INT,
       IN i_status VARCHAR(20),
       IN i_orderid INT
)
BEGIN
-- Type solution below
if i_status is null then
SET @stat = 'Drone Assigned';
else
SET @stat = i_status;
end if;

if i_username in (SELECT username from drone_tech) AND i_orderid in (SELECT id from orders) then
if ((SELECT droneid from orders where id = i_orderid) = i_droneid OR (SELECT droneid from orders where id = i_orderid) IS NULL) THEN
UPDATE DRONE SET dronestatus = 'Busy' WHERE dronetech = i_username AND ID = i_droneid;
UPDATE ORDERS SET droneid = i_droneid, orderstatus = @stat where id = i_orderid;

end if;
end if;
-- End of solution
END //
DELIMITER ;

-- ID: 18a
-- Author: agoyal89
-- Name: dronetech_order_details
DROP PROCEDURE IF EXISTS dronetech_order_details;
DELIMITER //
CREATE PROCEDURE dronetech_order_details(
	   IN i_username VARCHAR(40),
       IN i_orderid VARCHAR(40)
)
BEGIN
-- Type solution below

drop table if exists dronetech_order_details_result;
create table dronetech_order_details_result(
	Customer_Name varchar(50),
    Order_ID varchar(50), 
    Total_Amount varchar(50), 
    Total_Items varchar(50), 
    Date_of_purchase date, 
    Drone_ID varchar(50), 
    Store_Associate varchar(50), 
    Order_Status varchar(50), 
    Address varchar (200));
    
insert into dronetech_order_details_result
select concat(customer_info.FirstName, " ", customer_info.LastName), o.ID, sum(ci.price * c.Quantity), sum(c.Quantity), OrderDate, d.ID, 
concat(associate.FirstName, ' ', associate.LastName), OrderStatus, concat(customer_info.Street, ", ", customer_info.City, ", ", customer_info.State, " ", customer_info.Zipcode)
from orders as o 
join contains as c on o.ID = c.OrderID
join chain_item as ci on c.ItemName = ci.ChainItemName and c.ChainName = ci.ChainName
join drone as d on o.DroneID = d.ID
join users as customer_info on customer_info.Username = o.CustomerUsername
join users as associate on associate.Username = d.DroneTech
where i_username = d.DroneTech and i_orderid = o.ID 
group by customer_info.username, o.id;
    
-- End of solution
END //
DELIMITER ;


-- ID: 18b
-- Author: agoyal89
-- Name: dronetech_order_items
DROP PROCEDURE IF EXISTS dronetech_order_items;
DELIMITER //
CREATE PROCEDURE dronetech_order_items(
        IN i_username VARCHAR(40),
    	IN i_orderid INT
)
BEGIN
-- Type solution below

drop table if exists dronetech_order_items_result;
create table dronetech_order_items_result(
	Item varchar(50), 
    Count int);
    
insert into dronetech_order_items_result
(select contains.ItemName, contains.quantity from contains 
join orders on contains.OrderID = orders.ID 
where i_orderid = contains.orderID);

-- End of solution
END //
DELIMITER ;

-- ID: 19a
-- Author: agoyal89
-- Name: dronetech_assigned_drones
DROP PROCEDURE IF EXISTS dronetech_assigned_drones;
DELIMITER //
CREATE PROCEDURE dronetech_assigned_drones(
        IN i_username VARCHAR(40),
    	IN i_droneid INT,
    	IN i_status VARCHAR(20)
)
BEGIN
-- Type solution below
drop table if exists dronetech_assigned_drones_result;
create table dronetech_assigned_drones_result(
	Drone_ID int,
    Drone_Status varchar(50),
    Radius int);
    
if i_status in ("ALL", "All", "all", null) then
insert into dronetech_assigned_drones_result
(select Drone.ID, Drone.DroneStatus, Drone.Radius from Drone 
join Drone_Tech on Drone.DroneTech = Drone_Tech.Username 
where i_username = Drone.DroneTech);

else 
insert into dronetech_assigned_drones_result
(select Drone.ID, Drone.DroneStatus, Drone.Radius from Drone 
join Drone_Tech on Drone.DroneTech = Drone_Tech.Username 
where i_username = Drone.DroneTech and i_status = drone.droneStatus);
    
end if;
-- End of solution
END //
DELIMITER ;
