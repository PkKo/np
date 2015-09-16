#ifndef _PERMUTATION_
#define _PERMUTATION_

#ifdef __cplusplus
extern "C"
{
#endif
    /* return codes */
    
#define NFR_OK	0
#define NFR_REQ_PERM_SIZE_TOO_LARGE	1000
#define NFR_REQ_PAD_SIZE_TOO_LARGE  1001
#define NFR_MEMALLOC_ERROR			1002
#define NSR_PRNG_GEN_RANDOM_FAILED  1003
#define NFR_GAP_OBJ_NUM_TOO_LARGE	1004
    
    
    /* macro constants */
    
#define NF_MAX_PERM_SIZE	255
#define NF_MAX_PAD_SIZE		255
#define X9_RAND_BLKBYTE_SIZE 20
    
    int N_GenRandFromSeed(unsigned char *seedStr, unsigned int seedStrByte,
                          unsigned char **randStr, unsigned int randByte);
    
    void N_FreeRandString(unsigned char *randString, unsigned int randStringSize);
    
    int TrimObjStr(unsigned char *objStr, int objSize);
    
    int N_GenPermutation(unsigned char *sharedSecret, int sharedSecretSize,
                         unsigned char **permString, unsigned int permSize);
    
    void N_FreePermutation(unsigned char *permString, unsigned int permStringSize);
    
    int N_GenPadString(unsigned char *seedString, int seedStringSize,
                       unsigned int numObj, int maxPadSize,
                       unsigned char **padString, unsigned int *padStringSize);
    
    void N_FreePadString(unsigned char *padString, unsigned int padStringSize);
    
    int NM_GenKeyGapString(unsigned char *seedStr, unsigned int seedStrByte,
                           unsigned int m, unsigned int n,
                           unsigned char **gapString, unsigned int *gapStringSize);
    
    void N_FreeGapString(unsigned char *gapString, unsigned int gapStringSize);
    
#ifdef __cplusplus
}
#endif

#endif /* _PERMUTATION_ */