//
//  BSIFormDataRequest.h
//  BookShare
//
//  Created by yang on 2/11/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSIHTTPRequest.h"

@interface BSIFormDataRequest : BSIHTTPRequest {
    
}

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key;
- (void)addData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;

@end
