/*
    * MSSV: 18110103
    * Ho va ten: Dinh Anh Huy
    * Assignment: bt bonus 3
    * Created_at: 27/12/2021
    * IDE: Visual Studio Code
*/

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <stack>

using namespace std;

#define inf 2147483646 // define infinity value

vector<string> read_file(string fname)
{
    /* This function reads given file and returns list of lines in file.*/
    vector<string> lines; 
    string line;
    ifstream file(fname);
    while (getline(file, line))
        lines.push_back(line);
    file.close();
    return lines;
}

vector<int> split(string str, string delim = " ")
{
    /* 
        This function splits numbers in a string with given delimitation.
        And returns list of int type values in given string.
     */
    vector<int> values;
    size_t start, end = 0;
    while ((start = str.find_first_not_of(delim, end)) != string::npos)
    {
        end = str.find(delim, start);
        values.push_back(stof(str.substr(start, end-start)));
    }
    return values;
}

void get_vertices_information(string fname, vector<vector<vector<int>>>& adj_list, int& source, int& goal)
{
    /*
        This function reads given file and returns adjacency list, 
        source point and goal point for finding the shortest path.
    */
    vector<string> lines = read_file(fname);
    int type_graph = stof(lines[0]);
    int num_vertices = stof(lines[1]);

    for (int i = 0; i < num_vertices; i++)
    {
        vector<vector<int>> edge = {};
        adj_list.push_back(edge);
    }

    for (int i = 2; i < lines.size() - 1; i++)
    {
        vector<int> values = split(lines[i]);
        if (type_graph == 1)
        {
            vector<int> edge = {values[1]-1, values[2]};
            adj_list[values[0]-1].push_back(edge);
        }
        else
        {
            vector<int> edge1 = {values[1]-1, values[2]};
            adj_list[values[0]-1].push_back(edge1);
            vector<int> edge2 = {values[0]-1, values[2]};
            adj_list[values[1]-1].push_back(edge2);
        }
    }
    vector<int> points = split(lines[lines.size()-1]);
    source = points[0] - 1;
    goal = points[1] - 1;
}

vector<string> get_vertices_names(string fname)
{
    /*
        This function gets the name of vertices from file.
    */
    vector<string> names;
    vector<string> lines = read_file(fname);
    for (int i = 0; i < lines.size(); i++)
    {
        size_t pos = lines[i].find(' ', 0);
        names.push_back(lines[i].substr(pos + 1, lines[i].size()-pos));
    }
    return names;
}

int get_min_distance(vector<int> dist, vector<int> flat)
{
    /*
        This function returns the index of the minimum value in a given vector 
        satisfying this value that belongs to the unchecked point.
    */
    int idx = -1, min = inf;
    for (int i = 0; i < dist.size(); i++)
    {
        if ((dist[i] < min) && (flat[i] == 0))
        {
            min = dist[i];
            idx = i;
        }
    }
    return idx;
}

vector<int> dijkstra(vector<vector<vector<int>>> adj_list, int source, int goal)
{
    /* 
        This function performs dijkstra algorithm to find the shortest path from source to goal.
        And it returns a vector include:
            * The last value is like a variable that checks if the shortest path is found, 1 for exist and 0 for otherwise.
            * If the shortest path is found, the previous value will show the total cost for this path.
            * The remaining values store the shortest path information in the form of parent-child relationship.
     */
    int num_vers = adj_list.size(), exist_path = 1;
    vector<int> dist, flat, path;
    
    dist.assign(num_vers, inf);
    flat.assign(num_vers, 0);
    path.assign(num_vers, -1);

    dist[source] = 0;

    while (true)
    {
        int current = get_min_distance(dist, flat);
        if (current == goal)
        {
            path.push_back(dist[goal]);
            path.push_back(exist_path);
            break;
        }
        else 
            if(current == -1)
            {
                exist_path = 0;
                path.push_back(exist_path);
                break;
            }
        flat[current] = 1;
        path.push_back(current);

        for (int j = 0; j < adj_list[current].size(); j++)
        {
            int next = adj_list[current][j][0], weight = adj_list[current][j][1];
            if ((flat[next] == 0) && (dist[next] > (weight + dist[current])))
            {
                dist[next] = weight + dist[current];
                path[next] = current;
            }    
        }
    }
    return path;
}

void find_shortest_path_from_file(string input_fname, string vertices_fname, string output_fname)
{
    /*
        This function gets the information from the input file. 
        Then, it performs the Dijkstra algorithm to find the shortest path 
        and display the result in the output file and on screen.
    */
    vector<vector<vector<int>>> adj_list;
    vector<int> path;
    vector<string> names = get_vertices_names(vertices_fname);
    int num_vertices, source, goal;
    ofstream output(output_fname);

    get_vertices_information(input_fname, adj_list, source, goal);
    path = dijkstra(adj_list, source, goal);

    if (path[path.size()-1] == 0)
    {
        output << "Khong co duong di ngan nhat";
        cout << "Khong co duong di ngan nhat";
    }    
    else
    {
        stack<int> shortest_path;
        int current = goal;

        shortest_path.push(goal);

        while (current != source)
        {
            current = path[current];
            shortest_path.push(current);
        }

        output << "Tong chi phi di chuyen = " << path[path.size()-2] << endl;
        cout << "Tong chi phi di chuyen = " << path[path.size()-2] << endl;
        output << "Duong di ngan nhat cua do thi la: ";
        cout << "Duong di ngan nhat cua do thi la: ";
        output << names[shortest_path.top()] << " ";
        cout << names[shortest_path.top()] << " ";
        shortest_path.pop();
        while (!shortest_path.empty())
        {
            output << "-> " << names[shortest_path.top()] << " ";
            cout << "-> " << names[shortest_path.top()] << " ";
            shortest_path.pop();
        }
    }
    output.close();
}

int main()
{
    find_shortest_path_from_file("thong_tin_dinh_2.txt", "ten_dinh_2.txt", "ket_qua_bonus_18110103.txt");
    return 0;
}