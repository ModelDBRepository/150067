//function RBFs=RBF(grados,numerogaussianas,sigma,maxforce,ERROR)

 // force estimation (for friction)

#include <math.h>
#include "mex.h"   //--This one is required
#include <stdio.h>
#define E 2.7182818284590452354




//nlhs (Type = int): This paramter represents the number of "left hand side" arguments.
//plhs (Type = array of pointers to mxArrays): This parameter is the actual output arguments.  As we will see
//later, an mxArray is MATLAB's structure for holding data and each element in plhs holds an mxArray of data.
//nrhs (Type = int): Similar to nlhs, this paramter holds the number of "right hand side" arguments.
//prhs (Type = const array of pointers to mxArrays): This array hold all of the pointers to the mxArrays of input data
//for instance, prhs[0] holds the mxArray containing x, prhs[1] holds the mxArray containing y, etc).                
void fgaussmf(double *DataValues, double c, double sigma, double *outArray,int fin);
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	//All code and internal function calls go in here!
//Declarations of entries
//Declarations
const mxArray *DegreeData;
double *DegreeValues;
int rowLenDegree, colLenDegree;
const mxArray *Numgauss;
int NumgaussValues;
const mxArray *sigma;
double sigmaValue;
const mxArray *maxforce;
double maxforceValue;
const mxArray *errorData;
double *errorValues;
int rowLenerror, colLenerror;


//output
double *outArray;
int num,fin,i,j=0,k,cuenta=0;

double *media;
double aux=0;

//Copy input pointer 
DegreeData=prhs[0];
Numgauss=prhs[1];
sigma=prhs[2];
maxforce=prhs[3];
errorData=prhs[4];
//Get the double
NumgaussValues = (int)(mxGetScalar(Numgauss));
sigmaValue=(double)(mxGetScalar(sigma));
maxforceValue=(double)(mxGetScalar(maxforce));



//Get matrix 
DegreeValues=mxGetPr(DegreeData);
rowLenDegree=mxGetN(DegreeData);
colLenDegree=mxGetM(DegreeData);
errorValues=mxGetPr(errorData);
rowLenerror=mxGetN(errorData);
colLenerror=mxGetM(errorData);
//Copy output pointer
//Allocate memory and assign output pointer
	plhs[0]=mxCreateDoubleMatrix(rowLenDegree,NumgaussValues,mxREAL);
//Get a pointer to the data space in our newly allocated memory
  outArray = mxGetPr(plhs[0]);
  media=(double *) mxCalloc(NumgaussValues,sizeof(double));

 
  			
  				
  for(i=0;i<NumgaussValues;i++){
   		
 	
 					media[i]=(double)i*maxforceValue/(double)(NumgaussValues-1)+errorValues[i];
 			
  		
  	fgaussmf(DegreeValues,media[i],sigmaValue,(outArray+i*rowLenDegree), rowLenDegree);
  	
  	}
	return;
	}




void fgaussmf(double *DataValues, double c, double sigma, double *outArray, int fin)
  {
  	int i;
  	
for(i=0;i<fin;i++){
	

	outArray[i]=pow(E,(-pow((DataValues[i]-c),2)/(2*pow(sigma,2))));
	
	}
//y = exp(-(x - c).^2/(2*sigma^2));

return;
}
//outArray[i]=(outArray+i)[0]