/*=================================================================
 * Computation of exact autocorrelation and normalized autocorrelation.
 * Used for pitch estimation based on long-term prediction (LTP).
 * MATLAB call:
 * [rxx_norm, rxx_all, rxx0]=xcorr_norm(x_all, lmin, lmax, Nb)
 * x_all:    input block of length Nb+lmax, including lmax pre-samples
 * lmin:     min. tested pitch lag
 * lmax:     max. tested pitch lag
 * Nb:       block length
 * rxx_norm: rxx_all normalized on energy of delayed block (for long-term-prediction)
 * rxx_all:  autocorrelation with use of pre-samples, use of exact delayed signal
 * rxx_0:    energy of delayed blocks
 *
 * all return values are vectors for the lag range lmin:lmax
 *
 * This is a MEX-file for MATLAB.  
 * compile in MATLAB using "mex xcorr_norm.c" (produces a dll)
 *
 * (c) 2002 Florian Keiler
 *=================================================================*/

#include <math.h>
#include "mex.h"

/* Input Arguments */

#define   X_ALL     prhs[0]       // length: N+lmax, with lmax samples preceding X
#define   LMIN      prhs[1]       // min. pitch lag
#define   LMAX      prhs[2]       // max. pitch lag
#define   NBLOCK    prhs[3]       // length of X
#define   RIGHT_ARGS     4        // no. of input arguments


/* Output Arguments */

#define   RXX_NORM       plhs[0]  // rxx_norm
#define   RXX_ALL        plhs[1]  // rxx_all
#define   X_ENERGY       plhs[2]  // rxx_0
#define   LEFT_ARGS      3        // no. of output arguments


static void autocorr(
             double *x,
             double *x_all,
             double *rxx_all,
             double *rxx_norm,
             double *x_energy,
             int N,
             int lmin,
             int lmax
             )
{   int i, l;
    int lag;
    double sum, sum_energy;
    
    // calc. rxx_all:
    for (l=0, lag=lmin; lag<=lmax; l++, lag++)  
    {
      sum_energy=0.0;
      for (i=0, sum=0.0; i<N; i++)                   // i=0,..,N-1
      {   sum+=x_all[i+lmax]*x_all[i+lmax-lag];      // x(i)*x(i-lag)
          sum_energy+=x_all[i+lmax-lag]*x_all[i+lmax-lag];  // x(i-lag)^2
      }     
      rxx_all[l]=sum;
      rxx_norm[l]=sum*sum/sum_energy;
      x_energy[l]=sum_energy;
    }
    return;
}

void mexFunction( int nlhs, mxArray *plhs[], 
            int nrhs, const mxArray*prhs[] )
     
{ 
    double *x, *x_all, *rxx_all, *rxx_norm, *x_energy; 
    double *lmin, *lmax, *N; 
    int lmin_i, lmax_i, N_i; 
    int Nlag; 
    int nn;
    
    /* Check for proper number of arguments */
    if (nrhs < RIGHT_ARGS) 
      mexErrMsgTxt("Not enough input arguments."); 
    else if (nrhs > RIGHT_ARGS) 
      mexErrMsgTxt("Too many input arguments."); 
    
    if (nlhs > LEFT_ARGS) 
      mexErrMsgTxt("Too many output arguments."); 
    else if (nlhs < LEFT_ARGS) 
      mexErrMsgTxt("Not enough output arguments."); 
     
    
    /* Assign pointers to the input parameters */ 
    x_all = mxGetPr(X_ALL);
    N     = mxGetPr(NBLOCK); 
    lmin  = mxGetPr(LMIN); 
    lmax  = mxGetPr(LMAX);

    // get parameters:
    lmin_i= (int) lmin[0];     // &lmin instead of lmin[0] doesn't work!!!
    lmax_i= (int) lmax[0];
    N_i=    (int) N[0];
    Nlag=lmax_i-lmin_i+1;      // no. of tested lags = length of output vectors

    // create signal block without pre-samples:
    x = (double *) malloc(N_i * sizeof(double));
    for(nn=0; nn<N_i; nn++)
    {  x[nn] = x_all[nn+lmax_i];
    }
  
    /* Create vectors for the return arguments */       
    RXX_ALL  = mxCreateDoubleMatrix(1, Nlag, mxREAL); 
    RXX_NORM = mxCreateDoubleMatrix(1, Nlag, mxREAL); 
    X_ENERGY = mxCreateDoubleMatrix(1, Nlag, mxREAL);

    /* Assign pointers to the output parameters */ 
    rxx_all  = mxGetPr(RXX_ALL);
    rxx_norm = mxGetPr(RXX_NORM);
    x_energy = mxGetPr(X_ENERGY);

        
    /* Do the actual computations in a subroutine */
    autocorr(x, x_all, 
             rxx_all, rxx_norm, x_energy, 
             N_i, lmin_i, lmax_i); 
    return;
    
}


