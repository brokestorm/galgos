#include <iostream>
#include <stdlib.h>
#include <cmath>
#include "functions.h"
#define sizeX 5

using namespace std;


int main (){
	double x[]= {0.4, 0.5, 0.1, 0.2, 0.3};
	double norm;
	double* vet = 0;

	CalculateNorm(x, sizeX, &norm);
	printf("%lf\n", norm);

	Projection_Symmetric(x, sizeX, vet);
	for(int i = 0; i < sizeX; i++){
		cout << "vet["<< i << "]: "<< vet[i] << endl;
	}
	
	free(vet);

	return 0;
}
