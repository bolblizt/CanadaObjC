//
//  Downloader.m
//  CanadaObjC
//
//  Created by user on 12/1/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "Downloader.h"

#define kAppIconSize 48


@implementation Downloader

@synthesize record;
@synthesize queue;

-(void)Initialize{
    
    record  = [[AppImage alloc]init];
    
}



- (void)startDownLoadMy:(AppImage *)theRecord
                       completion:(void (^)(AppImage *))completionBlock
{
  
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.record.imageURL]];
    
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                    
                       
                       if (error != nil)
                       {
                           if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                           {
                                    abort();
                           }
                       }
                       
                       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                           
                           // Set appIcon and clear temporary data/image
                           UIImage *image = [[UIImage alloc] initWithData:data];
                           
                           if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
                           {
                               CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                               UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                               CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                               [image drawInRect:imageRect];
                               self.record.imageIcon = UIGraphicsGetImageFromCurrentImageContext();
                               UIGraphicsEndImageContext();
                           }
                           else
                           {
                               self.record.imageIcon = image;
                           }
                           
                           // call our completion handler to tell our client that our icon is ready for display
                           if (self. self.record.imageIcon != nil)
                           {
                                    completionBlock(theRecord);
                           }
                       }];
                   }];
    
    [self.sessionTask resume];

}


/*
- (void)DownLoadNow
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.record.imageURL]];
    
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                                                       // in case we want to know the response status code
                                                       //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                       
                                                       if (error != nil)
                                                       {
                                                           if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                           {
                                                               // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                               // then your Info.plist has not been properly configured to match the target server.
                                                               //
                                                               abort();
                                                           }
                                                       }
                                                       
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                           
                                                           // Set appIcon and clear temporary data/image
                                                           UIImage *image = [[UIImage alloc] initWithData:data];
                                                           
                                                           if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
                                                           {
                                                               CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                                                               UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                                                               CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                                                               [image drawInRect:imageRect];
                                                               self.record.imageIcon = UIGraphicsGetImageFromCurrentImageContext();
                                                               UIGraphicsEndImageContext();
                                                           }
                                                           else
                                                           {
                                                               self.record.imageIcon = image;
                                                           }
                                                           
                                                           // call our completion handler to tell our client that our icon is ready for display
                                                           if (self.completionHandler != nil)
                                                           {
                                                               self.completionHandler();
                                                              
 
                                                           }
                                                       }];
                                                   }];
    
    [self.sessionTask resume];
}
*/

- (void)StopDownLoad
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}




@end
