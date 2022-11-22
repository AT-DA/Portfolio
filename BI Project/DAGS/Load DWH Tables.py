from datetime import datetime
from airflow import DAG
from datetime import timedelta
from airflow.utils.dates import days_ago
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.mysql_operator import MySqlOperator


dag_mysql = DAG(
    dag_id='Load_DWH_Tables',
    schedule_interval='@once',
    start_date=days_ago(1),
    dagrun_timeout=timedelta(minutes=60),
    description='load data warehouse tables',
    catchup=False
)



Enable_Updates_SQL = 'SET SQL_SAFE_UPDATES = 0;'
Enable_Updates = MySqlOperator(sql = Enable_Updates_SQL, task_id = 'Enable_Updates', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)


Load_Area_Dim_SQL = 'call SP_Area_DIM();'
Load_Area_Dim = MySqlOperator(sql = Load_Area_Dim_SQL, task_id = 'Load_Area_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Branch_Dim_SQL = 'call SP_Branch_DIM();'
Load_Branch_Dim = MySqlOperator(sql = Load_Branch_Dim_SQL, task_id = 'Load_Branch_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Customer_Dim_SQL = 'call SP_Customer_DIM();'
Load_Customer_Dim = MySqlOperator(sql = Load_Customer_Dim_SQL, task_id = 'Load_Customer_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Date_Dim_SQL = 'call SP_Date_DIM();'
Load_Date_Dim = MySqlOperator(sql = Load_Date_Dim_SQL, task_id = 'Load_Date_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Employee_Dim_SQL = 'call SP_Employee_DIM();'
Load_Employee_Dim = MySqlOperator(sql = Load_Employee_Dim_SQL, task_id = 'Load_Employee_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Product_Dim_SQL = 'call SP_Product_DIM();'
Load_Product_Dim = MySqlOperator(sql = Load_Product_Dim_SQL, task_id = 'Load_Product_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Promotion_Dim_SQL = 'call SP_Promotion_DIM();'
Load_Promotion_Dim = MySqlOperator(sql = Load_Promotion_Dim_SQL, task_id = 'Load_Promotion_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Raw_Material_Dim_SQL = 'call SP_Raw_Material_DIM();'
Load_Raw_Material_Dim = MySqlOperator(sql = Load_Raw_Material_Dim_SQL, task_id = 'Load_Raw_Material_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Route_Dim_SQL = 'call SP_Route_DIM();'
Load_Route_Dim = MySqlOperator(sql = Load_Route_Dim_SQL, task_id = 'Load_Route_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Sales_Junk_Dim_SQL = 'call SP_Sales_Junk_DIM();'
Load_Sales_Junk_Dim = MySqlOperator(sql = Load_Sales_Junk_Dim_SQL, task_id = 'Load_Sales_Junk_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Supplier_Dim_SQL = 'call SP_Supplier_DIM();'
Load_Supplier_Dim = MySqlOperator(sql = Load_Supplier_Dim_SQL, task_id = 'Load_Supplier_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Vehicle_Dim_SQL = 'call SP_Vehicle_DIM();'
Load_Vehicle_Dim = MySqlOperator(sql = Load_Vehicle_Dim_SQL, task_id = 'Load_Vehicle_Dimension', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Sales_Fact_Table_SQL = 'call SP_Sales_Order_Details_Fact;'
Load_Sales_Fact_Table = MySqlOperator(sql = Load_Sales_Fact_Table_SQL, task_id = 'Load_Sales_Fact_Table', mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Purchase_Invoices_Fact_Table_SQL = 'call SP_Purchase_Invoices_Fact();'
Load_Purchase_Invoices_Fact_Table = MySqlOperator(sql = Load_Purchase_Invoices_Fact_Table_SQL, task_id = 'Load_Purchase_Invoices_Fact_Table', \
					mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Load_Orders_Trips_Fact_Table_SQL = 'call SP_Orders_Trips_Fact();'
Load_Orders_Trips_Fact_Table = MySqlOperator(sql = Load_Orders_Trips_Fact_Table_SQL, task_id = 'Load_Orders_Trips_Fact_Table', \
				 mysql_conn_id = 'MYSQL_CONN', dag = dag_mysql)

Dummy_Step = DummyOperator(task_id = 'Dummy_Step_If_All_Success', trigger_rule = 'all_success')
    


Enable_Updates >> [Load_Area_Dim, Load_Branch_Dim, Load_Customer_Dim, Load_Date_Dim,
                   Load_Employee_Dim, Load_Product_Dim,  Load_Promotion_Dim,
                   Load_Raw_Material_Dim, Load_Route_Dim, Load_Sales_Junk_Dim, 
                   Load_Supplier_Dim, Load_Vehicle_Dim] 

[Load_Area_Dim, Load_Branch_Dim, Load_Customer_Dim, Load_Date_Dim, 
                   Load_Employee_Dim, Load_Product_Dim,  Load_Promotion_Dim, 
                   Load_Raw_Material_Dim, Load_Route_Dim, Load_Sales_Junk_Dim, 
                   Load_Supplier_Dim, Load_Vehicle_Dim] >> Dummy_Step

Dummy_Step >> [Load_Sales_Fact_Table, Load_Purchase_Invoices_Fact_Table , Load_Orders_Trips_Fact_Table]




