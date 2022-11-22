Project Brief:

Hello Everyone!

This is a complete end to end BI project that covers the 3 main stages in the BI life cycle. Data modeling, ETL development
and the dashboard as the visualization layer.

Before designing the data warehouse design phase, there must be an data source (for example an OLTP system) that
will be used for designing. So designed an ERD that acts as the OLTP system for a fictional electronics retail company
that I made up based on some research and my limited experience. The ERD covers 3 main processes. Sales, purchasing
and order management. Based on those 3 processes, 3 fact tables where created. The image named BI_Project_Galaxy_Schema
in the folder screenshots is a result of combining the 3 fact tables with the conformed dimensions.

After the ERD was created, python functions were created based on some business rules to generate and 
insert the data into the tables.

SQL was mainy used to generate the ETL scripts that will load the galaxy schema from the OLTP database.
A separate stored procedure was created to fill each table in the datawarehouse/galaxy schema.

I used airflow for scheduling.

finally, 4 dashbords were created. 1 for each of the 3 main business processes, in addtion to a strategic dashboard
for the top level executives.

I highly recommend the book "The Data Warehouse Toolkit" by Ralph Kimball which helped me alot throughout the project.

***********************************************************************************************************************

Project folder contents:

DAGS- contains the DAG code used in airflow.

Dashboard- contains the power bi .pbix file for the dashboard

Database Scripts- contains the DDL scripts of the databse and the DWH, in addition to the
		 stored procedures definiton in a .SQL file named bi_project_galaxy_schema_routines.sql

Python Scripts- contains the Jupyter notebook file with comments for the python functions used to generate data
		and fill the OLTP database.

Screenshots- contains screenshots for the dashboards, data models and the Airflow DAG graph.

Visual Paradigm Data Modeling- contains the Visual Paradigm file for data modeling.

***********************************************************************************************************************

Tools used and purpose:

1. Oracle VM Virtual Box running Xubuntu- used to create a linux environment for running airflow.
2. MYSQL- creating ETL scripts
3. Visual Paradigm Community Edition- data modeling
4. Python (Mainly Pandas)- generate data and fill the OLTP database
5. Airflow- pipeline creation and scheduling
6. PowerBI- dashboards development



