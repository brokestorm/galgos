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

	return (treeNode->occurrences.size() != 0);
}

// Searches for the occurence of a RLE code in 'trieTree',
// if not found, returns NULL,
// if found, returns poniter pointing to the
// last node of the RLE code in the 'trieTree'
// Complexity -> O(length_of_maxRleCode_to_be_searched)
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
	// Checking children of current node
	for(auto myPair : trieNode->children)
	{	if (myPair.second != NULL) 
		{
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

	while (trieNode->occurrences.size() == 0 && trieNode->parent != NULL && childCount == 0) 
	{
		// trieNode->occurrences.size() -> tells if the node is associated with another RLE CODE
		// trieNode->parent != NULL -> is the base case sort-of condition, we simply ran
		// out of nodes to be deleted, as we reached the root
		// childCount -> does the same thing as explained in the beginning, to every node
		// we reach
		childCount = 0;
		parentNode = trieNode->parent;

		for(auto &myPair2 : parentNode->children)
		{
			if (myPair2.second != NULL) {
				if (trieNode == myPair2.second) {
					// the child node from which we reached
					// the parent, this is to be deleted
					myPair2.second = NULL;
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

// calls Print
void Trie::lexicographicalPrint()
{
	Node* trieNode = root;
	vector <int> *x = new vector <int> ();
	cout << endl;
	Print(trieNode, x);
	cout << endl;
	cout << "finished printing" << endl;

}



// Prints the 'trieTree' in a Pre-Order or a DFS manner
// which automatically results in a Lexicographical Order
void Trie::Print(Node* trieNode, vector <int>* path){
	if(trieNode->occurrences.size() != 0)
	{
		for(unsigned i = 0; i < path->size(); i++)
			cout << path->operator[] (i) << " - ";
		cout << "<" << trieNode->occurrences[0].first << ";" << trieNode->occurrences[0].second << ">" << endl;
	}

	for(auto &child : trieNode->children){
		if(child.second == NULL) 
			continue;
		else{
			path->push_back(child.first);
			Print(child.second, path);
			path->pop_back();
		}
	}
}
