#include <iostream>
#include <stack>
#include <vector>
#include <algorithm>
#include <conio.h>
#include <regex>
#include "Tree.h"

bool depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode_in, bool heuristic_type);
bool iterative_depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode, bool heuristic_type);
TreeNode* new_node(const TreeNode* prev, int l_r_u_d);
void step_cur_node(TreeNode* node);
void step_cur_data(std::stack<TreeNode*> fringer);
bool step_continue();
void step_results(int node_count, int step_count);
int h1_distance(int position1[3][3], int position2[3][3]);
int h2_distance(int position1[3][3], int position2[3][3]);
void find_index(int position[3][3], int value, int* x, int* y);

int main()
{
	int start_position[3][3] = { {-1,4,3},{6,2,1},{7,5,8} };
	int finish_position[3][3] = { {1,2,3},{4,-1,5},{6,7,8} };
	//std::cout << h1_distance(start_position, finish_position) << std::endl;
	//std::cout << h2_distance(start_position, finish_position) << std::endl;

	std::regex pattern("[Yy]");
	std::string mode;
	std::cout << "Step by step? (Y/n): ";
	std::cin >> mode;

	std::regex pattern_s("[Dd]");
	std::string search;
	std::cout << "Iterative depth or depth? (I/d): ";
	std::cin >> search;

	// # TODO можно упростить
	std::regex pattern_h("1");
	std::string h_mode;
	std::cout << "h1 or h2? (1/2): ";
	std::cin >> h_mode;

	if (std::regex_match(search, pattern_s))
		depth_search(start_position, finish_position, std::regex_match(mode, pattern), std::regex_match(h_mode, pattern_h));
	else
		iterative_depth_search(start_position, finish_position, std::regex_match(mode, pattern), std::regex_match(h_mode, pattern_h));

	system("pause");
	system("cls");
	return 0;
}

/* Поиск в глубину.
int start_pos[3][3] - стартовая позиция,
int finish_pos[3][3] - финишная позиция,
bool mode_in - включить/отключить вывод информации в консоль,
bool heuristic_type - вид эвристики соответственно: true - h1, false - h2.
*/
bool depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode_in, bool heuristic_type) {
	bool mode = mode_in;
	int node_count = 0;
	int step_count = 0;
	Tree* T = new Tree(start_pos); // Инициализация дерева поиска начальным состоянием задачи
	TreeNode* node = NULL;
	TreeNode* newnode = NULL;
	std::stack<TreeNode*> fringer;//создание стека
	std::vector<TreeNode*> sorter; //дополнительная сортировка данных
	fringer.push(T->m_root); //добавление начального состояния в стек
	while (true) // основной цикл
	{
		if (fringer.empty()) {//нет вершин - кандидатов для раскрытия
			step_results(node_count, step_count);
			return false; // решение не найдено !
		}
		else
		{
			//выбрать в соответствии со стратегией терминальную вершину (лист) для раскрытия;
			node = fringer.top();
			fringer.pop();
			step_count++;
			if (memcmp(node->m_data, finish_pos, 3 * 3 * sizeof(int)) == 0)//вершина содержит целевое состояние
			{
				T->print_way(node);
				step_results(node_count, step_count);
				return true;
			}
			else //раскрыть вершину и добавить новые вершины в дерево поиска;
			{
				//T->print_way(node);
				//std::cout << node->depth << std::endl;
				//std::cout << "----------checking-new-nodes----------------------------------" << std::endl;
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
							if (heuristic_type)
								newnode->h = h1_distance(newnode->m_data, finish_pos);
							else
								newnode->h = h2_distance(newnode->m_data, finish_pos);
							T->insert(node, newnode, i);
							// fringer.push(newnode);
							bool flag = false;
							for (std::vector<TreeNode*>::iterator iter = sorter.begin(); iter < sorter.end(); iter++) {
								if ((*iter)->h > newnode->h) {
									sorter.insert(iter, newnode);
									flag = true;
									break;
								}
							}
							if (!flag)
								sorter.push_back(newnode);
							node_count++;
							if (mode) {
								std::cout << "h = " << newnode->h << std::endl;
								std::cout << "Accepted" << std::endl;
							}
						}
						else
						{
							if (mode)
								std::cout << "Denied" << std::endl;
						}
					}
				}
				while (!sorter.empty()) {
					fringer.push(sorter.back());
					sorter.pop_back();
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

bool iterative_depth_search(int start_pos[3][3], int finish_pos[3][3], bool mode_in, bool heuristic_type) {
	bool mode = mode_in;
	int L = 1;
	int node_count = 0;
	int step_count = 0;
	TreeNode* node = NULL;
	TreeNode* newnode = NULL;
	std::vector<TreeNode*> sorter;
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
			step_count++;
			if (memcmp(node->m_data, finish_pos, 3 * 3 * sizeof(int)) == 0) //вершина содержит целевое состояние
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
								if (heuristic_type)
									newnode->h = h1_distance(newnode->m_data, finish_pos);
								else
									newnode->h = h2_distance(newnode->m_data, finish_pos);
								T->insert(node, newnode, i);
								// fringer.push(newnode);
								bool flag = false;
								for (std::vector<TreeNode*>::iterator iter = sorter.begin(); iter < sorter.end(); iter++) {
									if ((*iter)->h > newnode->h) {
										sorter.insert(iter, newnode);
										flag = true;
										break;
									}
								}
								if (!flag)
									sorter.push_back(newnode);
								node_count++;
								if (mode) {
									std::cout << "h = " << newnode->h << std::endl;
									std::cout << "Accepted" << std::endl;
								}
							}
							else
							{
								if (mode)
									std::cout << "Denied" << std::endl;
							}
						}
					}
					while (!sorter.empty()) {
						fringer.push(sorter.back());
						sorter.pop_back();
					}
				}
				else if (mode)
					std::cout << "No moves" << std::endl;

				if (mode) {
					step_cur_data(fringer);
					mode = step_continue();
					system("cls");
				}
			}
		}
		delete(T);
		++L;
	}
	step_results(node_count, step_count);
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
			std::swap(new_data[prev->i][prev->j], new_data[prev->i][prev->j - 1]);
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


// Эвристическая оценка h1
int h1_distance(int position1[3][3], int position2[3][3]) {
	int result = 0;

	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 3; ++j) {
			if (position1[i][j] != position2[i][j])
				++result;
		}
	}

	return result;
}

// Эвристическая оценка h2
int h2_distance(int position1[3][3], int position2[3][3]) {
	int result = 0;

	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 3; ++j) {
			int value = position1[i][j];
			int x2, y2;
			find_index(position2, value, &x2, &y2);
			result += abs(i - x2) + abs(j - y2);
		}
	}

	return result;
}

// Поиск индексов в матрице по значению
void find_index(int position[3][3], int value, int* x, int* y) {
	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 3; ++j) {
			if (position[i][j] == value) {
				*x = i;
				*y = j;
				return;
			}
		}
	}
}