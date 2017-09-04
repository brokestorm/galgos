#include <utility>
#include <iostream>
#include "rlecodetrie.h"

using namespace std;

int main()
{
	// INICIALIZATION
	Trie *myTrie = new Trie();

	vector <int> keys1 = { 1, 2, 3, 4, 5, 246 };
	vector <int> keys2 = { 1, 2, 3, 4, 15, 22, 11 };
	vector <int> keys3 = { 1, 2, 3, 14, 5, 1, 2, 3, 4, 5 };
	vector <int> keys4 = { 1, 2, 13, 4, 5, 20, 21, 22, 23, 24, 25 };
	vector <int> keys5 = { 1, 12, 3, 4, 5, 4, 3, 2, 1 };
	vector <int> keys6 = { 0, 256 };

	pair<int, int> coord01, coord02, coord03, coord04, coord05, coord06;
	coord01 = make_pair(1, 2);
	coord02 = make_pair(2, 3);
	coord03 = make_pair(3, 4);
	coord04 = make_pair(4, 5);
	coord05 = make_pair(5, 6);
	coord06 = make_pair(6, 7);
	
	// INSERTING KEYS
	myTrie->insert(keys1, coord01);
	myTrie->insert(keys2, coord02);
	myTrie->insert(keys3, coord03);
	myTrie->insert(keys5, coord05);
	myTrie->insert(keys6, coord06);

	cout << "insert done" << endl;
	
	// PRINTING KEYS
	if (myTrie->searchKey(keys1))
		myTrie->lexicographicalPrint(keys1);
	if (myTrie->searchKey(keys2))
		myTrie->lexicographicalPrint(keys2);
	if (myTrie->searchKey(keys3))
		myTrie->lexicographicalPrint(keys3);
	if (myTrie->searchKey(keys4)) // As you can see, this one wasn't inserted, so it should NOT be printed
		myTrie->lexicographicalPrint(keys4);
	if (myTrie->searchKey(keys5))
		myTrie->lexicographicalPrint(keys5);
	if (myTrie->searchKey(keys6))
		myTrie->lexicographicalPrint(keys6);
	
	/*
	removekeys(keys1);
	removekeys(keys2);
	removekeys(keys3);
	removekeys(keys4);
	removekeys(keys5);
	removekeys(keys6);
	*/
	return 0;
}
