#include <iostream>
class TreeNode
{
public:
    int m_data[3][3];
    int i, j;
    int depth;
    TreeNode* m_left;
    TreeNode* m_right;
    TreeNode* m_up;
    TreeNode* m_down;
    TreeNode* parent;
    TreeNode(const TreeNode* _parent, int _val[3][3])
    {
        m_left = NULL;
        m_right = NULL;
        m_up = NULL;
        m_down = NULL;
        parent = (TreeNode*)_parent;
        depth = _parent != NULL ? _parent->depth + 1 : 1;
        memcpy(m_data,_val,3*3*sizeof(int));
        int* index = find_index(_val);
        i = index[0];
        j = index[1];
        delete(index);
    }
    int* find_index(int data[3][3])
    {
        int index_i, index_j;
        for (int i = 0; i < 3; ++i)
            for (int j = 0; j < 3; ++j)
                if (data[i][j] == -1) return new int[] {i, j};
        return NULL;
    }
    void print_node()
    {
        for (int i = 0; i < 3; ++i)
        {
            for (int j = 0; j < 3; ++j)
            {
                if (m_data[i][j] == -1)
                    std::cout << "X";
                else
                    std::cout << m_data[i][j];
            }
            std::cout << std::endl;
        }
    };
};