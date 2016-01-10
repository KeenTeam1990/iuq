
//
//  URLS.h
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#ifndef i___URLS_h
#define i___URLS_h
//API
#define APIKEY (@"1c438219585ee8d0515c99c8e7583689")

//精选（随意搜索话题） NSString *urlString = @"page=2&key=娱乐”;（21亿）
#define kChosenUrl (@"http://apis.baidu.com/showapi_open_bus/weixin/weixin_article_list")

//发现

//
#define kDiscoverListDetail (@"http://www.duitang.com/napi/blog/list/by_category/?app_version=1.8%20rv%3A1808&cate_key=%@&limit=24&start=%ld")
#define kDiscoverList (@"http://www.duitang.com/napi/categories/?app_version=1.8%20rv%3A1808")

#define kFashion (@"http://www.duitang.com/napi/blog/list/by_category/?app_version=1.8%20rv%3A1808&cate_key=5017d172705cbe10c000000a&limit=24&start=0")

 
//行走日记：http://chanyouji.com/api/trips/featured.json?page=1
#define kTravelUrl (@"http://chanyouji.com/api/destinations.json")
#define kDestinationUrl (@"http://chanyouji.com/api/destinations/%@.json")
#define kTravelDetail (@"http://chanyouji.com/api/destinations/plans/%@.json?page=%ld")
#define kTravelToDetil (@"http://chanyouji.com/api/plans/%@.json")
#endif
