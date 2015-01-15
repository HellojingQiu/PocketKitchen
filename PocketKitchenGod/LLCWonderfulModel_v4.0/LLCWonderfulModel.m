
#import "LLCWonderfulModel.h"

#if 0
#import "GDataXMLNode.h"
#import "DDXML.h"
#endif

#import <objc/runtime.h>

@implementation LLCWonderfulModel

#if 0
/************************************ XML ************************************/

/**
 @funtion:
 使用数据模型来存储XML节点数组内每个节点指定属性的值
 @param
 elements: 需要解析的 XML节点数组
 @param
 isNodeNamesEqualPropertyNames: YES: 要解析的节点的属性名称和数据模型的属性名相同
 @param
 modelClassName: 用来存储XML节点的子节点值的 数据模型的类名
 @param
 ...: 输入要解析的XML节点的子节点名称 和用来接收子节点值的数据模型的属性名称. 如果 isNodeNamesEqualPropertyNames为NO, 那么以 "节点的子节点名称, 数据模型属性名, 节点的子节点名称, 数据模型属性名 ......"格式输入; 如果为YES, 则直接输入节点的子节点名称即可.
 @return:
 一个存有数据模型的数组, 数据模型中记录着被解析的XML节点中指定的子节点的值.
 */
+ (NSArray *)achieveXMLModelsWithElements:(NSArray *)elements
          isNodeNamesEqualToPropertyNames:(BOOL)isNodeNamesEqualPropertyNames
              modelClassNameAndValueNames:(NSString *)modelClassName, ... NS_REQUIRES_NIL_TERMINATION {
  
  NSAssert(elements.count != 0, @"elements' count shouldn't be 0");
  
  // 指向 参数列表的指针
  va_list varList;
  
  NSString *arg;
  NSMutableArray *models = [[NSMutableArray alloc] init];
  if (elements) {
    
    
    int count = 0;
    for (GDataXMLElement *aElement in elements) {
      
      /*
       va_start(ap, param):
       使指向参数列表的指针 指向第一个可选参数
       
       parameters:
       ap:     指向参数列表的指针
       param:  最后一个固定参数
       */
      va_start(varList, modelClassName);
      
      Class modelClass= NSClassFromString(modelClassName);
      id model = [[modelClass alloc] init];
      
      object_setClass(model, modelClass);
      
      /*
       va_arg(ap, type):
       获取 指针指向的参数, 并使指针指向下一个参数
       parameter:
       ap:     指向参数列表的指针
       type:   参数类型
       */
      while ((arg = va_arg(varList, NSString *))) {
        NSString *aValue = [self getStringValueFromElement:aElement
                                              forChildName:arg];
        
        if (!isNodeNamesEqualPropertyNames) {
          arg = va_arg(varList, NSString *);
        }
        
        [model setValue:aValue forKey:arg];
      }
      
      [models addObject:model];
      LLCRelease(model);
      
      count++;
    }
  }
  
  // 释放指针指向的空间
  va_end(varList);
  
  LLCAutorelease(models);
  return models;
}

/**
 @funtion:
 使用传入的参数 创建一个XML节点
 @parameter:
 rootName:     根节点名称
 elementName:  节点名称
 values:       节点的子节点的值
 attributes:   指定子节点的属性节点
 ...:          节点的子节点的名称
 
 defined like:
 NSArray *values = @[@"L", @"class1", @"男"];
 NSDictionary *attributes = @{@"name" : @[@[@"id", @"1"], @[@"uu", @"qq"]],
 @"class" : @[@[@"classID", @"2"]]};
 ...: @"name", @"sex", @"class", nil;
 @return:
 一个 xml字符串 like:
 
 <rootName>
 <elementName>
 <childName1 attribute1 attribute2>value1</childName1>
 <childName2 attribute1 attribute2>value2</childName2>
 </elementName>
 </rootName>
 */
