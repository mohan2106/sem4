#include <my_global.h>
#include <my_sys.h>
#include <mysql.h>
static char *opt_host_name = "localhost"; /* server host (default=localhost) */
static char *opt_user_name = "admin"; /* username (default=login name) */
static char *opt_password = "password"; /* password (default=none) */
static unsigned int opt_port_num = 0; /* port number (use built-in value) */
static char *opt_socket_name = NULL; /* socket name (use built-in value) */
static char *opt_db_name = "dbname"; /* database name (default=none) */
static unsigned int opt_flags = 0; /* connection flags (none) */
static MYSQL *conn; /* pointer to connection handler */
MYSQL_RES *results;
MYSQL_ROW record;


int main (int argc, char *argv[])
{
    // printf("%s",argv[0]);
    // MY_INIT (NULL);
    printf ("Original argument vector:\n");
    for (int i = 0; i < argc; i++)
        printf ("arg %d: %s\n", i, argv[i]);
    
    /* initialize clientlibrary */
    if (mysql_library_init (0, NULL, NULL))
    {
        printf ("mysql_library_init() failed\n");
        exit (1);
    }
    /* initialize connection handler */
    conn = mysql_init (NULL);
    if (conn == NULL){
        printf ("mysql_init() failed (probably out of memory)\n");
        exit (1);
    }else{
        printf("connected");
    }
    /* connect to server */
    if (mysql_real_connect (conn, opt_host_name, opt_user_name, opt_password,
    opt_db_name, opt_port_num, opt_socket_name, opt_flags) == NULL)
    {
        printf ("mysql_real_connect() failed\n");
        mysql_close (conn);
        exit (1);
    }else{
        printf("mysql real connect connected\n");
    }

    mysql_query(conn, "SELECT roll, name, sum(credit) FROM cwsl join cc WHERE cwsl.cid = cc.cid GROUP BY roll,name HAVING SUM(credit)>40;");

    results = mysql_store_result(conn);

    while((record = mysql_fetch_row(results))) {
        printf("%s - %s - %s\n", record[0], record[1], record[2]);
    }
    /* disconnect from server, terminate client library */
    mysql_close (conn);
    mysql_library_end ();
    exit (0);
}