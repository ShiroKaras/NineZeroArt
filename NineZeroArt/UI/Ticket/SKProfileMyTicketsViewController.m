//
//  SKProfileMyTicketsViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileMyTicketsViewController.h"
#import "HTUIHeader.h"
#import "SKTicketView.h"
#import "SKDescriptionView.h"

@interface SKProfileMyTicketsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSArray<SKTicket*>    *ticketArray;
@end

@implementation SKProfileMyTicketsViewController {
    float lastOffsetY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:self.tableView];
    
    UIView *tableViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
    tableViewFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableViewFooterView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 49)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_titletext"]];
    [headerView addSubview:headerImageView];
    headerImageView.centerX = headerView.centerX;
    headerImageView.centerY = headerView.height/2;
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [converView addSubview:_blankView];
        _blankView.center = converView.center;
    } else {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getUserTicketsCallbackCallback:^(BOOL suceese, NSArray<SKTicket *> *tickets) {
        if (tickets.count == 0) {
            UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
            converView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:converView];
            HTBlankView *blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_gift"] text:@"参加官方活动，凭券获得神秘礼物"];
            [blankView setOffset:10];
            [self.view addSubview:blankView];
            blankView.top = ROUND_HEIGHT_FLOAT(217);
        } else {
            self.ticketArray = tickets;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    SKTicketView *ticket = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(280), ROUND_WIDTH_FLOAT(108)) reward:self.ticketArray[indexPath.row]];
    [cell.contentView addSubview:ticket];
    [ticket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(280));
        make.height.equalTo(ROUND_WIDTH(108));
        make.top.equalTo(cell);
        make.centerX.equalTo(cell);
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROUND_WIDTH_FLOAT(108)+10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SKDescriptionView *descriptionView = [[SKDescriptionView alloc] initWithURLString:self.ticketArray[indexPath.row].address andType:SKDescriptionTypeReward andImageUrl:self.ticketArray[indexPath.row].pic];
    [descriptionView setReward:self.ticketArray[indexPath.row]];
    [self.view addSubview:descriptionView];
    [descriptionView showAnimated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ticketArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UIScrollView Delegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y <= 64) {
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.view viewWithTag:9001].alpha = 1;
//            [self.view viewWithTag:200].alpha = 1;
//            [self.view viewWithTag:202].alpha = 0;
//            [self.view viewWithTag:9001].bottom = [self.view viewWithTag:9001].height+12;
//            [self.view viewWithTag:200].bottom = [self.view viewWithTag:200].height;
//            [self.view viewWithTag:202].bottom = [self.view viewWithTag:202].height;
//        } completion:^(BOOL finished) {
//            
//        }];
//    } else {
//        if (lastOffsetY >= scrollView.contentOffset.y) {
//            [UIView animateWithDuration:0.3 animations:^{
//                //显示
//                [self.view viewWithTag:9001].alpha = 1;
//                [self.view viewWithTag:200].alpha = 1;
//                [self.view viewWithTag:202].alpha = 1;
//                [self.view viewWithTag:9001].bottom = [self.view viewWithTag:9001].height+12;
//                [self.view viewWithTag:200].bottom = [self.view viewWithTag:200].height;
//                [self.view viewWithTag:202].bottom = [self.view viewWithTag:202].height;
//            } completion:^(BOOL finished) {
//                
//            }];
//        } else {
//            [UIView animateWithDuration:0.3 animations:^{
//                //隐藏
//                [self.view viewWithTag:9001].alpha = 0;
//                [self.view viewWithTag:200].alpha = 0;
//                [self.view viewWithTag:202].alpha = 0;
//                [self.view viewWithTag:9001].bottom = 0;
//                [self.view viewWithTag:200].bottom = 0;
//                [self.view viewWithTag:202].bottom = 0;
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
//    }
//    lastOffsetY = scrollView.contentOffset.y;
//}


@end
