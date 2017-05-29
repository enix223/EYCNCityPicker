//
//  EYCNCityService.m
//  Pods
//
//  Created by Enix Yu on 29/5/2017.
//
//

#import "EYCNCityService.h"

static NSString * const kEYCNCityServiceAPIDomain = @"http://restapi.amap.com";

static NSString * const kEYCNCityServiceAPIURI = @"/v3/config/district";

static NSString * const kEYCNCitySerivceErrorDomain = @"cn.robotbros.EYCNCityPickerErrorDomain";

@interface EYCNCityService ()

@property (nonatomic, copy) NSString *key;

@end

@implementation EYCNCityService

- (instancetype)initWithAPIKey:(NSString *)key
{
    self = [super init];
    if (self) {
        self.key = key;
    }
    return self;
}

- (void)requestCNCitiesWithCompletion:(EYCNCityServiceCompletion)completion {
    NSAssert(_key != nil, @"高德Web API key未指定，详情请查看：http://developer.amap.com/api/webservice/summary/");
    
    NSString *baseURLString = _apiDomain == nil ? kEYCNCityServiceAPIDomain : _apiDomain;
    NSString *apiURI = _apiURI == nil ? kEYCNCityServiceAPIURI : _apiURI;
    NSString *params = [NSString stringWithFormat:@"?key=%@&subdistrict=3", _key];
    NSString *url = [[baseURLString stringByAppendingPathComponent:apiURI] stringByAppendingString:params];
    NSURL *apiURL = [NSURL URLWithString:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task =
        [session dataTaskWithURL:apiURL
               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                   if (error) {
                       completion(nil, error);
                   } else {
                       NSError *err;
                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableLeaves
                                                                              error:&err];
                       if (err != nil) {
                           NSString *errString = [NSString stringWithFormat:@"解析数据失败，原因: %@", err.localizedDescription];
                           NSError *customErr = [NSError errorWithDomain:kEYCNCitySerivceErrorDomain
                                                                    code:-1
                                                                userInfo:@{NSLocalizedDescriptionKey: errString}];
                           completion(nil, customErr);
                       } else {
                           if (![[json objectForKey:@"status"] isEqualToString:@"1"]) {
                               // request failed
                               NSString *errString = [NSString stringWithFormat:@"获取数据失败，原因: %@", [json objectForKey:@"info"]];
                               NSError *customErr = [NSError errorWithDomain:kEYCNCitySerivceErrorDomain
                                                                        code:-2
                                                                    userInfo:@{NSLocalizedDescriptionKey: errString}];
                               completion(nil, customErr);
                               return;
                           }
                           
                           NSDictionary *country = [[json objectForKey:@"districts"] firstObject];
                           NSArray *provinces = [country objectForKey:@"districts"];
                           NSMutableArray *newProvinces = [NSMutableArray array];
                           [provinces enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                               // 每个省
                               NSArray *cities = [obj valueForKeyPath:@"districts"];
                               NSMutableArray *newCities = [NSMutableArray array];
                               [cities enumerateObjectsUsingBlock:^(id item, NSUInteger idx2, BOOL * _Nonnull stop2) {
                                   // 每个城市
                                   NSArray *regions = [item valueForKeyPath:@"districts"];
                                   NSMutableArray *newRegions = [NSMutableArray array];
                                   [regions enumerateObjectsUsingBlock:^(id item2, NSUInteger idx, BOOL * _Nonnull stop) {
                                       // 每个区域
                                       [newRegions addObject:@{@"p": [item2 objectForKey:@"name"]}];
                                   }];
                                   if ([newRegions count] == 0) [newRegions addObject:@{@"p": @""}];
                                   
                                   [newCities addObject:@{@"p": [item objectForKey:@"name"], @"c": newRegions}];
                               }];
                               if ([newCities count] == 0) [newCities addObject:@{@"p": @""}];
                               
                               [newProvinces addObject:@{@"p": [obj objectForKey:@"name"], @"c": newCities}];
                           }];
                           
                           completion(newProvinces, nil);
                       }
                   }
               }];
    [task resume];
}

@end
