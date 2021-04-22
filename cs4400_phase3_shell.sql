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
	drop table if exists manager_manage_stores_result;
    create table manager_manage_stores_result(Storename varchar(40), Address varchar(200), orders varchar(500), employees varchar(500), total varchar(500));

	if i_storeName is not null and i_minTotal is not null and i_maxTotal is not null then
	insert into manager_manage_stores_result
    select store.storename, concat(store.street, ", ",store.city, ", ", store.state, " ",store.zipcode) as Address, count(orders.ID) as orders, count(drone_tech.username) as employees, sum(chain_item.Price * contains.quantity) as total
    from drone_tech join store on drone_tech.storename = store.storename and drone_tech.chainname = store.chainname join drone on drone.dronetech = drone_tech.username join orders on drone.id = orders.droneid join contains on orders.id = contains.orderid 
    join chain_item on contains.plunumber = chain_item.plunumber join manager on drone_tech.chainname = manager.chainname
    where i_mgr_username = manager.username and manager.chainname = store.chainname and i_storeName = store.storename and sum(chain_item.Price * contains.quantity) between i_minTotal and i_maxTotal ;
    
	elseif i_storeName is null and i_minTotal is not null and i_maxTotal is not null then
	insert into manager_manage_stores_result
    select store.storename, concat(store.street, ", ",store.city, ", ", store.state, " ",store.zipcode) as Address, count(orders.ID) as orders, count(drone_tech.username) as employees, sum(chain_item.Price * contains.quantity) as total
    from drone_tech join store on drone_tech.storename = store.storename and drone_tech.chainname = store.chainname join drone on drone.dronetech = drone_tech.username join orders on drone.id = orders.droneid join contains on orders.id = contains.orderid 
    join chain_item on contains.plunumber = chain_item.plunumber join manager on drone_tech.chainname = manager.chainname
    where i_mgr_username = manager.username and manager.chainname = store.chainname and sum(chain_item.Price * contains.quantity) between i_minTotal and i_maxTotal;
    
	elseif i_storeName is not null and i_minTotal is null and i_maxTotal is not null then
	insert into manager_manage_stores_result
    select store.storename, concat(store.street, ", ",store.city, ", ", store.state, " ",store.zipcode) as Address, count(orders.ID) as orders, count(drone_tech.username) as employees, sum(chain_item.Price * contains.quantity) as total
    from drone_tech join store on drone_tech.storename = store.storename and drone_tech.chainname = store.chainname join drone on drone.dronetech = drone_tech.username join orders on drone.id = orders.droneid join contains on orders.id = contains.orderid 
    join chain_item on contains.plunumber = chain_item.plunumber join manager on drone_tech.chainname = manager.chainname
    where i_mgr_username = manager.username and manager.chainname = store.chainname and i_storeName = store.storename and sum(chain_item.Price * contains.quantity) < i_maxTotal ;
    
	elseif i_storeName is not null and i_minTotal is not null and i_maxTotal is null then
	insert into manager_manage_stores_result
    select store.storename, concat(store.street, ", ",store.city, ", ", store.state, " ",store.zipcode) as Address, count(orders.ID) as orders, count(drone_tech.username) as employees, sum(chain_item.Price * contains.quantity) as total
    from drone_tech join store on drone_tech.storename = store.storename and drone_tech.chainname = store.chainname join drone on drone.dronetech = drone_tech.username join orders on drone.id = orders.droneid join contains on orders.id = contains.orderid 
    join chain_item on contains.plunumber = chain_item.plunumber join manager on drone_tech.chainname = manager.chainname
    where i_mgr_username = manager.username and manager.chainname = store.chainname and i_storeName = store.storename and sum(chain_item.Price * contains.quantity) > i_minTotal ;
    
	elseif i_storeName is null and i_minTotal is not null and i_maxTotal is null then
	insert into manager_manage_stores_result
    select store.storename, concat(store.street, ", ",store.city, ", ", store.state, " ",store.zipcode) as Address, count(orders.ID) as orders, count(drone_tech.username) as employees, sum(chain_item.Price * contains.quantity) as total
    from drone_tech join store on drone_tech.storename = store.storename and drone_tech.chainname = store.chainname join drone on drone.dronetech = drone_tech.username join orders on drone.id = orders.droneid join contains on orders.id = contains.orderid 
    join chain_item on contains.plunumber = chain_item.plunumber join manager on drone_tech.chainname = manager.chainname
    where i_mgr_username = manager.username and manager.chainname = store.chainname and sum(chain_item.Price * contains.quantity) > i_minTotal ;
    
	elseif i_storeName is null and i_minTotal is null and i_maxTotal is not null then
	insert into manager_manage_stores_result
    select store.storename, concat(store.street, ", ",store.city, ", ", store.state, " ",store.zipcode) as Address, count(orders.ID) as orders, count(drone_tech.username) as employees, sum(chain_item.Price * contains.quantity) as total
    from drone_tech join store on drone_tech.storename = store.storename and drone_tech.chainname = store.chainname join drone on drone.dronetech = drone_tech.username join orders on drone.id = orders.droneid join contains on orders.id = contains.orderid 
    join chain_item on contains.plunumber = chain_item.plunumber join manager on drone_tech.chainname = manager.chainname
    where i_mgr_username = manager.username and manager.chainname = store.chainname and sum(chain_item.Price * contains.quantity) < i_maxTotal ;
    
    
    end if;
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

-- End of solution
END //
DELIMITER ;