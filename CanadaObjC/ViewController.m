//
//  ViewController.m
//  CanadaObjC
//
//  Created by user on 11/1/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "ViewController.h"
#import "AppImage.h"
#import "TableViewCell.h"
#import "Downloader.h"


@interface ViewController ()
@property(nonatomic, strong)NSString *appTitle;
@property(nonatomic, strong)NSMutableArray *arrayList;
@property(nonatomic, strong)NSOperationQueue *queue;
//@property(nonatomic, sttrong)

- (BOOL)XMLParser:(NSData *)xmlData;

/*
var arrayList:NSMutableArray!
var dataProvider: TableDataListProvider?
private let cellIdentifer = "Cell"
var appTitle:String?
var downloader:Downloader?
var queue:OperationQueue!*/

@end

@implementation ViewController

@synthesize arrayList;
@synthesize appTitle;
@synthesize queue;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayList = [[NSMutableArray alloc]init];
    self.title = @"Loading...";
    
    // self.registerCellsForTableView(tableView: self.tableView)
    self.tableView.rowHeight = 80.0;
  self.arrayList = [self PrepData];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.arrayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =  @"Cell";

    TableViewCell *cellImage = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSInteger rowCount = 0;
    
    rowCount = [self.arrayList count];
    
    if (rowCount == 0 &&  indexPath.row == 0) {
        
        //set initial cell place holder while data is being retrieve
        AppImage *placeHolder = [[AppImage alloc]init];
        [cellImage setCell:placeHolder];
        
    }
    else
    {
        // Only load cached images; defer new downloads until scrolling ends
        if (rowCount > 0){
            
            
            AppImage *appIcon = [self.arrayList objectAtIndex:indexPath.row];
            [cellImage setCell:appIcon];
           
            if (appIcon.imageIcon == nil){
                
                if (tableView.isDragging == NO && tableView.isDecelerating == NO){
                    
                    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                    
                    dispatch_async(dispatchQueue, ^(void){
                       
                        [self startIconDownload:appIcon forIndexPath:indexPath];
                         // self.StartDownLoader(imageRecord: appIcon!, path: indexPath)
                    });
                }
                [cellImage setCell:appIcon];
            }
            else
            {
                [cellImage setCell:appIcon];
            }
            
          
        }
        
        
    }
    
    
    
    
    return cellImage;
}



#pragma mark predata

-(NSMutableArray *)PrepData{
    
    NSMutableArray *tempArray;
    NSError *error;
    
    NSString *urlStr = @"https://dl.dropboxusercontent.com/u/746330/facts.json";
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString: urlStr] encoding:NSISOLatin1StringEncoding error:&error];
    
    NSData *resData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary  *parseObjects = [NSJSONSerialization JSONObjectWithData:resData options:kNilOptions error:&error];
    if (error)
        NSLog(@"JSONObjectWithData error: %@", error);
    
    
    tempArray = [[NSMutableArray alloc]init];
    self.appTitle  = [parseObjects valueForKey:@"title"];
    self.title = self.appTitle;
    NSArray *results = [parseObjects valueForKey:@"rows"];
    
    for (NSMutableDictionary *dictionary in results)
    {
        AppImage *imageTemp = [[AppImage alloc]init];
        NSString *tempTitle =  [dictionary valueForKey:@"title"];
        NSString *urlStr =  [dictionary valueForKey:@"imageHref"];
        NSString *descr =  [dictionary valueForKey:@"description"];
        
        if ([NSNull null] != tempTitle ){
            imageTemp.title = tempTitle;
        }
        
        if ([NSNull null] != urlStr )
        {
            imageTemp.imageURL = urlStr;
        }
        
        if ([NSNull null] != descr){
             imageTemp.descript = descr;
        }

       
        
        [tempArray addObject:imageTemp];
        
    }
    
    return tempArray;
}




- (void)startIconDownload:(AppImage *)record forIndexPath:(NSIndexPath *)indexPath
{
   
    if (record.imageIcon == nil)
    {
        Downloader *myDownloader = [[Downloader alloc] init];
        myDownloader.record = record;
        [myDownloader startDownLoadMy:record completion:^(AppImage * myRecord){
            
            if (myRecord.imageIcon != nil && myRecord.imageURL != nil){
                
                //[self.arrayList replaceObjectAtIndex:indexPath.row withObject:record];
                 TableViewCell *cellImage = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                
                [cellImage setCell:myRecord];
            }
            
        
        }];
    }
}




- (void)loadImagesForOnscreenRows
{
    if (self.arrayList.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppImage *item = (self.arrayList)[indexPath.row];
            
           
               [self startIconDownload:item forIndexPath:indexPath];
            
        }
    }
}



#pragma mark - Scroll

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 
    [self loadImagesForOnscreenRows];
  }

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    if (!decelerate)
    {
       [self loadImagesForOnscreenRows];
       
    }
    
}

@end
