#include <iostream>
#include <stack>
#include <algorithm>
#include <regex>
#include "Tree.h"

bool depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode);
bool iterative_depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode);
TreeNode* new_node(const TreeNode* prev, int l_r_u_d);

int main()
{
    int start_position[3][3] = { {-1,4,3},{6,2,1},{7,5,8} };
    int finish_position[3][3] = { {1,2,3},{4,-1,5},{6,7,8} };
    int finish_position2[3][3] = { {4,3,1},{6,-1,2},{7,5,8} };

    std::regex pattern("[Yy]");
    std::string mode;
    std::cout << "Step by step? (Y/n): ";
    std::cin >> mode;
   
    std::regex pattern_s("[Ii]");
    std::string search;
    std::cout << "Iterative depth or depth? (I/d): ";
    std::cin >> search;
    
    if (std::regex_match(search, pattern_s))
        depth_search(start_position, finish_position, std::regex_match(mode, pattern));
    else
        iterative_depth_search(start_position, finish_position, std::regex_match(mode, pattern));
    return 0;
}

bool depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode) {
    Tree* T = new Tree(start_pos);// Инициализация дерева поиска начальным состоянием задачи
    TreeNode* node = NULL;
    TreeNode* newnode = NULL;
    std::stack<TreeNode*> fringer;//создание стека
    fringer.push(T->m_root);//добавление начального состояния в стек
    while(true) // основной цикл
    {
        if (fringer.empty())//нет вершин - кандидатов для раскрытия
            return false; // решение не найдено !
        else
        {
            //выбрать в соответствии со стратегией терминальную вершину(лист) для раскрытия;
            node = fringer.top();
            fringer.pop();
            if (memcmp(node->m_data, finish_pos, 3 * 3 * sizeof(int)) == 0)//вершина содержит целевое состояние
            {
                T->print_way(node);
                return true;
            }
            else//раскрыть вершину и добавить новые вершины в дерево поиска;
            {
                //T->print_way(node);
                //std::cout << node->depth << std::endl;
                //std::cout << "----------checking-new-nodes----------------------------------" << std::endl;
                if (mode) {
                    std::cout << "Depth: " << node->get_depth() << std::endl;
                    node->print_node();
                    std::cout << "Possible moves:" << std::endl;
                }
                for (int i = 4; i >= 0; --i)//перебор вариантов движения пустоты
                {
                    newnode = new_node(node, i);
                    if (newnode != NULL)
                    {
                        if (mode) 
                            newnode->print_node();                  
                        if (T->find(newnode->m_data) == false)
                        {
                            T->insert(node, newnode, i);
                            fringer.push(newnode);
                            if (mode)
                                std::cout << "Accepted" << std::endl;
                        }
                        else
                        {
                            if (mode)
                                std::cout << "Denied" << std::endl;
                        }
                    }
                }
                
                if (mode) {
                    system("pause");
                    system("cls");
                }
            }
        }
    }
}

bool iterative_depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode) {
    int L = 1;
    TreeNode* node = NULL;
    TreeNode* newnode = NULL;
    while (true)
    {
        Tree* T = new Tree(start_pos);// Инициализация дерева поиска начальным состоянием задачи
        node = NULL;
        newnode = NULL;
        std::stack<TreeNode*> fringer;//создание стека
        fringer.push(T->m_root);//добавление начального состояния в стек
        while (!fringer.empty()) // основной цикл
        {
            //std::cout << "Depth limit = " << L << std::endl;
            //выбрать в соответствии со стратегией терминальную вершину(лист) для раскрытия;
            node = fringer.top();
            fringer.pop();
            if (memcmp(node->m_data, finish_pos, 3 * 3 * sizeof(int)) == 0)//вершина содержит целевое состояние
            {
                T->print_way(node);
                return true;
            }
            else//раскрыть вершину и добавить новые вершины в дерево поиска;
            {
                if (mode) {
                    std::cout << "Depth: " << node->get_depth() << std::endl;
                    node->print_node();
                    std::cout << "Possible moves:" << std::endl;
                }
                //T->print_way(node);
                //std::cout << node->depth << std::endl;
                //std::cout << "----------checking-new-nodes----------------------------------" << std::endl;

                if (node->depth < L)
                {
                    for (int i = 4; i >= 0; --i)//перебор вариантов движения пустоты
                    {
                        newnode = new_node(node, i);
                        if (newnode != NULL)
                        {
                            if (mode)
                                newnode->print_node();
                            if (T->find(newnode->m_data) == false)
                            {
                                T->insert(node, newnode, i);
                                fringer.push(newnode);
                                if (mode)
                                    std::cout << "Accepted" << std::endl;
                            }
                            else
                            {
                                if (mode)
                                    std::cout << "Denied" << std::endl;
                            }
                        }
                    }
                }
                else if (mode)
                    std::cout << "No moves" << std::endl;

                if (mode) {
                    system("pause");
                    system("cls");
                }
            }
        }
        delete(T);
        ++L;
    }
    return false;
}

//получение новой вершины выбором движения пустого квадрата
TreeNode* new_node(const TreeNode* prev, int l_r_u_d)
{
    int new_data[3][3];
    switch (l_r_u_d)
    {
    case LEFT:
        if (prev->j - 1 >= 0)
        {
            memcpy(new_data, prev->m_data, 3 * 3 * sizeof(int));
            std::swap(new_data[prev->i][prev->j],new_data[prev->i][prev->j-1]);
            return new TreeNode(prev, new_data);
        }
        break;
    case RIGHT:
        if (prev->j + 1 <= 2)
        {
            memcpy(new_data, prev->m_data, 3 * 3 * sizeof(int));
            std::swap(new_data[prev->i][prev->j], new_data[prev->i][prev->j + 1]);
            return new TreeNode(prev, new_data);
        }
        break;
    case UP:
        if (prev->i - 1 >= 0)
        {
            memcpy(new_data, prev->m_data, 3 * 3 * sizeof(int));
            std::swap(new_data[prev->i][prev->j], new_data[prev->i - 1][prev->j]);
            return new TreeNode(prev, new_data);
        }
        break;
    case DOWN:
        if (prev->i + 1 <= 2)
        {
            memcpy(new_data, prev->m_data, 3 * 3 * sizeof(int));
            std::swap(new_data[prev->i][prev->j], new_data[prev->i + 1][prev->j]);
            return new TreeNode(prev, new_data);
        }
        break;
    }
    return NULL;
}