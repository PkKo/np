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

/* NSAFER library�� ���� ���� */
typedef struct _NS_VERSION {
  NS_BYTE	major;  /* integer portion of version number  */
  NS_BYTE	minor;  /* 1/100ths portion of version number */
}NS_VERSION, *NS_VERSION_PTR;

/* NSAFER library�� ���� ���� */ 
typedef struct _NS_INFO {
  NS_VERSION	nsapiVersion;			/* interface version  */
  NS_CHAR		manufacturerID[32];		/* blank padded       */
  NS_ULONG		flags;					/* must be zero       */
  NS_CHAR		libraryDescription[32];	/* blank padded       */
  NS_VERSION	libraryVersion;			/* version of library */
} NS_INFO, *NS_INFO_PTR;

typedef struct _NS_ATTRIBUTE {
	NS_ULONG		type;			/* �������� Ÿ��				*/
	NS_VOID_PTR		pValue;			/* ������						*/
	NS_ULONG		ulValueLen;		/* �������� byte ���� ũ��		*/
	NS_BBOOL		bSensitive;		/* ���Ȼ� �ΰ��� ������ ����	*/
	NS_BBOOL		bAlloc;			/* pValue�� ���� ���̺귯��
									   ���ο����� �޸� �Ҵ� ����	*/
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
	�Լ��� ��ȯ�ڵ带 ��Ÿ���� �ڷ���
***********************************************************************/
typedef NS_ULONG	NS_RV;

/***********************************************************************
	Return value
***********************************************************************/
/* return value : ������ */
#define NSR_OK								0

/* return value : ���н� */
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
/* ECDSA ���� ũ�� */
#define NS_ECDSA_SIGN_BYTE_LEN			1024

/* ECDH Key ũ�� */
#define NS_ECDH_KEY_BYTE_LEN			21

/* X9.62 XSEED, XKEY ũ�� */
#define NS_RANDOM_X9_62_SEED_BYTE_LEN	20

/* X9.62 XSEED, XKEY ũ�� */
#define NS_RANDOM_X9_31_SEED_BYTE_LEN	20

/* SEED block ũ�� */
#define NS_SEED_BLOCK_BYTE_LEN			16
#define NS_SEED_KEY_BYTE_LEN			16

/* AES block ũ�� */
#define NS_AES_BLOCK_BYTE_LEN			16
#define NS_AES128_KEY_BYTE_LEN			16
#define NS_AES192_KEY_BYTE_LEN			24
#define NS_AES256_KEY_BYTE_LEN			32

/* ARIA block ũ�� */
#define NS_ARIA_BLOCK_BYTE_LEN			16
#define NS_ARIA128_KEY_BYTE_LEN			16
#define NS_ARIA192_KEY_BYTE_LEN			24
#define NS_ARIA256_KEY_BYTE_LEN			32

/* DES block ũ�� */
#define NS_DES_BLOCK_BYTE_LEN			8
#define NS_DES_KEY_BYTE_LEN				8

/* SHA1 �ؽ� ũ�� */
#define NS_SHA1_HASH_BYTE_LEN			20

/* SHA256 �ؽ� ũ�� */
#define NS_SHA256_HASH_BYTE_LEN			32

/* SHA384 �ؽ� ũ�� */
#define NS_SHA384_HASH_BYTE_LEN			48

/* SHA512 �ؽ� ũ�� */
#define NS_SHA512_HASH_BYTE_LEN			64

/* �ִ� Label ����Ʈ*/
#define	NS_MAX_LABEL_BYTE_LEN			256


/***********************************************************************
 	NS_CONTEXT�� type���� NS_CONTEXT�� ù��° NS_ATTRIBUTE�� ������ ����
	������ �� �ִ�.
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
	 ���ο� �˰����� �� ���� �߰��Ѵ�.
	 ...
	 */

	 /* 
	 NSO_CTX_NONE�� �˰��� �߰��� 
	 ���� �������� ��ġ�ϵ��� ���� 	 
	 */
	 NSO_CTX_NONE,

};

