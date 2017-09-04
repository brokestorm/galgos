#include <utility>
#include <iostream>
#include "rlecodetrie.h"

using namespace std;

int main()
{   Trie *myTrie = new Trie(16);

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
    
    if(myTrie->searchKey(keys1))
        myTrie->lexicographicalPrint(keys1);
    else
        printf("This key wasn't inserted\n");

    if(myTrie->searchKey(keys2))
        myTrie->lexicographicalPrint(keys2);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys3))
        myTrie->lexicographicalPrint(keys3);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys4))
        myTrie->lexicographicalPrint(keys4);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys5))
        myTrie->lexicographicalPrint(keys5);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys6))
        myTrie->lexicographicalPrint(keys6);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys7))
        myTrie->lexicographicalPrint(keys7);
    else
        printf("This key wasn't inserted\n");

    myTrie->removeKey(keys1);
    printf("OK!\n");
    myTrie->removeKey(keys3);
    printf("OK!\n");
    myTrie->removeKey(keys4);
    printf("OK!\n");
    myTrie->removeKey(keys5);
    printf("OK!\n");
    myTrie->removeKey(keys6);
    printf("OK!\n");
    myTrie->removeKey(keys7);
    printf("OK!\n");
    
    if(myTrie->searchKey(keys1))
        myTrie->lexicographicalPrint(keys1);
    else
        printf("This key wasn't inserted\n");

    if(myTrie->searchKey(keys2))
        myTrie->lexicographicalPrint(keys2);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys3))
        myTrie->lexicographicalPrint(keys3);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys4))
        myTrie->lexicographicalPrint(keys4);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys5))
        myTrie->lexicographicalPrint(keys5);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys6))
        myTrie->lexicographicalPrint(keys6);
    else
        printf("This key wasn't inserted\n");
        
    if(myTrie->searchKey(keys7))
        myTrie->lexicographicalPrint(keys7);
    else
        printf("This key wasn't inserted\n");

    myTrie->lexicographicalPrint(keys1);
    myTrie->lexicographicalPrint(keys2);
    return 0;
}
