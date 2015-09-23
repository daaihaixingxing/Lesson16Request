//
//  GetViewController.m
//  
//
//  Created by lanouhn on 15/9/23.
//
//

#import "GetViewController.h"
#import "Model.h"

/**
 *  GET 和 POST 请求的区别：
 1.参数：GET请求将服务器地址和参数拼接在一起，形成请求数据的网址。而POST请求将两部分分开，参数以请求体的形式提交给服务器
 2.大小：GET最大为255个字节，而POST请求原则上没有限制
 3.安全性：GET请求因为参数可以在网址里面直接看到，所以是不安全的；而POST请求参数作为请求体提交，相对比较安全。
 4.用途：GET请求用于请求数据（下载数据）；POST请求用于提交数据（上传文件）
*/


@interface GetViewController () <NSURLConnectionDataDelegate>

@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableData *receiveData;

@end

@implementation GetViewController

- (void)dealloc {
    self.dataSource = nil;
    self.receiveData = nil;
    [super dealloc];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNaviBar];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}

- (void)configureNaviBar {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"同步" style:UIBarButtonItemStylePlain target:self action:@selector(handleSynchronizeRequest:)];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"异步" style:UIBarButtonItemStylePlain target:self action:@selector(handleAsynchronizeRequest:)] autorelease];
}

/**
 *  同步和异步：
 *
 *   同步请求：网络请求任务由主线程完成，当主线程在处理网络请求时，所有的用户交互就无法处理，用户体验差。
     异步请求：网络请求任务由子线程完成，当子线程在处理网络请求时，主线程依然可以处理用户交互，所以用户事件能够得到及时的处理。用户体验好。
 */

//GET 同步
- (void)handleSynchronizeRequest:(UIBarButtonItem *)sender {
   
    //1. 创建网址字符串
    NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?query=%@&region=%@&output=json&ak=6E823f587c95f0148c19993539b99295",@"酒店",@"郑州"];
    //2. URLEncode编码 对于网址中有中文的，需要更改编码格式
    NSString *newString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //3. 创建NSURL对象
    NSURL *url = [NSURL URLWithString:newString];
    //4. 创建请求对象 NSURLRequest
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    //5. 同步请求
    NSURLResponse *response = nil;//服务器响应对象，存储服务器响应的信息；返回数据的长度，数据的类型等
    NSError *error = nil;//存储连接错误信息，比如连接失败，网络中断等
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];//data就是通过网址从服务器请求到的数据
    
    //6. 解析数据 供界面上显示
    [self parserDataWithData:data];
    
}

#pragma mark ----------- 解析数据 -----------
- (void)parserDataWithData:(NSData *)data {
     [self.dataSource removeAllObjects];
    //使用系统JSON解析方式进行解析
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",dic);
    NSArray *arr = dic[@"results"];
    NSLog(@"%@",arr);
    for (NSDictionary *dict in arr) {
        Model *model = [[Model alloc] initWithDic:dict];
        [self.dataSource addObject:model];
        [model release];
    }
    [self.tableView reloadData];
}

//GET 异步
- (void)handleAsynchronizeRequest:(UIBarButtonItem *)sender {
    //1. 创建网址字符串
    NSString *urlStr = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?query=%@&region=%@&output=json&ak=6E823f587c95f0148c19993539b99295",@"餐厅",@"新乡"];
    //2. URLEncode编码 （网址中存在中文）
    NSString *newStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //3. 创建NSURL对象
    NSURL *url = [NSURL URLWithString:newStr];
    //4. 创建网址请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //5. ********异步请求第一种方式(block形式)*********
    /*
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //data 是服务器返回来的数据
        [self parserDataWithData:data];
    }];
    */
    // **********异步请求第二种方式（代理形式）************
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark --------- NSURLConnectionDataDelegate -----
//收到服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //该方法在建立连接的过程中，只会执行一次

    self.receiveData = [NSMutableData data];
    
}

//收到服务器数据时
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receiveData appendData:data];//拼接数据
    
}

//传输数据完毕时
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //解析
    [self parserDataWithData:self.receiveData];
}

//连接失败时
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    Model *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}

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
