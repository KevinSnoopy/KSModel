//
//  KSModel.h
//  KSModel
//
//  Created by mac on 2020/6/15.
//  Copyright © 2020 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSModel : NSObject
/**
 model与字典的转化
 */
+ (KSModel *)modelWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)dictionaryWithModel:(KSModel *)model;

@end

NS_ASSUME_NONNULL_END
