#include <iostream>
class TreeNode
{
    struct position {
        int x = 0;
        int y = 0;
    };
public:
    int m_data[3][3];
    position X_pos;
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
		memcpy(m_data, _val, 3 * 3 * sizeof(int));
        X_pos = *find_index(_val);
    }
    position* find_index(int data[3][3])
    {
        position cur_pos;
        for (int i = 0; i < 3; ++i)
            for (int j = 0; j < 3; ++j)
                if (data[i][j] == -1) { 
                    cur_pos.x = j;
                    cur_pos.y = i;
                    return &cur_pos; 
                }
        return NULL;
    }
    void print_node()
    {
        for (int i = 0; i < 3; ++i)
        {
            std::cout << "   ";
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
    int get_depth()
    {
        return depth;
    };
};