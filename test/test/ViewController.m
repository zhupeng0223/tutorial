//
//  ViewController.m
//  test
//
//  Created by zhupeng on 16/10/20.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewController.h"
#define kAppURL @"https://test.zzss.com/qunaweb/welfare/index2.html"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableData *dataM;
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kAppURL]]];
//    [self.view addSubview:self.webView];
    
    // Now start the connection
    self.url = [NSURL URLWithString:kAppURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
//    //发送请求
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
    
}

/**
 *  安装证书
 */
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

/**
 *  安装证书成功之后再加载https网页
 */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)pResponse {
    
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:_request];
    
}



//#pragma mark - NSURLSessionDataDelegate代理方法
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
//didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
//{
//    NSLog(@"challenge = %@",challenge.protectionSpace.serverTrust);
//    //判断是否是信任服务器证书
//    if (challenge.protectionSpace.authenticationMethod ==NSURLAuthenticationMethodServerTrust)
//    {
//        //创建一个凭据对象
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        //告诉服务器客户端信任证书
//        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//        
//    }
//}
//
///**
// *  接收到服务器返回的数据时调用
// */
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    NSLog(@"接收到的数据%zd",data.length);
//    [self.dataM appendData:data];
//}
///**
// *  请求完毕
// */
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSString *html = [[NSString alloc]initWithData:self.dataM encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"请求完毕");
//    [self.webView loadHTMLString:html baseURL:self.url];
//}
//
//- (NSMutableData *)dataM
//{
//    if (_dataM == nil)
//    {
//        _dataM = [[NSMutableData alloc]init];
//    }
//    return _dataM;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
