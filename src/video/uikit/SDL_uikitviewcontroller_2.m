//
//  SDL_uikitviewcontroller_2.m
//  Wrapture
//
//  Created by Administrator on 7/26/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import "SDL_uikitviewcontroller_2.h"

#ifndef __MACOSX__
#import "../../../Xcode-iOS/Wrapture/src/Util.h"
#endif

#define kAboutID @"FSIj9tI4w0G8o4RYeh67Mw"
#if TARGET_OS_TV
    #define kHeaderHeight 80
    #define kFooterHeight 48
    #define kRowHeight    144
    #define kScale        508
#else
    #define kHeaderHeight 32
    #define kFooterHeight 32
    #define kRowHeight    72
    #define kScale        180
#endif

@implementation SDL_uikitviewcontroller_2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self->myTable==nil) {
        CGRect rect = CGRectMake(0, 0, self.window->w, self.window->h);
        UITableView * tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        self->myTable = tableView;
        tableView.userInteractionEnabled = YES;
        tableView.rowHeight           = kRowHeight;
        tableView.sectionHeaderHeight = kHeaderHeight;
        tableView.sectionFooterHeight = kFooterHeight;
        
        UIView *view = [[UIView alloc] init];
        [view addSubview:self->myTable];
        self.view = view;
//      [self.view addSubview:self->myTable];   not necessary
        
        self->myTable.dataSource = self;
        self->myTable.delegate = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
#if !TARGET_OS_TV
        //Initialize the toolbar
        toolbar = [[UIToolbar alloc] init];
        toolbar.barStyle = UIBarStyleDefault;
        
        //Set the toolbar to fit the width of the app.
        [toolbar sizeToFit];
        
        //Caclulate the height of the toolbar
        CGFloat toolbarHeight = [toolbar frame].size.height;
        
        //Get the bounds of the parent view
        SDL_Window * w = self.window;
        CGRect rootViewBounds = CGRectMake(0, 0, w->w, w->h);
        
        //Get the width of the parent view,
        CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
        
        //Create a rectangle for the toolbar
        CGRect rectArea = CGRectMake(0+320, 0/* rootViewHeight - toolbarHeight */, rootViewWidth-320, toolbarHeight);
        
        //Reposition and resize the receiver
        [toolbar setFrame:rectArea];
        //Create a button
        UIBarButtonItem *BtnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"back " style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];

        [toolbar setItems:[NSArray arrayWithObjects:BtnSpace,infoButton,nil]];
        
        //Add the toolbar as a subview to the navigation controller.
        [toolbar setHidden:YES];
        [self.view addSubview:toolbar];
#endif
        
//        myArray = [[NSMutableArray alloc] init];
//        myArray2 = [[NSMutableArray alloc] init];
        
//        itemsInTable = 0;
//        rowselectedplaceholder = -1;
        page = 0;
        paused = NO;
        
        NSTimer * t = [NSTimer scheduledTimerWithTimeInterval: 0.25
                                                       target: self
                                                     selector: @selector(checkForUpdates:)
                                                     userInfo: nil repeats: YES];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:t forMode:NSDefaultRunLoopMode];
        
        [self handlePageChange];
    }
    
//    [myTable reloadData]; // done in the timer loop
}

-(void)back
{
    if(page>0) {
        --page;
        [self handlePageChange];
    }
}

// hack to receive callbacks upon async URL retrieval of playlists
-(void)checkForUpdates:(NSTimer *)timer
{
    if (paused) return;
    
    if ([myArray count]!=itemsInTable) {
        itemsInTable = [myArray count];
        [self->myTable reloadData];
    }
}

-(NSString*)formatDate:(NSString*)time
{
    NSRange foundTatLocation = [time rangeOfString:@"T"];
    NSString * mySmallerString = [NSString stringWithFormat:@"     %@", [time substringToIndex:foundTatLocation.location]];
    
    return mySmallerString;
}

-(NSString*)formatTime:(NSString*)time
{
    NSInteger length = [time integerValue];
    int x = (int)(length/60);
    if(length<60)
        return [NSString stringWithFormat:@"     00:00:%d", (int)length];
    
    if(length<3600)
        return [NSString stringWithFormat:@"     00:%d:%d", x, (int)(length - x*60)];
    
   return time;
}

