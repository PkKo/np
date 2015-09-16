#ifndef _NSAFER_
#define _NSAFER_

#ifdef __cplusplus
extern "C"
{
#endif

#ifndef NS_DISABLE_TRUE_FALSE
#ifndef FALSE
#define FALSE				0
#endif
#ifndef TRUE
#define TRUE				1
#endif
#endif /* !NS_DISABLE_TRUE_FALSE */

#define NS_TRUE				TRUE
#define NS_FALSE			FALSE

typedef unsigned char		NS_BYTE;
typedef NS_BYTE				NS_CHAR;
typedef NS_BYTE				NS_BBOOL;

typedef unsigned int		NS_ULONG;
typedef int					NS_LONG;

typedef NS_BYTE				*NS_BYTE_PTR;
typedef NS_CHAR				*NS_CHAR_PTR;
typedef NS_ULONG			*NS_ULONG_PTR;
typedef void				*NS_VOID_PTR;

/* NSAFER library의 버전 정보 */
typedef struct _NS_VERSION {
  NS_BYTE	major;  /* integer portion of version number  */
  NS_BYTE	minor;  /* 1/100ths portion of version number */
}NS_VERSION, *NS_VERSION_PTR;

/* NSAFER library의 세부 정보 */ 
typedef struct _NS_INFO {
  NS_VERSION	nsapiVersion;			/* interface version  */
  NS_CHAR		manufacturerID[32];		/* blank padded       */
  NS_ULONG		flags;					/* must be zero       */
  NS_CHAR		libraryDescription[32];	/* blank padded       */
  NS_VERSION	libraryVersion;			/* version of library */
} NS_INFO, *NS_INFO_PTR;

typedef struct _NS_ATTRIBUTE {
	NS_ULONG		type;			/* 데이터의 타입				*/
	NS_VOID_PTR		pValue;			/* 데이터						*/
	NS_ULONG		ulValueLen;		/* 데이터의 byte 단위 크기		*/
	NS_BBOOL		bSensitive;		/* 보안상 민감한 데이터 여부	*/
	NS_BBOOL		bAlloc;			/* pValue에 대한 라이브러리
									   내부에서의 메모리 할당 여부	*/
} NS_ATTRIBUTE, *NS_ATTRIBUTE_PTR;

#define	NS_SZ_OBJECT			8		
typedef NS_ATTRIBUTE			NS_OBJECT[NS_SZ_OBJECT];
typedef NS_OBJECT*				NS_OBJECT_PTR;

#define	NS_SZ_CONTEXT_INTERNAL	10
#define	NS_SZ_CONTEXT_EXTERNAL	10
#define	NS_SZ_CONTEXT	NS_SZ_CONTEXT_INTERNAL+NS_SZ_CONTEXT_EXTERNAL

typedef NS_ATTRIBUTE	NS_CONTEXT[NS_SZ_CONTEXT];
typedef NS_CONTEXT*		NS_CONTEXT_PTR;

/***********************************************************************
	함수의 반환코드를 나타내는 자료형
***********************************************************************/
typedef NS_ULONG	NS_RV;

/***********************************************************************
	Return value
***********************************************************************/
/* return value : 성공시 */
#define NSR_OK								0

/* return value : 실패시 */
#define NSR_DEFAULT_ERROR					-1

/***********************************************************************
	Global constants
***********************************************************************/
#ifdef WIN32
#ifdef SHLIB_EXPORTS
#define NSGLOBAL __declspec(dllexport) 
#else
#define NSGLOBAL __declspec(dllimport) 
#endif
#endif

/***********************************************************************
	Constants
***********************************************************************/
/* ECDSA 서명 크기 */
#define NS_ECDSA_SIGN_BYTE_LEN			1024

/* ECDH Key 크기 */
#define NS_ECDH_KEY_BYTE_LEN			21

/* X9.62 XSEED, XKEY 크기 */
#define NS_RANDOM_X9_62_SEED_BYTE_LEN	20

/* X9.62 XSEED, XKEY 크기 */
#define NS_RANDOM_X9_31_SEED_BYTE_LEN	20

/* SEED block 크기 */
#define NS_SEED_BLOCK_BYTE_LEN			16
#define NS_SEED_KEY_BYTE_LEN			16

/* AES block 크기 */
#define NS_AES_BLOCK_BYTE_LEN			16
#define NS_AES128_KEY_BYTE_LEN			16
#define NS_AES192_KEY_BYTE_LEN			24
#define NS_AES256_KEY_BYTE_LEN			32

/* ARIA block 크기 */
#define NS_ARIA_BLOCK_BYTE_LEN			16
#define NS_ARIA128_KEY_BYTE_LEN			16
#define NS_ARIA192_KEY_BYTE_LEN			24
#define NS_ARIA256_KEY_BYTE_LEN			32

/* DES block 크기 */
#define NS_DES_BLOCK_BYTE_LEN			8
#define NS_DES_KEY_BYTE_LEN				8

/* SHA1 해쉬 크기 */
#define NS_SHA1_HASH_BYTE_LEN			20

/* SHA256 해쉬 크기 */
#define NS_SHA256_HASH_BYTE_LEN			32

/* SHA384 해쉬 크기 */
#define NS_SHA384_HASH_BYTE_LEN			48

/* SHA512 해쉬 크기 */
#define NS_SHA512_HASH_BYTE_LEN			64

/* 최대 Label 바이트*/
#define	NS_MAX_LABEL_BYTE_LEN			256


/***********************************************************************
 	NS_CONTEXT의 type들은 NS_CONTEXT의 첫번째 NS_ATTRIBUTE에 다음과 같이
	지정될 수 있다.
***********************************************************************/
enum NSE_CONTEXT_TYPE{

	/*SEED */
	 NSO_CTX_SEED_KEY_GEN,
	 NSO_CTX_SEED_ECB,
	 NSO_CTX_SEED_CBC,
	 NSO_CTX_SEED_CBC_PAD,
	 NSO_CTX_SEED_OFB,
	 NSO_CTX_SEED_CFB,
	 NSO_CTX_SEED_MAC,
	 NSO_CTX_SEED_PAD_MAC,
	 NSO_CTX_RANDOM_SEED_CBC,

	/*ARIA*/
	 NSO_CTX_ARIA_KEY_GEN,
	 NSO_CTX_ARIA_ECB,
	 NSO_CTX_ARIA_CBC,
	 NSO_CTX_ARIA_CBC_PAD,
	 NSO_CTX_ARIA_OFB,
	 NSO_CTX_ARIA_CFB,
	 NSO_CTX_ARIA_MAC,
	 NSO_CTX_ARIA_PAD_MAC,
	 NSO_CTX_RANDOM_ARIA_CBC,

	 /*AES*/
	 NSO_CTX_AES_KEY_GEN,
	 NSO_CTX_AES_ECB,
	 NSO_CTX_AES_CBC,
	 NSO_CTX_AES_CBC_PAD,
	 NSO_CTX_AES_OFB,
	 NSO_CTX_AES_CFB,
	 NSO_CTX_AES_MAC,
	 NSO_CTX_AES_PAD_MAC,
	 NSO_CTX_RANDOM_AES_CBC,

	 /*DES*/
	 NSO_CTX_DES_KEY_GEN,
	 NSO_CTX_DES_ECB,
	 NSO_CTX_DES_CBC,
	 NSO_CTX_DES_CBC_PAD,
	 NSO_CTX_DES_OFB,
	 NSO_CTX_DES_CFB,
	 NSO_CTX_DES_MAC,
	 NSO_CTX_DES_PAD_MAC,
	 NSO_CTX_RANDOM_DES_CBC,

	 /*SHA1*/
	 NSO_CTX_SHA1,
	 NSO_CTX_SHA1_HMAC,	 

	 /*SHA256*/
	 NSO_CTX_SHA256,
	 NSO_CTX_SHA256_HMAC,

	 /*SHA384*/
	 NSO_CTX_SHA384,
	 NSO_CTX_SHA384_HMAC,

	 /*SHA512*/
	 NSO_CTX_SHA512,
	 NSO_CTX_SHA512_HMAC,
	 
	 /*MD5*/
	 NSO_CTX_MD5,

	 /*RAND*/
	 NSO_CTX_RANDOM_X9_62,
	 NSO_CTX_RANDOM_X9_31,

	 /*ECDHWithSEED Encryption*/
	 NSO_CTX_ECDH_SEED_CBC,
	 NSO_CTX_ECDH_SEED_CBC_PAD,

	/*RSA*/
	 NSO_CTX_RSA_KEYPAIR_GEN,
	 NSO_CTX_RSA_PKCK_V15_ENCRYPT,
	 NSO_CTX_RSA_OAEP_ENCRYPT_SHA1,
	 NSO_CTX_RSA_OAEP_ENCRYPT_SHA256,
	 NSO_CTX_RSA_OAEP_ENCRYPT_SHA384,
	 NSO_CTX_RSA_OAEP_ENCRYPT_SHA512,
	 NSO_CTX_RSA_OAEP_ENCRYPT_MD5,
	 NSO_CTX_RSASSA_PKCK_SHA1,
	 NSO_CTX_RSASSA_PKCK_SHA256,
	 NSO_CTX_RSASSA_PKCK_SHA384,
	 NSO_CTX_RSASSA_PKCK_SHA512,
	 NSO_CTX_RSASSA_PKCK_MD5,
	 NSO_CTX_RSASSA_PSS_SHA1,
	 NSO_CTX_RSASSA_PSS_SHA256,
	 NSO_CTX_RSASSA_PSS_SHA384,
	 NSO_CTX_RSASSA_PSS_SHA512,
	 NSO_CTX_RSASSA_PSS_MD5,
	 NSO_CTX_RSA_ENCRYPT,
	 
	/*ECC*/
	 NSO_CTX_EC_KEYPAIR_GEN,
	 NSO_CTX_EC_ENCRYPT,
	 NSO_CTX_ECDH_DERIVE,
	 NSO_CTX_ECDSA_SHA1,

	 /*RAND KEY*/
	 NSO_CTX_SYM_KEY_GEN,

	 /*
	 새로운 알고리즘을 이 곳에 추가한다.
	 ...
	 */

	 /* 
	 NSO_CTX_NONE을 알고리즘 추가시 
	 가장 마지막에 위치하도록 정리 	 
	 */
	 NSO_CTX_NONE,

};

/***********************************************************************
	공개키, 개인키, 비밀키, 데이터 등을 나타내는 NS_OBJECT의 type들은
	NS_OBJECT의 첫번째 NS_ATTRIBUTE에 다음과 같이 지정될 수 있다.
***********************************************************************/
enum NSE_OBJECT_TYPE{
	NSO_PUBLIC_KEY=0,
	NSO_PRIVATE_KEY,
	NSO_SECRET_KEY,
	NSO_DATA,
};

/***********************************************************************
	NS_ATTRIBUTE types
***********************************************************************/
enum NSE_ATTRIBUTE_TYPE{
/* 값을 나타내는 NS_ATTRIBUTE                             */
	NSA_VALUE = 0,
/* 타원곡선 번호를 나타내는 NS_ATTRIBUTE                  */
	NSA_EC_NUMBER,
/* 타원곡선 파라미터를 나타내는 NS_ATTRIBUTE			  */
	NSA_EC_PARAM,
/* ECC공개키의 형태를 나타내는 NS_ATTRIBUTE               */
	NSA_ECPT_FORM,
/* ECDH 키 합의시 상대방의 공개키를 나타내는 NS_ATTRIBUTE */
	NSA_ECDH_PEERS_PUBLICKEY,
/* 난수 생성기의 xseed를 나타내는 NS_ATTRIBUTE             */
	NSA_RAND_XSEED,
/* 난수 생성기의 xkey를 나타내는 NS_ATTRIBUTE             */
	NSA_RAND_XKEY,
/* 난수 생성기의 종류를 나태내는 NS_ATTRIBUTE             */
	NSA_RANDOM_FUNCTION_TYPE,
/* RSA의 prime type...*/
	NSA_RSA_PRIME_TYPE,
/* RSA의 bits...*/
	NSA_RSA_BITS,
/* SEED 블록 암호의 초기 벡터를 나타내는 NS_ATTRIBUTE     */
	NSA_SEED_IV,
/* AES 블록 암호의 초기 벡터를 나타내는 NS_ATTRIBUTE     */
	NSA_AES_IV,
/* ARIA 블록 암호의 초기 벡터를 나타내는 NS_ATTRIBUTE    */
	NSA_ARIA_IV,
/* DES 블록 암호의 초기 벡터를 나타내는 NS_ATTRIBUTE     */
	NSA_DES_IV,
/*	각종 파라미터의(공개키 주체,OAEP label 등..) label을 
	나타내는 NS_ATTRIBUTE*/
	NSA_LABEL,
/* NSE_OBJECT_TYPE (or NSE_CONTEXT_TYPE) type을 나타내는 NS_ATTRIBUTE*/
	NSA_OBJECT_TYPE
};

/* 난수 생성기 종류 */
enum NSE_RANDOM_FUNCTION_TYPE{
		NS_RANDOM_FUNCTION_TYPE_X9_62,
		NS_RANDOM_FUNCTION_TYPE_X9_31,
		NS_RANDOM_FUNCTION_TYPE_SEED_CBC,
		NS_RANDOM_FUNCTION_TYPE_ARIA_CBC,
		NS_RANDOM_FUNCTION_TYPE_AES_CBC,
		NS_RANDOM_FUNCTION_TYPE_DES_CBC
};

/* named elliptic curve 종류 */
enum NSE_WTLS_ECNUM{
		NSF_RANDOM_EC,
		NSF_WTLS_EC_1,
		NSF_WTLS_EC_3,
		NSF_WTLS_EC_4,
		NSF_WTLS_EC_5
};

/* 타원곡선 점 포맷 */
enum NSE_ECPT_FORM{
		NSF_ECPT_UNCOMPRESS,
		NSF_ECPT_COMPRESS, 
		NSF_ECPT_HYBRID
};

enum RSA_PRIME_TYPE{
		NSF_RSA_PRIMETYPE_PQ, 
		NSF_RSA_PRIMETYPE_PPQ
};

/***********************************************************************
	CMVP States
***********************************************************************/
enum NSS_CMVP_STATE{
/*호출성공상태*/
	NSS_MODULE_LOADED=1,
/*비인가모드*/
	NSS_MODULE_DISAPPROVAL,
/*인가모드*/
	NSS_MODULE_APPROVAL,
/*오류상태*/
	NSS_MODULE_FATAL_ERROR,
/*종료상태*/
	NSS_MODULE_TERMINATE,
/*전원인가자가시험상태*/
	NSS_MODULE_PUST,
};

/***********************************************************************
	Error Codes
***********************************************************************/

/*----------------------------------------------------------------------
	일반 에러 코드
----------------------------------------------------------------------*/
enum NSE_COMMON_ERROR{
	NSR_ARGUMENTS_BAD = 1000,		/* 입력값 에러 : 입출력 NS_OBJECT의
									   포인터가 NULL인 경우          */
	NSR_CTX_NOT_SUPPORTED,			/* 지원되지 않는 작업 수행       */
	NSR_INPUT_DATA_EMPTY,			/* 입력 NS_OBJECT의 하나 이상의
									   NS_ATTRIBUTE의 데이터 입력이
									   올바르지 않은 경우            */
	NSR_INPUT_DATALENGTH_INVALID,	/* 입력 NS_OBJECT의 하나 이상의
									   NS_ATTRIBUTE의 데이터 길이가
									   올바르지 않은 경우            */
	NSR_OUTBUFFER_NULL,				/* 출력버퍼가 할당되지 않음      */
	NSR_ENCRYPT_KEY_EMPTY,			/* 암호화 키값이 없음            */
	NSR_DECRYPT_KEY_EMPTY,			/* 복호화 키값이 없음            */
	NSR_KEY_TYPE_NOT_SUPPORTED,		/* 지원되지 않는 키 타입         */
	NSR_KEY_TYPE_INVAILD,			/* 잘못된 키 타입                */
	NSR_BUFFER_TOO_SMALL,			/* 출력할 버퍼의 크기가 충분히
									   크지 않음                     */
	NSR_RADNOM_LENGTH_INVAILD,		/* 입력된 난수의 길이가 올바르지
									   않음                          */
	NSR_X9_62_GEN_RANDOM_FAILED,		/* 난수 생성 실패			     */
	NSR_X9_31_GEN_RANDOM_FAILED,		/* 난수 생성 실패			     */
	NSR_SIGN_KEY_EMPTY,
	NSR_VERIFY_KEY_EMPTY,
	NSR_FILE_IO_ERROR,				/* 파일 입출력 에러 */
	NSR_MEM_ALLOC_FAILED,				/* 메모리할당 실패 */
	NSR_KEY_DECODE_FAILED,				/*키 디코딩 실패*/
	NSR_OBJECT_TYPE_ATTRIBUTE_MISSED,	/*Object type 속성 부재*/
	NSR_TO_BE_ALLOCATED_PTR_NOT_NULL, /*메모리 할당받을 포인터가 NULL로 초기화 되지 않음*/

	/*CMVP*/
	NSR_MODULE_NOT_INITIALIZED,		/*모듈이 초기화되지 않음*/
	NSR_MODULE_PUST_FAILED,		/*모듈 자가시험 실패*/
	NSR_MODULE_STATE_UNDEFINED,		/*모듈이 미지의 상태임*/
	NSR_MODULE_STATE_ILLEGAL_CHANGE,	/*모듈이 허용되지 않은 상태에 있음*/
	NSR_MODULE_ERROR_STATE,			/*모듈이 에러상태에 있음*/
	NSR_MODULE_TERMINATED,         /*모듈이 종료상태에 있음*/
	NSR_MODULE_STATE_DISAPPR_ALG, /* 현상태에서 허용하지 않는 알고리즘임 */
	NSR_INPUT_USER_KEY_TOO_SHORT,	/*입력된 사용자 키가 너무 짧음.*/
	NSR_MODULE_INTEGRITY_CHECK_FAILED, /*모듈 무결성검사에 실패함.*/
	NSR_MODULE_KEY_INITIALIZE_FAILED, /*모듈키 초기화에 실패함.*/
	NSR_MODULE_CST_FAILED,		/*모듈 자가시험 실패*/
};

/*----------------------------------------------------------------------
	블록 암호 에러 코드
----------------------------------------------------------------------*/
enum NSE_BLOCKCIPHER_ERROR{
	NSR_SEED_ENCRYPT_INIT_FAILED= 2000,/* SEED 암호 초기화 실패      */
	NSR_SEED_ENCRYPT_UPDATE_FAILED,		/* SEED 암호 갱신 실패        */
	NSR_SEED_ENCRYPT_FINAL_FAILED,		/* SEED 암호 종료 실패        */
	NSR_SEED_DECRYPT_INIT_FAILED,		/* SEED 암호 초기화 실패      */
	NSR_SEED_DECRYPT_UPDATE_FAILED,		/* SEED 암호 갱신 실패        */
	NSR_SEED_DECRYPT_FINAL_FAILED,		/* SEED 암호 종료 실패        */
	NSR_SEED_PADDING_ERROR,				/* 입력 데이터의 길이가
										   블록 크기의 배수가 아님    */
	NSR_SEED_MAC_UPDATE_FAILED,			/* SEED-CBC MAC Update 실패   */
	NSR_SEED_MAC_FINAL_FAILED,			/* SEED-CBC MAC Final 실패    */
	NSR_SEED_MAC_MISMATCHED,			/* SEED-CBC MAC 값이 일치하지
										   않음                       */
	NSR_SEED_GEN_RANDOM_FAILD,			/* SEED 난수 생성 실패             */
	NSR_SEED_KEY_SCHEDULE_FAILD,		/* SEED 키 스케쥴 실패             */
	/*AES*/
	NSR_AES_ENCRYPT_INIT_FAILED,		/* AES 암호 초기화 실패      */
	NSR_AES_ENCRYPT_UPDATE_FAILED,		/* AES 암호 갱신 실패        */
	NSR_AES_ENCRYPT_FINAL_FAILED,		/* AES 암호 종료 실패        */
	NSR_AES_DECRYPT_INIT_FAILED,		/* AES 암호 초기화 실패      */
	NSR_AES_DECRYPT_UPDATE_FAILED,		/* AES 암호 갱신 실패        */
	NSR_AES_DECRYPT_FINAL_FAILED,		/* AES 암호 종료 실패        */
	NSR_AES_PADDING_ERROR,				/* 입력 데이터의 길이가
										   블록 크기의 배수가 아님    */
	NSR_AES_MAC_UPDATE_FAILED,			/* AES-CBC MAC Update 실패   */
	NSR_AES_MAC_FINAL_FAILED,			/* AES-CBC MAC Final 실패    */
	NSR_AES_MAC_MISMATCHED,				/* AES-CBC MAC 값이 일치하지
										   않음                       */
	NSR_AES_GEN_RANDOM_FAILD,			/* AES 난수 생성 실패             */
	NSR_AES_KEY_SCHEDULE_FAILD,			/* AES 키 스케쥴 실패             */
	NSR_INVALID_AES_KEY_SIZE,			/* 지정된 AES 키 사이즈가 유효하지 않음 */
	/*ARIA*/
	NSR_ARIA_ENCRYPT_INIT_FAILED,		/* ARIA 암호 초기화 실패      */
	NSR_ARIA_ENCRYPT_UPDATE_FAILED,		/* ARIA 암호 갱신 실패        */
	NSR_ARIA_ENCRYPT_FINAL_FAILED,		/* ARIA 암호 종료 실패        */
	NSR_ARIA_DECRYPT_INIT_FAILED,		/* ARIA 암호 초기화 실패      */
	NSR_ARIA_DECRYPT_UPDATE_FAILED,		/* ARIA 암호 갱신 실패        */
	NSR_ARIA_DECRYPT_FINAL_FAILED,		/* ARIA 암호 종료 실패        */
	NSR_ARIA_PADDING_ERROR,				/* 입력 데이터의 길이가
										   블록 크기의 배수가 아님    */
	NSR_ARIA_MAC_UPDATE_FAILED,			/* ARIA-CBC MAC Update 실패   */
	NSR_ARIA_MAC_FINAL_FAILED,			/* ARIA-CBC MAC Final 실패    */
	NSR_ARIA_MAC_MISMATCHED,				/* ARIA-CBC MAC 값이 일치하지
										   않음                       */
	NSR_ARIA_GEN_RANDOM_FAILD,			/* ARIA 난수 생성 실패        */
	NSR_ARIA_KEY_SCHEDULE_FAILD,			/* ARIA 키 스케쥴 실패    */
	NSR_INVALID_ARIA_KEY_SIZE,			/* 지정된 ARIA 키 사이즈가 유효하지 않음 */
	/*DES*/
	NSR_DES_ENCRYPT_INIT_FAILED,		/* DES 암호 초기화 실패      */
	NSR_DES_ENCRYPT_UPDATE_FAILED,		/* DES 암호 갱신 실패        */
	NSR_DES_ENCRYPT_FINAL_FAILED,		/* DES 암호 종료 실패        */
	NSR_DES_DECRYPT_INIT_FAILED,		/* DES 암호 초기화 실패      */
	NSR_DES_DECRYPT_UPDATE_FAILED,		/* DES 암호 갱신 실패        */
	NSR_DES_DECRYPT_FINAL_FAILED,		/* DES 암호 종료 실패        */
	NSR_DES_PADDING_ERROR,				/* 입력 데이터의 길이가
										   블록 크기의 배수가 아님    */
	NSR_DES_MAC_UPDATE_FAILED,			/* DES-CBC MAC Update 실패   */
	NSR_DES_MAC_FINAL_FAILED,			/* DES-CBC MAC Final 실패    */
	NSR_DES_MAC_MISMATCHED,				/* DES-CBC MAC 값이 일치하지
										   않음                       */
	NSR_DES_GEN_RANDOM_FAILD,			/* DES 난수 생성 실패             */
	NSR_DES_KEY_SCHEDULE_FAILD			/* DES 키 스케쥴 실패             */
};


/*----------------------------------------------------------------------
	메시지 인증 코드 에러 코드
----------------------------------------------------------------------*/
enum NSE_HMAC_ERROR{
	/*SHA1*/
	NSR_SHA1_HMAC_VERIFY_FAILED= 3000,/* SHA1-HMAC 검증 실패 */
	NSR_SHA256_HMAC_VERIFY_FAILED,
	NSR_SHA384_HMAC_VERIFY_FAILED,
	NSR_SHA512_HMAC_VERIFY_FAILED,
};

/*----------------------------------------------------------------------
	타원 곡선 암호 에러 코드
----------------------------------------------------------------------*/
enum NSE_ECC_ERROR{
	NSR_EC_NUMBER_NOT_SUPPORTED= 4000,/* 지원되지 않는 타원곡선 번호 */
	NSR_ECC_ENCRYPT_FAILED,			   /* ECC 암호화 실패             */
	NSR_ECC_DECRYPT_FAILED,			   /* ECC 복호화 실패             */
	NSR_ECDH_BASEKEY_EMPTY,			   /* ECDH BASEKEY 입력 없음      */
	NSR_ECDH_PEERSKEY_EMPTY,		   /* ECDH PEER's KEY 없음        */
	NSR_ECDH_KEYLENGTH_INVAILD,		   /* ECDH 키길이가 잘못 되었음   */
	NSR_ECDSA_SIGNATURE_MISMATCHED,	   /* ECDSA 서명이 일치하지 않음  */
	NSR_ECC_KEYLENGTH_INVALID,
	NSR_ECC_GEN_KEYPAIR_FAILED,
	NSR_ECDH_DERIVE_KEY_FAILED,
	NSR_ECDSA_SIGN_FAILED,
	NSR_ECDSA_VERIFY_FAILED
};

/*----------------------------------------------------------------------
	RSA 암호 에러 코드
----------------------------------------------------------------------*/
enum NSE_RSA_ERROR{
	NSR_RSA_PRIME_TYPE_NOT_SUPPORTED= 5000,/* 지원되지 않는 소수타입*/
	NSR_RSA_ENCRYPT_FAILED,			   /* RSA 암호화 실패             */
	NSR_RSA_DECRYPT_FAILED,			   /* RSA 복호화 실패             */
	NSR_RSA_SIGNATURE_MISMATCHED,	   /* RSA 서명이 일치하지 않음  */
	NSR_RSA_KEYLENGTH_INVALID,
	NSR_RSA_GEN_KEYPAIR_FAILED,
	NSR_RSA_SIGN_FAILED,
	NSR_RSA_VERIFY_FAILED,
	NSR_RSA_KEY_DECODE_FAILED,
	NSR_RSA_BITSLENGTH_INVAILD,
};

/***********************************************************************
	Functions
***********************************************************************/
NS_BYTE_PTR
N_get_errmsg(
	NS_ULONG errorcode);

NS_RV
N_get_info(
	NS_INFO_PTR pInfo);

NS_RV
N_clear_object(
	NS_OBJECT_PTR	poObject,
	NS_ULONG		ulAttrCnt);

/* key management */
NS_RV 
N_generate_keypair(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poPublicKey,
	NS_OBJECT_PTR	poPrivateKey);

NS_RV 
N_generate_key(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poKey);

NS_RV
N_publickey_export(
	NS_OBJECT_PTR	poLabel,
	NS_OBJECT_PTR	poPublicKey);

NS_RV
N_publickey_import(
	NS_OBJECT_PTR	poLabel,
	NS_OBJECT_PTR	poPublicKey);

NS_RV N_derive_key(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poBaseKey,
	NS_OBJECT_PTR	poKey);

/* encryption */
NS_RV N_encrypt_init(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poKey);

NS_RV N_encrypt(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poData,
	NS_OBJECT_PTR	poEncryptedData);

NS_RV N_encrypt_update(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poPart,
	NS_OBJECT_PTR	poEncryptedPart);

NS_RV N_encrypt_final(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poLastEncryptedPart);

/* decryption */
NS_RV N_decrypt_init(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poKey);

NS_RV N_decrypt(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poEncryptedData,
	NS_OBJECT_PTR	poData);

NS_RV N_decrypt_update(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poEncryptedPart,
	NS_OBJECT_PTR	poPart);

NS_RV N_decrypt_final(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poLastPart);

/* sign */
NS_RV N_sign_init(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poKey);

NS_RV N_sign(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poData,
	NS_OBJECT_PTR	poSignature);

NS_RV N_sign_update(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poPart);

NS_RV N_sign_final(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poSignature);

NS_RV N_sign_recover_init(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poKey);

NS_RV N_sign_recover(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poData,
	NS_OBJECT_PTR	poSignature);

/* verify */
NS_RV N_verify_init(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poKey);

NS_RV N_verify(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poData,
	NS_OBJECT_PTR	poSignature);

NS_RV N_verify_update(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poPart);

NS_RV N_verify_final(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poSignature);

NS_RV N_verify_recover_init(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poKey);

NS_RV N_verify_recover(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poSignature,
	NS_OBJECT_PTR	poData);

/* random */
NS_RV N_seed_random(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poSeed);

NS_RV N_generate_random(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poRandom);

/* message digest */
NS_RV N_digest_init(
	NS_CONTEXT_PTR poCtx);

NS_RV N_digest(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poData,
	NS_OBJECT_PTR	poDigest);

NS_RV N_digest_update(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poPart);

NS_RV N_digest_final(
	NS_CONTEXT_PTR	poCtx,
	NS_OBJECT_PTR	poDigest);

/* utility */
NS_RV N_hex_dump(
	NS_BYTE_PTR	p,
	NS_ULONG	sz,
	NS_BYTE_PTR	displayStr);

NS_RV N_file_hex_dump(
	NS_BYTE_PTR	p,
	NS_ULONG	sz,
	NS_BYTE_PTR	displayStr,
	NS_BYTE_PTR	filePath);

NS_RV N_table_hex_dump(
	NS_BYTE_PTR	p,
	NS_ULONG	sz,
	NS_BYTE_PTR	displayStr);

/* CMVP module management */

NS_RV N_safer_start(void);

//NS_RV N_safer_end(VOID);

//NS_RV N_get_state(VOID);

//NS_RV N_change_state(NS_ULONG module_state);

//NS_RV N_self_test(VOID);

#ifdef __cplusplus
}
#endif

#endif /* _NSAFER_ */