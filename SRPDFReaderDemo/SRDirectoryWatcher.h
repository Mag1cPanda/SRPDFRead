//
//  SRDirectoryWatcher.h
//  SRPDFReaderDemo
//
//  Created by longrise on 2018/11/22.
//  Copyright © 2018 longrise. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *ZFileChangedNotification = @"ZFileChangedNotification";

NS_ASSUME_NONNULL_BEGIN

@interface SRDirectoryWatcher : NSObject
{
    dispatch_queue_t _zDispatchQueue;
    dispatch_source_t _zSource;
}

+(instancetype)defaultWatcher;

/**
 开始监听
 */
- (void)startMonitoringDocumentAsynchronous;

/**
 停止监听
 */
- (void)stopMonitoringDocument;
@end

NS_ASSUME_NONNULL_END