+ (NSString *)createXMLWithRootName:(NSString *)rootName
                        ElementName:(NSString *)elementName
                             values:(NSArray *)values
            attributesAndChildNames:(NSDictionary *)attributes, ... NS_REQUIRES_NIL_TERMINATION {
  
  va_list varList;
  NSString *arg;
  
  DDXMLElement *root = [[DDXMLElement alloc] initWithName:rootName];
  DDXMLElement *element = [[DDXMLElement alloc] initWithName:elementName];
  [root addChild:element];
  
  int count = 0;
  va_start(varList, attributes);
  while ((arg = va_arg(varList, NSString *))) {
    
    DDXMLElement *aChildElement = [[DDXMLElement alloc]
                                   initWithName:arg
                                   stringValue:[values objectAtIndex:count]];
    
    if ([attributes objectForKey:arg]) {
      NSArray *attribute = [attributes objectForKey:arg];
      
      for (NSArray *aAttribute in attribute) {
        
        NSString *attributeName = [aAttribute objectAtIndex:0];
        NSString *attributeValue = [aAttribute objectAtIndex:1];
        [aChildElement addAttribute:[DDXMLElement attributeWithName:attributeName
                                                        stringValue:attributeValue]];
      }
    }
    
    [element addChild:aChildElement];
    LLCRelease(aChildElement);
    
    count++;
  }
  
  va_end(varList);
  
  LLCRelease(element);
  LLCAutorelease(root);
  return root.XMLString;
}

/**
 @abstract
 类比上一个方法
 @return
 一个XML节点
 */
+ (DDXMLElement *)createXMLNodeWithElementName:(NSString *)elementName
                                        values:(NSArray *)values
                       attributesAndChildNames:(NSDictionary *)attributes, ... NS_REQUIRES_NIL_TERMINATION{
  
  va_list varList;
  NSString *arg;
  
  DDXMLElement *element = [[DDXMLElement alloc] initWithName:elementName];
  
  int count = 0;
  va_start(varList, attributes);
  while ((arg = va_arg(varList, NSString *))) {
    
    DDXMLElement *aChildElement = [[DDXMLElement alloc]
                                   initWithName:arg
                                   stringValue:[values objectAtIndex:count]];
    
    if ([attributes objectForKey:arg]) {
      NSArray *attribute = [attributes objectForKey:arg];
      
      for (NSArray *aAttribute in attribute) {
        
        NSString *attributeName = [aAttribute objectAtIndex:0];
        NSString *attributeValue = [aAttribute objectAtIndex:1];
        [aChildElement addAttribute:[DDXMLElement attributeWithName:attributeName
                                                        stringValue:attributeValue]];
      }
    }
    
    [element addChild:aChildElement];
    LLCRelease(aChildElement);
    
    count++;
  }
  
  va_end(varList);
  
  LLCAutorelease(element);
  return element;
}

/**
 achieve the string-value from the imported element's children element.
 */
+ (NSString *)getStringValueFromElement:(GDataXMLElement *)element
                           forChildName:(NSString *)childName {
  return [[[element elementsForName:childName] lastObject] stringValue];
}

#endif

/************************************ JSON ************************************/

+ (NSArray *)achieveJSONModelsWithDataAndElementNames:(NSArray *)data
                      isNodeNamesEqualToPropertyNames:(BOOL)isNodeNamesEqualPropertyNames
                          modelClassNameAndValueNames:(NSString *)modelClassName, ... NS_REQUIRES_NIL_TERMINATION {
  
  va_list varList;
  NSString *arg;
  NSMutableArray *models = [[NSMutableArray alloc] init];
  
  for (NSDictionary *aDict in data) {
    
    va_start(varList, modelClassName);
    
    Class modelClass = NSClassFromString(modelClassName);
    id model = [[modelClass alloc] init];
    
    object_setClass(model, modelClass);
    
    while ((arg = va_arg(varList, NSString *))) { // j s j s
      NSString *aValue = [aDict objectForKey:arg];
      
      if (!isNodeNamesEqualPropertyNames) {
        arg = va_arg(varList, NSString *);
      }
      
      [model setValue:aValue forKey:arg];
    }
    
    [models addObject:model];
    LLCRelease(model);
  }
  
  va_end(varList);
  
  LLCAutorelease(models);
  return models;
}

@end

