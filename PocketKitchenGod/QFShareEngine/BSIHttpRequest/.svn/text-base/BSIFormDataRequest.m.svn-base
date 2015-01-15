//
//  BSIFormDataRequest.m
//  BookShare
//
//  Created by yang on 2/11/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "BSIFormDataRequest.h"

@implementation BSIFormDataRequest

- (id) initWithURL:(NSURL *)url {
    if (self = [super initWithURL:url]) {
        _method = HttpMethodPOST;
        _contentType = ContentTypeURLEncoded;
    }
    return self;
}

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key {
    [_postParams setObject:value forKey:key];
}
- (void)addData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key {
    _contentType = ContentTypeMultipartFormData;

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          data, @"Data",
                          fileName, @"FileName",
                          contentType, @"ContentType",
                          key, @"Key", nil];
    [_postFileParams addObject:dict];
}


@end
