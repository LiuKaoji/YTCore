//
//  UIButton+Block.m
//  YTCore
//
//  Created by kaoji on 3/14/23.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

- (void)addActionHandler:(void (^)(NSInteger tag))touchHandler {
    // 绑定block到UIControlEventTouchUpInside事件
    [self addTarget:self action:@selector(blockActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    // 将block存储为关联对象
    objc_setAssociatedObject(self, @selector(actionHandler), touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSInteger tag))actionHandler {
    // 获取存储的关联对象
    return objc_getAssociatedObject(self, @selector(actionHandler));
}

- (void)blockActionHandler:(UIButton *)button {
    // 获取存储的关联对象并执行block
    void (^action)(NSInteger tag) = [self actionHandler];
    if (action) {
        action(button.tag);
    }
}

@end
