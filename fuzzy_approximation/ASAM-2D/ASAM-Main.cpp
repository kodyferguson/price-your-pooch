// 2DASAM-v2.1 main function
// Linear samples version
// 7-March-2017
// Olaoluwa Adigun

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include "Eigen/Core"

#define PI 3.14159265

using namespace std;
using namespace Eigen;

#include "ASAM.h"
#include "GaussianASAM.h"
#include "SincASAM.h"
#include "CauchyASAM.h"

int main(int argc, char *argv[]){

	int numRules = 24;
	int epochSize = 500; 
	int adaptIters = epochSize*5;
	matrix fxn, fxn1;
	VectorXd xin, yin, fxyin;
	const int fnums = 3; int temp;

	string line=" ";
	istringstream buf(line);

	system("cd");

	string rd, mk;
	string mkcmd = "mkdir -p ";
	string rmcmd = "rm -r ";
	
	

	string fnames[3] = {"FxnGen2D.dat", "InputFxn.dat", "Errors.dat"};

        std::fstream fxnio[3];
        //fxnio[0].open(fnames[0].data(), ios::in);
        fxnio[1].open(fnames[1].data(), ios::out);
        fxnio[2].open(fnames[2].data(), ios::out);
	
	fxnio[1].precision(9);fxnio[2].precision(9);

	if (fxnio[1].fail() || fxnio[2].fail()){
		cout<<"file i/o error.\n";
		//system("PAUSE");  This system command does not exist in linux. You can achieve 
		//		    same fanctionality with the linux command read 
		return EXIT_FAILURE; 
	}
	cout<<"File Opening done \n";
/***
	// Determine dynamic matrix size
	int nrows=0;
	while(getline(fxnio[0], line)) nrows++;	

	fxn.resize(nrows, 3);
	fxn.fill(0);
	cout << "\n# of Input Data Points= " << fxn.rows() << endl;

	// Read in function values
	fxnio[0].clear(); fxnio[0].seekg(0);
	int r=0, c=0;
	double tmp; 
	while(getline(fxnio[0], line)){
		buf.clear(); buf.str(line);
		while(buf >> tmp){
			fxn(r,c)=tmp; 
			fxnio[1] << tmp << "\t";
			c++;
		}
		fxnio[1] << endl;
		r++; c = 0;
	}	
***/
////////////////////////////////////////////////////////////////////////////

	// Set input information
	int N = 3114; // 3114 different dog listings input size
	double min_x = 0.00, max_x = 6.414;	
	double step_size_x = (max_x - min_x) / N;

	double min_y = 0.00, max_y = 6.414;	
	double step_size_y = (max_y - min_y) / N;

	fxn1.resize(N, 3);
	fxn1.fill(0);
	cout << "\n# of Input Data Points= " << fxn1.rows() << endl;

	vector<double> n(N,1);
	double u1, u2, g1, g2;


	///////// DEFINE PARAMETER FOR ADDED NOISE

	// Define the parameter for Uniform noise
	double a = 0.0 , b = 0.1;
	// Define the parameter for the Cauchy noise
	double m = 0.0, d = 0.001;
	// Define the paramter for Gaussian noise
	double mu = 0.0, sigma = 0.005; // Originally 0.001

	// Generate the noise samples
	int noisetype = 3; // 1 -- No noise, 2 -- Uniform Noise, 3 -- Gaussian, 4-- Cauchy Noise    


	switch (noisetype) {
		// No noise
		case 1: cout << "NOISE MODE : No Noise" << endl;  
			for (int i=0; i<N; i++) {
				n[i] = 0;
				
			}
			break;
		// Uniform
		case 2: cout << "NOISE MODE : Uniform" << endl; 
			for (int i=0; i<N; i++) {
				n[i] = rand()/(float)RAND_MAX;
				n[i] = a + (n[i] * (b-a));
			}
			break;
		// Gaussian using Box-Muller transform
		case 3: cout << "NOISE MODE : Gaussian" << endl; 
			for (int i=0; i<N; i++) {
				u1 = rand()/(float)RAND_MAX;
				u2 = rand()/(float)RAND_MAX;
				n[i] = sqrt(-2*log(u1))*cos(2*PI*u2);
				n[i] = (n[i] * sigma) + mu;
			}
			break;
		// Cauchy using Box-Muller transformation -> ratio
		case 4: cout << "NOISE MODE : Cauchy" << endl; 
			for (int i = 0; i<N; i++) {
				u1 = rand()/(float)RAND_MAX;
				u2 = rand()/(float)RAND_MAX;
				g1 = sqrt(-2*log(u1))*cos(2*PI*u2);
				g2 = sqrt(-2*log(u1))*sin(2*PI*u2);
				n[i] = g1/g2;
				n[i] = (n[i] * d) + m;
			}
	}

	
	//Need to change precision of I/O pipes here...
	fxnio[1].precision(9);

	/*
	// Generate the samples
	fxnio[1] << "  x   " << "\t \t" << "   y   " << "\t \t" << "   F(x,y)   " << endl;
	for (int i = 0; i < N; i++){
		fxn1(i,0) = min_x + (i*step_size_x);
		fxn1(i,1) = min_x + (i*step_size_y);
		fxn1(i,2) = (sin(fxn1(i,0))*cos(fxn1(i,1))) + n[i] ; // THE FUNCTION
		fxnio[1]  <<fxn1(i,0) << "\t" << fxn1(i,1) << "\t " << fxn1(i,2) << endl;
	}
	*/

	// Need to read in input file and populate xv, yv, and fxyv
	std::ifstream dogDataFile("standardized_reduced_dog_data_bounded.txt");
	int matrixRow = 0;
	fxnio[1] << "  x   " << "\t \t" << "   y   " << "\t \t" << "   F(x,y)   " << endl;
	while (!dogDataFile.eof())
        {
            std::string nextLine;
            std::getline(dogDataFile, nextLine);
            std::string breed, heritage, price;
            double breedNum, heritageNum, priceNum;
            breed = nextLine.substr(0,nextLine.find(",")-2);
            heritage = nextLine.substr(nextLine.find(",")-1,1);
            price = nextLine.substr(nextLine.find(",")+1, nextLine.length()-nextLine.find(",")-1);
            int breedInt = std::stoi(breed);
            int heritageInt = std::stoi(heritage);
            //int priceInt = std::stoi(price);
            breedNum = static_cast<double>(breedInt);
            heritageNum = static_cast<double>(heritageInt);
            //priceNum = static_cast<double>(priceInt);
            priceNum = std::stod(price);
            // Populate data matrix
            fxn1(matrixRow,0) = breedNum;
            fxn1(matrixRow,1) = heritageNum;
            fxn1(matrixRow,2) = priceNum;
			//fxn1(matrixRow,2) = breedNum + heritageNum;
			fxnio[1]  <<fxn1(matrixRow,0) << "\t" << fxn1(matrixRow,1) << "\t " << fxn1(matrixRow,2) << endl;
			std::cout << breedNum << " " << heritageNum << " " << priceNum << " " << std::endl;
            //xv.push_back(breedNum);
            //yv.push_back(heritageNum);
            //fxyv.push_back(priceNum);
            matrixRow++;
        }
	dogDataFile.close();

///////////////////////////////////////////////////////////////////////////

	xin = (fxn1.col(0)); vector<double> xv = eigvec2stdvec(xin) ;	
	yin = (fxn1.col(1)); vector<double> yv = eigvec2stdvec(yin) ;	
	fxyin = (fxn1.col(2)); vector<double>fxyv = eigvec2stdvec(fxyin) ;	
	

	//...ASAM(xvals, yvals, fxyvals, _numpat, _numsam, _numdes)
	//ASAM* sam =  new CauchyASAM( xv, yv, fxyv, numRules, (int) (0.5*xin.size()), xin.size() );
	//delete sam;

	GaussianASAM gsam( xv, yv, fxyv, numRules, (int) (0.2*xin.size()), xin.size() ); 
	SincASAM ssam( xv, yv, fxyv , numRules, (int) (0.2*xin.size()), xin.size() );
	CauchyASAM csam( xv, yv, fxyv , numRules, (int) (0.2*xin.size()), xin.size() );

	//(Make) Dirs for each fit fxn.
	// Reset Record by removing dirs.
	string name[] = {"Gauss", "Sinc", "Cauchy"};
	fxnio[2] << "Iter# ";
	for(int t = 0; t < 3 ; t++){
		rd = rmcmd + name[t];
		mk = mkcmd + name[t];
		system(rd.data());  //Reset record for new runs.
		system(mk.data()); 
		fxnio[2] << "\t    " << name[t];
	}
	fxnio[2] << endl;
	cout << "Epoch Size: "<< epochSize << endl;

	int k = 0; vector<double> errors;
	vector<double>::const_iterator i;
	double minerr; int loc; bool minQ;
	do {
		gsam.Learn(); 
		ssam.Learn();
		csam.Learn();
		if (k% epochSize == 0){	
			errors.clear();
			errors.push_back(gsam.Approx()); errors.push_back(ssam.Approx()); errors.push_back(csam.Approx());
			gsam.WriteEpoch(k); ssam.WriteEpoch(k); csam.WriteEpoch(k);

			minerr = *(std::min_element(errors.begin(), errors.end()));			
			fxnio[2] << k ;
			minQ = false; loc = 0;
			for ( i = errors.begin(); i < errors.end() ; i++ ){ //Log MSEs & Locate Min.
				fxnio[2] << "\t" << *i ;
				if ( (!minQ) && (*i != minerr) ) loc++;
				else minQ = true;
			}
			fxnio[2]<< endl;
			double rootMinerr = std::sqrt(minerr);
			cout << "iter# " << k << ": Min. Error = " << rootMinerr 
				<< " using " << name[loc] << " fit function." << endl;
		}
		k++;
	} while( k <= adaptIters || minerr < 1e-7 );

	for(temp = 0; temp < fnums ; temp++) fxnio[temp].close();	
	std::cout << "\nDone. Final min MSE = " << std::sqrt(errors[loc]) << endl;
	//system("PAUSE");  This system command does not exist in linux. You can achieve same fanctionality with the linux command read
	return EXIT_SUCCESS;
}
