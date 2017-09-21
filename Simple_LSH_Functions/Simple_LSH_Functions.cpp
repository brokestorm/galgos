#include "Simple_LSH_Functions.h"

using namespace std;

void CalculateNorm(double* x, int sizeX, double* ret){
	double sum = 0;

	for(int i = 0;i < sizeX; i++){
		sum += pow(x[i], 2);
	}
	*ret = sqrt(sum);
}

double* Projection_Symmetric(double* x, int sizeX){
	double aux;
	ret = (double*) malloc ((sizeX + 1)*sizeof(double));

	for(int i = 0; i < sizeX; i++){
		ret[i] = x[i];
	}
	CalculateNorm(x, sizeX, &aux);
	ret[sizeX] = sqrt(1 - aux);
}

double* Projection_Asymmetric1(double* x, int sizeX){
	double aux;
	ret = (double*) malloc ((sizeX + 2)*sizeof(double));

	for(int i = 0; i < sizeX; i++){
		ret[i] = x[i];
	}
	CalculateNorm(x, sizeX, &aux);
	aux = pow(aux, 2);
	ret[sizeX] = sqrt(1 - aux);
	ret[sizeX + 1] = 0;
	return ret;
}

double* Projection_Asymmetric2(double* x, int sizeX){
	double aux;
	double* ret = (double*) malloc ((sizeX + 2)*sizeof(double));

	for(int i = 0; i < sizeX; i++){
		ret[i] = x[i];
	}
	CalculateNorm(x, sizeX, &aux);
	aux = pow(aux, 2);
	ret[sizeX] = 0;
	ret[sizeX + 1] = sqrt(1 - aux);
	return ret;
}

/*void GetSphericalRandomVector_Alpha(int sizeAlpha, double* Alpha){
	Alpha = (double*) malloc (sizeAlpha*sizeof(double));
	default_random_engine generator;
	normal_distribution<double> distribution(0,1);
	int nrolls = 1000;
	for (int i = 0; i<nrolls; ++i) {
    double number = distribution(generator);
    if ((number>=0)&&(number<sizeAlpha)) ++Alpha[int(number)];
  }
}*/

void InnerProduct(double* x, double* y, int sizeXY, double* ret){
	*ret = 0;
	for(int i = 0; i < sizeXY; i++){
		*(ret) = *(ret) + x[i]*y[i];
	}
}

void Sign(double x, double* ret){
	if (x >= 0){*ret = 1;}
	else {*ret = -1;}
}

void Sign01(double x, double* ret){
	if (x >= 0){*ret = 1;}
	else {*ret = 0;}
}