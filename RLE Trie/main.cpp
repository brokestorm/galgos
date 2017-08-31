#include <bits/stdc++.h>
#include "rlecodetrie.cpp"

using namespace std;

int main()
{   Trie myTrie = new Trie();

	// Creating the Trie Tree using calloc
	// so that the components are initialised
    int keys1[] = {1, 2, 3, 4, 5, 246};
    int keys2[] = {1, 2, 3, 4, 15, 22, 11};
    int keys3[] = {1, 2, 3, 14, 5, 1, 2, 3, 4, 5};
    int keys4[] = {1, 2, 13, 4, 5, 20, 21, 22, 23, 24, 25};
    int keys5[] = {1, 12, 3, 4, 5, 4, 3, 2, 1};
    int keys6[] = {0, 256};
   // int keys[MAX_KEY_SIZE];

    pair<int, int> coord01, coord02, coord03, coord04, coord05, coord06;
    coord01 = make_pair(1,2);
    coord02 = make_pair(2,3);
    coord03 = make_pair(3,4);
    coord04 = make_pair(4,5);
    coord05 = make_pair(5,6);
    coord06 = make_pair(6,7);

	//printf("Enter the number of keys-\n");
    //scanf("%d", &n);
    myTrie.insert(keys1, coord01);
    myTrie.insert(keys2, coord02);
    myTrie.insert(keys3, coord03);
    myTrie.insert(keys4, coord04);
    myTrie.insert(keys5, coord05);
    myTrie.insert(keys6, coord06);

/*
    printf("\n");   // Just to make the output more readable
    lexicographicalPrint(keys1);
    printf("\n");   // Just to make the output more readable
    lexicographicalPrint(keys2);
    printf("\n");   // Just to make the output more readable
    lexicographicalPrint(keys3);
    printf("\n");   // Just to make the output more readable
    lexicographicalPrint(keys4);
    printf("\n");   // Just to make the output more readable
    lexicographicalPrint(keys5);
    printf("\n");   // Just to make the output more readable
    lexicographicalPrint(keys6);

    removekeys(keys1);
    removekeys(keys2);
    removekeys(keys3);
    removekeys(keys4);
    removekeys(keys5);
    removekeys(keys6);
*/
    return 0;
}