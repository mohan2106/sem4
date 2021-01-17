#include<bits/stdc++.h>
#include "mysql.h"
#include "db_details.h"

using namespace std;
MYSQL *mysql;
MYSQL_RES *results;
MYSQL_ROW record;


int main()
{
   

   mysql_library_init(0, NULL, NULL);
   mysql = mysql_init(NULL);
   mysql_options(mysql, MYSQL_READ_DEFAULT_GROUP, "libmysqld_client");
   mysql_options(mysql, MYSQL_OPT_USE_EMBEDDED_CONNECTION, NULL);

   if(mysql_real_connect(mysql, host.c_str(),user_name.c_str(),pass.c_str(), db_name.c_str(), 0,NULL,0) == NULL){
     cout<<"not connected\n";
     return 0;
   }

  mysql_query(mysql,"SELECT roll, name, sum(credit) FROM cwsl join cc WHERE cwsl.cid = cc.cid GROUP BY roll,name HAVING SUM(credit)>40;");
  results = mysql_store_result(mysql);

    int count = 0;
  while((record = mysql_fetch_row(results))) {
      printf("%10s - %50s - %3s \n", record[0],record[1],record[2]);
      count++;
      // cout<<"working\n";
  }
  cout<<"Total result := "<<count<<'\n';

  mysql_free_result(results);
  mysql_close(mysql);
  mysql_library_end();
   return 0;
}