/***********************************************************************
	����Ű, ����Ű, ���Ű, ������ ���� ��Ÿ���� NS_OBJECT�� type����
	NS_OBJECT�� ù��° NS_ATTRIBUTE�� ������ ���� ������ �� �ִ�.
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
/* ���� ��Ÿ���� NS_ATTRIBUTE                             */
	NSA_VALUE = 0,
/* Ÿ��� ��ȣ�� ��Ÿ���� NS_ATTRIBUTE                  */
	NSA_EC_NUMBER,
/* Ÿ��� �Ķ���͸� ��Ÿ���� NS_ATTRIBUTE			  */
	NSA_EC_PARAM,
/* ECC����Ű�� ���¸� ��Ÿ���� NS_ATTRIBUTE               */
	NSA_ECPT_FORM,
/* ECDH Ű ���ǽ� ������ ����Ű�� ��Ÿ���� NS_ATTRIBUTE */
	NSA_ECDH_PEERS_PUBLICKEY,
/* ���� �������� xseed�� ��Ÿ���� NS_ATTRIBUTE             */
	NSA_RAND_XSEED,
/* ���� �������� xkey�� ��Ÿ���� NS_ATTRIBUTE             */
	NSA_RAND_XKEY,
/* ���� �������� ������ ���³��� NS_ATTRIBUTE             */
	NSA_RANDOM_FUNCTION_TYPE,
/* RSA�� prime type...*/
	NSA_RSA_PRIME_TYPE,
/* RSA�� bits...*/
	NSA_RSA_BITS,
/* SEED ��� ��ȣ�� �ʱ� ���͸� ��Ÿ���� NS_ATTRIBUTE     */
	NSA_SEED_IV,
/* AES ��� ��ȣ�� �ʱ� ���͸� ��Ÿ���� NS_ATTRIBUTE     */
	NSA_AES_IV,
/* ARIA ��� ��ȣ�� �ʱ� ���͸� ��Ÿ���� NS_ATTRIBUTE    */
	NSA_ARIA_IV,
/* DES ��� ��ȣ�� �ʱ� ���͸� ��Ÿ���� NS_ATTRIBUTE     */
	NSA_DES_IV,
/*	���� �Ķ������(����Ű ��ü,OAEP label ��..) label�� 
	��Ÿ���� NS_ATTRIBUTE*/
	NSA_LABEL,
/* NSE_OBJECT_TYPE (or NSE_CONTEXT_TYPE) type�� ��Ÿ���� NS_ATTRIBUTE*/
	NSA_OBJECT_TYPE
};

/* ���� ������ ���� */
enum NSE_RANDOM_FUNCTION_TYPE{
		NS_RANDOM_FUNCTION_TYPE_X9_62,
		NS_RANDOM_FUNCTION_TYPE_X9_31,
		NS_RANDOM_FUNCTION_TYPE_SEED_CBC,
		NS_RANDOM_FUNCTION_TYPE_ARIA_CBC,
		NS_RANDOM_FUNCTION_TYPE_AES_CBC,
		NS_RANDOM_FUNCTION_TYPE_DES_CBC
};

/* named elliptic curve ���� */
enum NSE_WTLS_ECNUM{
		NSF_RANDOM_EC,
		NSF_WTLS_EC_1,
		NSF_WTLS_EC_3,
		NSF_WTLS_EC_4,
		NSF_WTLS_EC_5
};

/* Ÿ��� �� ���� */
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
/*ȣ�⼺������*/
	NSS_MODULE_LOADED=1,
/*���ΰ����*/
	NSS_MODULE_DISAPPROVAL,
/*�ΰ����*/
	NSS_MODULE_APPROVAL,
/*��������*/
	NSS_MODULE_FATAL_ERROR,
/*�������*/
	NSS_MODULE_TERMINATE,
/*�����ΰ��ڰ��������*/
	NSS_MODULE_PUST,
};

/***********************************************************************
	Error Codes
***********************************************************************/

