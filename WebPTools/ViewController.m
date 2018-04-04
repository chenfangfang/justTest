//
//  ViewController.m
//  WebPTools
//
//  Created by 陈方方 on 2017/10/24.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ViewController.h"
#import "NXWebpEncoder.h"

@interface ViewController ()
{
    NSTextField * _nameField;
    NSTextField * _dirText;
    

    NSTextField * _timeField;

    NSTextField * _qualityField;

    NSTextField * _loopCountField;


    NSMutableArray * _imagesArray;

    //上次选择的目录
    NSString * _lastPath;

    NSString * _finnalPath;


}

@end



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    float startY = 50;

    [self.view addSubview:[self textWithFrame:CGRectMake(100, startY - 5, 50, 25) text:@"文件名:"]];

    _nameField = [[NSTextField alloc] initWithFrame:CGRectMake(150, startY, 80, 25)];
    _nameField.userActivity = NO;
    _nameField.stringValue = @"test";
    [self.view addSubview:_nameField];
    
    NSButton * createBtn = [[NSButton alloc] initWithFrame:CGRectMake(260, startY, 100, 30)];
    [createBtn setBezelColor:[NSColor blackColor]];
    [createBtn setTitle:@"生成webP"];
    [createBtn setTarget:self];
    [createBtn setAction:@selector(createBtnClick)];
    [self.view addSubview:createBtn];
  
    
    float sacpY = 25;

    startY += 40 + sacpY;
    
    NSButton * chooseBtn = [[NSButton alloc] initWithFrame:CGRectMake(100, startY, 260, 30)];
    [chooseBtn setBezelColor:[NSColor blackColor]];
    [chooseBtn setTitle:@"选择文件夹或图片"];
    [chooseBtn setTarget:self];
    [chooseBtn setAction:@selector(chooseBtnClick)];
    [self.view addSubview:chooseBtn];
    
    startY += 15 + sacpY;

    _dirText = [[NSTextField alloc] initWithFrame:CGRectMake(100, startY, 260, 40)];
    _dirText.enabled = NO;
    _dirText.userActivity = NO;
    [self.view addSubview:_dirText];
    
    //总时长
    startY += 40 + sacpY;

    [self.view addSubview:[self textWithFrame:CGRectMake(100, startY - 5, 40, 25) text:@"时长:"]];
    
    _timeField = [[NSTextField alloc] initWithFrame:CGRectMake(140, startY, 30, 25)];
    _timeField.stringValue = @"3";
    [self.view addSubview:_timeField];
 
    //质量
    [self.view addSubview:[self textWithFrame:CGRectMake(180, startY -5 , 40, 25) text:@"质量:"]];
    
    _qualityField = [[NSTextField alloc] initWithFrame:CGRectMake(220, startY, 30, 25)];
    _qualityField.stringValue = @"0.8";
    [self.view addSubview:_qualityField];

    [self.view addSubview:[self textWithFrame:CGRectMake(260, startY - 5, 60, 25) text:@"循环次数:"]];
    _loopCountField = [[NSTextField alloc] initWithFrame:CGRectMake(320, startY, 30, 25)];
    _loopCountField.stringValue = @"0";
    [self.view addSubview:_loopCountField];

}

-(NSTextField *)textWithFrame:(CGRect)rect text:(NSString *)text
{
    NSTextField * timeText = [[NSTextField alloc] initWithFrame:rect];
    timeText.backgroundColor = [NSColor clearColor];
    timeText.bordered = NO;
    timeText.enabled = NO;
    timeText.userActivity = NO;
    timeText.placeholderString = text;
    return timeText;
}


