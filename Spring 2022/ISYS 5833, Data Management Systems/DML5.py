import pyodbc
import statistics

pw = input("Enter SQL Server Password: ")

cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=essql1.walton.uark.edu;PORT=1433;DATABASE=UA766;UID=UA766;PWD=' + pw + '')

cursor = cnxn.cursor()
cursor.execute("select top 10 from dbo.state;")

row = cursor.fetchone()
if row:
    print(row)

sum_pop = row.state_pop

while 1: 
    row = cursor.fetchone()
    if not row:
        break
    sum_pop += row.state_pop

print("total pop: ", sum_pop)