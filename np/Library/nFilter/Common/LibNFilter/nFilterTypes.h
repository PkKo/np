//
//  nFilterTypes.h
//  nFilter For iPad
//
//  Created by Kinamee on 11. 2. 24..
//  Copyright 2011 NSHC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	NCenter,
	NLeft,
	NRight, 	
} NAlignment;

typedef enum {
	NKeymodeEng,
	NKeymodeSEng,
	NKeymodeHan,
	NKeymodeSHan,
	NKeymodeSpecl,
} NKeymodeType;

typedef enum {
	NEngLower,
	NEngUpper,
	NSpecial,
	NNum,
 	NKor
} NKeymodeTypeR;