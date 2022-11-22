Project Brief:

Hello Everyone!

I'd like to share this end to end project that covers the 3 main stages of the BI life cycle. Data modeling, ETL development
and the dashboard design.

Before the data warehouse design phase, there must be atleast one data source (for example an OLTP system)
So I designed an ERD that acts as the OLTP system database for a fictional electronics retail company
that I made up based on some research and my limited experience. The ERD covers 3 main processes. Sales, purchasing
and order management. Based on those 3 processes, 5 fact tables where created. The image named BI_Project_Galaxy_Schema
in the folder screenshots is a result of combining the 5 fact tables with the conformed dimensions.

After I designed the ERD, python functions were created based on some business rules to generate and 
insert the data into the tables.

When desiging the Datawarehouse, I applied the type 2 SCD concept to keep track of historical changes. Regarding the fact tables, 3/5 are of the type accumulating snapshot. Each one of the accumulating snaphot fact tables has a different criteria for completing its process pipeline. 2/5 of the fact tables are of the type periodic snapshot

SQL was mainy used to generate the ETL scripts that will load the data warehouse from the OLTP database.
A separate stored procedure was created for each table to fill it in the datawarehouse.

I used airflow for scheduling.

finally, 4 dashbords were created. 1 for each of the 3 main business processes, in addtion to a strategic dashboard
for the top level executives.

I highly recommend the book "The Data Warehouse Toolkit" by Ralph Kimball which helped me alot throughout the project.

***********************************************************************************************************************

Project folders contents:

Visual Paradigm Data Modeling- contains the Visual Paradigm file for data modeling.

Python Scripts- contains the Jupyter notebook file with comments for the python functions used to generate data
		and fill the OLTP database.

Database Scripts- contains the DDL scripts of the databse and the DWH, in addition to the
		 stored procedures definiton in a .SQL file named bi_project_galaxy_schema_routines.sql

DAGS- contains the DAG code used in airflow.

Dashboard- contains the power bi .pbix file for the dashboard

Screenshots- contains screenshots for the dashboards, data models and the Airflow DAG graph.


***********************************************************************************************************************

Tools used and purpose:

1. Oracle VM Virtual Box running Xubuntu- used to create a Linux environment for running airflow.
2. MYSQL- creating ETL scripts
3. Visual Paradigm Community Edition- data modeling
4. Python (Mainly Pandas)- generate data and fill the OLTP database
5. Airflow- pipeline creation and scheduling
6. Power BI- dashboards development



