//
//  NSObject+AssociatedObject.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AssociatedObject)

- (id)objectWithAssociatedKey:(void *)key;
- (void)setObject:(id)object forAssociatedKey:(void *)key retained:(BOOL)retain;

@end

NS_ASSUME_NONNULL_END
