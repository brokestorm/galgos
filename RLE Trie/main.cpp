#include <bits/stdc++.h>

int main()
{
    int n, i;
	vector<char> printUtil;		// Utility variable to print tree

	// Creating the Trie Tree using calloc
	// so that the components are initialised
    struct node * trieTree = (struct node *) calloc(1, sizeof(struct node));
    char word[MAX_WORD_SIZE];

	printf("Enter the number of words-\n");
    scanf("%d", &n);

    for (i = 1; i <= n; ++i) {
        scanf("%s", word);
        insertWord(trieTree, word, i);
    }

    printf("\n");   // Just to make the output more readable
    lexicographicalPrint(trieTree, printUtil);

    printf("\nEnter the Word to be removed - ");
    scanf("%s", word);
    removeWord(trieTree, word);

    printf("\n");   // Just to make the output more readable
    lexicographicalPrint(trieTree, printUtil);

    return 0;
}