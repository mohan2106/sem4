#include <bits/stdc++.h>
#include <iostream>
#include <string>
#include <dirent.h>
using namespace std;

struct exam{
    string roll;
    string name;
    string email;
    string cid;
};
vector<exam> arr;

void ProcessDirectory(string directory);
void ProcessFile(string d,string file);
void ProcessEntity(string dir,struct dirent* entity);

string path = "/home/mohan/Desktop/sem4/dbms/labs/assignment2/";


void writeData(){
    freopen("load_data.csv", "w", stdout);
    for(int i=0;i<arr.size();i++){
        cout<<arr[i].roll<<','<<arr[i].cid<<','<<arr[i].name<<','<<arr[i].email<<"\n";
    }
}


int main()
{
    // freopen("input.txt", "r", stdin);
    // freopen("load-from_csv.sql", "w", stdout);
    string directory = "course-wise-students-list";
    ProcessDirectory(directory);    
    writeData();
    return 0;
}

void ProcessDirectory(string directory)
{
    string dirToOpen = path + directory;
    auto dir = opendir(dirToOpen.c_str());

    path = dirToOpen + "/";

    // cout << "Process directory: " << dirToOpen.c_str() << endl;

    if(NULL == dir)
    {
        // cout << "could not open directory: " << dirToOpen.c_str() << endl;
        return;
    }

    auto entity = readdir(dir);

    while(entity != NULL)
    {
        ProcessEntity(dirToOpen,entity);
        entity = readdir(dir);
    }
    //closing the directory
    path.resize(path.length() - 1 - directory.length());
    closedir(dir);
}

void ProcessEntity(string dir,struct dirent* entity)
{
    if(entity->d_type == DT_DIR)
    {
        if(entity->d_name[0] == '.')
        {
            return;
        }

        ProcessDirectory(string(entity->d_name));
        return;
    }

    if(entity->d_type == DT_REG)
    {
        ProcessFile(dir,string(entity->d_name));
        return;
    }

    // cout << "Not a file or directory: " << entity->d_name << endl;
}

void ProcessFile(string dir,string file)
{
    // cout << "Process file     : " << file.c_str() << endl;
    string directory = dir+"/"+file;

    ifstream ip(directory.c_str());
    if(!ip.is_open()){
        cout<<"Error in opening file: "<<dir<<"/"<<file<<'\n';
        return;
    }
    exam node;
    string cid = "";
    for(char c:file){
        if(c=='.'){
            break;
        }else{
            cid += c;
        }
    }
    node.cid = cid;
    string x;
    while(ip.good()){
        getline(ip,x,',');
        getline(ip,node.roll,',');
        getline(ip,node.name,',');
        getline(ip,node.email,'\n');
        int n = arr.size();
        if(n>0 && node.name == arr[n-1].name && node.roll == arr[n-1].roll && node.cid == arr[n-1].cid){
            continue;
        }else{
            arr.push_back(node);
        }
        
    }
    ip.close();
}



