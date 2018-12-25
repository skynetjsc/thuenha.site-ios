//
//  NCNotificationView.m
//  eSchool
//
//  Created by Dong Vo on 11/14/16.
//  Copyright © 2016 NhatCuongSofware. All rights reserved.
//

#import "NCNotificationViewDown.h"

@interface NCNotificationDownView (){
    
    NSString * content;
    NSString * xib;
    BOOL isShowMess;
}

@property (nonatomic, copy) block notiHandler;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnHandler;



@end

@implementation NCNotificationDownView
- (id)initWithFrame:(CGRect)frame xib:(NSString *)strXib content:(NSString *)strContent {
    if(self = [super initWithFrame:frame]){
        
        content = strContent;
        xib = strXib;
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame content:(NSString *)strContent{
    
    if(self = [super initWithFrame:frame]){
        
        content = strContent;
        
        [self setup];
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame content:(NSString *)strContent handler:(void(^)(void))handler {
    self.notiHandler = handler;
    if(self = [super initWithFrame:frame]) {
        content = strContent;
        [self setup];
    }
    return self;
}
- (IBAction)close:(id)sender {
    
    [self closeMessage];
}

-(void)setup{
    
    self.view  = [[NSBundle mainBundle] loadNibNamed:xib.length > 0?xib: @"NCNotificationViewDown" owner:self options:nil].firstObject;
    self.view.clipsToBounds = YES;
    self.view.frame = self.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.view];
    self.frame = CGRectMake(self.frame.origin.x, - (CGRectGetMaxY(self.frame)), self.frame.size.width, self.frame.size.width);
    self.lblContent.text = content;
    
    [self showMessage];
}

-(void)closeMessage {
    
    if(isShowMess){
        
        isShowMess = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeMessage) object:nil];
        
        [UIView animateWithDuration:0.33 animations:^{
            self.frame = CGRectMake(0, - (CGRectGetMaxY(self.frame)), self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

-(void)showMessage{
    
    if(!isShowMess){
        
        isShowMess = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {
        }];
        
        [self performSelector:@selector(closeMessage) withObject:nil afterDelay:4.0f];
        
    }
}
- (IBAction)notiAction:(id)sender {
    self.notiHandler();
}
@end
