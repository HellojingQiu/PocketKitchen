
#import <Foundation/Foundation.h>

@class DDXMLElement;
@interface LLCWonderfulModel : NSObject

/************************************ XML ************************************/

/**
 @funtion:
 use the models imported to store the data defined by you which from elements of xml.
 @param
 elements: the elements of xml what you want to analyse.
 @param
 isNodeNamesEqualPropertyNames: Specify if the node-names is equal to models' property-names.
 @param
 modelClassName:   the response-model's class-name.
 @param
 ...:      if the parameter: isNodeNamesEqualPropertyNames is NO, then
 Input children names of elements and relevant models' property-names which are used to receive the childs' value.
 The formater like: child, property, child, property. Two parameters make up a group.
 else: just need to input node-names.
 @return:
 an array which stores all models, and the models store all data you specify nodes' values.
 */
+ (NSArray *)achieveXMLModelsWithElements:(NSArray *)elements
          isNodeNamesEqualToPropertyNames:(BOOL)isNodeNamesEqualPropertyNames
              modelClassNameAndValueNames:(NSString *)modelClassName, ... NS_REQUIRES_NIL_TERMINATION;

/**
 @funtion:
 use imported parameters to create a xml
 @param
 rootName:     the root-node name.
 @param
 elementName:  the element-node name.
 @param
 values:       the element-node's child's string-value
 @param
 attributes:   the attributes of appointed node.
 @param
 ...:          input any child-name of the element-node.
 
 @abstract
 defined like:
 NSArray *values = @[@"L"];
 NSDictionary *attributes = @{@"name"  : @[@[@"id", @"1"], @[@"qq", @"qq"]],
 @"class" : @[@["id", "2"]]};
 ...: @"name", @"sex", @"class", nil;
 @return:
 a xmlString like:
 
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
            attributesAndChildNames:(NSDictionary *)attributes, ... NS_REQUIRES_NIL_TERMINATION;

/**
 @function
 like the + (NSString *)createXMLWithRootName:(NSString *)rootName ElementName:(NSString *)elementName values:(NSArray *)values attributesAndChildNames:(NSDictionary *)attributes, ... NS_REQUIRES_NIL_TERMINATION;
 @return
 a xml node.
 */
+ (DDXMLElement *)createXMLNodeWithElementName:(NSString *)elementName
                                        values:(NSArray *)values
                       attributesAndChildNames:(NSDictionary *)attributes, ... NS_REQUIRES_NIL_TERMINATION;

/************************************ JSON ************************************/

/**
 @funtion:
 use the models imported to store the data defined by you which from elements of xml.
 @param
 elements: the elements of xml what you want to analyse.
 @param
 isNodeNamesEqualPropertyNames: Specify if the node-names is equal to models' property-names.
 @param
 modelClassName:   the response-model's class-name.
 @param
 ...:      if the parameter: isNodeNamesEqualPropertyNames is NO, then
 Input children names of elements and relevant models' property-names which are used to receive the childs' value.
 The formater like: child, property, child, property. Two parameters make up a group.
 else: just need to input node-names.
 @return:
 an array which stores all models, and the models store all data you specify nodes' values.
 */
+ (NSArray *)achieveJSONModelsWithDataAndElementNames:(NSArray *)data
                      isNodeNamesEqualToPropertyNames:(BOOL)isNodeNamesEqualPropertyNames
                          modelClassNameAndValueNames:(NSString *)modelClassName, ... NS_REQUIRES_NIL_TERMINATION;

@end






