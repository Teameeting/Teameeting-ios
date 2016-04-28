//
//  ErrorUtil.m
//  Dropeva
//
//  Created by zjq on 15/10/16.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "ErrorUtil.h"

@implementation ErrorUtil
+(NSString*)getErrorInfoWithCode:(int)code

{
    switch (code) {
        case 201:
            return @"http请求参数为空或者长度为零";
            break;
        case 202:
            return @"注册手机号等已存在";
            break;
        case 203:
            return @"短信发送失败";
            break;
        case 204:
            return @"短信验证码失败";
            break;
        case 205:
            return @"用户不存在";
            break;
        case 206:
            return @"登录失败";
            break;
        case 207:
            return @"用户验证为空";
            break;
        case 208:
            return @"用户在线验证失败";
            break;
        case 209:
            return @"注销失败";
            break;
        case 210:
            return @"修改密码失败";
            break;
        case 211:
            return @"二维码信息已过期";
            break;
        case 212:
            return @"发送登录信息成功";
            break;
        case 213:
            return @"二维码验证不通过";
            break;
        case 214:
            return @"更新设备信息失败";
            break;
        case 215:
            return @"更新用户信息失败";
            break;
        case 216:
            return @"该手机号码已经被绑定";
            break;
        case 217:
            return @"该用户已经绑定手机号码";
            break;
        case 218:
            return @"添加设备失败";
            break;
        case 219:
            return @"添加的设备已存在";
            break;
        case 220:
            return @"获取设备列表失败";
            break;
        case 221:
            return @"删除设备失败";
            break;
        case 222:
            return @"发送分享信息失败";
            break;
        case 223:
            return @"回复分享信息失败";
            break;
        case 224:
            return @"获取分享记录失败";
            break;
        case 225:
            return @"删除分享记录失败";
            break;
        case 226:
            return @"二维码超时";
            break;
        case 227:
            return @"解除绑定电话状况失败";
            break;
        case 228:
            return @"更新设备查看次数失败";
            break;
        case 229:
            return @"撤回分享设备失败";
            break;
        case 230:
            return @"用户绑定第三方账户失败";
            break;
        case 231:
            return @"用户解除绑定第三方账户失败";
            break;
        case 232:
            return @"用户预登录失败";
            break;
        default:
            return @"未知错误,请重试";
            break;
    }
    return @"未知错误,请重试";
}

@end
