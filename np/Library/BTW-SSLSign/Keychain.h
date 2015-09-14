//
//  Keychain.h
//  SecureBrowser
//
//  Created by 양호중 on 10. 9. 13..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface Keychain : NSObject
{
    NSMutableDictionary *keychainItemData;
    NSMutableDictionary *genericPasswordQuery;
}

@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;

- (id)initWithIdentifier:(NSString *)identifier kindOfFile:(NSString *)name;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;
- (void)resetKeychainItem;
- (void)deleteKeychain:(NSString *)identifier;

@end