/*----------------------------------------------------------------------
	�Ϲ� ���� �ڵ�
----------------------------------------------------------------------*/
enum NSE_COMMON_ERROR{
	NSR_ARGUMENTS_BAD = 1000,		/* �Է°� ���� : ����� NS_OBJECT��
									   �����Ͱ� NULL�� ���          */
	NSR_CTX_NOT_SUPPORTED,			/* �������� �ʴ� �۾� ����       */
	NSR_INPUT_DATA_EMPTY,			/* �Է� NS_OBJECT�� �ϳ� �̻���
									   NS_ATTRIBUTE�� ������ �Է���
									   �ùٸ��� ���� ���            */
	NSR_INPUT_DATALENGTH_INVALID,	/* �Է� NS_OBJECT�� �ϳ� �̻���
									   NS_ATTRIBUTE�� ������ ���̰�
									   �ùٸ��� ���� ���            */
	NSR_OUTBUFFER_NULL,				/* ��¹��۰� �Ҵ���� ����      */
	NSR_ENCRYPT_KEY_EMPTY,			/* ��ȣȭ Ű���� ����            */
	NSR_DECRYPT_KEY_EMPTY,			/* ��ȣȭ Ű���� ����            */
	NSR_KEY_TYPE_NOT_SUPPORTED,		/* �������� �ʴ� Ű Ÿ��         */
	NSR_KEY_TYPE_INVAILD,			/* �߸��� Ű Ÿ��                */
	NSR_BUFFER_TOO_SMALL,			/* ����� ������ ũ�Ⱑ �����
									   ũ�� ����                     */
	NSR_RADNOM_LENGTH_INVAILD,		/* �Էµ� ������ ���̰� �ùٸ���
									   ����                          */
	NSR_X9_62_GEN_RANDOM_FAILED,		/* ���� ���� ����			     */
	NSR_X9_31_GEN_RANDOM_FAILED,		/* ���� ���� ����			     */
	NSR_SIGN_KEY_EMPTY,
	NSR_VERIFY_KEY_EMPTY,
	NSR_FILE_IO_ERROR,				/* ���� ����� ���� */
	NSR_MEM_ALLOC_FAILED,				/* �޸��Ҵ� ���� */
	NSR_KEY_DECODE_FAILED,				/*Ű ���ڵ� ����*/
	NSR_OBJECT_TYPE_ATTRIBUTE_MISSED,	/*Object type �Ӽ� ����*/
	NSR_TO_BE_ALLOCATED_PTR_NOT_NULL, /*�޸� �Ҵ���� �����Ͱ� NULL�� �ʱ�ȭ ���� ����*/

	/*CMVP*/
	NSR_MODULE_NOT_INITIALIZED,		/*����� �ʱ�ȭ���� ����*/
	NSR_MODULE_PUST_FAILED,		/*��� �ڰ����� ����*/
	NSR_MODULE_STATE_UNDEFINED,		/*����� ������ ������*/
	NSR_MODULE_STATE_ILLEGAL_CHANGE,	/*����� ������ ���� ���¿� ����*/
	NSR_MODULE_ERROR_STATE,			/*����� �������¿� ����*/
	NSR_MODULE_TERMINATED,         /*����� ������¿� ����*/
	NSR_MODULE_STATE_DISAPPR_ALG, /* �����¿��� ������� �ʴ� �˰����� */
	NSR_INPUT_USER_KEY_TOO_SHORT,	/*�Էµ� ����� Ű�� �ʹ� ª��.*/
	NSR_MODULE_INTEGRITY_CHECK_FAILED, /*��� ���Ἲ�˻翡 ������.*/
	NSR_MODULE_KEY_INITIALIZE_FAILED, /*���Ű �ʱ�ȭ�� ������.*/
	NSR_MODULE_CST_FAILED,		/*��� �ڰ����� ����*/
};

