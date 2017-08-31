#include <bits/stdc++.h>

using namespace std;

#define PATTERN_SIZE 16
#define RLE_CODE (PATTERN_SIZE * PATTERN_SIZE)
#define MAX_KEY_SIZE (PATTERN_SIZE * PATTERN_SIZE)



class Trie
{
	private:
		class Node {
    		Node * parent;
    		//struct node * children[RLE_CODE];
    		unordered_map < int, Node *> children;
    		vector<pair<int, int> > occurrences;
		};
 
		Node * root;

		// Searches for the occurence of a RLE code in 'trieTree',
			// if not found, returns NULL,
			// if found, returns poniter pointing to the
			// last node of the RLE code in the 'trieTree'
			// Complexity -> O(length_of_rlecode_to_be_searched)
		Node * searchNode(int* keys);
	
	public:
			// Inserts a int vector "keys" into the Trie Tree
			// 'trieTree' and associates a vector which contains
			// the coordinates from the corresponding template.
		void insert(int* keys, pair<int, int> coordinates);
		
		bool searchKey(int* keys);
		
			// Searches the RLE Code first, if not found, does nothing
			// if found, deletes the nodes corresponding to the RLE Code
		void remove(int * keys);
		
			// Prints the 'trieTree' in a Pre-Order or a DFS manner
			// which automatically results in a Lexicographical Order
		void lexicographicalPrint(vector<int> keys);

		Trie();
};