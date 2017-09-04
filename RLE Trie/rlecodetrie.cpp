#include "rlecodetrie.h"

using namespace std;

Trie::Trie()
{
	root = new Node();
}

// Inserts a int vector "keys" into the Trie Tree
// 'trieTree' and associates a vector which contains
// the coordinates from the corresponding template.
void Trie::insert(vector <int> keys, pair<int, int> coordinates)
{
	Node *traverse = root;
    
	vector <int>::iterator counter = keys.begin();
	while (counter != keys.end()) {     // Until there is something to process
		if (traverse->children[*counter] == NULL)
		{
			// There is no node in 'trieTree' corresponding to this RLE code
			traverse->children[*counter] = new Node();
			traverse->children[*counter]->parent = traverse;  // Assigning parent
		}

		traverse = traverse->children[*counter];
		counter++;
	}

	traverse->occurrences.push_back(coordinates);      // associates the RLE code with the coordinates from the template which is being analized
}


// Verify either if the key exists or not, returns a bool value
bool Trie::searchKey(vector <int> keys)
{	// Function is very similar to insert() function

	Node* treeNode = root;
    
    vector <int>::iterator counter = keys.begin(); 
    
	while (counter != keys.end()) {
		if (treeNode->children[*counter] != NULL) {
			treeNode = treeNode->children[*counter];
			++counter;
		}
		else {
			break;
		}
	}

	if (treeNode->occurrences.size() != 0) { 
		// keys found
		return true;
	}
	else {
		// keys not found
		return false;
	}
}

// Searches for the occurence of a RLE code in 'trieTree',
// if not found, returns NULL,
// if found, returns poniter pointing to the
// last node of the RLE code in the 'trieTree'
// Complexity -> O(length_of_rlecode_to_be_searched)
Trie::Node * Trie::searchNode(vector<int> keys)
{
	Node* trieNode = root;

	// Function is very similar to insert() function
	vector<int>::iterator counter = keys.begin(); 
	while (counter!= keys.end()) {
		if (trieNode->children[*counter] != NULL) {
			trieNode = trieNode->children[*counter];
			++counter;
		}
		else {
			break;
		}
	}

	if (trieNode->occurrences.size() != 0) {
		// keys found
		return trieNode;
	}
	else {
		// keys not found
		return NULL;
	}
}

// Searches the RLE Code first, if not found, does nothing
// if found, deletes the nodes corresponding to the RLE Code
void Trie::removeKey(vector<int>keys)
{
	Node* trieNode = searchNode(keys); //search the key in the tree

	if (trieNode == NULL) {
		// keys not found
		return;
	}

	trieNode->occurrences.pop_back();    // Deleting the coordinate

    // 'noChild' indicates if the node is a leaf node
	bool noChild = true;

	int childCount = 0;
	// 'childCount' has the number of children the current node
	// has which actually tells us if the node is associated with
	// another RLE Code .This will happen if 'childCount' != 0.
	int i;

	// Checking children of current node
	for (i = 0; i <= RLE_CODE; ++i) {
		if (trieNode->children[i] != NULL) {
			noChild = false;
			++childCount;
		}
	}

	if (!noChild) {
		// The node has children, which means that the RLE code whose
		// occurrence was just removed is a prefix
		// So, logically no more nodes have to be deleted
		return;
	}

	Node * parentNode = root;     // variable to assist in traversal

	while (trieNode->occurrences.size() == 0 && trieNode->parent != NULL && childCount == 0) {
		// trieNode->occurrences.size() -> tells if the node is associated with another RLE CODE
		// trieNode->parent != NULL -> is the base case sort-of condition, we simply ran
		// out of nodes to be deleted, as we reached the root
		// childCount -> does the same thing as explained in the beginning, to every node
		// we reach
		childCount = 0;
		parentNode = trieNode->parent;

		for (i = 0; i <= RLE_CODE; ++i) {
			if (parentNode->children[i] != NULL) {
				if (trieNode == parentNode->children[i]) {
					// the child node from which we reached
					// the parent, this is to be deleted
					parentNode->children[i] = NULL;
					free(trieNode);
					trieNode = parentNode;
				}
				else {
					++childCount;
				}
			}
		}
	}
}

// Prints the 'trieTree' in a Pre-Order or a DFS manner
// which automatically results in a Lexicographical Order
void Trie::lexicographicalPrint(vector<int> keys)
{
	int i;
	bool noChild = true;

	Node* trieNode = root;
	
	if(!searchKey(keys))
	{
	    cout << "this key hasn't been inserted yet" << endl;
	    return;
	}

    //counter to pass through the key
	vector<int>::iterator counter = keys.begin();
    
	while (counter != keys.end()) {
		if (trieNode->children[*counter] != NULL) { //do the key exists in the treeNode?
			cout << *counter << " -> "; // print the content from the key, if it exists in the treeNode 
			trieNode = trieNode->children[*counter];
			++counter;
		}
		else {
			break;
		}
	}
	cout << "@ Coordinate -> ";
		
	//this format is useful for printing pairs
    for (auto &x : trieNode->occurrences)
	{
	   	cout << x.first << ":" << x.second << endl;
	}
	
}



