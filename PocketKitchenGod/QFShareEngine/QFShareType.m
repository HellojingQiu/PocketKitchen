//
//  QFShareType.m
//  BookShare
//
//  Created by yang on 31/10/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "QFShareType.h"

@implementation QFShareType

#define Synthesize(a) @synthesize a = _ ## a
Synthesize(type);
Synthesize(appKey);
Synthesize(appSecret);
Synthesize(redirectUri);

- (void)dealloc
{
    self.type = ShareTypeNull;
    self.appKey = nil;
    self.redirectUri = nil;
    self.appSecret = nil;
    SuperDealloc;
}
@end

@implementation QFShareQueue

static id _s;
static NSMutableArray *queue;
+ (void) initialize {
    queue = [[NSMutableArray alloc] init];
}
+ (id) sharedInstance {
    if (_s == nil) {
        _s = [[[self class] alloc] init];
    }
    return _s;
}

- (BOOL) addShareTypeToQueue:(QFShareType *)sType {
    for (QFShareType *oneItm in queue) {
        if (oneItm.type == sType.type) {
            // 有重复的, 删除之前的内容
            [queue removeObject:oneItm];
            break;
        }
    }
    [queue addObject:sType];
    return TRUE;
}

- (NSArray *) getShareTypeList {
    id obj = [queue copy];
    return SAFELY_AUTORELEASE(obj);
}


@end
