//
//  imageViewController.m
//  Lesson16Request
//
//  Created by lanouhn on 15/9/23.
//  Copyright (c) 2015年 大爱海星星. All rights reserved.
//

#import "imageViewController.h"

@interface imageViewController () <NSURLConnectionDataDelegate>

{
    long long _totleLength;//记录总的数据大小
}
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UILabel *label;
@property (nonatomic,retain) NSMutableData *receiveData;

@end

@implementation imageViewController

- (void)dealloc {
    self.imageView = nil;
    self.label = nil;
    self.receiveData = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"请求" style:UIBarButtonItemStylePlain target:self action:@selector(handleRequest:)] autorelease];
    
    //imageView
    self.imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_imageView];
    [_imageView release];
    
    //label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(87.5, 300, 200, 60)];
    _label.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_label];
    [_label release];
}

#pragma mark ************* handle Action *************
//异步请求
- (void)handleRequest:(UIBarButtonItem *)item {
    //1. 创建网址字符串
    NSString *urlString = [NSString stringWithFormat:@"http://img.zcool.cn/community/0332de1559f800a32f875370ac09559.jpg"];
    //2. 创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlString];
    //3. 创建NSURLRequest对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    //4. 异步连接 ******* 第一种方式（block形式）********
    
    //第二种方式
    [NSURLConnection connectionWithRequest:request delegate:self];


}

#pragma mark *********** NSURLConnectionDataDelegate *********
//连接成功
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receiveData = [NSMutableData data];
    //response 包含数据的大小，数据的类型
    _totleLength =  response.expectedContentLength;//数据的总长度
}

//接收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //每一次返回一部分，为了得到完成的数据，数据需要拼接
    [self.receiveData appendData:data];
    //求出下载的比例 已下载的数据大小 / 总的数据大小
    CGFloat percent = self.receiveData.length * 1.0 / _totleLength;
    self.label.text = [NSString stringWithFormat:@"%.0f%%",percent * 100];
    self.imageView.image = [UIImage imageWithData:self.receiveData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
