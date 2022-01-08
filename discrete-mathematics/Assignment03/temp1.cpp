#include <iostream>
#include <vector>
#include <queue>
#include <stack>
#include <set>
#include <map>
#include <iterator>
#include <algorithm> 
#include <iomanip>
#include <fstream>
#include <cctype>
#include <cstring>
#include <string>
#include <typeinfo>
#include <bits/stdc++.h>
#include <limits.h>
using namespace std;

#define TRUE 1
#define FALSE 0

// function split string into vector by any arbitrary character or string
void split(string str, string splitBy, vector<string>& tokens)
{
       /* Store the original string in the array, so we can loop the rest
        * of the algorithm. */
       tokens.push_back(str);

       // Store the split index in a 'size_t' (unsigned integer) type.
       size_t splitAt;
       // Store the size of what we're splicing out.
       size_t splitLen = splitBy.size();
       // Create a string for temporarily storing the fragment we're processing.
       std::string frag;
       // Loop infinitely - break is internal.
       while(true)
       {
           /* Store the last string in the vector, which is the only logical
            * candidate for processing. */
           frag = tokens.back();
           /* The index where the split is. */
           splitAt = frag.find(splitBy);
           // If we didn't find a new split point...
           if(splitAt == string::npos)
           {
               // Break the loop and (implicitly) return.
               break;
           }
           /* Put everything from the left side of the split where the string
            * being processed used to be. */
           tokens.back() = frag.substr(0, splitAt);
           /* Push everything from the right side of the split to the next empty
            * index in the vector. */
           tokens.push_back(frag.substr(splitAt+splitLen, frag.size()-(splitAt+splitLen)));
       }
}
// function return index of string in vector contain them
int getIndex(vector<string> v, string K)
{
    auto it = find(v.begin(), v.end(), K);
 
    // If element was found
    if (it != v.end()) 
    {
     
        // calculating the index of K
        int index = it - v.begin();
        return index;
    }
    else {
        // If the element is not
        // present in the vector
        return -1;
    }
}

// function create edges of any 2 vertices
void addEdge(vector<vector<int>> &matrix,int x, int y, int weight = 1, int directed=0){ 
    if (!directed) {
        matrix[y][x] = weight; 
        matrix[x][y] = weight; }
    else
    {
        matrix[x][y] = weight;
    }
}

void convert_to_graph(vector<vector<int>> matrix, map <int,vector<pair<int,int>>> &Graph){
    for(int i = 0;i < matrix.size();i++){
        vector<pair<int,int>> ls;
        for(int j = 0; j < matrix[i].size();j++){
            if (matrix[i][j] != 0){
                int a = j;
                int b; 
                b = matrix[i][j];
                ls.push_back(std::make_pair(a,b));
            }
        }
        Graph[i] = ls;
    }
}

void Display_path_shortest(vector <int> path, int cost, string filename){
    ofstream fout;
    fout.open(filename, ofstream::out);
    fout << "Tong chi phi di chuyen = " << cost << endl;
    fout << "Duong di ngan nhat cua do thi la: ";
    for(int i = 0; i < path.size()-1; i++){
        fout << path[i]+1 << " -> ";
    }
    fout << path.back()+1 << " ";
    fout.close();
}

void Dijktra(map <int,vector<pair<int,int>>> &Graph, int Start, int Goal, string filename){
    ofstream fout;
    fout.open(filename, ofstream::out);
    int check = 0;
    vector <int> explored;
    vector <pair<int,vector<int>>> frontier={{0,{Start}}};
    int current_node, current_cost;
    while(!frontier.empty()){
        if (frontier.empty()){
            fout << "Khong co duong di ngan nhat";
            fout.close();
            break;
        }
        else{
            vector <int> path;
            sort(frontier.begin(),frontier.end(),
            [](const pair<int,vector<int>>& left , const pair<int,vector<int>>& right){
                return left.first < right.first;
            });
            current_cost = frontier.front().first;
            current_node = frontier.front().second.back();
            path = frontier.front().second;
            
            
            if (current_node == Goal){
                fout.close();
                check = 1;
                Display_path_shortest(path,current_cost,filename);
                break;
            }
            // frontier.pop_front();
            frontier.erase(frontier.begin());
            if (find(explored.begin(),explored.end(), current_node) == explored.end()){
                
                if (Graph.find(current_node) == Graph.end()){
                    continue;
                }
                for(auto item:Graph[current_node]){
                    vector <int> new_path;
                    int node,cost;
                    // path.data(frontier.back().second.);
                    copy(path.begin(), path.end(), back_inserter(new_path));
                    node = item.first;
                    cost = item.second;
                    new_path.push_back(node);
                    // queue.push(make_pair(node,cost+current_cost));
                    frontier.push_back(make_pair(cost+current_cost,new_path));
                }
                explored.push_back(current_node);
            }
        }
    }
    if (!check) {
    fout << "Khong co duong di ngan nhat";
    fout.close();}
}

int main()
{
    string input;
    vector <string> Open;
    vector<vector<string>> list_value;
    set <string> Set;
    int n_vertices, type;
    int Start;
    int Goal;
    // Doc du lieu
    ifstream myfile("thong_tin_dinh_4.txt");
    getline(myfile,input);
    type = stof(input);
    getline(myfile,input);
    n_vertices = stof(input);
    while(getline(myfile,input)){
        vector<string> value;
        // tach nhung phan tu ngan cach boi dau phay 
        split(input, " ", value);
        // them mang da tach vao mang lon hon
        list_value.push_back(value);
    }
    Open = list_value.back();
    list_value.pop_back();
    Start = stof(Open[0])-1;
    Goal = stof(Open[1])-1;
	myfile.close();

    // Khoi tao ma tran (n,n) gom nhung phan tu 0; 
    vector<vector<int>> matrix(n_vertices,vector<int> (n_vertices,0));
    // Tao canh tuong ung voi cac bien
    for (int i = 0; i < list_value.size();i++){
        
        int x = stof(list_value[i][0])-1;
        int y = stof(list_value[i][1])-1;
        if (list_value[i].size() < 3)
            addEdge(matrix,x,y,1, type);
        else{
            int weight = stof(list_value[i][2]);
            addEdge(matrix,x,y,weight, type);
        }
    }
    map <int,vector<pair<int,int>>> Graph;
    convert_to_graph(matrix,Graph);
    Dijktra(Graph,Start,Goal, "ket_qua_bai_3_18110171.txt");
    return 0;
}