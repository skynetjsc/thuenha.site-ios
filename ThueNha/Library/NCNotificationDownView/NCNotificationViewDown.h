//
//  NCNotificationView.h
//  eSchool
//
//  Created by Dong Vo on 11/14/16.
//  Copyright © 2016 NhatCuongSofware. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NCNotificationDownViewDelegate <NSObject>

@end

@interface NCNotificationDownView : UIView
typedef void (^block)();
- (id)initWithFrame:(CGRect)frame content:(NSString *)strContent;//default
- (id)initWithFrame:(CGRect)frame xib:(NSString *)strXib content:(NSString *)strContent;
- (id)initWithFrame:(CGRect)frame content:(NSString *)strContent handler:(void(^)(void))handler;

-(void)closeMessage;
@property (weak, nonatomic) id<NCNotificationDownViewDelegate> delegate;
@end
