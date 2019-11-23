//
//  ViewController.m
//  XBWebImage
//
//  Created by youxiao on 2019/11/22.
//  Copyright © 2019 youxiao. All rights reserved.
//

#import "ViewController.h"
#import "XBImageDownloader.h"
#import "UIImageView+XBWebCache.h"
#import "MainCell.h"
#import <UIImageView+WebCache.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>

@property(nonatomic,retain)NSArray *imageArr;
@property(nonatomic,retain)NSMutableData *mutData;
@property(nonatomic,retain)UIImageView *coverImg;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *mainBundle = [[NSBundle mainBundle] pathForResource:@"url.txt" ofType:nil];
    NSString *needStr = [NSString stringWithContentsOfFile:mainBundle encoding:NSUTF8StringEncoding error:nil];
    _imageArr = [needStr componentsSeparatedByString:@"\n"];
    
    UITableView *mainTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, HEIGHT-64) style:UITableViewStylePlain];
    mainTab.delegate = self;
    mainTab.dataSource = self;
    [self.view addSubview:mainTab];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imageArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *iden = @"cell";
    MainCell *mainCell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!mainCell){
        mainCell = [[MainCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    [mainCell.coverImg xb_setImageWithUrl:_imageArr[indexPath.row]];
    return mainCell;
}
@end
