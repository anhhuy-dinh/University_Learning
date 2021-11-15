/*
    * MSSV: 18110103
    * Ho va ten: Dinh Anh Huy
    * Assignment: bai1
    * Created_at: 04/11/2021
    * IDE: Visual Studio Code
*/

#include <iostream>
#include <string>
#include <vector>
#include <stack>
#include <queue>
#include <algorithm>
#include <cmath>
#include <iomanip>

using namespace std;

void replace_all(string& source, const string from, const string to)
{
    /* This function helps replace all 'from' strings that exist on 'source' string to 'to' string */
    size_t index = source.find(from, 0);
    while (index != string::npos)
    {
        source.replace(index, from.length(), to);
        index = source.find(from, index+1);
    }
}

void convert_expression(string& expression)
{
    /* This function helps convert logic operators to numbers */
    vector<string> operators = {"~", "^", "v", "<->", "->", "(", ")"};
    vector<string> priors = {"1", "2", "3", "5", "4", "6", "7"};

    for (int i = 0; i < operators.size(); i++)
        replace_all(expression, operators[i], priors[i]);
}

int check_operand(char c)
{
    /* This function checks whether c is an operand */
    if (((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) && c != 'v')
        return 1;
    return 0;
}

string convert_infix_to_postfix(string expression)
{
    /* This function helps convert infix expression to postfix expression */
    stack<char> operators;
    string result;

    for (int i = 0; i < expression.length(); i++)
    {
        char c = expression[i];

        if (check_operand(c))
            result += c;
        else
            if (c == '6')
                operators.push('6');
            else
                if (c == '7')
                {
                    while(operators.top() != '6')
                    {
                        result += operators.top();
                        operators.pop();
                    }
                    operators.pop();
                }
                else
                {
                    while (!operators.empty() && c >= operators.top())
                    {
                        result += operators.top();
                        operators.pop();
                    }
                    operators.push(c);
                }
    }
    while (!operators.empty())
    {
        result += operators.top();
        operators.pop();
    }
    return result;
}

char get_negation(char x)
{
    /* This function gets negative value of x. */
    if (x == '0')
        return '1';
    return '0';
}

char calculate_logic(char x, char y, char oper)
{
    /* This function calculates logic expression with 2 operands. */
    switch (oper)
    {
        case '2':
            if (x == '1' && y == '1')
                return '1';
            else return '0';
            break;
        case '3':
            if (x == '0' && y == '0')
                return '0';
            else return '1';
        case '4':
            if (x == '1' && y == '0')
                return '0';
            else return '1';
        case '5':
            if ((x == '1' && y == '1') || (x == '0' && y == '0'))
                return '1';
            else return '0';
        default:
            cout << "The operator is not valid.";
            break;
    }
}

string get_operands(string expression)
{
    /* This function gets all operators in logic expression. */
    string operands;
    for (int i = 0; i < expression.length(); i++)
    {
        if (check_operand(expression[i]))
        {
            size_t index = operands.find(expression[i]);
            if (index == string::npos)
                operands += expression[i];
        }
    }
    return operands;
}

string convert_decimal_to_binary(int n, int length)
{
    /* This function converts decimal number to binary number. */
    string binary;

    while (n > 0)
    {
        binary += to_string(n % 2);
        n = n / 2;
    }
    while (binary.length() < length)
        binary += "0";

    reverse(binary.begin(), binary.end());
    return binary;
}

vector<string> get_first_row(string postfix)
{
	/* This function gets the first row in truth table (row consists of variables and subexpressions). */
    vector<string> operators = {"~", "^", "v", "->", "<->"};
    vector<string> result; // vector contains variables and subexpressions
    stack<string> temp; // a stack 
    string operands;
    operands = get_operands(postfix);

    // Push variables that exist in logic expression to result
    for (int i = 0; i < operands.length(); i++)
        result.push_back(string(1, operands[i]));

    // Get subexpressions and push to result
    for (int i = 0; i < postfix.length(); i++)
    {
        char cur = postfix[i];
        if (check_operand(cur)) // if cur is an operand
            temp.push(string(1, cur));
        else // if cur is an operator
        {
            int idx = (int)cur - 49; 
            string oper = operators[idx];
            string subexpr;

            if (cur == '1') // if cur is negative operator
            {
                string x = temp.top();
                temp.pop();
                subexpr = oper + x;
                temp.push(subexpr);
                result.push_back(subexpr);
            }
            else // otherwise
            {
                string y = temp.top(); temp.pop();
                string x = temp.top(); temp.pop();
                if (x.length() > 1)
                    x = "(" + x + ")";
                if (y.length() > 1)
                    y = "(" + y + ")";
                subexpr = x + oper + y;
                temp.push(subexpr);
                result.push_back(subexpr);
            }
        }
    }
    return result;
}

vector<string> get_calculate_row(int number_row, string postfix, string operands)
{
	/* This function returns a row in the truth table with the specified number of row. 
	The returned value is a vector that contains values of variables and result of logic subexpression. */
    stack<char> temp;
    vector<string> result;
    string values = convert_decimal_to_binary(number_row, operands.length());

    for (int i = 0; i < values.length(); i++)
        result.push_back(string(1, values[i]));
    
    for (int i = 0; i < postfix.length(); i++)
    {
        char cur = postfix[i];
        size_t idx;
        char sub_result;

        if (check_operand(cur))
            temp.push(cur);
        else
        {
            if (cur == '1')
            {
                char x = temp.top(); temp.pop();
                idx = operands.find(x);
                // if (idx != string::npos)
                x = values[idx];
                sub_result = get_negation(x);
                temp.push(sub_result);
                result.push_back(string(1, sub_result));
            }
            else
            {
                char y = temp.top(); temp.pop();
                idx = operands.find(y);
                if (idx != string::npos)
                    y = values[idx];                

                char x = temp.top(); temp.pop();
                idx = operands.find(x);
                if (idx != string::npos)
                    x = values[idx];

                sub_result = calculate_logic(x, y, cur);
                // cout << sub_result << endl;
                temp.push(sub_result);
                result.push_back(string(1, sub_result));
            }
        }
    }
    return result;
}

void truth_table(string expression)
{
    /* This function displays the truth table of logical expression. */
    int num_vars;
    string postfix, operands;
    
    vector<string> temp;
    vector<vector<string>> results;
    
    convert_expression(expression);
    postfix = convert_infix_to_postfix(expression);
    operands = get_operands(expression);
    num_vars = operands.length();
    
    results.push_back(get_first_row(postfix));

    for (int i = 0; i < pow(2, num_vars); i++)
        results.push_back(get_calculate_row(i, postfix, operands));
    cout << "+";
    for (int i = 0; i < results[0].size(); i++)
        cout << " " + string(results[0][i].length() + 6, '=') + " +";
    cout << endl;
    for (int i = 0; i < results.size(); i++)
    {
        cout << "|";
        for (int j = 0; j < results[i].size(); j++)
        {
            if (i != 0)
            {
                if (results[i][j] == "0")
                    results[i][j] = "F";
                else
                    results[i][j] = "T";
                if (results[0][j].length() % 2 != 0)
                    cout << string((int)((results[0][j].length() + 7)/2), ' ') + results[i][j] + string((int)((results[0][j].length() + 7)/2), ' ') + "|";
                else
                    cout << string((int)((results[0][j].length() + 7)/2), ' ') + results[i][j] + string((int)((results[0][j].length() + 7)/2) + 1, ' ') + "|";
            }
            else
                cout << string(4, ' ') + results[i][j] + string(4, ' ') + "|";
        }
        cout << endl;
        if (i == 0)
        {
            cout << "+";
            for (int i = 0; i < results[0].size(); i++)
                cout << " " + string(results[0][i].length() + 6, '=') + " +";
            cout << endl;
        }
    }
    cout << "+";
    for (int i = 0; i < results[0].size(); i++)
        cout << " " + string(results[0][i].length() + 6, '=') + " +";
    cout << endl;
}

void print_truth_table(string c)
{
    /* This function prints the truth table of operator c. */
    vector<string> operators = {"~", "^", "v", "->", "<->"};
    int idx;

    for (int i = 0; i < operators.size(); i++)
        if (c == operators[i])
        {
            idx = i;
            break;
        }

    switch (idx)
    {
        case 0:
            cout << ">> The truth Table for the Negative of a Proposition:" << endl;
            truth_table("~p");
            break;
        case 1:
            cout << ">> The truth Table for the Conjunction of Two Proposition:" << endl;
            truth_table("p^q");
            break;
        case 2:
            cout << ">> The truth Table for the Disjunction of Two Proposition:" << endl;
            truth_table("pvq");
            break;
        case 3:
            cout << ">> The truth Table for the Conditional Statement p -> q:" << endl;
            truth_table("p->q");
            break;
        case 4:
            cout << ">> The truth Table for the Biconditional p <-> q:" << endl;
            truth_table("p<->q");
            break;
        default:
            cout << "The operator is not valid.";
            break;
    }
}

int main()
{
    vector<string> operators = {"~", "^", "v", "->", "<->"};

    for (int i = 0; i < operators.size(); i++)
    {
        print_truth_table(operators[i]);
        cout << endl;        
    }
        
    return 0;
}