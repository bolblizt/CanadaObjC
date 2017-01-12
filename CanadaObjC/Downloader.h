//
//  Downloader.h
//  CanadaObjC
//
//  Created by user on 12/1/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppImage.h"

@interface Downloader : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@property(nonatomic, strong)AppImage *record;
@property(nonatomic, strong)NSOperationQueue *queue;
@property (nonatomic, copy)  void(^completionHandler)(void);


- (void)startDownLoadMy:(AppImage *)theRecord
                       completion:(void (^)(AppImage *))completionBlock;
- (void)startDownLoad;
- (void)StopDownLoad;


@end
