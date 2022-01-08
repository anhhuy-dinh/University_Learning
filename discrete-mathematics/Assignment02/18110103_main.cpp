/*
    * MSSV: 18110103
    * Ho va ten: Dinh Anh Huy
    * Assignment: bai2
    * Created_at: 07/12/2021
    * IDE: Visual Studio Code
*/

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <algorithm>

using namespace std;

#define min(x, y) (x < y ? x : y) // define a function to get minimum value between x and y

vector<string> read_file(string fname)
{
    /* This function gets adjacency matrix (string type) from file. */
    vector<string> adj_matrix; 
    string line;
    ifstream file(fname);

    while (getline(file, line))
        adj_matrix.push_back(line);
    file.close();
    return adj_matrix;
}

vector<int> split(string str, char delim)
{
    /* This function splits string to each characters (int type). */
    vector<int> token;
    for (int i = 0; i < str.length(); i++)
        if (str[i] != delim)
            token.push_back((int)str[i] - 48);
    return token;
}

vector<vector<int>> get_adj_list(vector<string> adj_matrix, char delim)
{
    /* This function converts adjacency matrix to adjacency list. */
    vector<vector<int>> adj_list, int_adj_matrix;

    for (int i = 0; i < adj_matrix.size(); i++)
        int_adj_matrix.push_back(split(adj_matrix[i], delim));

    int num_vertices = int_adj_matrix.size(); 

    for (int i = 0; i < num_vertices; i++)
    {
        vector<int> connections = {};
        for (int j = 0; j < num_vertices; j++)
        {
            if (int_adj_matrix[i][j] == 1)
                connections.push_back(j);
        }
        adj_list.push_back(connections);
    }   
    return adj_list; 
}

vector<int> get_unique_values(vector<int> vec)
{
    /* This function gets unique values from a vector. */
    vector<int> vec_cpy = vec;
    sort(vec_cpy.begin(), vec_cpy.end());
    vec_cpy.erase(unique(vec_cpy.begin(), vec_cpy.end()), vec_cpy.end());
    return vec_cpy;
}

vector<vector<int>> get_connected_components(vector<vector<int>> adj_list)
{
    /* This function returns connected components. */
    vector<vector<int>> components;
    vector<int> flat;
    int num_vers = adj_list.size();

    for (int i = 0; i < num_vers; i++)
        flat.push_back(i);

    for (int i = 0; i < num_vers; i++)
    {
        for (int j = 0; j < adj_list[i].size(); j++)
        {
            int current_ver = adj_list[i][j];
            flat[i] = flat[current_ver] = min(flat[i], flat[current_ver]);
        }
    }

    vector<int> uniq_val = get_unique_values(flat);
    
    for (int i = 0; i < uniq_val.size(); i++)
    {
        vector<int> current_comp;
        for (int j = 0; j < num_vers; j++)
        {
            if (flat[j] == uniq_val[i])
                current_comp.push_back(j);
        }
        components.push_back(current_comp);
    }
    return components;
}

void check_connected_component(string fname, char delim = ' ')
{
    /* This function reads undirected graph from file and prints number of 
    connected components and corresponding vertices */
    vector<string> adj_matrix;
    adj_matrix = read_file(fname);

    vector<vector<int>> adj_list = get_adj_list(adj_matrix, delim);

    vector<vector<int>> connected_comps = get_connected_components(adj_list);

    cout << "** Number of connected components: " << connected_comps.size() << endl;
    for (int i = 0; i < connected_comps.size(); i++)
    {
        cout << "- " << i + 1 << "th connected component: ";
        for (int j = 0; j < connected_comps[i].size(); j++)
            cout << connected_comps[i][j] + 1 << " ";
        cout << endl;
    }
}

int main()
{
    string fname = "input_dothi.txt";
    check_connected_component(fname);
    return 0;
}