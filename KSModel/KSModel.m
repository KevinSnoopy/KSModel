//
//  KSModel.m
//  KSModel
//
//  Created by mac on 2020/6/15.
//  Copyright © 2020 Kevin. All rights reserved.
//

#import "KSModel.h"

#import <objc/runtime.h>

@implementation KSModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self=[super init]) {
        unsigned int count;
        objc_property_t *propertys = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i ++) {
            objc_property_t property = propertys[i];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            id value = [dictionary objectForKey:key];
            if (!value) {
                value = nil;
            }
            [self setValue:value forKey:key];
        }
    }
    return self;
}

+ (id)getObjectInternal:(id)objc {
    if ([objc isKindOfClass:[NSString class]]||[objc isKindOfClass:[NSNumber class]]||[objc isKindOfClass:[NSNull class]]) {
        return objc;
    }else if ([objc isKindOfClass:[KSModel class]]) {
        return [KSModel dictionaryWithModel:(KSModel *)objc];
    }else if ([objc isKindOfClass:[NSDictionary class]]) {
        NSArray *objcs = (NSArray *)objc;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[objcs count]];
        for (int i = 0; i < [objcs count]; i ++) {
            [array setObject:[KSModel getObjectInternal:[objcs objectAtIndex:i]] atIndexedSubscript:i];
        }
        return array;
    }else if ([objc isKindOfClass:[NSArray class]]) {
        NSDictionary *objcs = (NSDictionary *)objc;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[objcs count]];
        for (NSString *key in objcs.allKeys) {
            [dictionary setObject:[KSModel getObjectInternal:[objcs objectForKey:key]] forKey:key];
        }
        return dictionary;
    }
    return [NSNull null];
}

/**
 model与字典的转化
 */
+ (KSModel *)modelWithDictionary:(NSDictionary *)dictionary {
    return [[KSModel alloc]initWithDictionary:dictionary];
}
+ (NSDictionary *)dictionaryWithModel:(KSModel *)model {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([model class], &count);
    for (int i = 0; i < count; i ++) {
        objc_property_t property = propertys[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        id value = [model valueForKey:key];
        if (!value) {
            value = [NSNull null];
        }else {
            value = [KSModel getObjectInternal:value];
        }
        [dictionary setValue:value forKey:key];
    }
    return dictionary;
}

@end
