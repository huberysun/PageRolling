//
//  ViewController.m
//  RollingPage
//
//  Created by HuberySun on 16/3/30.
//  Copyright © 2016年 HuberySun. All rights reserved.
//

#import "ViewController.h"

#define totalCount 5
@interface ViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong)NSTimer *timer;
@end

@implementation ViewController

- (NSTimer *)timer{
    if (!_timer) {
        //创建NSTimer对象，定时滚动图片
        self.timer=[NSTimer timerWithTimeInterval:2 target:self selector:@selector(rollPage) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //向uiscrollview添加图片
    CGFloat imgViewW=self.scrollView.frame.size.width;
    CGFloat imgViewH=self.scrollView.frame.size.height;
    for (int i=0; i<totalCount; i++) {
        NSString *imgName=[NSString stringWithFormat:@"img_%02d",i+1];
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(i*imgViewW, 0, imgViewW, imgViewH)];
        imgView.image=[UIImage imageNamed:imgName];
        [self.scrollView addSubview:imgView];
    }
    
    //设置uiscrollview的contentsize，使得其可以滚动
    self.scrollView.contentSize=CGSizeMake(totalCount*imgViewW, 0);
    self.scrollView.showsHorizontalScrollIndicator=NO;
    
    //设置pageEnable属性使得uiscrollview可以滚动
    self.scrollView.pagingEnabled=YES;
    
    //初始化pageControl
    self.pageControl.numberOfPages=totalCount;
    self.pageControl.currentPage=0;
    
    //默认模式添加到timer
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//滚动页面
- (void)rollPage{
    NSInteger pageWidth=self.scrollView.bounds.size.width;
    
    if (self.pageControl.currentPage==totalCount-1) {
        //self.scrollView.contentOffset=CGPointMake(0, 0);
        self.pageControl.currentPage=0;
    }else{
//        CGFloat contentOffsetX=self.scrollView.contentOffset.x;
//        self.scrollView.contentOffset=CGPointMake(contentOffsetX+pageWidth, 0);
        self.pageControl.currentPage++;
    }
    self.scrollView.contentOffset=CGPointMake(self.pageControl.currentPage*pageWidth, 0);
}

//更新pageControl控件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger imgViewW=self.scrollView.frame.size.width;
    //为什么偏移量要加上imgViewW的一半，因为，这样就可以使得当新的page页面出现一半的时候， pagecontrol的currentPage应该改变，而不是等到新的page页面全部出现，才改变currentPage属性
   // NSInteger currentPageIndex=scrollView.contentOffset.x/imgViewW;
    NSInteger currentPageIndex=(scrollView.contentOffset.x+imgViewW/2)/imgViewW;
    self.pageControl.currentPage=currentPageIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];//从runloop移除
    self.timer=nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
@end