/*----------------------------------------------------------------------
	��� ��ȣ ���� �ڵ�
----------------------------------------------------------------------*/
enum NSE_BLOCKCIPHER_ERROR{
	NSR_SEED_ENCRYPT_INIT_FAILED= 2000,/* SEED ��ȣ �ʱ�ȭ ����      */
	NSR_SEED_ENCRYPT_UPDATE_FAILED,		/* SEED ��ȣ ���� ����        */
	NSR_SEED_ENCRYPT_FINAL_FAILED,		/* SEED ��ȣ ���� ����        */
	NSR_SEED_DECRYPT_INIT_FAILED,		/* SEED ��ȣ �ʱ�ȭ ����      */
	NSR_SEED_DECRYPT_UPDATE_FAILED,		/* SEED ��ȣ ���� ����        */
	NSR_SEED_DECRYPT_FINAL_FAILED,		/* SEED ��ȣ ���� ����        */
	NSR_SEED_PADDING_ERROR,				/* �Է� �������� ���̰�
										   ��� ũ���� ����� �ƴ�    */
	NSR_SEED_MAC_UPDATE_FAILED,			/* SEED-CBC MAC Update ����   */
	NSR_SEED_MAC_FINAL_FAILED,			/* SEED-CBC MAC Final ����    */
	NSR_SEED_MAC_MISMATCHED,			/* SEED-CBC MAC ���� ��ġ����
										   ����                       */
	NSR_SEED_GEN_RANDOM_FAILD,			/* SEED ���� ���� ����             */
	NSR_SEED_KEY_SCHEDULE_FAILD,		/* SEED Ű ������ ����             */
	/*AES*/
	NSR_AES_ENCRYPT_INIT_FAILED,		/* AES ��ȣ �ʱ�ȭ ����      */
	NSR_AES_ENCRYPT_UPDATE_FAILED,		/* AES ��ȣ ���� ����        */
	NSR_AES_ENCRYPT_FINAL_FAILED,		/* AES ��ȣ ���� ����        */
	NSR_AES_DECRYPT_INIT_FAILED,		/* AES ��ȣ �ʱ�ȭ ����      */
	NSR_AES_DECRYPT_UPDATE_FAILED,		/* AES ��ȣ ���� ����        */
	NSR_AES_DECRYPT_FINAL_FAILED,		/* AES ��ȣ ���� ����        */
	NSR_AES_PADDING_ERROR,				/* �Է� �������� ���̰�
										   ��� ũ���� ����� �ƴ�    */
	NSR_AES_MAC_UPDATE_FAILED,			/* AES-CBC MAC Update ����   */
	NSR_AES_MAC_FINAL_FAILED,			/* AES-CBC MAC Final ����    */
	NSR_AES_MAC_MISMATCHED,				/* AES-CBC MAC ���� ��ġ����
										   ����                       */
	NSR_AES_GEN_RANDOM_FAILD,			/* AES ���� ���� ����             */
	NSR_AES_KEY_SCHEDULE_FAILD,			/* AES Ű ������ ����             */
	NSR_INVALID_AES_KEY_SIZE,			/* ������ AES Ű ����� ��ȿ���� ���� */
	/*ARIA*/
	NSR_ARIA_ENCRYPT_INIT_FAILED,		/* ARIA ��ȣ �ʱ�ȭ ����      */
	NSR_ARIA_ENCRYPT_UPDATE_FAILED,		/* ARIA ��ȣ ���� ����        */
	NSR_ARIA_ENCRYPT_FINAL_FAILED,		/* ARIA ��ȣ ���� ����        */
	NSR_ARIA_DECRYPT_INIT_FAILED,		/* ARIA ��ȣ �ʱ�ȭ ����      */
	NSR_ARIA_DECRYPT_UPDATE_FAILED,		/* ARIA ��ȣ ���� ����        */
	NSR_ARIA_DECRYPT_FINAL_FAILED,		/* ARIA ��ȣ ���� ����        */
	NSR_ARIA_PADDING_ERROR,				/* �Է� �������� ���̰�
										   ��� ũ���� ����� �ƴ�    */
	NSR_ARIA_MAC_UPDATE_FAILED,			/* ARIA-CBC MAC Update ����   */
	NSR_ARIA_MAC_FINAL_FAILED,			/* ARIA-CBC MAC Final ����    */
	NSR_ARIA_MAC_MISMATCHED,				/* ARIA-CBC MAC ���� ��ġ����
										   ����                       */
	NSR_ARIA_GEN_RANDOM_FAILD,			/* ARIA ���� ���� ����        */
	NSR_ARIA_KEY_SCHEDULE_FAILD,			/* ARIA Ű ������ ����    */
	NSR_INVALID_ARIA_KEY_SIZE,			/* ������ ARIA Ű ����� ��ȿ���� ���� */
	/*DES*/
	NSR_DES_ENCRYPT_INIT_FAILED,		/* DES ��ȣ �ʱ�ȭ ����      */
	NSR_DES_ENCRYPT_UPDATE_FAILED,		/* DES ��ȣ ���� ����        */
	NSR_DES_ENCRYPT_FINAL_FAILED,		/* DES ��ȣ ���� ����        */
	NSR_DES_DECRYPT_INIT_FAILED,		/* DES ��ȣ �ʱ�ȭ ����      */
	NSR_DES_DECRYPT_UPDATE_FAILED,		/* DES ��ȣ ���� ����        */
	NSR_DES_DECRYPT_FINAL_FAILED,		/* DES ��ȣ ���� ����        */
	NSR_DES_PADDING_ERROR,				/* �Է� �������� ���̰�
										   ��� ũ���� ����� �ƴ�    */
	NSR_DES_MAC_UPDATE_FAILED,			/* DES-CBC MAC Update ����   */
	NSR_DES_MAC_FINAL_FAILED,			/* DES-CBC MAC Final ����    */
	NSR_DES_MAC_MISMATCHED,				/* DES-CBC MAC ���� ��ġ����
										   ����                       */
	NSR_DES_GEN_RANDOM_FAILD,			/* DES ���� ���� ����             */
	NSR_DES_KEY_SCHEDULE_FAILD			/* DES Ű ������ ����             */
};


