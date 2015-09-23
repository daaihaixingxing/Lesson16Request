//
//  PostViewController.m
//  Lesson16Request
//
//  Created by lanouhn on 15/9/23.
//  Copyright (c) 2015年 大爱海星星. All rights reserved.
//

#define kURL @"http://api.tudou.com/v3/gw"
#import "PostViewController.h"

@interface PostViewController () <NSURLConnectionDataDelegate>

@property (nonatomic,retain) NSMutableData *receiveData;

@end

@implementation PostViewController

- (void)dealloc {
    self.receiveData = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self configureNaviBar];
}

- (void)configureNaviBar {
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"同步" style:UIBarButtonItemStylePlain target:self action:@selector(synchronizeRequest:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"异步" style:UIBarButtonItemStylePlain target:self action:@selector(handleAsynchronizeRequest:)] autorelease];
}

#pragma mark ************** handle Action ***************

#pragma mark ---- POST同步连接 ----
- (void)synchronizeRequest:(UIBarButtonItem *)item {
    //1. 创建网址字符串
    NSString *string = [NSString stringWithFormat:kURL];
    //2. 创建NSURL对象
    NSURL *url = [NSURL URLWithString:string];
    //3. 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //4. 创建参数字符串
    NSString *parmStr = [NSString stringWithFormat:@"method=album.channel.get&appKey=myKey&format=json&channel=t&pageNo=1&pageSize=10"];
    //5. 设置请求体，将参数字符串转化为NSData对象
    [request setHTTPBody:[parmStr dataUsingEncoding:NSUTF8StringEncoding]];
    //6. 设置请求方式(不设置的话，默认为GET)
    [request setHTTPMethod:@"POST"];
    //7. 同步连接
//    NSURLResponse *response = nil;
//    NSError *error = nil;
     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //8. 解析
    [self parserData:data];
    
    
}

- (void)parserData:(NSData *)data {
    //系统JSON解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@",dic);
}

#pragma mark ---- POST异步连接 ----
- (void)handleAsynchronizeRequest:(UIBarButtonItem *)item {
    //1. 创建网址字符串
    NSString *urlString = [NSString stringWithFormat:kURL];
    //2. 创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlString];
    //3. 创建NSMutableURLRequest对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //4. 创建参数字符串
    NSString *parmString = [NSString stringWithFormat:@"method=album.channel.get&appKey=myKey&format=json&channel=t&pageNo=1&pageSize=10"];
    //5. 设置请求体，将参数字符串转化为NSData对象
    [request setHTTPBody:[parmString dataUsingEncoding:NSUTF8StringEncoding]];
    //6. 设置请求的方式
    [request setHTTPMethod:@"POST"];
    //7. 异步连接
    /*
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       //解析(调用上面写好的解析方法解析数据)
        [self parserData:data];
    }];
    */
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *********** NSURLConnectionDataDelegate ********

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receiveData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receiveData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self parserData:self.receiveData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
