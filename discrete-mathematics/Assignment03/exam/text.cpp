/*
    * MSSV: 18110075
    * Ho va ten: Le Hoang Duc
    * Assignment: Bai3
    * Created_at: 25/12/2021
    * IDE: Visual Studio Code, version C/C++: C++11
*/

#include<bits/stdc++.h>
#include <ostream>
using namespace std;

namespace Color {
    enum Code {
        FG_RED      = 31,
        FG_GREEN    = 32, 
        FG_BLUE     = 34,
        FG_DEFAULT  = 39,
        BG_RED      = 41,
        BG_GREEN    = 42,
        BG_BLUE     = 44,
        BG_DEFAULT  = 49
    };
    class Modifier {
        Code code;
    public:
        Modifier(Code pCode) : code(pCode) {}
        friend std::ostream&
        operator<<(std::ostream& os, const Modifier& mod) {
            return os << "\033[" << mod.code << "m";
        }
    };
}

Color::Modifier red(Color::FG_RED);
Color::Modifier def(Color::FG_DEFAULT);
Color::Modifier green(Color::FG_BLUE);

typedef string str;
typedef map<int, long long> Dict;
typedef pair<int, int> MyPairType;

struct CompareSecond{ // to compare second (value) term of dict
    bool operator()(const MyPairType& left, const MyPairType& right) const{
        return left.second < right.second;
    }
};

int get_min(Dict dist){
    /* return key of element that has min value */
    MyPairType min = *min_element(dist.begin(), dist.end(), CompareSecond());
    return min.first;
}

bool isNumber(const string& str)
{
    return str.find_first_not_of("0123456789") == string::npos;
}

class Graph{
    int type; // graph is a directed graph if type is 1, otherwise is undirected
    int n_vertex; 
    int src; // source
    int des; // destination
    Dict dist; // dist[u] is a length/cost/weight from vertex u to source. 
    Dict prev; // save the previous vertex of each vertex.
    vector<vector<int>> adjMatrix; // for querying weight
    map<int, vector<int>> graph;
    stack<int> shortest_path;
public:
    Graph(){type = 0; n_vertex=0;};
    void read_graph(const str& path);
    void build_dict_graph();
    int get_length(const int& u, const int& v); // return length (or weight) from vertex u to v
    void Dijkstra();
    void find_shortest_path();
    void path_to_console();
    void output_shortest_path();
};

void Graph::read_graph(const str& path){
    /* read graph information from input file */
    str line;
    ifstream myfile (path);

    if (!myfile.is_open()){
        cout << "Unable to open file, check your file path carefully!!!" << endl;
        return;
    }

    int count_line = 0;
    vector<vector<int>> info;
    while(getline(myfile, line)){
        vector<int> vt;
        istringstream iss(line);
        str token;
        while (iss >> token) 
        {   
            if(isNumber(token)){
                int int_token = stoi(token);
                vt.push_back(int_token);
            }
        }
        info.push_back(vt);
        count_line++;
    }
    src = info.back()[0] - 1;
    des = info.back()[1] - 1;
    info.pop_back(); // the last line is source vertex and target vertex (destination)

    n_vertex = info.size();
    adjMatrix.insert(adjMatrix.end(), info.begin(), info.end());
}

void Graph::build_dict_graph(){
    /* convert input type graph to form as adjacent matrix */
    if (adjMatrix.empty())
        return;
    for (int i=0; i < n_vertex; i++)
    {
        for (int j=0; j < n_vertex; j++)
        {
            if (adjMatrix[i][j] != 0)
            {
                graph[i].push_back(j);
            }
        }
    }
}

int Graph::get_length(const int& u, const int& v){
    /* return length from vertex u to v */
    return adjMatrix[u][v];
}

void Graph::find_shortest_path(){
    int u = des;
    if (prev[u] != -1 || u == src){
        while(u != -1){
            shortest_path.push(u);
            u = prev[u];
        }
    }
}

void Graph::path_to_console(){   
    /* write shortest path to file */
    if(shortest_path.empty())
    {
        return;
    }
    while(!shortest_path.empty()){
        if (1 < shortest_path.size())
            cout << shortest_path.top() + 1 << " -> "; // s.top() + 1 guaranteed output format
        else
            cout << shortest_path.top() + 1 << " ";
        shortest_path.pop();
    }
}

void Graph::output_shortest_path(){
    if (shortest_path.empty())
        cout << "Khong co duong di ngan nhat";
    else{
        cout << "Tong chi phi di chuyen = " << dist[des] << endl;
        cout << "Duong di ngan nhat cua do thi la: ";
        path_to_console();
    }
}

void display_table(Dict Q, Dict prev, int node){
  for (auto const &pair: Q) {
      if (pair.first == 0 || prev[pair.first] == -1)
      {
        if(pair.second == INT_MAX)
          cout << "(" << pair.first + 1 << ": [" << "INF" << "])  ";
        else{
          if(pair.first == node)
            cout << "(" << green << pair.first + 1 << def <<": [" << red << pair.second << def << "])  ";  
          else
            cout << "(" << pair.first + 1 << ": [" << pair.second << "])  ";
        }
      }
      else{
        if (pair.first == node)
          cout << "("<< green << pair.first + 1 << def << ": [" << red << pair.second << ", "<< prev[pair.first] + 1 << def << "])  "; 
        else
          cout << "(" << pair.first + 1 << ": [" << pair.second  << ", "<< prev[pair.first] + 1 << "])  ";
      }
    }
  cout << endl;
}
void Graph::Dijkstra(){
    Dict Q; //set of vertexes
    Dict Q_display;
    for (int v=0; v < n_vertex; v++){
        dist[v] = INT_MAX;
        prev[v] = -1;
        Q[v] = dist[v];
        Q_display[v] = dist[v];
    }
    dist[src] = 0;
    Q[src] = dist[src];
    Q_display[src] = dist[src];
    cout << ">> ";
    display_table(Q_display, prev, src);
    while(!Q.empty()){
        int u = get_min(Q);
        Q.erase(u);
        for (auto v: graph[u]){
            if (!Q.count(v))
                continue;
            
            unsigned long long alt = dist[u] + get_length(u, v);
            
            if (alt < dist[v]){
                dist[v] = alt;
                prev[v] = u;
                Q[v] = dist[v];
                Q_display[v] = dist[v];
            }
        }
        cout << ">> ";
        display_table(Q_display, prev, u);
    }
}


int main(){
    str path = "thong_tin_dinh.txt";
    // str output_path = "ket_qua_bai_3_18110075.txt";
    
    Graph graph;

    graph.read_graph(path);
    graph.build_dict_graph();
    graph.Dijkstra();
    graph.find_shortest_path();
    graph.output_shortest_path();

    return 0;
}