-(void)handlePageChange
{
    myArray = nil;
    myArray = [[NSMutableArray alloc] init];
    myArray2 = nil;
    myArray2 = [[NSMutableArray alloc] init];
    
    itemsInTable = -1;

    switch (page)
    {
        case 0:
        {
#if !TARGET_OS_TV
            [toolbar setHidden:YES];
#endif
            // Clear the cache in preparation for an HTTPS request
            NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            
            // Create the playlist request
            NSString * url_playlists = @"https://www.firestationstudios.com/playlists/txst-m3u8-playlists.xml";
            NSURLSession * session_playslists = [NSURLSession sessionWithConfiguration:configuration];
            NSURLSessionDataTask * dataTask_playlist = [session_playslists dataTaskWithURL:[NSURL URLWithString:url_playlists] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                // response - XML list of playlists - not on main thread
                NSXMLParser * nsXmlParser = [[NSXMLParser alloc] initWithData:data];
                self->playlistParser = nil;
                self->playlistParser = [[PlaylistParser alloc] initPlaylistParser];
                [nsXmlParser setDelegate:(id <NSXMLParserDelegate>)self->playlistParser];
                BOOL success = [nsXmlParser parse];
                if (success) {
                    NSMutableArray * playlistsArray = [self->playlistParser playlists];
                    if (playlistsArray != nil) {
//                      NSLog(@"Found - playlists count : %lu", (unsigned long)[playlistsArray count]);
                        for (int i = 0; i < [playlistsArray count]; i++) {
                            Playlist * play = playlistsArray[i];
                            if ( play == nil ) break;
                            NSString * link = [play webSiteID];
                            NSString * name = [play webSiteName];
                            if ( link != nil ) {
                                NSString * path = [NSString stringWithFormat:@"https://www.firestationstudios.com/playlists/images/%@%@", link, @".png"];
                                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: path]];
                                if(imageData==nil) break;
                                UIImage * thumbnail = [UIImage imageWithData: imageData];
                                if(thumbnail==nil) break;
                                UIImage * icon = [Util imageWithImage:thumbnail scaledToSize:CGSizeMake(kRowHeight*16/9, kRowHeight)];
                                
                                [self->myArray addObject:name];
                                [self->myArray2 addObject:icon];
                                
                                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
                            }
                        }
                    }
                } else {
                    NSLog(@"Error parsing playlists!");
                }
                
                self->paused = NO;
            }];
            [dataTask_playlist resume];
            paused = YES;

            break;
        }
            
        case 1:
        {
#if !TARGET_OS_TV
            [toolbar setHidden:NO];
#endif
            // Clear the cache in preparation for an HTTPS request
            NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            
            // Create the category request given a valid playlist
            NSString * url = [NSString stringWithFormat:@"https://mediaflo.txstate.edu/app/simpleapi/category/list.xml/%@", selectedPlaylist];
            NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
            NSURLSessionDataTask * dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSXMLParser * nsXmlParser = [[NSXMLParser alloc] initWithData:data];
                self->categoryParser = nil;
                self->categoryParser = [[CategoryParser alloc] initCategoryParser];
                [nsXmlParser setDelegate:(id <NSXMLParserDelegate>)self->categoryParser];
                BOOL success = [nsXmlParser parse];
                if (success) {
                    NSMutableArray * categoryArray = [self->categoryParser categories];
                    if (categoryArray != nil) {
//                      NSLog(@"... Found - categories count : %lu", (unsigned long)[categoryArray count]);
                        for ( int i = 0; i < [categoryArray count]; i++ ) {
                            Category * cat = categoryArray[i];
                            if ( cat == nil ) break;
                            NSString * link = [cat categoryID];
                            if ( link != nil && [[cat categoryName] rangeOfString:@"Default"].location == NSNotFound ) {
                                
                                [self->myArray addObject:[cat categoryName]];
                                
                                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
                            }
                        }
                    }
                } else {
                    NSLog(@"Error parsing categories!");
                }
                
                self->paused = NO;
            }];
            [dataTask resume];
            paused = YES;
        
            break;
        }
            
        case 2:
        {
#if !TARGET_OS_TV
            [toolbar setHidden:NO];
#endif
            NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            
            // Create the video request given a valid category
            NSString * url = [NSString stringWithFormat:@"%@%@", @"https://mediaflo.txstate.edu/app/simpleapi/video/list.xml/?categoryID=", selectedCategory];
            NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];//[NSURLSession sharedSession];
            NSURLSessionDataTask * dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSXMLParser * nsXmlParser = [[NSXMLParser alloc] initWithData:data];
                self->videoParser = nil;
                self->videoParser = [[VideoParser alloc] initVideoParser];
                [nsXmlParser setDelegate:(id <NSXMLParserDelegate>)self->videoParser];
                BOOL success = [nsXmlParser parse];
                if (success) {
                    NSMutableArray * videoArray = [self->videoParser videos];
                    if ( videoArray != nil ) {
//                      NSLog(@"Found - videos count : %lu", (unsigned long)[videoArray count]);
                        for ( int i = 0; i < [videoArray count]; i++) {
                            Video * vid = videoArray[i];
                            if ( vid == nil ) break;
                            [self->myArray addObject:[vid videoTitle]];
                            
                            NSString * path = [vid previewUrl];
                            NSURL * url2 = [NSURL URLWithString: path];
                            NSData * imageData = [[NSData alloc] initWithContentsOfURL: url2];
                            if(imageData==nil) break;
                            UIImage * thumbnail = [UIImage imageWithData: imageData];
                            if(thumbnail==nil) break;
                            UIImage * icon = [Util imageWithImage:thumbnail scaledToSize:CGSizeMake(kRowHeight*16/9, kRowHeight)];
                            
                            [self->myArray2 addObject:icon];
                         }
                    }
                } else {
                    NSLog(@"Error parsing videos!");
                }
                
                self->paused = NO;
            }];
            [dataTask resume];
            paused = YES;
            
            break;
        }
            
        case 3:
        {
#if !TARGET_OS_TV
            [toolbar setHidden:NO];
#endif
            // PARSE the video's WATCH info to obtain the *.m3u8 link
            NSString * path = [NSString stringWithFormat:@"https://mediaflo.txstate.edu/Watch/%@", selectedVideo];
            if (path == nil ) return;
            
            NSURL * url = [NSURL URLWithString:path];
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            NSURLSession * session = [NSURLSession sharedSession];
            NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError * error)
                                           {
                                               if ( [data length] > 0 && error == nil )
                                               {
                                                   NSString * web = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                   NSRange start = [web rangeOfString:@"\"file\":"];
                                                   NSRange end = [web rangeOfString:@".m3u8"];
                                                   if ( start.length < 1 || end.length < 1 ) {
                                                       self->paused = NO;
                                                       return;
                                                   }
                                                   
                                                   NSRange loc = NSMakeRange (start.location + 8, end.location - start.location - 3);
                                                   self->hack = nil;
                                                   self->hack = [web substringWithRange:loc];
                                                   
                                                   NSMutableArray * videoArray = [self->videoParser videos];
                                                   Video * vid = videoArray[self->selectedVideoNum];
                                                   [self->myArray addObject:[self formatDate:[vid videoDate]]];
                                                   [self->myArray addObject:[self formatTime:[vid videoDuration]]];
                                                   if ([vid videoDescription]!=nil)
                                                       [self->myArray addObject:[vid videoDescription]];
                                                   
                                               } else {
                                                   NSLog(@"error: isnull");
                                               }
                                               
                                               self->paused = NO;
                                           }];
            [task resume];
            self->paused = YES;
            break;
        }
            
        default:
            break;
    }
    