/*----------------------------------------------------------------------
	�޽��� ���� �ڵ� ���� �ڵ�
----------------------------------------------------------------------*/
enum NSE_HMAC_ERROR{
	/*SHA1*/
	NSR_SHA1_HMAC_VERIFY_FAILED= 3000,/* SHA1-HMAC ���� ���� */
	NSR_SHA256_HMAC_VERIFY_FAILED,
	NSR_SHA384_HMAC_VERIFY_FAILED,
	NSR_SHA512_HMAC_VERIFY_FAILED,
};

/*----------------------------------------------------------------------
	Ÿ�� � ��ȣ ���� �ڵ�
----------------------------------------------------------------------*/
enum NSE_ECC_ERROR{
	NSR_EC_NUMBER_NOT_SUPPORTED= 4000,/* �������� �ʴ� Ÿ��� ��ȣ */
	NSR_ECC_ENCRYPT_FAILED,			   /* ECC ��ȣȭ ����             */
	NSR_ECC_DECRYPT_FAILED,			   /* ECC ��ȣȭ ����             */
	NSR_ECDH_BASEKEY_EMPTY,			   /* ECDH BASEKEY �Է� ����      */
	NSR_ECDH_PEERSKEY_EMPTY,		   /* ECDH PEER's KEY ����        */
	NSR_ECDH_KEYLENGTH_INVAILD,		   /* ECDH Ű���̰� �߸� �Ǿ���   */
	NSR_ECDSA_SIGNATURE_MISMATCHED,	   /* ECDSA ������ ��ġ���� ����  */
	NSR_ECC_KEYLENGTH_INVALID,
	NSR_ECC_GEN_KEYPAIR_FAILED,
	NSR_ECDH_DERIVE_KEY_FAILED,
	NSR_ECDSA_SIGN_FAILED,
	NSR_ECDSA_VERIFY_FAILED
};

/*----------------------------------------------------------------------
	RSA ��ȣ ���� �ڵ�
----------------------------------------------------------------------*/
enum NSE_RSA_ERROR{
	NSR_RSA_PRIME_TYPE_NOT_SUPPORTED= 5000,/* �������� �ʴ� �Ҽ�Ÿ��*/
	NSR_RSA_ENCRYPT_FAILED,			   /* RSA ��ȣȭ ����             */
	NSR_RSA_DECRYPT_FAILED,			   /* RSA ��ȣȭ ����             */
	NSR_RSA_SIGNATURE_MISMATCHED,	   /* RSA ������ ��ġ���� ����  */
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