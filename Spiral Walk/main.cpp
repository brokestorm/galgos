#include <bits/stdc++.h>
#include "spiralWalk.h"

using namespace std;

#define DIM 16

int main (){
	int templateWidth = DIM;
	int templateHeight = DIM;

	int **patternA = new int *[DIM];
	int **patternB = new int *[DIM];
	int **patternC = new int *[DIM];
	int **patternD = new int *[DIM];
	int **patternE = new int *[DIM];
	int **patternF = new int *[DIM];
	int **patternG = new int *[DIM];
	
	for(int i = 0; i < templateWidth; i++)
	{	
		patternA[i] = new int [DIM];
		patternB[i] = new int [DIM];
		patternC[i] = new int [DIM];
		patternD[i] = new int [DIM];
		patternE[i] = new int [DIM];
		patternF[i] = new int [DIM];
		patternG[i] = new int [DIM];
		for(int j = 0; j < templateHeight; j++)
		{	
			patternA[i][j] = 0;
			patternB[i][j] = 0;
			patternC[i][j] = 0;
			patternD[i][j] = 0;
			patternE[i][j] = 0;
			patternF[i][j] = 0;
			patternG[i][j] = 0;
		}
	}
    
	patternC[8][8] = 1;
	patternD[0][0] = 1;
	patternE[0][15] = 1;
	patternF[15][15] = 1;
	patternG[3][3] = 1;

	bool check;
    check = compareSpiral(patternA, patternB, templateWidth, templateHeight);
    cout << check << endl;
    for(int i = 0; i < 1000000000; i++)
    {
		//check = compareSpiral(patternA, patternC, templateWidth, templateHeight);
    	//cout << check << endl;
    	printf("%d\n", i);
	}
	cout << "done" << endl;
	/*
    check = compareSpiral(patternA, patternD, templateWidth, templateHeight);
    cout << check << endl;
	check = compareSpiral(patternA, patternE, templateWidth, templateHeight);
    cout << check << endl;
    for(int i = 0; i < 1000000000; i++)
    {
    check = compareSpiral(patternA, patternF, templateWidth, templateHeight);
    cout << check << endl;
	}
	cout << "done 2" << endl;
	check = compareSpiral(patternA, patternG, templateWidth, templateHeight);
    cout << check << endl;
	*/

	return 0;
}