//    [self->myTable reloadData]; // done in the timer loop
}

#pragma mark - Table View Data source
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell setUserInteractionEnabled:YES];
    cell.textLabel.textColor = [UIColor blackColor];
    if(page==1 && [selectedPlaylist containsString:kAboutID])
        [cell setUserInteractionEnabled:NO];
    
    NSString * stringForCell;
    if (indexPath.section == 0) {
        stringForCell = [myArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:stringForCell];
        cell.textLabel.font = [UIFont fontWithDescriptor:[cell.textLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:0] size:cell.textLabel.font.pointSize];
        if (page==0 || page==2) {
            UIImage * image = [myArray2 objectAtIndex:indexPath.row];
            if(image!=nil) {
                cell.imageView.image = image;
                [cell.imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
                [cell.imageView.layer setBorderWidth: 2.0];
            }
        } else if (page==1 && ![selectedPlaylist containsString:kAboutID]) {
            if (selectedPlaylistImage!=nil) {
                cell.imageView.image = selectedPlaylistImage;
                [cell.imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
                [cell.imageView.layer setBorderWidth: 2.0];
            }
        } else {
            cell.imageView.image = nil;
        }
        
        if (page==3) {
            [cell setUserInteractionEnabled:NO];
            cell.textLabel.font = [UIFont fontWithDescriptor:[cell.textLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:cell.textLabel.font.pointSize];
        }
    }
    
    if (indexPath.section == 1) {
        stringForCell = @"";
        [cell.textLabel setText:stringForCell];
#if TARGET_OS_TV
        [cell setUserInteractionEnabled:NO];    // see tvOS delegates below
#endif
        if (selectedVideoImage!=nil) {
            UIImage * img = [Util imageWithImage:selectedVideoImage scaledToSize:CGSizeMake(kScale*16/9, kScale)];
//          UIImage * img = [Util resizedImageToSize:selectedVideoImage size:CGSizeMake(kScale*16/9, kScale)];
            cell.imageView.image = img;
            [cell.imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [cell.imageView.layer setBorderWidth: 2.0];
        }
    }

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 1;
    if (page==0) {
        num = [myArray count];
    } else if (page==1) {
        num = [myArray count];
    } else if (page==2) {
        num = [myArray count];
    } else if (page==3) {
        if (section==0)
            num = [myArray count];
        else
            num = 1;
    }

    return num;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 1;
    if (page==3) {
        sections = 2;
    }
    
    return sections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(page!=3) {
            if(page==1 && [selectedPlaylist containsString:kAboutID])
                return kRowHeight/2;
            else
                return kRowHeight;
        } else
            return kRowHeight/2;
    }
    
    return kScale;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * headerTitle = nil;
    if (page==0) {
        headerTitle = @"Wrapture Video Playlists:";
    } else if (page==1) {
        if([selectedPlaylist containsString:kAboutID])
            headerTitle = @"About...";
        else
            headerTitle = @"Categories:";
    } else if (page==2) {
        headerTitle = @"Videos:";
    } else if (page==3) {
        if(section==0)
            headerTitle = selectedVideoName;
        else
            headerTitle = [NSString stringWithFormat:@"Watch: %@", selectedVideoName];
    }
    
    return headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footerTitle = nil;
    if (page==0) {
        footerTitle = @"Select a playlist to view more info...";
    } else if (page==1) {
        if([selectedPlaylist containsString:kAboutID])
            footerTitle = @"For more information, visit: http://www.auriculaonline.com/wrapture.html";
        else
            footerTitle = @"Select a category to view more info...";
    } else  if (page==2) {
        footerTitle = @"Select a video to view more info...";
    } else  if (page==3 && section==1) {
        footerTitle = @"Click to play...";
    }
    
    return footerTitle;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%ld Row:%ld selected and its data is %@", (long)indexPath.section, (long)indexPath.row, cell.textLabel.text);
    
    if (page==0) {
        NSMutableArray * playlistsArray = [self->playlistParser playlists];
        Playlist * play = playlistsArray[[indexPath row]];
        selectedPlaylist = [play webSiteID];
        selectedPlaylistImage = myArray2[[indexPath row]];
    } else if (page==1) {
        NSMutableArray * categoriesArray = [self->categoryParser categories];
        Category * category = categoriesArray[[indexPath row]];
        selectedCategory = [category categoryID];
    } else if (page==2) {
        NSMutableArray * videosArray = [self->videoParser videos];
        Video * video = videosArray[[indexPath row]];
        selectedVideo = [video videoKeywords];
        selectedVideoNum = [indexPath row];
        selectedVideoName = [video videoTitle];
        selectedVideoImage = myArray2[[indexPath row]];
    }

    page++; // 0=playlists, 1=categories, 2=videos, 3=video, 4=clicked on play
    
    // are we ready to play a video yet ?
    if (page>3) {
        SDL_Window * w = self.window;
        self->paused = YES;
#if !TARGET_OS_TV
        [toolbar removeFromSuperview];
        toolbar = nil;
//        if(w->next!=nil) w->next = nil;
#endif
        w->flags |= SDL_WINDOW_PLAY;
        char * new_url = malloc(sizeof(char) * 1024);
        BOOL b = [hack getCString:new_url maxLength:(sizeof(char) * 1024) encoding:NSUTF8StringEncoding];
        if(b) SDL_SetVideoUrl(new_url);
//      Uint32 tmp = w->flags;
    } else {
        [self handlePageChange];
    }
}

#pragma mark - tvOS delegates

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event
{
    for(UIPress *press in presses)
    {
        if(press.type == UIPressTypeMenu) {
            if(page>0) {
                --page;
                [self handlePageChange];
                return;
            } else {
                SDL_Window * w = self.window;
                w->flags |= SDL_WINDOW_QUIT;
            }
        } else  // handle click on play video screen
            if (page==3) {
                paused = YES;
                SDL_Window * w = self.window;
                w->flags |= SDL_WINDOW_PLAY;
                char * new_url = malloc(sizeof(char) * 1024);
                BOOL b = [hack getCString:new_url maxLength:(sizeof(char) * 1024) encoding:NSUTF8StringEncoding];
                if(b) SDL_SetVideoUrl(new_url);
                return;
        }
    }
    
    [super pressesBegan:presses withEvent:event];
}

- (void)pressesChanged:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event
{
    [super pressesChanged:presses withEvent:event];
}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event
{
    [super pressesEnded:presses withEvent:event];
}

- (void)pressesCancelled:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event
{
    [super pressesCancelled:presses withEvent:event];
}

@end
