//
//  ConstantMaster.h
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#ifndef ConstantMaster_h
#define ConstantMaster_h

#define TEXT_FIELD_BORDER_COLOR [[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1] CGColor]

#define TRANS_ALL_ACCOUNT  @"전체계좌"

#define TRANS_TYPE_GENERAL @"입출금"
#define TRANS_TYPE_INCOME  @"입금"
#define TRANS_TYPE_EXPENSE @"출금"

//@"최신순", @"과거순"
#define TIME_ACSENDING_ORDER    @"과거순"
#define TIME_DECSENDING_ORDER   @"최신순"

#define PREF_KEY_SIMPLE_LOGIN_SETT_PW           @"simpleLoginSettingsKeyPW"
#define PREF_KEY_SIMPLE_LOGIN_SETT_FAILED_TIMES @"simpleLoginSettingsKeyFailedTimes"

#define PREF_KEY_CERT_TO_LOGIN                  @"certificateToLogin"

#define PREF_KEY_LOGIN_METHOD                   @"loginMethodKey"
typedef enum LoginMethod {
    LOGIN_BY_NONE,
    LOGIN_BY_ACCOUNT,
    LOGIN_BY_CERTIFICATE,
    LOGIN_BY_SIMPLEPW,
    LOGIN_BY_PATTERN
} LoginMethod;


#define ALERT_GOTO_SELF_IDENTIFY    100
#define ALERT_DO_NOTHING            0
#define ALERT_SUCCEED_SAVE          1

#endif /* ConstantMaster_h */
