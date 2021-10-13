#include <iostream>
#include <stack>
#include <algorithm>
#include <conio.h>
#include <regex>
#include "Tree.h"

bool depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode);
bool iterative_depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode);
TreeNode* new_node(const TreeNode* prev, int l_r_u_d);
void step_cur_node(TreeNode* node);
void step_cur_data(std::stack<TreeNode*> fringer);
bool step_continue();
void step_results(int node_count, int step_count);

int main()
{
	int start_position[3][3] = { {-1,4,3},{6,2,1},{7,5,8} };
	int finish_position[3][3] = { {1,2,3},{4,-1,5},{6,7,8} };

	std::regex pattern("[Yy]");
	std::string mode;
	std::cout << "Step by step? (Y/n): ";
	std::cin >> mode;

	std::regex pattern_s("[Dd]");
	std::string search;
	std::cout << "Iterative depth or depth? (I/d): ";
	std::cin >> search;

	if (std::regex_match(search, pattern_s))
		depth_search(start_position, finish_position, std::regex_match(mode, pattern));
	else
		iterative_depth_search(start_position, finish_position, std::regex_match(mode, pattern));

	system("pause");
	system("cls");
	return 0;
}

bool depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode_in) {
	bool mode = mode_in;
	int node_count = 0;
	int step_count = 0;
	Tree* T = new Tree(start_pos);// Инициализация дерева поиска начальным состоянием задачи
	TreeNode* node = NULL;
	TreeNode* newnode = NULL;
	std::stack<TreeNode*> fringer;//создание стека
	fringer.push(T->m_root);//добавление начального состояния в стек
	while (true) // основной цикл
	{
		if (fringer.empty()) {//нет вершин - кандидатов для раскрытия
			step_results(node_count, step_count);
			return false; // решение не найдено!
		}
		else
		{
			//выбрать в соответствии со стратегией терминальную вершину(лист) для раскрытия;
			node = fringer.top();
			fringer.pop();
			step_count++;
			if (memcmp(node->m_data, finish_pos, 3 * 3 * sizeof(int)) == 0)//вершина содержит целевое состояние
			{
				T->print_way(node);
				step_results(node_count, step_count);
				return true;
			}
			else//раскрыть вершину и добавить новые вершины в дерево поиска;
			{
				if (mode) {
					step_cur_node(node);
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
							node_count++;
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
					step_cur_data(fringer);
					mode = step_continue();
					system("cls");
				}
			}
		}
	}
}

bool iterative_depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode_in) {
	bool mode = mode_in;
	int cur_search_depth = 1;
	int node_count = 0;
	int step_count = 0;
	bool search_deapth_reached = false;
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
			node = fringer.top();
			fringer.pop();
			step_count++;
			if (memcmp(node->m_data, finish_pos, 3 * 3 * sizeof(int)) == 0)//вершина содержит целевое состояние
			{
				T->print_way(node);
				step_results(node_count, step_count);
				return true;
			}
			else//раскрыть вершину и добавить новые вершины в дерево поиска;
			{
				if (mode) {
					step_cur_node(node);
				}

				if (node->depth < cur_search_depth)
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
								node_count++;
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
				else {
					search_deapth_reached = true;
					if (mode)
						std::cout << "No moves" << std::endl;
				}
				if (mode) {
					step_cur_data(fringer);
					mode = step_continue();
					system("cls");
				}
			}
		}
		delete(T);
		if (search_deapth_reached)
			++cur_search_depth;
		else {
			step_results(node_count, step_count);
			return false;
		}
	}
}

//получение новой вершины выбором движения пустого квадрата
TreeNode* new_node(const TreeNode* prev, int l_r_u_d)
{
	int new_data[3][3];
	switch (l_r_u_d)
	{
	case LEFT:
		if (prev->X_pos.x - 1 >= 0)
		{
			memcpy(new_data, prev->m_data, 3 * 3 * sizeof(int));
			std::swap(new_data[prev->X_pos.y][prev->X_pos.x],
				new_data[prev->X_pos.y][prev->X_pos.x - 1]);
			return new TreeNode(prev, new_data);
		}
		break;
	case RIGHT:
		if (prev->X_pos.x + 1 <= 2)
		{
			memcpy(new_data, prev->m_data, 3 * 3 * sizeof(int));
			std::swap(new_data[prev->X_pos.y][prev->X_pos.x],
				new_data[prev->X_pos.y][prev->X_pos.x + 1]);
			return new TreeNode(prev, new_data);
		}
		break;
	case UP:
		if (prev->X_pos.y - 1 >= 0)
		{
			memcpy(new_data, prev->m_data, 3 * 3 * sizeof(int));
			std::swap(new_data[prev->X_pos.y][prev->X_pos.x], 
				new_data[prev->X_pos.y - 1][prev->X_pos.x]);
			return new TreeNode(prev, new_data);
		}
		break;
	case DOWN:
		if (prev->X_pos.y + 1 <= 2)
		{
			memcpy(new_data, prev->m_data, 3 * 3 * sizeof(int));
			std::swap(new_data[prev->X_pos.y][prev->X_pos.x], 
				new_data[prev->X_pos.y + 1][prev->X_pos.x]);
			return new TreeNode(prev, new_data);
		}
		break;
	}
	return NULL;
}

void step_cur_node(TreeNode* node) {
	std::cout << "Depth: " << node->get_depth() << std::endl;
	node->print_node();
	std::cout << std::endl << "Possible moves:" << std::endl;
}

void step_cur_data(std::stack<TreeNode*> fringer) {
	std::cout << std::endl << "Current fringe count: " << fringer.size() << std::endl;
	std::cout << "New node will be: " << std::endl;
	if (!fringer.empty())
		fringer.top()->print_node();
	else
		std::cout << "There is no nodes left on current depth" << std::endl;
}

bool step_continue() {
	std::cout << std::endl << "Press enter for next step" << std::endl;
	std::cout << "Press z to finish the algorithm" << std::endl;
	bool correct_key = false;
	char ch = _getch();
	do {
		switch (ch) {
		case 'z': {
			correct_key = true;
			return false;
			break;
		}
		case 13: { // enter
			correct_key = true;
			return true;
			break;
		}
		default: {

		}
		}
	} while (!correct_key);
}

void step_results(int node_count, int step_count) {
	std::cout << std::endl << "Total memory units: " << node_count << std::endl;
	std::cout << "Total steps: " << step_count << std::endl;
}