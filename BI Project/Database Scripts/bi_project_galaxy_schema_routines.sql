-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bi_project_galaxy_schema
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'bi_project_galaxy_schema'
--
/*!50003 DROP PROCEDURE IF EXISTS `SP_Area_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Area_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table

	set @records_count = (select count(*) from bi_project_galaxy_schema.area_dim);

	drop table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		SELECT a.id id, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.area a
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		);
		
		insert into bi_project_galaxy_schema.area_dim
        (ID, area, city, country, is_active, Active_From_Date, Active_To_Date)
		select a.*, 1, current_date, NULL
		from dim_temp a;
		
	else
    
		#check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select Area_key, ID, Is_Active,
			rank() over(partition by ID, Is_Active order by Area_Key asc) as col_rank
			from bi_project_galaxy_schema.area_dim
			where Is_Active = 1
			);
		
	   
	   #keep one record only of the duplicates with the latest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.area_dim
	   where area_Key in (select area_key from temp_duplicates_check where col_rank <> 1);
		
    

    
		#Get new areas
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT a.id id, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.area a
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where a.id not in
		(select id from bi_project_galaxy_schema.area_dim where is_active = 1)
		);

		insert into bi_project_galaxy_schema.area_dim
		(ID, area, city, country, is_active, Active_From_Date, Active_To_Date)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active areas from the area dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct ID, Area, City, Country
		FROM bi_project_galaxy_schema.area_dim a
        where is_active = 1
		);
		
        #Get the latest data of the active areas in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT a.id id, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.area a
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where a.id in
		(select id from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.id
		where (a.area_Name <> b.area) or (a.city_Name <> b.city) or (a.country_Name <> b.country) 
		);

        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.area_dim
        set is_active = 0, Active_To_Date = current_date
        where id in (select id from dim_temp_updated_records)
        and
        is_active = 1;

        #Insert the updated version of the records and set them as active in the dimension 
        insert into bi_project_galaxy_schema.area_dim
		(ID, area, city, country, is_active, Active_From_Date, Active_To_Date)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
	end if;
    drop table if exists temp_duplicates_check;
	drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Branch_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Branch_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table

	SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175
    
	set @records_count = (select count(*) from bi_project_galaxy_schema.branch_dim);

	drop temporary table if exists temp_duplicates_check;
	drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;
    

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		SELECT br.ID, br.Name, br.Type, br.square_meters, br.monthly_rent, br.average_monthly_expenses, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.branch br
        inner join bi_project_db.area a on br.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		);
		
		insert into bi_project_galaxy_schema.branch_dim
        (ID, Name, Type, square_meters, monthly_rent, average_monthly_expenses, Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
        #Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(branch_key) as max_key
		from bi_project_galaxy_schema.branch_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.branch_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
		
	else
    
    
        #check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select branch_key, id, Activation_Flag,
			rank() over(partition by id, Activation_Flag order by branch_key asc) as col_rank
			from bi_project_galaxy_schema.branch_dim
			where Activation_Flag = 1
			);
		
	   
	   #keep one record only of the duplicates with the latest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.branch_dim
	   where branch_key in (select branch_key from temp_duplicates_check where col_rank <> 1);
    
    
    
    
    
    
    
    
		#Get new branches
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT br.ID, br.Name, br.Type, br.square_meters, br.monthly_rent, br.average_monthly_expenses, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.branch br
        inner join bi_project_db.area a on br.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where br.id not in
		(select id from bi_project_galaxy_schema.branch_dim)
		);

		insert into bi_project_galaxy_schema.branch_dim
        (ID, Name, Type, square_meters, monthly_rent, average_monthly_expenses, Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active branches from the branch dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct ID, Name, Type, square_meters, monthly_rent, average_monthly_expenses, Area_Name, City_Name, Country_Name
		FROM bi_project_galaxy_schema.branch_dim a
        where activation_flag = 1
		);
		
        #Get the latest data of the active branches in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT br.ID, br.Name, br.Type, br.square_meters, br.monthly_rent, br.average_monthly_expenses, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.branch br
        inner join bi_project_db.area a on br.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where br.id in
		(select id from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.id
		where (a.Name <> b.Name) or (a.Type <> b.Type) or (a.monthly_rent <> b.monthly_rent) or
        (a.average_monthly_expenses <> b.average_monthly_expenses) or (a.Area_Name <> b.Area_Name) or
        (a.City_Name <> b.City_Name) or (a.Country_Name <> b.Country_Name)
		);

        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.branch_dim
        set Activation_Flag = 0, Active_To = current_date
        where id in (select id from dim_temp_updated_records)
        and
        activation_flag = 1;

        #Insert the updated version of the records and set them as active in the dimension 
        insert into bi_project_galaxy_schema.branch_dim
        (ID, Name, Type, square_meters, monthly_rent, average_monthly_expenses, area_name, city_name, country_name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
        #Add the last dimension_key for each ID from the source
		CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(branch_key) as max_key
		from bi_project_galaxy_schema.branch_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.branch_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
        
        
        
	end if;
    drop temporary table if exists temp_duplicates_check;
	drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Customer_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Customer_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table

	SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175
    
    set @records_count = (select count(*) from bi_project_galaxy_schema.customer_dim);

	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
	drop temporary table if exists max_key;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		SELECT cu.ID, cu.First_Name, cu.Last_Name, cu.Phone_Number, cu.Email, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.customer cu
        inner join bi_project_db.area a on cu.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		);
		
		insert into bi_project_galaxy_schema.customer_dim
        (ID, First_Name, Last_Name, Phone_Number, Email, Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(customer_key) as max_key
		from bi_project_galaxy_schema.customer_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.customer_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
		
	else
    
     #check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select customer_key, id, Activation_Flag,
			rank() over(partition by id, Activation_Flag order by customer_key asc) as col_rank
			from bi_project_galaxy_schema.customer_dim
			where Activation_Flag = 1
			);
		
	   
	   #keep one record only of the duplicates with the latest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.customer_dim
	   where customer_key in (select customer_key from temp_duplicates_check where col_rank <> 1);
    
    
    
    
    
    
    
    
    
		#Get new customers
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT cu.ID, cu.First_Name, cu.Last_Name, cu.Phone_Number, cu.Email, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.customer cu
        inner join bi_project_db.area a on cu.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where cu.id not in
		(select id from bi_project_galaxy_schema.customer_dim where Activation_Flag = 1)
		);

		insert into bi_project_galaxy_schema.customer_dim
        (ID, First_Name, Last_Name, Phone_Number, Email, Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active customers from the customer dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct ID, First_Name, Last_Name, Phone_Number, Email, Area_Name, City_Name, Country_Name
		FROM bi_project_galaxy_schema.customer_dim a
        where activation_flag = 1
		);
		
        #Get the latest data of the active customers in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT cu.ID, cu.First_Name, cu.Last_Name, cu.Phone_Number, cu.Email, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.customer cu
        inner join bi_project_db.area a on cu.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where cu.id in
		(select id from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.id
		where (a.First_Name <> b.First_Name) or (a.Last_Name <> b.Last_Name) or (a.Phone_Number <> b.Phone_Number) or
        (a.Email <> b.Email) or (a.Area_Name <> b.Area_Name) or (a.City_Name <> b.City_Name) or (a.Country_Name <> b.Country_Name)
		);

        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.customer_dim
        set Activation_Flag = 0, Active_To = current_date
        where id in (select id from dim_temp_updated_records)
        and
        activation_flag = 1;

        #Insert the updated version of the records and set them as active in the dimension 
        insert into bi_project_galaxy_schema.customer_dim
        (ID, First_Name, Last_Name, Phone_Number, Email, Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(customer_key) as max_key
		from bi_project_galaxy_schema.customer_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.customer_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
        
        
        
        
	end if;
	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Date_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Date_DIM`()
BEGIN

	SET SESSION cte_max_recursion_depth = 1000000; #to prevent error 3636

	drop temporary table if exists dates_temp;
    drop temporary table if exists dim_temp_new_records;

    CREATE TEMPORARY TABLE IF NOT EXISTS dates_temp AS 
    
	with recursive #create the cte
	dates as
	(
	select 1 as index_column, '2019-01-01' as date_column #give an alias for columns at the start of the recursion because they will be used later
	union all
	select index_column + 1, date_add(date_column, INTERVAL 1 DAY) #recall the start of the recursion while adding a counter
	from dates
	where date_add(date_column, INTERVAL 1 DAY) <= date_add(current_date, INTERVAL 3 MONTH) #add an end condition for the recursion in the where clause
	)

	(select * FROM dates); #insert the values into the temp table dates_temp


	#Get new dates
	CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
	(
	SELECT * 
	FROM  dates_temp
	where date_column not in
	(select date from bi_project_galaxy_schema.date_dim )
	);

	insert into bi_project_galaxy_schema.date_dim
	(Date, Day, Year, Month, Quarter, Week_Number, Day_Description, Is_Holiday, Is_Weekend)
	select date_column, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	from dim_temp_new_records;
	




	drop temporary table if exists dates_temp;
    drop temporary table if exists dim_temp_new_records;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Employee_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Employee_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table

	SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175
    

	set @records_count = (select count(*) from bi_project_galaxy_schema.employee_dim);

	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		 SELECT e.ID, e.First_Name, e.Last_Name, e.Phone_Number, e.Email, d.name department_name, m.first_name manager_name, e.level, e.national_id, 
        a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.employee e
        inner join bi_project_db.department d on e.departmentid = d.id
        left join bi_project_db.employee m on e.managerid = m.id
        inner join bi_project_db.area a on e.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		);
		
		insert into bi_project_galaxy_schema.employee_dim
        (Employee_ID, First_Name, Last_Name, Phone_Number, Email, Department_Name, Manager_Name, Level, National_ID, 
        Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select employee_id, max(employee_key) as max_key
		from bi_project_galaxy_schema.employee_dim
		group by employee_id
		);
        
        UPDATE bi_project_galaxy_schema.employee_dim main
        INNER JOIN max_key as t1 ON main.employee_id = t1.employee_id
		SET main.Last_Key = t1.max_key;
		
	else
    
       #check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select employee_key, employee_id, Activation_Flag,
			rank() over(partition by employee_id, Activation_Flag order by employee_key asc) as col_rank
			from bi_project_galaxy_schema.employee_dim
			where Activation_Flag = 1
			);
		
	   
	   #keep one record only of the duplicates with the earliest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.employee_dim
	   where employee_key in (select employee_key from temp_duplicates_check where col_rank <> 1);
    
    
    
    
    
		#Get new employees
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		 SELECT e.ID, e.First_Name, e.Last_Name, e.Phone_Number, e.Email, d.name department_name, m.first_name manager_name, e.level, e.national_id, 
        a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.employee e
        inner join bi_project_db.department d on e.departmentid = d.id
        left join bi_project_db.employee m on e.managerid = m.id
        inner join bi_project_db.area a on e.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where e.id not in
		(select employee_id from bi_project_galaxy_schema.employee_dim where Activation_Flag = 1)
		);

		insert into bi_project_galaxy_schema.employee_dim
        (Employee_ID, First_Name, Last_Name, Phone_Number, Email, Department_Name, Manager_Name, Level, National_ID, 
        Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active employees from the estomer dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct Employee_ID, First_Name, Last_Name, Phone_Number, Email, Department_Name,
        Manager_Name, Level, National_ID, Area_Name, City_Name, Country_Name
		FROM bi_project_galaxy_schema.employee_dim a
        where activation_flag = 1
		);
		
        #Get the latest data of the active employees in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT e.ID, e.First_Name, e.Last_Name, e.Phone_Number, e.Email, d.name department_name, m.first_name manager_name, e.level, e.national_id, 
        a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.employee e
        inner join bi_project_db.department d on e.departmentid = d.id
        left join bi_project_db.employee m on e.managerid = m.id
        inner join bi_project_db.area a on e.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where e.id in
		(select Employee_ID from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.Employee_ID
		where (a.First_Name <> b.First_Name) or (a.Last_Name <> b.Last_Name) or (a.Phone_Number <> b.Phone_Number) or
        (a.Email <> b.Email) or (a.department_name <> b.department_name) or (a.manager_name <> b.manager_name) or (a.level <> b.level) or
        (a.Area_Name <> b.Area_Name) or (a.City_Name <> b.City_Name) or (a.Country_Name <> b.Country_Name)
		);

        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.employee_dim
        set Activation_Flag = 0, Active_To = current_date
        where Employee_ID in (select id from dim_temp_updated_records)
        and
        activation_flag = 1;

        #Insert the updated version of the records and set them as active in the dimension 
        insert into bi_project_galaxy_schema.employee_dim
        (Employee_ID, First_Name, Last_Name, Phone_Number, Email, Department_Name, Manager_Name, Level, National_ID, 
        Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
        #Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select employee_id, max(employee_key) as max_key
		from bi_project_galaxy_schema.employee_dim
		group by employee_id
		);
        
        UPDATE bi_project_galaxy_schema.employee_dim main
        INNER JOIN max_key as t1 ON main.employee_id = t1.employee_id
		SET main.Last_Key = t1.max_key;
        
        
        
	end if;
	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Orders_Trips_Fact` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Orders_Trips_Fact`()
BEGIN
    
	drop temporary table if exists fact_temp_stg;
	drop temporary table if exists fact_temp;
	drop temporary table if exists fact_temp_delta_stg;
	drop temporary table if exists fact_temp_delta;
	drop temporary table if exists fact_temp_incomplete_pipeline;
	drop temporary table if exists temp_source_complete_pipeline;
	drop temporary table if exists fact_temp_updates;
	drop temporary table if exists current_Key1;
    drop temporary table if exists current_Key2;
    drop temporary table if exists current_Key3;

    
    set @records_count = (select count(*) from bi_project_galaxy_schema.orders_trips_fact);
    
    if @records_count = 0 then
    
    
		#create the fact table from the oltp tables
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_stg AS
		(
			select o.customerid, cast(o.Order_Date as date) as Order_Date, cast(o.expected_delivery_Date as date) as expected_delivery_Date,
			cast(o.Actual_Delivery_Date as date) as Actual_Delivery_Date, cast(t.expected_start_date as date) as trip_planned_start_date, 
			time(t.expected_start_date) as trip_planned_start_time, cast(t.Actual_Start_Date as date)  as Trip_Actual_Start_Date, 
			time(t.Actual_Start_Date) as Trip_Actual_Start_Time, cast(t.Actual_End_Date as date) as Trip_Actual_End_Date,
			time(t.Actual_End_Date) as Trip_Actual_End_Time, t.RouteID, t.vehicleid, t.EmployeeID as driver_id, o.id as order_id,
			o.Order_Net_Amount, t.id as trip_id, TIMESTAMPDIFF(minute, t.Expected_Start_Date, t.Actual_Start_Date) trip_start_delay_minutes,
			TIMESTAMPDIFF(minute, t.Actual_Start_Date, t.Actual_End_Date) trip_duration_minutes, 
			TIMESTAMPDIFF(HOUR,  o.order_date, o.actual_delivery_date)  as Order_Lead_Time_Hours

			from  bi_project_db.sales_order o
			left join bi_project_db.trip t on o.TripID = t.id
			left join bi_project_db.route r on t.routeid = r.id

		);



		#populate the surrogate keys
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp AS
		(
			select c.Customer_Key, od.Date_Key as order_date_key, ed.Date_Key as expected_delivery_date_key, 
            ad.Date_Key as actual_delivery_date_key, tpd.Date_Key as trip_planned_start_date_key,
            main.trip_planned_start_time, tad.Date_Key as trip_actual_start_date_key,
            main.trip_actual_start_time, ted.Date_Key as trip_end_date_key, main.Trip_Actual_End_Time,
            r.Route_Key, v.Vehicle_Key, dri.employee_key as Driver_Key, main.Order_ID, main.Order_Net_Amount,
            main.Trip_ID, main.trip_start_delay_minutes, main.Trip_Duration_Minutes, main.Order_Lead_Time_Hours
            
			from fact_temp_stg main
            left join date_dim od on cast(main.Order_Date as date) = od.date
			left join date_dim ed on cast(main.expected_delivery_Date as date) = ed.date 
			left join date_dim ad on cast(main.Actual_Delivery_Date as date) = ad.date
			left join date_dim tpd on cast(main.trip_planned_start_date as date) = tpd.date
            left join date_dim tad on cast(main.Trip_Actual_Start_Date as date) = tad.date
            left join date_dim ted on cast(main.Trip_Actual_End_Date as date) = ted.date
			left join customer_dim c on main.customerid = c.id
				and c.Activation_Flag = 1
			left join route_dim r on main.routeid = r.id
				and r.Is_Active = 1
            left join vehicle_dim v on main.vehicleid = v.id
				and v.Activation_Flag = 1    
			left join employee_dim dri on main.driver_id = dri.employee_id
				and dri.Activation_Flag = 1
		);



		insert into bi_project_galaxy_schema.orders_trips_fact
		(
		Customer_Key, order_date_key, expected_delivery_date_key, actual_delivery_date_key,
        trip_planned_start_date_key, trip_planned_start_time, trip_actual_start_date_key,
		trip_actual_start_time, trip_end_date_key, Trip_End_Time, Route_Key,
        Vehicle_Key, Driver_Key, Order_ID, Order_Net_Amount, Trip_ID, trip_start_delay_minutes, 
        Trip_Duration_Minutes, Order_Lead_Time_Hours,Loading_Time_Stamp

		)
		select Customer_Key, order_date_key, expected_delivery_date_key, actual_delivery_date_key,
        trip_planned_start_date_key, trip_planned_start_time, trip_actual_start_date_key,
		trip_actual_start_time, trip_end_date_key, Trip_Actual_End_Time, Route_Key,
        Vehicle_Key, Driver_Key, Order_ID, Order_Net_Amount, Trip_ID, trip_start_delay_minutes, 
        Trip_Duration_Minutes, Order_Lead_Time_Hours, now()
		
        from fact_temp;
        
        
		#Add the current route key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key1 AS
		(
		select route_Key, last_key
		from bi_project_galaxy_schema.route_dim
		);
        
        UPDATE bi_project_galaxy_schema.orders_trips_fact main
        INNER JOIN current_Key1 as t1 ON main.route_Key = t1.route_Key
		SET main.Current_route_Key = t1.last_key;
        
        
		#Add the current vehicle key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key2 AS
		(
		select vehicle_Key, last_key
		from bi_project_galaxy_schema.vehicle_dim
		);
        
        UPDATE bi_project_galaxy_schema.orders_trips_fact main
        INNER JOIN current_Key2 as t1 ON main.vehicle_Key = t1.vehicle_Key
		SET main.Current_vehicle_Key = t1.last_key;	
        
        
		#Add the current driver key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key3 AS
		(
		select employee_Key, last_key
		from bi_project_galaxy_schema.employee_dim
		);
        
        UPDATE bi_project_galaxy_schema.orders_trips_fact main
        INNER JOIN current_Key3 as t1 ON main.driver_Key = t1.employee_Key
		SET main.Current_driver_Key = t1.last_key;	
        
        
        
        

	else
    
    
		#get the latest date of the data in the fact table
		set @delta =
		(
		select max(d.date)
		from bi_project_galaxy_schema.orders_trips_fact main
		inner join bi_project_galaxy_schema.date_dim d on main.Order_Date_Key = d.date_key
		); 


		#delete all records of the max date because data may not be complete on that day
		delete main
		from bi_project_galaxy_schema.orders_trips_fact main
		inner join bi_project_galaxy_schema.date_dim d on main.Order_Date_Key = d.date_key
		where d.date = @delta;


		#get all records where the order date in the source is >= than the max order date in the fact table
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_delta_stg AS
		(
			select o.customerid, cast(o.Order_Date as date) as Order_Date, cast(o.expected_delivery_Date as date) as expected_delivery_Date,
			cast(o.Actual_Delivery_Date as date) as Actual_Delivery_Date, cast(t.expected_start_date as date) as trip_planned_start_date, 
			time(t.expected_start_date) as trip_planned_start_time, cast(t.Actual_Start_Date as date)  as Trip_Actual_Start_Date, 
			time(t.Actual_Start_Date) as Trip_Actual_Start_Time, cast(t.Actual_End_Date as date) as Trip_Actual_End_Date,
			time(t.Actual_End_Date) as Trip_Actual_End_Time, t.RouteID, t.vehicleid, t.EmployeeID as driver_id, o.id as order_id,
			o.Order_Net_Amount, t.id as trip_id, TIMESTAMPDIFF(minute, t.Expected_Start_Date, t.Actual_Start_Date) trip_start_delay_minutes,
			TIMESTAMPDIFF(minute, t.Actual_Start_Date, t.Actual_End_Date) trip_duration_minutes, 
			TIMESTAMPDIFF(HOUR,  o.order_date, o.actual_delivery_date)  as Order_Lead_Time_Hours

			from  bi_project_db.sales_order o
			left join bi_project_db.trip t on o.TripID = t.id
			left join bi_project_db.route r on t.routeid = r.id
			
			where o.order_date >= @delta

		);



		#populate the surrogate keys
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_delta AS
		(
			select c.Customer_Key, od.Date_Key as order_date_key, ed.Date_Key as expected_delivery_date_key, 
            ad.Date_Key as actual_delivery_date_key, tpd.Date_Key as trip_planned_start_date_key,
            main.trip_planned_start_time, tad.Date_Key as trip_actual_start_date_key,
            main.trip_actual_start_time, ted.Date_Key as trip_end_date_key, main.Trip_Actual_End_Time,
            r.Route_Key, v.Vehicle_Key, dri.employee_key as Driver_Key, main.Order_ID, main.Order_Net_Amount,
            main.Trip_ID, main.trip_start_delay_minutes, main.Trip_Duration_Minutes, main.Order_Lead_Time_Hours
            
			from fact_temp_delta_stg main
            
            left join date_dim od on cast(main.Order_Date as date) = od.date
			left join date_dim ed on cast(main.expected_delivery_Date as date) = ed.date 
			left join date_dim ad on cast(main.Actual_Delivery_Date as date) = ad.date
			left join date_dim tpd on cast(main.trip_planned_start_date as date) = tpd.date
            left join date_dim tad on cast(main.Trip_Actual_Start_Date as date) = tad.date
            left join date_dim ted on cast(main.Trip_Actual_End_Date as date) = ted.date
			left join customer_dim c on main.customerid = c.id
				and c.Activation_Flag = 1
			left join route_dim r on main.routeid = r.id
				and r.Is_Active = 1
            left join vehicle_dim v on main.vehicleid = v.id
				and v.Activation_Flag = 1    
			left join employee_dim dri on main.driver_id = dri.employee_id
				and dri.Activation_Flag = 1
		);


		insert into bi_project_galaxy_schema.orders_trips_fact
		(
		Customer_Key, order_date_key, expected_delivery_date_key, actual_delivery_date_key,
        trip_planned_start_date_key, trip_planned_start_time, trip_actual_start_date_key,
		trip_actual_start_time, trip_end_date_key, Trip_End_Time, Route_Key,
        Vehicle_Key, Driver_Key, Order_ID, Order_Net_Amount, Trip_ID, trip_start_delay_minutes, 
        Trip_Duration_Minutes, Order_Lead_Time_Hours,Loading_Time_Stamp

		)
		select Customer_Key, order_date_key, expected_delivery_date_key, actual_delivery_date_key,
        trip_planned_start_date_key, trip_planned_start_time, trip_actual_start_date_key,
		trip_actual_start_time, trip_end_date_key, Trip_Actual_End_Time, Route_Key,
        Vehicle_Key, Driver_Key, Order_ID, Order_Net_Amount, Trip_ID, trip_start_delay_minutes, 
        Trip_Duration_Minutes, Order_Lead_Time_Hours, now()
        
		from fact_temp_delta main;

		#Add the current route key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key1 AS
		(
		select route_Key, last_key
		from bi_project_galaxy_schema.route_dim
		);
        
        UPDATE bi_project_galaxy_schema.orders_trips_fact main
        INNER JOIN current_Key1 as t1 ON main.route_Key = t1.route_Key
		SET main.Current_route_Key = t1.last_key;
        
        
		#Add the current vehicle key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key2 AS
		(
		select vehicle_Key, last_key
		from bi_project_galaxy_schema.vehicle_dim
		);
        
        UPDATE bi_project_galaxy_schema.orders_trips_fact main
        INNER JOIN current_Key2 as t1 ON main.vehicle_Key = t1.vehicle_Key
		SET main.Current_vehicle_Key = t1.last_key;	
        
        
		#Add the current driver key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key3 AS
		(
		select employee_Key, last_key
		from bi_project_galaxy_schema.employee_dim
		);
        
        UPDATE bi_project_galaxy_schema.orders_trips_fact main
        INNER JOIN current_Key3 as t1 ON main.driver_Key = t1.employee_Key
		SET main.Current_driver_Key = t1.last_key;	



		#get records from the fact table that do not have their pipeline process completed yet (Order_Lead_Time_Hours is NULL)
       

		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_incomplete_pipeline AS
		(
		select ID, actual_delivery_date_key,
        trip_planned_start_date_key, trip_planned_start_time, trip_actual_start_date_key, trip_actual_start_time,
        trip_end_date_key, Trip_End_Time, Route_Key, Vehicle_Key, Driver_Key, Order_ID, Trip_ID, trip_start_delay_minutes, 
        Trip_Duration_Minutes, Order_Lead_Time_Hours, Loading_Time_Stamp
		from bi_project_galaxy_schema.orders_trips_fact main
		where Order_Lead_Time_Hours is NULL
		);



		#get records from the source tables that have a complete pipeline (Actual_Delivery_Date is NOT NULL) and 
        #the date difference between the order date and today is no longer than 15 days. I added the 15 days date difference
        #condition to reduce the data being extracted from the source, because as days pass, most orders would have already 
        #been completed.
		

		CREATE TEMPORARY TABLE IF NOT EXISTS temp_source_complete_pipeline AS
		(
			
			select 
			cast(o.Actual_Delivery_Date as date) as Actual_Delivery_Date, cast(t.expected_start_date as date) as trip_planned_start_date, 
			time(t.expected_start_date) as trip_planned_start_time, cast(t.Actual_Start_Date as date)  as Trip_Actual_Start_Date, 
			time(t.Actual_Start_Date) as Trip_Actual_Start_Time, cast(t.Actual_End_Date as date) as Trip_Actual_End_Date,
			time(t.Actual_End_Date) as Trip_Actual_End_Time, t.RouteID, t.vehicleid, t.EmployeeID as driver_id, o.id as order_id,
			t.id as trip_id, TIMESTAMPDIFF(minute, t.Expected_Start_Date, t.Actual_Start_Date) trip_start_delay_minutes,
			TIMESTAMPDIFF(minute, t.Actual_Start_Date, t.Actual_End_Date) trip_duration_minutes, 
			TIMESTAMPDIFF(HOUR,  o.order_date, o.actual_delivery_date)  as Order_Lead_Time_Hours

			from  bi_project_db.sales_order o
			left join bi_project_db.trip t on o.TripID = t.id
			left join bi_project_db.route r on t.routeid = r.id
            
            where Actual_Delivery_Date is NOT NULL and o.Order_Date between DATE_ADD(current_date, INTERVAL -15 DAY) and current_date 
		);
        
 
	
		 #populate the surrogate keys
		 #the ID of this temp will be joined with the ID in the fact table in the next step to update the fact table
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_updates AS
		(
			select a.id, ad.date_key as actual_delivery_date_key, tpd.date_key as trip_planned_start_date_key,
            b.trip_planned_start_time, tad.date_key as trip_actual_start_date_key, b.trip_actual_start_time,
            ted.date_key as trip_end_date_key, b.Trip_Actual_End_Time, r.Route_Key, v.Vehicle_Key, dri.Employee_Key as driver_key,
            b.Trip_ID, b.trip_start_delay_minutes, b.Trip_Duration_Minutes, b.Order_Lead_Time_Hours
            
			from fact_temp_incomplete_pipeline a
			inner join temp_source_complete_pipeline b on a.Order_ID = b.order_id
			left join date_dim ad on cast(b.Actual_Delivery_Date as date) = ad.date
			left join date_dim tpd on cast(b.trip_planned_start_date as date) = tpd.date
            left join date_dim tad on cast(b.Trip_Actual_Start_Date as date) = tad.date
            left join date_dim ted on cast(b.Trip_Actual_End_Date as date) = ted.date
			left join route_dim r on b.routeid = r.id
				and r.Is_Active = 1
            left join vehicle_dim v on b.vehicleid = v.id
				and v.Activation_Flag = 1    
			left join employee_dim dri on b.driver_id = dri.employee_id
				and dri.Activation_Flag = 1		
		);


		 #update the records using the ID of the fact table 
		 UPDATE bi_project_galaxy_schema.orders_trips_fact main 
		 INNER JOIN fact_temp_updates updates ON main.id = updates.id

		SET 
		main.Actual_Delivery_Date_Key = updates.Actual_Delivery_Date_Key,
		main.Trip_Planned_Start_Date_Key = updates.Trip_Planned_Start_Date_Key,
		main.Trip_Planned_Start_Time = updates.Trip_Planned_Start_Time,
		main.Trip_Actual_Start_Date_Key = updates.Trip_Actual_Start_Date_Key,
		main.Trip_Actual_Start_Time = updates.Trip_Actual_Start_Time,
        main.Trip_End_Date_Key = updates.Trip_End_Date_Key,
        main.Trip_End_Time = updates.Trip_Actual_End_Time,
        main.Route_Key = updates.Route_Key,
        main.Vehicle_Key = updates.Vehicle_Key,
        main.Driver_Key = updates.Driver_Key,
        main.Trip_ID = updates.Trip_ID,
        main.trip_start_delay_minutes = updates.trip_start_delay_minutes,
        main.Trip_Duration_Minutes = updates.Trip_Duration_Minutes,
        main.Order_Lead_Time_Hours = updates.Order_Lead_Time_Hours,
		main.Loading_Time_Stamp = now();
        
	end if;

	drop temporary table if exists fact_temp_stg;
	drop temporary table if exists fact_temp;
	drop temporary table if exists fact_temp_delta_stg;
	drop temporary table if exists fact_temp_delta;
	drop temporary table if exists fact_temp_incomplete_pipeline;
	drop temporary table if exists temp_source_complete_pipeline;
	drop temporary table if exists fact_temp_updates;
	drop temporary table if exists current_Key1;
	drop temporary table if exists current_Key2;
	drop temporary table if exists current_Key3;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Product_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Product_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table
    
	SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175
    
	set @records_count = (select count(*) from bi_project_galaxy_schema.product_dim);

	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
	drop temporary table if exists max_key;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		SELECT * 
		FROM bi_project_db.product
		);
		
		insert into bi_project_galaxy_schema.product_dim
        (ID, Name, Color, Category, Cost_Price, Selling_Price, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(product_key) as max_key
		from bi_project_galaxy_schema.product_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.product_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
		
	else
    
       #check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select product_key, id, Activation_Flag,
			rank() over(partition by id, Activation_Flag order by product_key asc) as col_rank
			from bi_project_galaxy_schema.product_dim
			where Activation_Flag = 1
			);
		
	   
	   #keep one record only of the duplicates with the earliest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.product_dim
	   where product_key in (select product_key from temp_duplicates_check where col_rank <> 1);
    
    
    
    
    
    
		#Get new products
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT * 
		FROM bi_project_db.product
		where id not in
		(select id from bi_project_galaxy_schema.product_dim where Activation_Flag = 1)
		);

		insert into bi_project_galaxy_schema.product_dim
        (ID, Name, Color, Category, Cost_Price, Selling_Price, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active products from the product dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct id, a.name, Color, category, cost_price, selling_price 
		FROM bi_project_galaxy_schema.product_dim a
        where activation_flag = 1
		);
		
        #Get the latest data of the active products in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT * 
		FROM bi_project_db.product
		where id in
		(select id from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.id
		where (a.name <> b.name) or (a.color <> b.color) or (a.category <> b.category) or
        (a.cost_price <> b.cost_price) or (a.selling_price <> b.selling_Price)
		);
        
        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.product_dim
        set Activation_Flag = 0, Active_To = current_date
        where id in (select id from dim_temp_updated_records)
        and
        activation_flag = 1;

        #Insert the updated version of the records and set them as active in the dimensionSP_Product_DIM
        insert into bi_project_galaxy_schema.product_dim
        (ID, Name, Color, Category, Cost_Price, Selling_Price, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(product_key) as max_key
		from bi_project_galaxy_schema.product_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.product_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
	end if;
    
	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Product_Stock_Fact` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Product_Stock_Fact`()
Begin

    
    #create a variable that has today's date key from the date dimension
    #this variable will be inserted in the product_stock_fact as the date_key.

	drop temporary table if exists fact_temp;
	drop temporary table if exists active_products_temp;
	drop temporary table if exists active_branches_temp;

		
	set @date_key = (select date_key from  bi_project_galaxy_schema.date_dim where date = current_date);


    
    CREATE TEMPORARY TABLE IF NOT EXISTS active_products_temp AS 
	(
    select Product_Key, id
	from bi_project_galaxy_schema.product_dim
    where Activation_Flag = 1
    );
    
	CREATE TEMPORARY TABLE IF NOT EXISTS active_branches_temp AS 
	(
    select branch_Key, id
	from bi_project_galaxy_schema.branch_dim
    where Activation_Flag = 1
    );
    
	CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp AS 
	(
    select p.Product_Key, b.Branch_Key, @date_key, available_quantity
	from bi_project_db.product_stock f
    left join active_products_temp p on f.ProductID = p.ID
    left join active_branches_temp b on f.BranchID = b.ID
    );
    
    

	delete 
    from bi_project_galaxy_schema.product_stock_fact
    where date_key = @date_key;
    
    
	insert into bi_project_galaxy_schema.product_stock_fact
    (Product_Key, Branch_Key, date_key, Available_Quantity, Loading_Time_Stamp)
    select a.*, Now()
    from fact_temp a;

    drop temporary table if exists fact_temp;
	drop temporary table if exists active_products_temp;
	drop temporary table if exists active_branches_temp;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Promotion_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Promotion_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table

	SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175
    
	set @records_count = (select count(*) from bi_project_galaxy_schema.promotion_dim);

	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		SELECT a.id, a.code, a.type, a.amount, a.valid_from, a.valid_to
		FROM bi_project_db.promotion a
		);
        
        
		insert into bi_project_galaxy_schema.promotion_dim 
		(id, code, type, amount, valid_from, valid_to, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(promotion_key) as max_key
		from bi_project_galaxy_schema.promotion_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.promotion_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
		
	else
    
		#check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select promotion_key, id, Activation_Flag,
			rank() over(partition by id, Activation_Flag order by promotion_key asc) as col_rank
			from bi_project_galaxy_schema.promotion_dim
			where Activation_Flag = 1
			);
		
	   
	   #keep one record only of the duplicates with the latest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.promotion_dim
	   where promotion_key in (select promotion_key from temp_duplicates_check where col_rank <> 1);
    
    
    
    
    
    
    
    
		#Get new promotions
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT a.id, a.code, a.type, a.amount, a.valid_from, a.valid_to
		FROM bi_project_db.promotion a
		where a.id not in
		(select id from bi_project_galaxy_schema.promotion_dim where activation_flag = 1)
		);


		insert into bi_project_galaxy_schema.promotion_dim 
		(id, code, type, amount, valid_from, valid_to, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active promotions from the promotion dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct a.id, a.code, a.type, a.amount, a.valid_from, a.valid_to
		FROM bi_project_galaxy_schema.promotion_dim a
        where activation_flag = 1
		);
		
        #Get the latest data of the active promotions in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT a.id, a.code, a.type, a.amount, a.valid_from, a.valid_to
		FROM bi_project_db.promotion a
		where a.id in
		(select id from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.id
		where (a.code <> b.code) or (a.type <> b.type) or (a.amount <> b.amount) 
        or (a.valid_from <> b.valid_from)  or (a.valid_to <> b.valid_to) 
		);

        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.promotion_dim
        set activation_flag = 0, Active_To = current_date
        where id in (select id from dim_temp_updated_records)
        and
        activation_flag = 1;

        #Insert the updated version of the records and set them as active in the dimension 
        insert into bi_project_galaxy_schema.promotion_dim 
		(id, code, type, amount, valid_from, valid_to, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(promotion_key) as max_key
		from bi_project_galaxy_schema.promotion_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.promotion_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
	end if;
    
    drop temporary table if exists temp_duplicates_check;
	drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Purchase_Invoices_Fact` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Purchase_Invoices_Fact`()
BEGIN
    
	drop temporary table if exists fact_temp_stg;
	drop temporary table if exists fact_temp;
	drop temporary table if exists fact_temp_delta_stg;
	drop temporary table if exists fact_temp_delta;
	drop temporary table if exists fact_temp_incomplete_pipeline;
	drop temporary table if exists temp_source_complete_pipeline;
	drop temporary table if exists fact_temp_updates;
    drop temporary table if exists current_Key1;
	drop temporary table if exists current_Key2;
    drop temporary table if exists current_Key3;
    drop temporary table if exists current_Key4;
    
    set @records_count = (select count(*) from bi_project_galaxy_schema.purchase_invoices_fact);
    
    if @records_count = 0 then
    
 
		#create the fact table from the oltp tables
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_stg AS
		(
			select h.id as Order_ID, h.order_date, h.expected_arrival_date, max_date.latest_invoice_date, h.supplierid,
			 h.branchid, h.employeeid, d.line_number, d.raw_materialID, d.ordered_quantity, d.ordered_value,
			 inv.Invoiced_Quantity, inv.Invoiced_Amount
			from bi_project_db.purchase_order_details d
			left join bi_project_db.purchase_order h on d.purchase_orderid = h.id
			left join 
			(
				select purchase_orderid, raw_materialID, sum(invoiced_quantity) Invoiced_Quantity, sum(invoiced_amount) Invoiced_Amount
				from bi_project_db.invoice_details d
				left join bi_project_db.invoice h on d.invoiceid = h.id
                where h.date <= current_Date() #the source system system creates all invoices in advance, this condition makes sure 
                #to load invoices in the DWH up to today only. when invoice date is >= current_Date, the new invoices created
                # in the source system will be inserted in the DWH, so the invoiced qty will be updated as days pass.
                #in the DWH
				group by purchase_orderid, raw_materialID
			)
			inv on h.id = inv.purchase_orderid and d.raw_materialID = inv.raw_materialID
			left join 
			(
				select h.purchase_orderid,  max(h.date) as latest_invoice_date
				from bi_project_db.invoice h
                where h.date <= current_Date()
				group by h.purchase_orderid
			)
			max_date on h.id = max_date.purchase_orderid

		);



		#populate the surrogate keys
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp AS
		(
			select Order_ID, od.date_key as Order_Date_Key, ed.date_key as Expected_Arrival_Date_Key,
			ad.date_key as Latest_Invoice_Date_Key, s.supplier_Key, br.Branch_Key, e.Employee_Key,
			main.line_number, rm.raw_material_key, main.ordered_quantity, main.ordered_value,
			main.Invoiced_Quantity, main.Invoiced_Amount, NULL as Lead_Time_Days,
			NULL as Arrival_Delay_Days

			from fact_temp_stg main
			left join date_dim od on cast(main.order_date as date) = od.date 
			left join date_dim ed on cast(main.expected_arrival_date as date) = ed.date
			left join date_dim ad on cast(main.latest_invoice_date as date) = ad.date
			left join supplier_dim s on main.supplierid = s.id
				and s.Activation_Flag = 1
			left join branch_dim br on main.branchid = br.id
				and br.Activation_Flag = 1
			left join employee_dim e on main.employeeid = e.employee_id
				and e.Activation_Flag = 1
			left join raw_material_dim rm on main.raw_materialID = rm.id
				and rm.Activation_Flag = 1
		);



		insert into bi_project_galaxy_schema.purchase_invoices_fact
		(
		Purchase_Order_ID, Purchase_Order_Date_Key, Expected_Arrival_Date_Key, Last_Invoice_Date_Key, Line_Number,
		Raw_Material_Key, Ordered_Employee_Key, Branch_Key, Supplier_Key, Ordered_Quantity, Invoiced_Quantity,
		Ordered_Amount, Invoiced_Amount, Lead_Time_Days, Arrival_Delay_Days, Loading_Time_Stamp 

		)
		select  Order_ID, Order_Date_Key, ifnull(Expected_Arrival_Date_Key,0), Latest_Invoice_Date_Key, 
		line_number, raw_material_key, Employee_Key, Branch_Key, supplier_Key, ordered_quantity,
		Invoiced_Quantity, ordered_value, Invoiced_Amount, Lead_Time_Days, Arrival_Delay_Days, now()
		from fact_temp main;
        
        

        #Add the current raw_material key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key1 AS
		(
		select Raw_Material_Key, last_key
		from bi_project_galaxy_schema.raw_material_dim
		);
        
        UPDATE bi_project_galaxy_schema.purchase_invoices_fact main
        INNER JOIN current_Key1 as t1 ON main.Raw_Material_Key = t1.Raw_Material_Key
		SET main.Current_Raw_Material_Key = t1.last_key;



        #Add the current ordered employee key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key2 AS
		(
		select Employee_Key, last_key
		from bi_project_galaxy_schema.employee_dim
		);
        
        UPDATE bi_project_galaxy_schema.purchase_invoices_fact main
        INNER JOIN current_Key2 as t1 ON main.Ordered_Employee_Key = t1.Employee_Key
		SET main.current_Ordered_Employee_Key = t1.last_key;



        #Add the current branch key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key3 AS
		(
		select Branch_Key, last_key
		from bi_project_galaxy_schema.branch_dim
		);
        
        UPDATE bi_project_galaxy_schema.purchase_invoices_fact main
        INNER JOIN current_Key3 as t1 ON main.branch_key = t1.Branch_Key
		SET main.Current_Branch_Key = t1.last_key;
        
        
        
		#Add the current supplier key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key4 AS
		(
		select Supplier_Key, last_key
		from bi_project_galaxy_schema.supplier_dim
		);
        
        UPDATE bi_project_galaxy_schema.purchase_invoices_fact main
        INNER JOIN current_Key4 as t1 ON main.Supplier_Key = t1.Supplier_Key
		SET main.Current_Supplier_Key= t1.last_key;
        



		#get records from the fact table that do not have their pipeline process completed yet (invoiced quantity < ordered quantity)
        #or invoiced quantity is equal to the ordered quantity but the lead and delay days have not been filled in the fact yet

		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_incomplete_pipeline AS
		(
		select ID, Purchase_Order_ID, Line_Number, Raw_Material_Key
		from bi_project_galaxy_schema.purchase_invoices_fact main
		where (Invoiced_Quantity = Ordered_Quantity and (Lead_Time_Days is null or Arrival_Delay_Days is null)) or
        Invoiced_Quantity < Ordered_Quantity
		);


		#get records from the source tables that have a complete pipeline (invoiced quantity = ordered quantity) 
		#populate the actual arrival date key (the new Latest_Invoice_Date_Key)
		#populate the raw material key because it will be used in the join in the next step

		CREATE TEMPORARY TABLE IF NOT EXISTS temp_source_complete_pipeline AS
		(
			select h.id as Order_ID,  max_date.latest_invoice_date, ad.date_key as Latest_Invoice_Date_Key,
            d.line_number, d.raw_materialID, rm.raw_material_key, inv.Invoiced_Quantity,
            inv.Invoiced_Amount, h.order_date, h.expected_arrival_date
			
			from bi_project_db.purchase_order_details d
			left join bi_project_db.purchase_order h on d.purchase_orderid = h.id
			left join 
			(
				select purchase_orderid, raw_materialID, sum(invoiced_quantity) Invoiced_Quantity, sum(invoiced_amount) Invoiced_Amount
				from bi_project_db.invoice_details d
				left join bi_project_db.invoice h on d.invoiceid = h.id
                where h.date <= current_Date() #the source system system creates all invoices in advance, this condition makes sure 
                #to load invoices in the DWH up to today only. when invoice date is >= current_Date, the new invoices created
                # in the source system will be inserted in the DWH, so the invoiced qty will be updated as days pass.
                #in the DWH
				group by purchase_orderid, raw_materialID
			)
			inv on h.id = inv.purchase_orderid and d.raw_materialID = inv.raw_materialID
			left join 
			(
				select h.purchase_orderid,  max(h.date) as latest_invoice_date
				from bi_project_db.invoice h
				where h.date <= current_Date()
				group by h.purchase_orderid
			)
			max_date on h.id = max_date.purchase_orderid
			left join date_dim ad on cast(max_date.latest_invoice_date as date) = ad.date
			left join raw_material_dim rm on d.raw_materialID = rm.id

			where inv.Invoiced_Quantity = d.ordered_quantity
		);

		 #the ID of this temp will be joined with the ID in the fact table in the next step to update the fact table
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_updates AS
		(
			select a.id, b.Invoiced_Quantity, b.Invoiced_Amount, b.Latest_Invoice_Date_Key, 
			datediff(b.latest_invoice_date, b.order_date) as Lead_Time_Days,
			datediff(b.expected_arrival_date, b.latest_invoice_date) as Arrival_Delay_Days
			from fact_temp_incomplete_pipeline a
			inner join temp_source_complete_pipeline b on a.Purchase_Order_ID = b.order_id
				and a.Raw_Material_Key = b.raw_material_key
				and a.Line_Number = b.line_number
		);


		 #update the records using the ID of the fact table 
		 UPDATE bi_project_galaxy_schema.purchase_invoices_fact main 
		 INNER JOIN fact_temp_updates updates ON main.id = updates.id

		SET 
		main.Last_Invoice_Date_Key = updates.Latest_Invoice_Date_Key,
		main.Invoiced_Quantity = updates.Invoiced_Quantity,
		main.Invoiced_Amount = updates.Invoiced_Amount,
		main.Lead_Time_Days = updates.Lead_Time_Days,
		main.Arrival_Delay_Days = updates.Arrival_Delay_Days,
		main.Loading_Time_Stamp = now();



	else
    
    
		#get the latest date of the data in the fact table
		set @delta =
		(
		select max(d.date)
		from bi_project_galaxy_schema.purchase_invoices_fact main
		inner join bi_project_galaxy_schema.date_dim d on main.Purchase_Order_Date_Key = d.date_key
		); 


		#delete all records of the max date because data may not be complete on that day
		delete main
		from bi_project_galaxy_schema.purchase_invoices_fact main
		inner join bi_project_galaxy_schema.date_dim d on main.Purchase_Order_Date_Key = d.date_key
		where d.date = @delta;


		#get all records where the order date in the source is >= than the max order date in the fact table
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_delta_stg AS
		(
			select h.id as Order_ID, h.order_date, h.expected_arrival_date, max_date.latest_invoice_date, h.supplierid,
			 h.branchid, h.employeeid, d.line_number, d.raw_materialID, d.ordered_quantity, d.ordered_value,
			 inv.Invoiced_Quantity, inv.Invoiced_Amount
			from bi_project_db.purchase_order_details d
			left join bi_project_db.purchase_order h on d.purchase_orderid = h.id
			left join 
			(
				select purchase_orderid, raw_materialID, sum(invoiced_quantity) Invoiced_Quantity, sum(invoiced_amount) Invoiced_Amount
				from bi_project_db.invoice_details d
				left join bi_project_db.invoice h on d.invoiceid = h.id
				where h.date <= current_Date() #the source system system creates all invoices in advance, this condition makes sure 
                #to load invoices in the DWH up to today only. when invoice date is >= current_Date, the new invoices created
                # in the source system will be inserted in the DWH, so the invoiced qty will be updated as days pass.
                #in the DWH
				group by purchase_orderid, raw_materialID
			)
			inv on h.id = inv.purchase_orderid and d.raw_materialID = inv.raw_materialID
			left join 
			(
				select h.purchase_orderid,  max(h.date) as latest_invoice_date
				from bi_project_db.invoice h
                where h.date <= current_Date()
				group by h.purchase_orderid
			)
			max_date on h.id = max_date.purchase_orderid
			
			where h.order_date >= @delta

		);



		#populate the surrogate keys
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_delta AS
		(
			select Order_ID, od.date_key as Order_Date_Key, ed.date_key as Expected_Arrival_Date_Key,
			ad.date_key as Latest_Invoice_Date_Key, s.supplier_Key, br.Branch_Key, e.Employee_Key,
			main.line_number, rm.raw_material_key, main.ordered_quantity, main.ordered_value,
			main.Invoiced_Quantity, main.Invoiced_Amount, NULL as Lead_Time_Days,
			NULL as Arrival_Delay_Days

			from fact_temp_delta_stg main
			left join date_dim od on cast(main.order_date as date) = od.date 
			left join date_dim ed on cast(main.expected_arrival_date as date) = ed.date
			left join date_dim ad on cast(main.latest_invoice_date as date) = ad.date
			left join supplier_dim s on main.supplierid = s.id
				and s.Activation_Flag = 1
			left join branch_dim br on main.branchid = br.id
				and br.Activation_Flag = 1
			left join employee_dim e on main.employeeid = e.employee_id
				and e.Activation_Flag = 1
			left join raw_material_dim rm on main.raw_materialID = rm.id
				and rm.Activation_Flag = 1
		);


		insert into bi_project_galaxy_schema.purchase_invoices_fact
		(
		Purchase_Order_ID, Purchase_Order_Date_Key, Expected_Arrival_Date_Key, Last_Invoice_Date_Key, Line_Number,
		Raw_Material_Key, Ordered_Employee_Key, Branch_Key, Supplier_Key, Ordered_Quantity, Invoiced_Quantity,
		Ordered_Amount, Invoiced_Amount, Lead_Time_Days, Arrival_Delay_Days, Loading_Time_Stamp 

		)
		select  Order_ID, Order_Date_Key, ifnull(Expected_Arrival_Date_Key,0), Latest_Invoice_Date_Key, 
		line_number, raw_material_key, Employee_Key, Branch_Key, supplier_Key, ordered_quantity,
		Invoiced_Quantity, ordered_value, Invoiced_Amount, Lead_Time_Days, Arrival_Delay_Days, now()
		from fact_temp_delta main;
        
        
        
		#Add the current raw_material key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key1 AS
		(
		select Raw_Material_Key, last_key
		from bi_project_galaxy_schema.raw_material_dim
		);
        
        UPDATE bi_project_galaxy_schema.purchase_invoices_fact main
        INNER JOIN current_Key1 as t1 ON main.Raw_Material_Key = t1.Raw_Material_Key
		SET main.Current_Raw_Material_Key = t1.last_key;



        #Add the current ordered employee key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key2 AS
		(
		select Employee_Key, last_key
		from bi_project_galaxy_schema.employee_dim
		);
        
        UPDATE bi_project_galaxy_schema.purchase_invoices_fact main
        INNER JOIN current_Key2 as t1 ON main.Ordered_Employee_Key = t1.Employee_Key
		SET main.current_Ordered_Employee_Key = t1.last_key;



        #Add the current branch key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key3 AS
		(
		select Branch_Key, last_key
		from bi_project_galaxy_schema.branch_dim
		);
        
        UPDATE bi_project_galaxy_schema.purchase_invoices_fact main
        INNER JOIN current_Key3 as t1 ON main.branch_key = t1.Branch_Key
		SET main.Current_Branch_Key = t1.last_key;
        
        
        
		#Add the current supplier key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key4 AS
		(
		select Supplier_Key, last_key
		from bi_project_galaxy_schema.supplier_dim
		);
        
        UPDATE bi_project_galaxy_schema.purchase_invoices_fact main
        INNER JOIN current_Key4 as t1 ON main.Supplier_Key = t1.Supplier_Key
		SET main.Current_Supplier_Key= t1.last_key;
        


		#get records from the fact table that do not have their pipeline process completed yet (invoiced quantity < ordered quantity)
        #or invoiced quantity is equal to the ordered quantity but the lead and delay days have not been filled in the fact yet

		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_incomplete_pipeline AS
		(
		select ID, Purchase_Order_ID, Line_Number, Raw_Material_Key
		from bi_project_galaxy_schema.purchase_invoices_fact main
		where ((Invoiced_Quantity = Ordered_Quantity) and (Lead_Time_Days is null or Arrival_Delay_Days is null)) or
        Invoiced_Quantity < Ordered_Quantity
		);



		#get records from the source tables that have a complete pipeline (invoiced quantity = ordered quantity) 
		#populate the actual arrival date key (the new Latest_Invoice_Date_Key)
		#populate the raw material key because it will be used in the join in the next step

		CREATE TEMPORARY TABLE IF NOT EXISTS temp_source_complete_pipeline AS
		(
			select h.id as Order_ID,  max_date.latest_invoice_date, ad.date_key as Latest_Invoice_Date_Key,
            d.line_number, d.raw_materialID, rm.raw_material_key, inv.Invoiced_Quantity,
            inv.Invoiced_Amount, h.order_date, h.expected_arrival_date
			
			from bi_project_db.purchase_order_details d
			left join bi_project_db.purchase_order h on d.purchase_orderid = h.id
			left join 
			(
				select purchase_orderid, raw_materialID, sum(invoiced_quantity) Invoiced_Quantity, sum(invoiced_amount) Invoiced_Amount
				from bi_project_db.invoice_details d
				left join bi_project_db.invoice h on d.invoiceid = h.id
				where h.date <= current_Date() #the source system system creates all invoices in advance, this condition makes sure 
                #to load invoices in the DWH up to today only. when invoice date is >= current_Date, the new invoices created
                # in the source system will be inserted in the DWH, so the invoiced qty will be updated as days pass.
                #in the DWH
				group by purchase_orderid, raw_materialID
			)
			inv on h.id = inv.purchase_orderid and d.raw_materialID = inv.raw_materialID
			left join 
			(
				select h.purchase_orderid,  max(h.date) as latest_invoice_date
				from bi_project_db.invoice h
                where h.date <= current_Date()
				group by h.purchase_orderid
			)
			max_date on h.id = max_date.purchase_orderid
			left join date_dim ad on cast(max_date.latest_invoice_date as date) = ad.date
			left join raw_material_dim rm on d.raw_materialID = rm.id

			where inv.Invoiced_Quantity = d.ordered_quantity
		);
        


		 #the ID of this temp will be joined with the ID in the fact table in the next step to update the fact table
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_updates AS
		(
			select a.id, b.Invoiced_Quantity, b.Invoiced_Amount, b.Latest_Invoice_Date_Key, 
			datediff(b.latest_invoice_date, b.order_date) as Lead_Time_Days,
			datediff(b.expected_arrival_date, b.latest_invoice_date) as Arrival_Delay_Days
			from fact_temp_incomplete_pipeline a
			inner join temp_source_complete_pipeline b on a.Purchase_Order_ID = b.order_id
				and a.Raw_Material_Key = b.raw_material_key
				and a.Line_Number = b.line_number
		);


		 #update the records using the ID of the fact table 
		 UPDATE bi_project_galaxy_schema.purchase_invoices_fact main 
		 INNER JOIN fact_temp_updates updates ON main.id = updates.id

		SET 
		main.Last_Invoice_Date_Key = updates.Latest_Invoice_Date_Key,
		main.Invoiced_Quantity = updates.Invoiced_Quantity,
		main.Invoiced_Amount = updates.Invoiced_Amount,
		main.Lead_Time_Days = updates.Lead_Time_Days,
		main.Arrival_Delay_Days = updates.Arrival_Delay_Days,
		main.Loading_Time_Stamp = now();
        
	end if;

	drop temporary table if exists fact_temp_stg;
	drop temporary table if exists fact_temp;
	drop temporary table if exists fact_temp_delta_stg;
	drop temporary table if exists fact_temp_delta;
	drop temporary table if exists fact_temp_incomplete_pipeline;
	drop temporary table if exists temp_source_complete_pipeline;
	drop temporary table if exists fact_temp_updates;
    drop temporary table if exists current_Key1;
	drop temporary table if exists current_Key2;
    drop temporary table if exists current_Key3;
    drop temporary table if exists current_Key4;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Raw_Material_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Raw_Material_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table
	set @records_count = (select count(*) from bi_project_galaxy_schema.raw_material_dim);
    
      SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175

	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		SELECT * 
		FROM bi_project_db.raw_material
		);
		
		insert into bi_project_galaxy_schema.raw_material_dim
        (ID, Name, Category, Cost_Price, Unit_Of_Measure, Unit_Value, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(raw_material_key) as max_key
		from bi_project_galaxy_schema.raw_material_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.raw_material_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
		
	else
    
       #check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select raw_material_key, id, Activation_Flag,
			rank() over(partition by id, Activation_Flag order by raw_material_key asc) as col_rank
			from bi_project_galaxy_schema.raw_material_dim
			where Activation_Flag = 1
			);
		
	   
	   #keep one record only of the duplicates with the earliest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.raw_material_dim
	   where raw_material_key in (select raw_material_key from temp_duplicates_check where col_rank <> 1);
    


		#Get new raw materials
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT * 
		FROM bi_project_db.raw_material
		where id not in
		(select id from bi_project_galaxy_schema.raw_material_dim where Activation_Flag = 1)
		);

		insert into bi_project_galaxy_schema.raw_material_dim
        (ID, Name, Category, Cost_Price, Unit_Of_Measure, Unit_Value, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active raw materials from the raw material dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct id, a.name, category, Unit_Of_Measure, Unit_Value, cost_price
		FROM bi_project_galaxy_schema.raw_material_dim a
        where activation_flag = 1
		);
		
        #Get the latest data of the active raw materials in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT * 
		FROM bi_project_db.raw_material
		where id in
		(select id from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.id
		where (a.name <> b.name) or (a.category <> b.category) or (a.cost_price <> b.cost_price)
        or (a.Unit_Of_Measure <> b.Unit_Of_Measure) or (a.Unit_Value <> b.Unit_Value)
		);
        
        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.raw_material_dim
        set Activation_Flag = 0, Active_To = current_date
        where id in (select id from dim_temp_updated_records)
        and
        activation_flag = 1;

        #Insert the updated version of the records and set them as active in the dimension 
        insert into bi_project_galaxy_schema.raw_material_dim
        (ID, Name, Category, Cost_Price, Unit_Of_Measure, Unit_Value, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(raw_material_key) as max_key
		from bi_project_galaxy_schema.raw_material_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.raw_material_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
	end if;
    
	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
	drop temporary table if exists max_key;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Raw_Material_Stock_Fact` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Raw_Material_Stock_Fact`()
Begin

    
    #create a variable that has today's date key from the date dimension
    #this variable will be inserted in the raw_material_stock_fact as the date_key.

	drop temporary table if exists fact_temp;
	drop temporary table if exists active_raw_materials_temp;
	drop temporary table if exists active_branches_temp;

		
	set @date_key = (select date_key from  bi_project_galaxy_schema.date_dim where date = current_date);


    
    CREATE TEMPORARY TABLE IF NOT EXISTS active_raw_materials_temp AS 
	(
    select raw_material_Key, id
	from bi_project_galaxy_schema.raw_material_dim
    where Activation_Flag = 1
    );
    
	CREATE TEMPORARY TABLE IF NOT EXISTS active_branches_temp AS 
	(
    select branch_Key, id
	from bi_project_galaxy_schema.branch_dim
    where Activation_Flag = 1
    );
    
	CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp AS 
	(
    select rm.raw_material_Key, b.Branch_Key, @date_key, available_quantity
	from bi_project_db.raw_material_stock f
    left join active_raw_materials_temp rm on f.raw_materialID = rm.ID
    left join active_branches_temp b on f.BranchID = b.ID
    );
    
    

	delete 
    from bi_project_galaxy_schema.raw_material_stock_fact
    where date_key = @date_key;
    
    
	insert into bi_project_galaxy_schema.raw_material_stock_fact
    (raw_material_Key, Branch_Key, date_key, Available_Quantity, Loading_Time_Stamp)
    select a.*, NOW()
    from fact_temp a;

    drop temporary table if exists fact_temp;
	drop temporary table if exists active_raw_materials_temp;
	drop temporary table if exists active_branches_temp;
    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Route_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Route_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table
	set @records_count = (select count(*) from bi_project_galaxy_schema.route_dim);
    
    SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175

	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
	drop temporary table if exists max_key;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		select r.id, r.code, b.name as from_branch, a.name as last_Destination_Stop, r.Total_Kilometers_Distance, r.Average_Minutes_Duration
		from bi_project_db.route r
		left join bi_project_db.branch b on r.From_Branch = b.id
		left join bi_project_db.area a on r.last_Destination_Stop = a.id
		);
		
		insert into bi_project_galaxy_schema.route_dim
        (ID, Code, From_Branch, Last_Stop, Total_Kilometers_Distance, Average_Minutes_Duration, Is_Active, Active_From, Active_To)
		select a.id, a.code, from_branch, last_Destination_Stop, Total_Kilometers_Distance,
        Average_Minutes_Duration, 1, current_date, NULL
		from dim_temp a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(route_key) as max_key
		from bi_project_galaxy_schema.route_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.route_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
		
	else
    
       #check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select route_key, id, Is_Active,
			rank() over(partition by id, Is_Active order by route_key asc) as col_rank
			from bi_project_galaxy_schema.route_dim
			where Is_Active = 1
			);
            
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(route_key) as max_key
		from bi_project_galaxy_schema.route_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.route_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
		
	   
	   #keep one record only of the duplicates with the earliest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.route_dim
	   where route_key in (select route_key from temp_duplicates_check where col_rank <> 1);
    

		#Get new routes
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT * 
		FROM bi_project_db.route
		where id not in
		(select id from bi_project_galaxy_schema.route_dim where Is_Active = 1)
		);

		insert into bi_project_galaxy_schema.route_dim
        (ID, Code, From_Branch, Last_Stop, Total_Kilometers_Distance, Average_Minutes_Duration, Is_Active, Active_From, Active_To)
		select a.id, a.code, from_branch, last_Destination_Stop, Total_Kilometers_Distance,
        Average_Minutes_Duration, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active routes from the route dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT a.ID, a.Code, From_Branch, Last_Stop, Total_Kilometers_Distance, Average_Minutes_Duration
		FROM bi_project_galaxy_schema.route_dim a
        where Is_Active = 1
		);
		
        #Get the latest data of the active routes in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		select r.id, r.code, b.name as from_branch, a.name as last_Destination_Stop, r.Total_Kilometers_Distance, r.Average_Minutes_Duration
		from bi_project_db.route r
		left join bi_project_db.branch b on r.From_Branch = b.id
		left join bi_project_db.area a on r.last_Destination_Stop = a.id
		where r.id in
		(select id from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.id
		where (a.code <> b.code) or (a.From_Branch <> b.From_Branch) or (a.last_Destination_Stop <> b.Last_Stop) or
        (a.Total_Kilometers_Distance <> b.Total_Kilometers_Distance) or (a.Average_Minutes_Duration <> b.Average_Minutes_Duration)
		);
        
        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.route_dim
        set Is_Active = 0, Active_To = current_date
        where id in (select id from dim_temp_updated_records)
        and
        Is_Active = 1;

        #Insert the updated version of the records and set them as active in the dimension
        insert into bi_project_galaxy_schema.route_dim
        (ID, Code, From_Branch, Last_Stop, Total_Kilometers_Distance, Average_Minutes_Duration, Is_Active, Active_From, Active_To)
		select a.id, a.code, from_branch, last_Destination_Stop, Total_Kilometers_Distance,
        Average_Minutes_Duration, 1, current_date, NULL
		from dim_temp_updated_records a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(route_key) as max_key
		from bi_project_galaxy_schema.route_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.route_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
	end if;
    
	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
	drop temporary table if exists max_key;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Sales_Junk_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Sales_Junk_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table
	set @records_count = (select count(*) from bi_project_galaxy_schema.sales_order_junk_dim);
    
    SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175

	drop table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop table if exists dim_temp_updated_records;
	drop table if exists max_key;

	if @records_count = 0 then

		#Get all records from the source system
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		select a.id Order_Method_ID, a.description Order_Method_Description, b.id Payment_Type_ID,
        b.description Payment_Type_Description, c.id Return_Reason_ID, c.description Return_Reason_Description
        
		from bi_project_db.order_method a
		cross join bi_project_db.payment_type b
		cross join 
			(
            select * from bi_project_db.return_reason
            union all
            select NULL, NULL
            ) c
		); #added the union all and NULLs to cover the scenario if there are no returns on the line level.
			#the nulls will be later subsituted with 0's using ifnull(return_reasonid,0) so that a match can be made
            #when joining with the source system to generate the junk_key when creating the sales fact table in the procedure
            #SP_Sales_Order_Details_Fact()
        
        
		insert into bi_project_galaxy_schema.sales_order_junk_dim 
		(Order_Method_ID, Order_Method_Description, Payment_Type_ID, Payment_Type_Description,
        Return_Reason_ID, Return_Reason_Description, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select order_method_id, payment_type_id, Return_Reason_ID, max(junk_key) as max_key
		from bi_project_galaxy_schema.sales_order_junk_dim
		group by order_method_id, payment_type_id, Return_Reason_ID
		);
        
        UPDATE bi_project_galaxy_schema.sales_order_junk_dim main
        INNER JOIN max_key as t1 ON
			main.Order_Method_ID = t1.Order_Method_ID and
            main.Payment_Type_ID = t1.Payment_Type_ID and
            main.Return_Reason_ID = t1.Return_Reason_ID
		SET main.Last_Key = t1.max_key;
		
	else
    
    #check if source system primary key duplicates SP_Sales_Junk_DIM are found in the dimension when the record is active
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
		(
		select junk_key, Order_Method_ID, Payment_Type_ID, Return_Reason_ID, Activation_Flag,
		rank() over(partition by Order_Method_ID, Payment_Type_ID, Return_Reason_ID, Return_Reason_Description,
        Activation_Flag order by Junk_Key asc) as col_rank
		from bi_project_galaxy_schema.sales_order_junk_dim
		where Activation_Flag = 1
		);
    
   
   #keep one record only of the duplicates with the earliest dimension key and delete the rest
   delete from bi_project_galaxy_schema.sales_order_junk_dim
   where junk_Key in (select junk_key from temp_duplicates_check where col_rank <> 1);
    
    
    
    #Get all records from the source system
    CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		select a.id Order_Method_ID, a.description Order_Method_Description, b.id Payment_Type_ID,
        b.description Payment_Type_Description, c.id Return_Reason_ID, c.description Return_Reason_Description
        
		from bi_project_db.order_method a
		cross join bi_project_db.payment_type b
		cross join 
			(
            select * from bi_project_db.return_reason
            union all
            select NULL, NULL
            ) c
		);
    
    
		#Get current active records from the sales order junk dimension
		CREATE TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT Junk_Key, Order_Method_ID, Order_Method_Description, Payment_Type_ID, Payment_Type_Description,
        Return_Reason_ID, Return_Reason_Description
		FROM bi_project_galaxy_schema.sales_order_junk_dim a
        where activation_flag = 1
		);
    

    
		#Get new records
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		select a.* 
        from dim_temp a
        left join dim_temp_active_records b on
			ifnull(a.Order_Method_ID,0) = ifnull(b.Order_Method_ID,0) and
            ifnull(a.Payment_Type_ID,0) = ifnull(b.Payment_Type_ID,0) and
            ifnull(a.Return_Reason_ID,0) = ifnull(b.Return_Reason_ID,0)
            where b.order_method_id is null #get records that are not in the source system
		);


		insert into bi_project_galaxy_schema.sales_order_junk_dim 
		(Order_Method_ID, Order_Method_Description, Payment_Type_ID, Payment_Type_Description,
        Return_Reason_ID, Return_Reason_Description, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		
		#Get the latest data of the active records in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		select b.junk_key,  a.Order_Method_ID, a.Order_Method_Description, a.Payment_Type_ID,
        a.Payment_Type_Description, a.Return_Reason_ID, a.Return_Reason_Description
		from dim_temp a
		inner join dim_temp_active_records b on
			a.Order_Method_ID = b.Order_Method_ID and
            a.Payment_Type_ID = b.Payment_Type_ID and
            a.Return_Reason_ID = b.Return_Reason_ID
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on 
			a.Order_Method_ID = b.Order_Method_ID and
            a.Payment_Type_ID = b.Payment_Type_ID and
            a.Return_Reason_ID = b.Return_Reason_ID
            
		where
        (a.Order_Method_Description <> b.Order_Method_Description) or
        (a.Payment_Type_Description <> b.Payment_Type_Description) or 
        (a.Return_Reason_Description <> b.Return_Reason_Description) 
		);
        


        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.sales_order_junk_dim
        set activation_flag = 0, Active_To = current_date
		where 
        (
		junk_key in (select junk_Key from dim_temp_updated_records)
        )
        and
        activation_flag = 1;


       #Insert the updated version of the records and set them as active in the dimension 
        insert into bi_project_galaxy_schema.sales_order_junk_dim 
		(Order_Method_ID, Order_Method_Description, Payment_Type_ID, Payment_Type_Description,
        Return_Reason_ID, Return_Reason_Description, Activation_Flag, Active_From, Active_To)
		select a.Order_Method_ID, a.Order_Method_Description, a.Payment_Type_ID,
        a.Payment_Type_Description, a.Return_Reason_ID, a.Return_Reason_Description, 
        1, current_date, NULL
		from dim_temp_updated_records a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select order_method_id, payment_type_id, Return_Reason_ID, max(junk_key) as max_key
		from bi_project_galaxy_schema.sales_order_junk_dim
		group by order_method_id, payment_type_id, Return_Reason_ID
		);
        
        UPDATE bi_project_galaxy_schema.sales_order_junk_dim main
        INNER JOIN max_key as t1 ON
			main.Order_Method_ID = t1.Order_Method_ID and
            main.Payment_Type_ID = t1.Payment_Type_ID and
            main.Return_Reason_ID = t1.Return_Reason_ID
		SET main.Last_Key = t1.max_key;
        
	end if;
    
	drop table if exists temp_duplicates_check;
	drop temporary table if exists dim_temp;
    drop table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop table if exists dim_temp_updated_records;
    drop table if exists max_key;
    

    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Sales_Order_Details_Fact` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Sales_Order_Details_Fact`()
BEGIN


	set @records_count = (select count(*) from bi_project_galaxy_schema.sales_order_details_fact);

	   drop temporary table if exists fact_temp_stg;
       drop temporary table if exists fact_temp;
       drop temporary table if exists fact_temp_delta_stg;
       drop temporary table if exists fact_temp_delta;
       drop temporary table if exists fact_temp_incomplete_pipeline;
       drop temporary table if exists fact_temp_updates_check;
       drop temporary table if exists fact_temp_returns_check;
       drop temporary table if exists fact_temp_source_returns;
       drop temporary table if exists fact_temp_returns_after_updating_records;
	   drop temporary table if exists current_Key1;
       drop temporary table if exists current_Key2;
       drop temporary table if exists current_Key3;
       
       
 

	if @records_count = 0 then

		#create the fact table from the oltp tables
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_stg AS
		(
		select od.orderid, od.Order_Line_Number, o.order_date, o.expected_delivery_date, o.actual_delivery_date,
        o.customerid, o.employeeid, od.productid, od.promotionid, o.order_method_id, o.payment_type_id, 
        r.return_reasonid, r.return_date, od.quantity_sold, r.returned_quantity, od.gross_amount, od.net_amount, o.rating,
        r.Returned_Amount

		from bi_project_db.sales_order_details od
		inner join bi_project_db.sales_order o on od.OrderID = o.ID
		left join bi_project_db.returns r on od.ID = r.Order_DetailsID
		left join bi_project_db.return_reason rr on r.return_reasonid = rr.id
		);

		#populate the surrogate keys
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp AS
		(
		select main.orderid, main.Order_Line_Number, od.date_key order_date_key, 
        ed.date_key expected_delivery_date_key, ad.date_key actual_delivery_date_key,
        c.Customer_Key, e.employee_key, prod.product_key, prom.promotion_key, j.Junk_Key,
        rd.Date_Key as return_date_key, main.quantity_sold, main.returned_quantity, main.Returned_Amount,
        main.gross_amount, main.net_amount, main.rating, TIMESTAMPDIFF(HOUR,  main.order_date, main.actual_delivery_date)  as Lead_Time_Hours,
		TIMESTAMPDIFF(MINUTE, main.expected_delivery_date, main.actual_delivery_date)  Delivery_Delay_Minutes
		 
		from fact_temp_stg main
		left join date_dim od on cast(main.order_date as date) = od.date 
		left join date_dim ed on cast(main.expected_delivery_date as date) = ed.date
		left join date_dim ad on cast(main.actual_delivery_date as date) = ad.date
		left join customer_dim c on main.customerid = c.id
			and c.Activation_Flag = 1
		left join employee_dim e on main.employeeid = e.employee_id
			and e.Activation_Flag = 1
		left join product_dim prod on main.productid = prod.id
			and prod.Activation_Flag = 1
		left join promotion_dim prom on main.promotionid = prom.id and 
			prom.Activation_Flag = 1
		left join sales_order_junk_dim j on main.order_method_id = j.Order_Method_ID and
			main.payment_type_id = j.payment_type_id and
			 ifnull(main.return_reasonid,0) = ifnull(j.return_reason_id,0) and
			j.Activation_Flag = 1
		left join date_dim rd on cast(main.return_date as date) = rd.date
		);
		
        insert into bi_project_galaxy_schema.sales_order_details_fact
		(
        Sales_Order_ID, Order_Line_Number, Order_Date_Key, Expected_Delivery_Date_Key, Actual_Delivery_Date_Key,
        Customer_Key, Employee_Key, Product_Key, Promotion_Key, Junk_Dim_Key, Return_Date_Key,
        Quantity_Sold, Net_Quantity, Quantity_Returned, Returned_Amount, Gross_Amount, Net_Amount, Order_Rating, Lead_Time_Hours,
		Delivery_Delay_Minutes, Loading_Time_Stamp
		)
        select orderid, Order_Line_Number, order_date_key, expected_delivery_date_key, actual_delivery_date_key,
        Customer_Key, employee_key, product_key, promotion_key, Junk_Key, return_date_key, quantity_sold, quantity_sold,
        returned_quantity, Returned_Amount, gross_amount, net_amount, rating, Lead_Time_Hours,
		Delivery_Delay_Minutes, now()
        from fact_temp main; 
        
        
		#Add the current customer key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key1 AS
		(
		select customer_Key, last_key
		from bi_project_galaxy_schema.customer_dim
		);
        
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main
        INNER JOIN current_Key1 as t1 ON main.customer_Key = t1.customer_Key
		SET main.Current_customer_Key = t1.last_key;
        
        
		#Add the current employee key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key2 AS
		(
		select employee_Key, last_key
		from bi_project_galaxy_schema.employee_dim
		);
        
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main
        INNER JOIN current_Key2 as t1 ON main.employee_Key = t1.employee_Key
		SET main.Current_employee_Key = t1.last_key;
        
        
		#Add the current product key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key3 AS
		(
		select product_Key, last_key
		from bi_project_galaxy_schema.product_dim
		);
        
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main
        INNER JOIN current_Key3 as t1 ON main.product_Key = t1.product_Key
		SET main.Current_product_Key = t1.last_key;
        
        
        
         #make an assumption that returns can't be made 14 days after the order date

		#get records from the fact table that do not have returns within the last 14 days
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_returns_check AS
		(
        select main.id, main.Sales_Order_ID, Order_Line_Number, od.date as order_date, rd.date as return_date,
        Return_Date_Key, main.quantity_sold, main.Quantity_Returned, main.gross_amount, main.returned_amount,
        main.net_quantity, main.net_amount
        
        from bi_project_galaxy_schema.sales_order_details_fact main        
		LEFT JOIN bi_project_galaxy_schema.date_dim od ON main.Order_Date_Key = od.Date_Key #get order date
        LEFT JOIN bi_project_galaxy_schema.date_dim rd ON main.Return_Date_Key = rd.Date_Key #get return date
        where (Return_Date_Key is null) and (cast(od.date as date) between current_date() - 14 and current_date())
        );
    
    
		#get records from the source that that do have returns 14 days since the order date
        CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_source_returns AS
		(
        select od.orderid, od.Order_Line_Number, o.order_date, r.return_date, r.return_reasonid, 
        od.quantity_sold, r.returned_quantity, r.returned_amount, od.gross_amount, od.net_amount,
        o.order_method_id, o.payment_type_id

		from bi_project_db.sales_order_details od
		inner join bi_project_db.sales_order o on od.OrderID = o.ID
		left join bi_project_db.returns r on od.ID = r.Order_DetailsID
        
        where (r.return_date is not null) and (cast(o.order_date as date) between current_date() - 14 and current_date())
        );
    

		#combine the fact table id with the new values of the columns affected by returns from the source
        #generate the return date key and the new junk dim key
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_returns_after_updating_records AS
        (
		select t_fact.id, t_source.orderid, t_source.Order_Line_Number, t_source.order_date, t_source.return_reasonid,
        t_source.return_date, t_source.quantity_sold, t_source.returned_quantity, t_source.gross_amount, t_source.net_amount,
        t_source.order_method_id, t_source.payment_type_id, rd.Date_Key as return_date_key, j.Junk_Key as junk_key, 
        t_source.Returned_Amount
        from fact_temp_returns_check t_fact
        inner join fact_temp_source_returns t_source on t_fact.Sales_Order_ID = t_source.orderid
			and t_fact.Order_Line_Number = t_source.Order_Line_Number
		inner join bi_project_galaxy_schema.date_dim rd on cast(t_source.return_date as date) = rd.date
        inner join bi_project_galaxy_schema.sales_order_junk_dim j on t_source.order_method_id = j.Order_Method_ID and
			t_source.payment_type_id = j.payment_type_id and
			 ifnull(t_source.return_reasonid,0) = ifnull(j.return_reason_id,0) and
			j.Activation_Flag = 1
		);
    
    
        #update the records using the ID of the fact table 
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main 
        INNER JOIN fact_temp_returns_after_updating_records updates ON main.id = updates.id

		SET
        main.Return_Date_Key = updates.Return_Date_Key,
        main.Junk_Dim_Key = updates.junk_key,
        main.Quantity_Returned = updates.returned_quantity, 
        main.Returned_Amount = updates.Returned_Amount, 
        main.Net_Quantity = updates.Quantity_Sold - updates.returned_quantity, 
        main.Net_Amount = updates.Net_Amount - updates.Returned_Amount,
        main.Loading_Time_Stamp = Now();
        
        
	else
    
    
		#get the latest date of the data in the fact table
		set @delta =
		(
		select max(d.date)
		from bi_project_galaxy_schema.sales_order_details_fact main
		inner join bi_project_galaxy_schema.date_dim d on main.order_date_key = d.date_key
		);
		
		#delete all records of the max date because data may not be complete on that day
		delete main
		from bi_project_galaxy_schema.sales_order_details_fact main
		inner join bi_project_galaxy_schema.date_dim d on main.order_date_key = d.date_key
		where d.date = @delta;
		
        
		#get all records where the order date in the source is >= than the max order date in the fact table
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_delta_stg AS
		(
		select od.orderid, od.Order_Line_Number, o.order_date, o.expected_delivery_date, o.actual_delivery_date,
        o.customerid, o.employeeid, od.productid, od.promotionid, o.order_method_id, o.payment_type_id, 
        r.return_reasonid, r.return_date, od.quantity_sold, r.returned_quantity, od.gross_amount, od.net_amount, o.rating,
        r.Returned_Amount

		from bi_project_db.sales_order_details od
		inner join bi_project_db.sales_order o on od.OrderID = o.ID
		left join bi_project_db.returns r on od.ID = r.Order_DetailsID
		left join bi_project_db.return_reason rr on r.return_reasonid = rr.id
        where o.order_date >= @delta
		);
        
        
        #populate the surrogate keys
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_delta AS
		(
		select main.orderid, main.Order_Line_Number, od.date_key order_date_key, 
        ed.date_key expected_delivery_date_key, ad.date_key actual_delivery_date_key,
        c.Customer_Key, e.employee_key, prod.product_key, prom.promotion_key, j.Junk_Key,
        rd.Date_Key as return_date_key, main.quantity_sold, 
        IFNULL(main.Quantity_Sold - main.returned_quantity, main.Quantity_Sold)  as Net_Quantity,
        main.returned_quantity, main.gross_amount, IFNULL(main.net_amount - main.Returned_Amount, main.net_amount) as Net_Amount,
        main.rating, TIMESTAMPDIFF(HOUR,  main.order_date, main.actual_delivery_date)  as Lead_Time_Hours,
		TIMESTAMPDIFF(MINUTE, main.expected_delivery_date, main.actual_delivery_date)  Delivery_Delay_Minutes, main.Returned_Amount
		 
		from fact_temp_delta_stg main
		left join  bi_project_galaxy_schema.date_dim od on cast(main.order_date as date) = od.date 
		left join  bi_project_galaxy_schema.date_dim ed on cast(main.expected_delivery_date as date) = ed.date
		left join  bi_project_galaxy_schema.date_dim ad on cast(main.actual_delivery_date as date) = ad.date
		left join  bi_project_galaxy_schema.customer_dim c on main.customerid = c.id
			and c.Activation_Flag = 1
		left join  bi_project_galaxy_schema.employee_dim e on main.employeeid = e.employee_id
			and e.Activation_Flag = 1
		left join  bi_project_galaxy_schema.product_dim prod on main.productid = prod.id
			and prod.Activation_Flag = 1
		left join  bi_project_galaxy_schema.promotion_dim prom on main.promotionid = prom.id and 
			prom.Activation_Flag = 1
		left join  bi_project_galaxy_schema.sales_order_junk_dim j on main.order_method_id = j.Order_Method_ID and
			main.payment_type_id = j.payment_type_id and
			 ifnull(main.return_reasonid,0) = ifnull(j.return_reason_id,0) and
			j.Activation_Flag = 1
		left join  bi_project_galaxy_schema.date_dim rd on cast(main.return_date as date) = rd.date
		);
		
        #insert into the fact table the delta records
		insert into bi_project_galaxy_schema.sales_order_details_fact
		(
        Sales_Order_ID, Order_Line_Number, Order_Date_Key, Expected_Delivery_Date_Key, Actual_Delivery_Date_Key,
        Customer_Key, Employee_Key, Product_Key, Promotion_Key, Junk_Dim_Key, Return_Date_Key,
        Quantity_Sold, Net_Quantity, Quantity_Returned, Returned_Amount, Gross_Amount, Net_Amount, Order_Rating, Lead_Time_Hours,
		Delivery_Delay_Minutes, Loading_Time_Stamp
		)
        select orderid, Order_Line_Number, order_date_key, expected_delivery_date_key, actual_delivery_date_key,
        Customer_Key, employee_key, product_key, promotion_key, Junk_Key, return_date_key, quantity_sold, Net_Quantity,
        returned_quantity, Returned_Amount, gross_amount, net_amount, rating, Lead_Time_Hours,
		Delivery_Delay_Minutes, now()
        
        from fact_temp_delta main;  
        
        
        
		#Add the current customer key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key1 AS
		(
		select customer_Key, last_key
		from bi_project_galaxy_schema.customer_dim
		);
        
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main
        INNER JOIN current_Key1 as t1 ON main.customer_Key = t1.customer_Key
		SET main.Current_customer_Key = t1.last_key;
        
        
		#Add the current employee key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key2 AS
		(
		select employee_Key, last_key
		from bi_project_galaxy_schema.employee_dim
		);
        
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main
        INNER JOIN current_Key2 as t1 ON main.employee_Key = t1.employee_Key
		SET main.Current_employee_Key = t1.last_key;
        
        
		#Add the current product key from the dimension to the fact table
        CREATE TEMPORARY TABLE IF NOT EXISTS current_Key3 AS
		(
		select product_Key, last_key
		from bi_project_galaxy_schema.product_dim
		);
        
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main
        INNER JOIN current_Key3 as t1 ON main.product_Key = t1.product_Key
		SET main.Current_product_Key = t1.last_key;
        
        


        #get records in the fact table that do not have their pipeline process completed yet (no actual delivery date)
        CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_incomplete_pipeline AS
		(
        select id, Sales_Order_ID, Order_Line_Number, Order_Date_Key, Expected_Delivery_Date_Key, Actual_Delivery_Date_Key
        from bi_project_galaxy_schema.sales_order_details_fact
        where Actual_Delivery_Date_Key is null
        #the order date and expected delivery date keys will be used in the next step the get the dates from the date dimension
        #those dates will be used to calculate the lead time and delay days after getting the Actual Delivery Date
        );
        
        #Tip- In SQL null is not equal ( = ) to anything—not even to another null.


		#get records from the source table that have a complete pipeline (actual delivery date is not null) 
        #populate the actual delivery date key
        #populate the dates of the order date key and the expected delivery date key
        #the ID of this temp will be joined with the ID in the fact table in the next step to update the fact table
        #those dates will be used to calculate the lead time and delay days after getting the Actual Delivery Date
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_updates_check AS
		(
        select main.id, Sales_Order_ID, Order_Line_Number, o.Actual_Delivery_Date as Source_Actual_Delivery_Date,
        d.date_key as Fact_Actual_Delivery_Date_Key, od.date as order_date, ed.date as expected_delivery_date
        from fact_temp_incomplete_pipeline main
        LEFT join bi_project_db.sales_order o on main.Sales_Order_ID = o.ID
			and Actual_Delivery_Date is not null #get orders with a complete pipeline
        LEFT join bi_project_galaxy_schema.date_dim d on cast(o.Actual_Delivery_Date as date) = d.date 
        #populate the actual delivery date key
		LEFT JOIN bi_project_galaxy_schema.date_dim od ON main.Order_Date_Key = od.Date_Key #get order date
        LEFT JOIN bi_project_galaxy_schema.date_dim ed ON main.Expected_Delivery_Date_Key = ed.Date_Key #get Expected Delivery Date
        );
        
		#I will be updating instead of deleting and re-inserting since this method is better in terms of performance
        
        #update the records using the ID of the fact table 
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main 
        INNER JOIN fact_temp_updates_check updates ON main.id = updates.id

		SET Actual_Delivery_Date_Key = updates.Fact_Actual_Delivery_Date_Key,
        Lead_Time_Hours = datediff(updates.Source_Actual_Delivery_Date, updates.order_date),
        Delivery_Delay_Minutes = datediff(updates.expected_delivery_date, updates.Source_Actual_Delivery_Date);
        
        #make an assumption that returns can't be made 14 days after the order date

		#get records from the fact table that do not have returns within the last 14 days
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_returns_check AS
		(
        select main.id, main.Sales_Order_ID, Order_Line_Number, od.date as order_date, rd.date as return_date,
        Return_Date_Key, main.quantity_sold, main.Quantity_Returned, main.gross_amount, main.returned_amount,
        main.net_quantity, main.net_amount
        
        from bi_project_galaxy_schema.sales_order_details_fact main        
		LEFT JOIN bi_project_galaxy_schema.date_dim od ON main.Order_Date_Key = od.Date_Key #get order date
        LEFT JOIN bi_project_galaxy_schema.date_dim rd ON main.Return_Date_Key = rd.Date_Key #get return date
        where (Return_Date_Key is null) and (cast(od.date as date) between current_date() - 14 and current_date())
        );
    
    
		#get records from the source that that do have returns 14 days since the order date
        CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_source_returns AS
		(
        select od.orderid, od.Order_Line_Number, o.order_date, r.return_date, r.return_reasonid, 
        od.quantity_sold, r.returned_quantity, r.returned_amount, od.gross_amount, od.net_amount,
        o.order_method_id, o.payment_type_id

		from bi_project_db.sales_order_details od
		inner join bi_project_db.sales_order o on od.OrderID = o.ID
		left join bi_project_db.returns r on od.ID = r.Order_DetailsID
        
        where (r.return_date is not null) and (cast(o.order_date as date) between current_date() - 14 and current_date())
        );
    

		#combine the fact table id with the new values of the columns affected by returns from the source
        #generate the return date key and the new junk dim key
		CREATE TEMPORARY TABLE IF NOT EXISTS fact_temp_returns_after_updating_records AS
        (
		select t_fact.id, t_source.orderid, t_source.Order_Line_Number, t_source.order_date, t_source.return_reasonid,
        t_source.return_date, t_source.quantity_sold, t_source.returned_quantity, t_source.gross_amount, t_source.net_amount,
        t_source.order_method_id, t_source.payment_type_id, rd.Date_Key as return_date_key, j.Junk_Key as junk_key, 
        t_source.Returned_Amount
        from fact_temp_returns_check t_fact
        inner join fact_temp_source_returns t_source on t_fact.Sales_Order_ID = t_source.orderid
			and t_fact.Order_Line_Number = t_source.Order_Line_Number
		inner join bi_project_galaxy_schema.date_dim rd on cast(t_source.return_date as date) = rd.date
        inner join bi_project_galaxy_schema.sales_order_junk_dim j on t_source.order_method_id = j.Order_Method_ID and
			t_source.payment_type_id = j.payment_type_id and
			 ifnull(t_source.return_reasonid,0) = ifnull(j.return_reason_id,0) and
			j.Activation_Flag = 1
		);
    
    
        #update the records using the ID of the fact table 
        UPDATE bi_project_galaxy_schema.sales_order_details_fact main 
        INNER JOIN fact_temp_returns_after_updating_records updates ON main.id = updates.id

		SET
        main.Return_Date_Key = updates.Return_Date_Key,
        main.Junk_Dim_Key = updates.junk_key,
        main.Quantity_Returned = updates.returned_quantity, 
        main.Returned_Amount = updates.Returned_Amount, 
        main.Net_Quantity = updates.Quantity_Sold - updates.returned_quantity, 
        main.Net_Amount = updates.Net_Amount - updates.Returned_Amount,
        main.Loading_Time_Stamp = Now();


	end if;
	   drop temporary table if exists fact_temp_stg;
       drop temporary table if exists fact_temp;
       drop temporary table if exists fact_temp_delta_stg;
       drop temporary table if exists fact_temp_delta;
       drop temporary table if exists fact_temp_incomplete_pipeline;
       drop temporary table if exists fact_temp_updates_check;
       drop temporary table if exists fact_temp_returns_check;
       drop temporary table if exists fact_temp_source_returns;
       drop temporary table if exists fact_temp_returns_after_updating_records;
	   drop temporary table if exists current_Key1;
       drop temporary table if exists current_Key2;
       drop temporary table if exists current_Key3;
       
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Supplier_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Supplier_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table
	set @records_count = (select count(*) from bi_project_galaxy_schema.supplier_dim);
    
    SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175

	drop temporary table if exists temp_duplicates_check;
    drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		 SELECT s.ID, s.Name, s.Phone_Number, s.Email, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.supplier s
        inner join bi_project_db.area a on s.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		);
		
		insert into bi_project_galaxy_schema.supplier_dim
        (ID, Name, Phone_Number, Email, Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(supplier_key) as max_key
		from bi_project_galaxy_schema.supplier_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.supplier_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
		
	else
    
       #check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select supplier_key, id, Activation_Flag,
			rank() over(partition by id, Activation_Flag order by supplier_key asc) as col_rank
			from bi_project_galaxy_schema.supplier_dim
			where Activation_Flag = 1
			);
		
	   
	   #keep one record only of the duplicates with the earliest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.supplier_dim
	   where supplier_key in (select supplier_key from temp_duplicates_check where col_rank <> 1);
    
    
    
    
		#Get new suppliers
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT s.ID, s.Name, s.Phone_Number, s.Email, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.supplier s
        inner join bi_project_db.area a on s.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where s.id not in
		(select id from bi_project_galaxy_schema.supplier_dim where Activation_Flag = 1)
		);

		insert into bi_project_galaxy_schema.supplier_dim
         (ID, Name, Phone_Number, Email, Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active suppliers from the supplier dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct ID, Name, Phone_Number, Email, Area_Name, City_Name, Country_Name
		FROM bi_project_galaxy_schema.supplier_dim a
        where activation_flag = 1
		);
		
        #Get the latest data of the active suppliers in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT s.ID, s.Name, s.Phone_Number, s.Email, a.Name area_name, ci.Name city_name, co.Name country_name
		FROM bi_project_db.supplier s
        inner join bi_project_db.area a on s.areaID = a.ID
        inner join bi_project_db.city ci on a.cityID = ci.ID
        inner join bi_project_db.country co on ci.countryID = co.ID
		where s.id in
		(select ID from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.ID
		where (a.Name <> b.Name) or (a.Phone_Number <> b.Phone_Number) or (a.Email <> b.Email) or
        (a.Area_Name <> b.Area_Name) or (a.City_Name <> b.City_Name) or (a.Country_Name <> b.Country_Name)
		);

        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.supplier_dim
        set Activation_Flag = 0, Active_To = current_date
        where ID in (select id from dim_temp_updated_records)
        and
        activation_flag = 1;

        #Insert the updated version of the records and set them as active in the dimension 
		insert into bi_project_galaxy_schema.supplier_dim
		(ID, Name, Phone_Number, Email, Area_Name, City_Name, Country_Name, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(supplier_key) as max_key
		from bi_project_galaxy_schema.supplier_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.supplier_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
	end if;
    
    drop temporary table if exists temp_duplicates_check;
	drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Vehicle_DIM` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Vehicle_DIM`()
BEGIN

	#declare records_count int; #used to get the count of records from the main source table
	set @records_count = (select count(*) from bi_project_galaxy_schema.vehicle_dim);
    
	SET SQL_SAFE_UPDATES = 0; #to prevent MYSQL error 1175

	drop temporary table if exists temp_duplicates_check;
	drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;

	if @records_count = 0 then

		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp AS
		(
		 SELECT v.id, v.brand, v.model, v.year_of_model, v.plate_number, v.license_number
		FROM bi_project_db.vehicle v
		);
		
		insert into bi_project_galaxy_schema.vehicle_dim
        (id, brand, model, year_of_model, plate_number, license_number, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(vehicle_key) as max_key
		from bi_project_galaxy_schema.vehicle_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.vehicle_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
		
	else
    
    
        #check if source system primary key duplicates are found in the dimension when the record is active
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_duplicates_check AS
			(
			select vehicle_key, id, Activation_Flag,
			rank() over(partition by id, Activation_Flag order by vehicle_key asc) as col_rank
			from bi_project_galaxy_schema.vehicle_dim
			where Activation_Flag = 1
			);
		
	   
	   #keep one record only of the duplicates with the earliest dimension key and delete the rest
	   delete from bi_project_galaxy_schema.vehicle_dim
	   where vehicle_key in (select vehicle_key from temp_duplicates_check where col_rank <> 1);
    
    
    
    
		#Get new vehicles
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_new_records AS 
		(
		SELECT v.id, v.brand, v.model, v.year_of_model, v.plate_number, v.license_number
		FROM bi_project_db.vehicle v
		where v.id not in
		(select id from bi_project_galaxy_schema.vehicle_dim where Activation_Flag = 1)
		);

		insert into bi_project_galaxy_schema.vehicle_dim
        (id, brand, model, year_of_model, plate_number, license_number, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_new_records a;
        
		#Get current active vehicles from the vehicle dimension
		CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_active_records AS 
		(
		SELECT distinct id, brand, model, year_of_model, plate_number, license_number
		FROM bi_project_galaxy_schema.vehicle_dim a
        where activation_flag = 1
		);
		
        #Get the latest data of the active vehicles in the dimension from the source system
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_existing_records AS 
		(
		SELECT v.id, v.brand, v.model, v.year_of_model, v.plate_number, v.license_number
		FROM bi_project_db.vehicle v
		where v.id in
		(select ID from dim_temp_active_records)
		);
        
        #Compare records of the source with records in the dimension, and get records that are different
        CREATE TEMPORARY TABLE IF NOT EXISTS dim_temp_updated_records AS 
		(
		SELECT a.*
		FROM dim_temp_existing_records a
		left join dim_temp_active_records b on a.id = b.ID
		where (a.brand <> b.brand) or (a.model <> b.model) or (a.year_of_model <> b.year_of_model) or
        (a.plate_number <> b.plate_number) or (a.license_number <> b.license_number)
		);

        #Mark the records that are different from the source as inactive in the dimension
		update bi_project_galaxy_schema.vehicle_dim
        set Activation_Flag = 0, Active_To = current_date
        where ID in (select id from dim_temp_updated_records)
        and
        activation_flag = 1;

        #Insert the updated version of the records and set them as active in the dimension 
		insert into bi_project_galaxy_schema.vehicle_dim
        (id, brand, model, year_of_model, plate_number, license_number, Activation_Flag, Active_From, Active_To)
		select a.*, 1, current_date, NULL
		from dim_temp_updated_records a;
        
		#Add the last dimension_key for each ID from the source
        CREATE TEMPORARY TABLE IF NOT EXISTS max_key AS
		(
		select id, max(vehicle_key) as max_key
		from bi_project_galaxy_schema.vehicle_dim
		group by id
		);
        
        UPDATE bi_project_galaxy_schema.vehicle_dim main
        INNER JOIN max_key as t1 ON main.id = t1.id
		SET main.Last_Key = t1.max_key;
        
	end if;
    
    drop temporary table if exists temp_duplicates_check;
	drop temporary table if exists dim_temp;
    drop temporary table if exists dim_temp_active_records;
    drop temporary table if exists dim_temp_new_records;
	drop temporary table if exists dim_temp_existing_records;
	drop temporary table if exists dim_temp_updated_records;
    drop temporary table if exists max_key;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-20 11:50:52
