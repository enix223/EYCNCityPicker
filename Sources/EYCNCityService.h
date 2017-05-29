//
//  EYCNCityService.h
//  Pods
//
//  Created by Enix Yu on 29/5/2017.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^EYCNCityServiceCompletion)(NSArray * _Nullable cities, NSError * _Nullable error);

@interface EYCNCityService : NSObject

/// 高德web api Domain，默认为:http://restapi.amap.com
@property (nonatomic, copy, nullable) NSString *apiDomain;

/// 高德获取行政区域web api URI, 默认为: /v3/config/district
@property (nonatomic, copy, nullable) NSString *apiURI;

/**
 * @brief 初始化Service
 * @param key: 高德web API Key，详情请查看：http://developer.amap.com/api/webservice/summary/
 * @return: Service 实例
 */
- (instancetype)initWithAPIKey:(NSString *)key NS_DESIGNATED_INITIALIZER;

/**
 * @brief 请求中国行政区域数据
 * @param completion: 请求完成回调
 */
- (void)requestCNCitiesWithCompletion:(EYCNCityServiceCompletion)completion;

@end

NS_ASSUME_NONNULL_END
