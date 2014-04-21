//
//  RootViewController.m
//  XMLDemo
//
//  Created by YuLei on 14-4-21.
//  Copyright (c) 2014年 ___DuanYuLei___. All rights reserved.
//

#import "RootViewController.h"
#import "DataBase.h"
#import "GDataXMLNode.h"
#import "MyTableViewCell.h"
#define URL @"http://119.255.38.178:8088/sns/my/login.php?format=xml"
#define SINA @"http://rss.sina.com.cn/roll/sports/hot_roll.xml"
@interface RootViewController ()<NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RootViewController{
    NSMutableData *_recvData;
    NSMutableArray *_mydataArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"体育要闻汇总";
    // Do any additional setup after loading the view.
    if(_mydataArray == nil){
        _mydataArray = [NSMutableArray array];
    }
    [_myTableView setScrollEnabled:YES];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    _recvData = [[NSMutableData alloc] init];
    _mydataArray = [[NSMutableArray alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:SINA]];
    [NSURLConnection connectionWithRequest:request delegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_recvData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _recvData.length = 0;
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:_recvData options:0 error:nil];

    NSString *xpath = @"/rss/channel/item";
    NSArray *arr = [document nodesForXPath:xpath error:nil];

    for (GDataXMLElement * element in arr) {
        DataBase *model = [[DataBase alloc] init];
        NSString *name = [[element elementsForName:@"title"][0] stringValue];
        model.name = name;
        NSString *mydata = [[element elementsForName:@"pubDate"][0] stringValue];
        NSString *mydescription = [[element elementsForName:@"description"][0] stringValue];
        model.description = mydescription;
        
        NSString *dateStr = mydata;
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        dateFormatter2.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        //@"yyyy/MM/dd HH:mm";
        NSDate *newdate = [dateFormatter2 dateFromString:dateStr];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormatter.dateFormat = @"y/MM/dd HH:mm eeee";

        model.data = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:newdate]];
        
        [_mydataArray addObject:model];
    }
    [_myTableView reloadData];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mydataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"cell"];
    DataBase *model = _mydataArray[indexPath.row];
    [cell passModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}



@end
