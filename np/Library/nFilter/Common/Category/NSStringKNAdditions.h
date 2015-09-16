//
//  NSString+CocoaDevUsersAdditions.h
//  SmpNSStringCategory
//
//  Created by 발팀 개 on 10. 3. 9..
//  Copyright 2010 NSHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringKNAdditions)
+ (NSString *)stringWithPascalString:(Str255)aString encoding:(CFStringEncoding)encoding;
- (id)initWithPascalString:(Str255)aString encoding:(CFStringEncoding)encoding;
- (int)convertToPascalStringInBuffer:(StringPtr)strBuffer
								size:(int)bufSize encoding:(CFStringEncoding)encoding;

- (int)occurencesOfSubstring:(NSString *)substr;
- (int)occurencesOfSubstring:(NSString *)substr options:(int)opt;

- (NSArray *)tokensSeparatedByCharactersFromSet:(NSCharacterSet *) separatorSet;
- (NSArray *)objCTokens; //(and C tokens too) a contiguous body of non-'punctuation' characters.
//skips quotes, -, +, (), {}, [], and the like.
- (NSArray *)words; //roman-alphabet words

- (BOOL)containsCharacterFromSet:(NSCharacterSet *)set;
- (NSString *)stringWithSubstitute:(NSString *)subs forCharactersFromSet:(NSCharacterSet *)set;

- (NSArray *)linesSortedByLength;
- (NSComparisonResult)compareLength:(NSString *)otherString;

- (unsigned)lineCount; // count lines/paragraphs

- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag;

-(NSArray *)splitToSize:(unsigned)size; //returns NSArray of <= size character strings
-(NSString *)removeTabsAndReturns;
-(NSString *)newlineToCR;

-(NSString *)safeFilePath;

-(NSRange)whitespaceRangeForRange:(NSRange)characterRange; 
//returns the range of characters around characterRange, extended out to the nearest whitespace

- (NSString *)substringBeforeRange:(NSRange)range;
- (NSString *)substringAfterRange:(NSRange)range;

-(BOOL)isValidURL;
- (NSString *)stringSafeForXML;

@end
