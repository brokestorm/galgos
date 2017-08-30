#include <bits/stdc++.h>
#include "spiralWalk.h"

using namespace std;

bool compareSpiral (int **patternA, int **patternB, int templateWidth, int templateHeight)
{
	int topLimit = 0;
	int bottomLimit = templateHeight -1;
	int leftLimit = 0;
	int rightLimit = templateWidth -1;
	
	while (topLimit <= bottomLimit && leftLimit <= rightLimit)
	{	for(int i = leftLimit; i <= rightLimit; i++)
		{
			
			if(patternA[topLimit][i] != patternB[topLimit][i]) return false;

		}	
		topLimit++;
		for(int i = topLimit; i <= bottomLimit; i++)
		{	
			if(patternA[i][rightLimit] != patternB[i][rightLimit]) return false;
		}
		rightLimit--;
		for(int i = rightLimit; i >= leftLimit; i--)
		{	
			if(patternA[bottomLimit][i] != patternB[bottomLimit][i]) return false;
		}	
		bottomLimit--;
		for(int i = bottomLimit; i >= topLimit; i--)
		{	
			if(patternA[i][leftLimit] != patternB[i][leftLimit]) return false;
		}
		leftLimit++;
	}

	return true;
}