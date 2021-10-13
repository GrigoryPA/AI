#pragma once
#include "TreeNode.h"
#include <iostream>
#include <queue>
#include <queue>

enum { RIGHT = 1, LEFT = 2, UP = 3, DOWN = 4 };

class Tree
{
private:
    int m_size;//количество узлов
    int max_depth;//глубина
    void print_tree(TreeNode*);//вывести дерево
    void delete_tree(TreeNode*);//удалить дерево
public:
    TreeNode* m_root;//укзаатель на корень
    Tree(int[3][3]);//конструктор
    ~Tree();//дестркутор
    void print();//
    void print_way(TreeNode* prev);//
    bool find(int data[3][3]);//поиск
    void insert(TreeNode* prev, int l_r_u_d, int data[3][3]);
    void insert(TreeNode* prev, TreeNode* newnode, int l_r_u_d); //вставка
    int size();//размер
};
Tree::Tree(int data[3][3])
{
    m_root = new TreeNode(NULL, data);
    m_size = 1;
    max_depth = 1;
}
Tree::~Tree()
{
    delete_tree(m_root);
}
void Tree::delete_tree(TreeNode* curr)
{
    if (curr)
    {
        delete_tree(curr->m_left);
        delete_tree(curr->m_right);
        delete_tree(curr->m_up);
        delete_tree(curr->m_down);
        delete curr;
    }
}
void Tree::insert(TreeNode* prev, int l_r_u_d, int data[3][3])
{
    if (prev != NULL) {
            if (prev->m_left == NULL && l_r_u_d == LEFT)
                prev->m_left = new TreeNode(prev, data), ++max_depth;
        
            if (prev->m_right == NULL && l_r_u_d == RIGHT)
                prev->m_right = new TreeNode(prev, data), ++max_depth;
        
            if (prev->m_up == NULL && l_r_u_d == UP)
                prev->m_up = new TreeNode(prev, data), ++max_depth;
        
            if (prev->m_down == NULL && l_r_u_d == DOWN)
                prev->m_down = new TreeNode(prev, data), ++max_depth;
        
   
    }
}
void Tree::insert(TreeNode* prev, TreeNode* newnode, int l_r_u_d)
{
    if (prev != NULL) {
        if (prev->m_left == NULL && l_r_u_d == LEFT)
            prev->m_left = newnode;

        if (prev->m_right == NULL && l_r_u_d == RIGHT)
            prev->m_right = newnode;

        if (prev->m_up == NULL && l_r_u_d == UP)
            prev->m_up = newnode;

        if (prev->m_down == NULL && l_r_u_d == DOWN)
            prev->m_down = newnode;
    }
}

void Tree::print_way(TreeNode* prev)
{
    std::stack<TreeNode*> way;
    while (prev)
    {
        way.push(prev);
        prev = prev->parent;
    }
    while (!way.empty())
    {
        std::cout << "----\\/---- Depth: " << way.top()->depth << std::endl;
        way.top()->print_node();
        way.pop();
    }
}

bool Tree::find(int data[3][3])
{
    std::queue<TreeNode*> Q;
    TreeNode* prev = NULL;
    Q.push(m_root);
    while (Q.empty() != true)
    {
        prev = Q.front();
        Q.pop();
        if (memcmp(prev->m_data, data, 3 * 3 * sizeof(int)) == 0)
            return true;
        else {
            if (prev->m_left != NULL)
            {
                Q.push(prev->m_left);
            }
            if (prev->m_right != NULL)
            {
                Q.push(prev->m_right);
            }
            if (prev->m_up != NULL)
            {
                Q.push(prev->m_up);
            }
            if (prev->m_down != NULL)
            {
                Q.push(prev->m_down);
            }
        }
    }
    return false;
}
/*void Tree::print() // вывод дерева полностью, но реализован для единичных данных типа int
{
    print_tree(m_root);
    std::cout << std::endl;
}
void Tree::print_tree(TreeNode* curr)
{
    std::queue<TreeNode*> Q;
    TreeNode* prev=NULL;
    Q.push(curr); 
    std::cout << curr->m_data << std::endl;
    while (Q.empty() != true)
    {
        prev = Q.front();
        Q.pop();
        if (prev->m_left != NULL)
        {
            Q.push(prev->m_left);
            std::cout << prev->m_left->m_data << " ";
        }
        if (prev->m_right != NULL)
        {
            Q.push(prev->m_right);
            std::cout << prev->m_right->m_data << " ";
        }
        if (prev->m_up != NULL)
        {
            Q.push(prev->m_up);
            std::cout << prev->m_up->m_data << " ";
        }
        if (prev->m_down != NULL)
        {
            Q.push(prev->m_down);
            std::cout << prev->m_down->m_data << " ";
        }
        std::cout << "|";
        if (!Q.empty() && prev->depth != Q.front()->depth)
            std::cout << std::endl;
    }
}*/