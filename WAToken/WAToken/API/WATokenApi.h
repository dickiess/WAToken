//
//  WATokenApi.h
//  WAToken
//
//  Created by dizhihao on 2018/6/20.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "Interfaces.h"

#ifndef WATokenApi_h
#define WATokenApi_h

/********************************************************************************************************/

#pragma mark - API


/*
 用户登录
 
 入参： name、password
 出参： result、obj
 
 */
#define WAT_USER_LOGIN  @"/SL.php/WatUser/login"
// 用例: localhost/SL.php/WatUser/login?name=xxx&&password=xxx


/*
 用户注册
 
 入参： name、mobile、invitation、password
 出参： result、obj
 
 */
#define WAT_USER_REG    @"/SL.php/WatUser/add"
// 用例: localhost/SL.php/WatUser/add?name=xxx&&mobile=xxx&&invitation=xxx&&password=xxx


/*
 用户信息编辑
 
 入参： code、gender、ident、city、email
 出参： result、obj
 
 */
#define WAT_USER_EDIT   @"/SL.php/WatUser/edit"
// 用例: localhost/SL.php/WatUser/edit?code=xxx&&gender=1&&ident=310105199110100023&&city=284&&email=77778888@qq.com


/*
 登陆口令修改
 
 入参： code、p1、p2
 出参： result、obj
 
 */
#define WAT_USER_PASS   @"/SL.php/WatUser/pass"
// 用例: localhost/SL.php/WatUser/pass?code=xxx&&p1=xxx&&p2=xxx



#endif /* WATokenApi_h */
