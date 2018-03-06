//
//  HKFilteredProtocol.h
//  BlackCard
//
//  Created by pz on 2017/12/5.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKFilteredProtocol : NSURLProtocol
@property (nonatomic, strong) NSMutableData   *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@end
