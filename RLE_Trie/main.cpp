#include <utility>
#include <iostream>
#include "rlecodetrie.h"

using namespace std;

int main()
{   Trie *myTrie = new Trie();

    vector <int> keys1 = {1, 2, 3, 4, 5, 246};
    vector <int> keys2 = {1, 2, 3, 4, 15, 22, 11};
    vector <int> keys3 = {1, 2, 3, 14, 5, 1, 2, 3, 4, 5};
    vector <int> keys4 = {1, 2, 13, 4, 5, 20, 21, 22, 23, 24, 25};
    vector <int> keys5 = {1, 12, 3, 4, 5, 4, 3, 2, 1};
    vector <int> keys6 = {0, 256};
    vector <int> keys7 = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                          1, 1, 1, 1, 1, 1};


    pair<int, int> coord01, coord02, coord03, coord04, coord05, coord06, coord07, coord08;
    coord01 = make_pair(1,25);
    coord02 = make_pair(2,24);
    coord03 = make_pair(3,42);
    coord04 = make_pair(4,32);
    coord05 = make_pair(5,12);
    coord06 = make_pair(6,23);
    coord07 = make_pair(7,12);

    myTrie->insert(keys1, coord01);
    myTrie->insert(keys2, coord02);
    myTrie->insert(keys3, coord03);
    myTrie->insert(keys5, coord05);
    myTrie->insert(keys6, coord06);
    myTrie->insert(keys7, coord07);
    
    cout << "insert done" << endl;
    
    myTrie->lexicographicalPrint();

    myTrie->removeKey(keys1);
    myTrie->removeKey(keys3);
    myTrie->removeKey(keys5);
    myTrie->removeKey(keys6);
    myTrie->removeKey(keys7);

    cout << "remove done" << endl;
    
    myTrie->lexicographicalPrint();

    return 0;
}
