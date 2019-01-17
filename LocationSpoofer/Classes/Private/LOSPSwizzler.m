//
//  LOSPSwizzler.m
//
//  Copyright © 2019 Buglife, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "LOSPSwizzler.h"
#import <objc/runtime.h>

typedef void (^LOSPClassEnumerationBlock)(Class);
typedef void (^LOSPMethodEnumerationBlock)(Class);
void LOSPEnumerateAllClasses(LOSPClassEnumerationBlock block);

@implementation LOSPSwizzler

@end

IMP LOSPReplaceMethodWithBlock(Class c, SEL origSEL, id block) {
    NSCParameterAssert(block);
    Method origMethod = class_getInstanceMethod(c, origSEL);
    NSCParameterAssert(origMethod);
    IMP newIMP = imp_implementationWithBlock(block);
    
    if (!class_addMethod(c, origSEL, newIMP, method_getTypeEncoding(origMethod))) {
        return method_setImplementation(origMethod, newIMP);
    } else {
        return method_getImplementation(origMethod);
    }
}

IMP LOSPReplaceClassMethodWithBlock(Class c, SEL origSEL, id block) {
    NSCParameterAssert(block);
    Method origMethod = class_getClassMethod(c, origSEL);
    NSCParameterAssert(origMethod);
    IMP newIMP = imp_implementationWithBlock(block);
    
    if (!class_addMethod(c, origSEL, newIMP, method_getTypeEncoding(origMethod))) {
        return method_setImplementation(origMethod, newIMP);
    } else {
        return method_getImplementation(origMethod);
    }
}

NSArray<Class> *LOSPGetClassesAdoptingProtocol(Protocol *protocol) {
    NSMutableArray *classes = [NSMutableArray array];
    
    LOSPEnumerateAllClasses(^(__unsafe_unretained Class cls) {
        if (class_conformsToProtocol(cls, protocol)) {
            [classes addObject:cls];
        }
    });
    
    return [NSArray arrayWithArray:classes];
}

void LOSPEnumerateAllClasses(LOSPClassEnumerationBlock block) {
    int numClasses;
    Class * classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class cls = classes[i];
            block(cls);
        }
        free(classes);
    }
}