//选择文件夹
-(void)chooseBtnClick
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, NO);
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    NSFileManager *fileManager =[[NSFileManager alloc] init];
    if (!_lastPath || _lastPath.length == 0 ||![fileManager fileExistsAtPath:_lastPath])
    {
        NSString *theDesktopPath = [paths objectAtIndex:0];
        _lastPath = theDesktopPath;
    }
    
    [panel setDirectoryURL:[NSURL URLWithString:_lastPath]];
    
    //可以新建文件夹
    [panel setCanCreateDirectories:YES];

    //可以选中文件
    [panel setCanChooseFiles:YES];
    //允许多选
    [panel setAllowsMultipleSelection:YES];
    
    //可以打开文件夹
    [panel setCanChooseDirectories:YES];
    
    
    if ([panel runModal] == NSModalResponseOK)
    {
        _imagesArray = [NSMutableArray arrayWithCapacity:0];
        
        BOOL isDir = NO;
        [fileManager fileExistsAtPath:panel.URLs.firstObject.path isDirectory:&isDir];
        
        if (isDir)
        {//是文件夹
            
            NSString * directPath = panel.URLs.firstObject.path;
            
            _dirText.stringValue = _lastPath = directPath;

            NSError * error;
            //只要图片
            NSArray *fileList = [[fileManager contentsOfDirectoryAtPath:directPath error:&error] pathsMatchingExtensions:[NSArray arrayWithObjects:@"png",nil]];
            
            fileList = [fileList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                //筛选出纯数字 然后排序
                NSString *result1 = [[obj1 componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
                
                NSString *result2 = [[obj2 componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
                
                return [[NSNumber numberWithInt:result1.intValue] compare:[NSNumber numberWithInt:result2.intValue]];
                
            }];
            
            for (int i =0; i<fileList.count; i++)
            {
                NSString * fileStr = [directPath stringByAppendingPathComponent:[fileList objectAtIndex:i]];
                
                NSImage * image = [[NSImage alloc] initWithContentsOfFile:fileStr];
                if(image)
                {
                    [_imagesArray addObject:fileStr];
                }
            }
            
            _finnalPath = directPath;
        }
        else
        {//选择的是图片
            _finnalPath = panel.URLs.firstObject.path.stringByDeletingLastPathComponent;

            _dirText.stringValue = _lastPath = _finnalPath;
            
            for (int i = 0 ; i < panel.URLs.count ;i++ )
            {
                NSString * directPath = [panel.URLs objectAtIndex:i].path;
                NSImage * image = [[NSImage alloc] initWithContentsOfFile:directPath];
                if(image)
                {
                    [_imagesArray addObject:directPath];
                }
            }
          
        }
    }
}

//生成webP
-(void)createBtnClick
{
    if ([_nameField stringValue].length == 0)
    {
        [self showAlertWithMessage:@"请输入文件名称!"];
        return;
    }
    if ([_qualityField stringValue].floatValue <= 0)
    {
        [self showAlertWithMessage:@"图片质量必须大于0!"];
        return;

    }
    
    if ([_qualityField stringValue].floatValue > 1)
    {
        [self showAlertWithMessage:@"图片质量不能大于1!"];
        return;

    }
    
    if (_imagesArray.count > 1 && [_timeField stringValue].floatValue <= 0)
    {
        [self showAlertWithMessage:@"动画时长必须大于0!"];
        return;

    }
    
    if (_imagesArray.count > 0)
    {

        if(_imagesArray.count == 1)
        {//一张的 也做两张
            NSMutableArray * array= [NSMutableArray arrayWithCapacity:0];
            [array addObject:[_imagesArray firstObject]];
            [array addObject:[_imagesArray firstObject]];

            _imagesArray = array;
        }

        NSString * fileName = [NSString stringWithFormat:@"%@.webp",[_nameField stringValue]];
        
        NSString *dataPath = [_finnalPath stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager =[[NSFileManager alloc] init];
        [fileManager createFileAtPath:dataPath contents:nil attributes:nil];
        
        NXWebpEncoder * encode = [[NXWebpEncoder alloc] init];
        encode.imageArray = _imagesArray;
       
        NSMutableArray * durationA = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < _imagesArray.count; i++)
        {
            float perDuration = [[_timeField stringValue]  floatValue] /_imagesArray.count;
            [durationA addObject:[NSNumber numberWithFloat:perDuration]];

        }
        encode.durationArray = durationA;
        
        encode.quality = [[_qualityField stringValue] floatValue];
        encode.loopCount = [[_loopCountField stringValue] intValue];
        NSData * data = [encode encodeWebP];
        
        BOOL isTrue = [data writeToFile:dataPath atomically:YES];
        
        if (!isTrue)
        {
            [self showAlertWithMessage:@"生成失败,请重试!"];

            [fileManager removeItemAtPath:dataPath error:nil];
        }
        else
        {
            [self showAlertWithMessage:@"生成成功"];

            NSLog(@"out put file path %@",_finnalPath);
            [[NSWorkspace sharedWorkspace] openFile:_finnalPath withApplication:@"Finder"];
            
            [_imagesArray removeAllObjects];
            _dirText.stringValue = @"";

        }
    }
    else
    {
        [self showAlertWithMessage:@"请选择图片文件目录!!!"];
    }
}

-(void)showAlertWithMessage:(NSString *)message
{
    NSAlert * alert = [[NSAlert alloc] init];
    [alert setMessageText:message];
    [alert addButtonWithTitle:@"知道啦"];
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].mainWindow completionHandler:nil];
    
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}




@end
