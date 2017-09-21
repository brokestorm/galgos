#include <cstdio>
#include <cstdlib>
#include <cstring>


int main (){
	FILE *pGrid;
	FILE *pNewFile;
	char character;
	int i = 0, j = 0;
	int dim = 0;

	pGrid = fopen("Strebelle_HD_Lists/HDlist2_Strebelle.csv", "r");
	if(pGrid == NULL)
	{
		printf("Ocorreu um erro ao abrir o arquivo\n");
		exit(1);
	}

	pNewFile = fopen("Strebelle_HD_Lists_Results/New_HDlist_Strebelle.txt", "w");
	if(pNewFile == NULL)
	{
		printf("Ocorreu um erro ao criar um novo arquivo\n");
		exit(1);
	}	

	while(!feof(pGrid))
	{	
		fscanf(pGrid, "%c", &character);
		if (character == '1' || character == '2')
		{
			fprintf(pNewFile, "%d %d %d %c\n", i, j, dim, character);
		}
		else if(character == ',')
		{
			i++;
		}
		else if(character == '\n'){
			j++;
			i = 0;
		}
		
	}

	fclose(pGrid);
	fclose(pNewFile);
	return 0;
}

