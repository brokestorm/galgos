#include <iostream>
#include <utility>
#include <unordered_map>
#include <vector>

using namespace std;

class Trie
{
	private:
		struct Node {
		    	Node * parent;
		    	unordered_map < int, Node *> children;
		    	vector<pair<int, int> > occurrences; // stores the coordinates and marks the end of each rle code
		};
	
		Node * root;
		
		// Searches for the occurence of a RLE code in 'trieTree',
		// if not found, returns NULL,
		// if found, returns poniter pointing to the
		// last node of the RLE code in the 'trieTree'
		// Complexity -> O(length_of_rlecode_to_be_searched)
		Node * searchNode(vector <int> keys);
		
		int maxRleCode; // parameter that stores the maximum size of a branch
	
	
	public:

		// Inserts a int vector "keys" into the Trie Tree
		// 'trieTree' and associates a vector which contains
		// the coordinates from the corresponding template.
		void insert(vector <int> keys, pair<int, int> coordinates);
	
	    // Verify either if the key exists or not, returns a bool value
		bool searchKey(vector <int> keys);
	
		// Searches the RLE Code first, if not found, does nothing
		// if found, deletes the nodes corresponding to the RLE Code
		void removeKey(vector <int> keys);
	
		// Prints the 'trieTree' in a Pre-Order or a DFS manner
		// which automatically results in a Lexicographical Order
		void lexicographicalPrint(vector<int> keys);
	    
	    //Constructor
		Trie(int);
};
