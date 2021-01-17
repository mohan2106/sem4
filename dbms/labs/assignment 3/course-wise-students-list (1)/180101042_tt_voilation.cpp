#include<bits/stdc++.h>
#include "mysql.h"
#include "db_details.h"

using namespace std;
MYSQL *mysql;
MYSQL_RES *results;
MYSQL_ROW record;

struct user{
  string roll;
  string name;
  string c1,c2;
  user(string sroll,string sname,string sc1,string sc2){
    roll = sroll;
    name = sname;
    c1 = sc1;
    c2 = sc2;
  }
};

vector<user> arr;

int main()
{

  string query = "SELECT DISTINCT T1.roll, T1.name, T1.cid,T2.cid ";
  query += "FROM (SELECT C1.roll, C1.name, C1.cid , C2.exam_date,C2.start_time ";
  query += "FROM cwsl as C1 JOIN ett as C2 ";
  query += "ON C1.cid = C2.cid) AS T1 JOIN ";
  query += "(SELECT C1.roll, C1.name, C1.cid , C2.exam_date,C2.start_time ";
  query += "FROM cwsl as C1 JOIN ett as C2 ";
  query += "ON C1.cid = C2.cid) AS T2 ";
  query += "WHERE T1.roll = T2.roll and ";
  query += "T1.exam_date=T2.exam_date and T1.start_time=T2.start_time ";
  query += "and T1.cid <> T2.cid;";

   mysql_library_init(0, NULL, NULL);
   mysql = mysql_init(NULL);
   mysql_options(mysql, MYSQL_READ_DEFAULT_GROUP, "libmysqld_client");
   mysql_options(mysql, MYSQL_OPT_USE_EMBEDDED_CONNECTION, NULL);

   if(mysql_real_connect(mysql, host.c_str(),user_name.c_str(),pass.c_str(), db_name.c_str(), 0,NULL,0) == NULL){
     cout<<"not connected\n";
     return 0;
   }


  mysql_query(mysql,query.c_str());
  results = mysql_store_result(mysql);
  while((record = mysql_fetch_row(results))) {
      string c1 = record[2];
      string c2 = record[3];
      string name = record[1];
      string roll = record[0];
      int n = arr.size();
      bool flag  = false;
      for(int i = 0;i<n;i++){
        if((arr[i].roll == roll) && (c1 == arr[i].c2 && c2 == arr[i].c1)){
          flag = true;
          break;
        }
      }
      if(!flag)
        arr.push_back({roll,name,c1,c2});
  }
  string line = "";
  for(int i=0;i<82;i++){
    line+='_';
  }
  cout<<line<<"\n";
  printf("|%12s|%50s|%10s|%10s|\n","ROLL","NAME","COURSE 1","COURSE 2");
  cout<<line<<"\n";
  for(int i=0;i<arr.size();i++){
    printf("|%12s|%50s|%10s|%10s|\n",arr[i].roll.c_str(),arr[i].name.c_str(),arr[i].c1.c_str(),arr[i].c2.c_str());
  }
  cout<<line<<"\n";
  cout<<"Total results count := "<<arr.size()<<'\n';
  
  mysql_free_result(results);
  mysql_close(mysql);
  mysql_library_end();
   return 0;
}

