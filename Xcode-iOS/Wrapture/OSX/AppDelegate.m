//
//  AppDelegate.m
//  m3u8-Player
//
//  Created by Administrator on 7/8/19.
//  Copyright © 2019 Auricula. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//static AppDelegate * appDelegate = [[NSApplication sharedApplication] delegate];


- (void)parseCategory:(NSString*)path menu:(NSMenu*)menu
{
    // Clear the cache in preparation for an HTTPS request
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    // Create the video request given a valid category
    NSString * url = [NSString stringWithFormat:@"%@%@", @"https://mediaflo.txstate.edu/app/simpleapi/video/list.xml/?categoryID=", path];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];//[NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSXMLParser * nsXmlParser = [[NSXMLParser alloc] initWithData:data];
        VideoParser * videoParser = [[VideoParser alloc] initVideoParser];
        [nsXmlParser setDelegate:(id <NSXMLParserDelegate>)videoParser];
        BOOL success = [nsXmlParser parse];
        if (success) {
            NSMutableArray * videoArray = [videoParser videos];
            if ( videoArray != nil ) {
//              NSLog(@"Found - videos count : %lu", (unsigned long)[videoArray count]);
                for ( int i = 0; i < [videoArray count]; i++) {
                    Video * vid = videoArray[i];
                    if ( vid == nil ) break;
                    NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle: [vid videoTitle] action:@selector(menuHandler:)  keyEquivalent:@""];
                    [menuItem setTag:i+3000]; // 3000, 3001, 3002, etc...
                    [menuItem setAccessibilityTitle:[vid videoKeywords]];
                    [menuItem setEnabled:YES];
                    [menuItem setTarget:self];
                    [menu addItem: menuItem];
                }
            }
        } else {
            NSLog(@"Error parsing videos!");
        }
    }];
    [dataTask resume];
}

- (void)parsePlaylist:(NSString*)path menu:(NSMenu *)menu menuitem:(NSMenuItem*)menuitem
{
    // Clear the cache in preparation for an HTTPS request
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    // Create the category request given a valid playlist
    NSString * url = [NSString stringWithFormat:@"https://mediaflo.txstate.edu/app/simpleapi/category/list.xml/%@", path];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSXMLParser * nsXmlParser = [[NSXMLParser alloc] initWithData:data];
        /*self->*/CategoryParser * categoryParser = [[CategoryParser alloc] initCategoryParser];
        [nsXmlParser setDelegate:(id <NSXMLParserDelegate>)/*self->*/categoryParser];
        BOOL success = [nsXmlParser parse];
        if (success) {
            NSMutableArray * categoryArray = [/*self->*/categoryParser categories];
            if (categoryArray != nil) {
//              NSLog(@"... Found - categories count : %lu", (unsigned long)[categoryArray count]);
//              AppDelegate * appDelegate = [[NSApplication sharedApplication] delegate];
                for ( int i = 0; i < [categoryArray count]; i++ ) {
                    Category * cat = categoryArray[i];
                    if ( cat == nil ) break;
                    if ( i == 0 ) [menuitem setTitle:[cat websiteName]];
                    NSString * link = [cat categoryID];
                    if ( link != nil && [[cat categoryName] rangeOfString:@"Default"].location == NSNotFound ) {
                        NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle: [cat categoryName] action:nil  keyEquivalent:@""];
                        [menuItem setTag:i+2000]; // 2000, 2001, 2002, etc...
                        NSMenu * newMenu = [[NSMenu alloc] initWithTitle:@"boo"];
                        [menuItem setSubmenu:newMenu];
                        [menu addItem:menuItem];
                        [self parseCategory:link menu:newMenu];
                        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
                    }
                }
            }
        } else {
            NSLog(@"Error parsing categories!");
        }
        
    }];
    [dataTask resume];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Sanity check - make sure ffplay & ffprobe exist
    NSBundle * myBundle = [NSBundle mainBundle];
    pathToFFplay = [myBundle pathForResource:@"ffplay" ofType: @""];
    pathToFFprobe = [myBundle pathForResource:@"ffprobe" ofType: @""];
    
    if ( ! [self checkForFFMPEG] ) {
        NSAlert * alert = [[NSAlert alloc] init];
        [alert setMessageText:@"This app appears to be damaged."];
        [alert setInformativeText:@"Please download the newest version and reinstall."];
        [alert addButtonWithTitle:@"Ok"];
        [alert runModal];
        
        [[NSApplication sharedApplication] terminate:(self)];
    }
    
    // Clear the cache in preparation for an HTTPS request
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    // Create the playlist request
    NSString * url_playlists = @"https://www.firestationstudios.com/playlists/txst-m3u8-playlists.xml";
    NSURLSession * session_playslists = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask * dataTask_playlist = [session_playslists dataTaskWithURL:[NSURL URLWithString:url_playlists] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSXMLParser * nsXmlParser = [[NSXMLParser alloc] initWithData:data];
        /*self->*/PlaylistParser * playlistParser = [[PlaylistParser alloc] initPlaylistParser];
        [nsXmlParser setDelegate:(id <NSXMLParserDelegate>)/*self->*/playlistParser];
        BOOL success = [nsXmlParser parse];
        if (success) {
            NSMutableArray * playlistsArray = [/*self->*/playlistParser playlists];
//          AppDelegate * appDelegate = [[NSApplication sharedApplication] delegate];
            if (playlistsArray != nil) {
//              NSLog(@"Found - playlists count : %lu", (unsigned long)[playlistsArray count]);
                for (int i = 0; i < [playlistsArray count]; i++) {
                    Playlist * play = playlistsArray[i];
                    if ( play == nil ) break;
                    NSString * link = [play webSiteID];
                    if ( link != nil ) {
                        NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle: @"123" action:nil  keyEquivalent:@""];
                        [menuItem setTag:i+1000]; // 1000, 1001, 1002, etc...
                        NSMenu * newMenu = [[NSMenu alloc] initWithTitle:@"boo"];
                        [menuItem setSubmenu:newMenu];
                        [self->dMenu addItem:menuItem];
                        [self parsePlaylist:link menu:newMenu menuitem:menuItem];
                        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
                    }
                }
            }
        } else {
            NSLog(@"Error parsing playlists!");
        }

    }];
    [dataTask_playlist resume];
/*
    // Create the category request
    NSString * url = @"https://mediaflo.txstate.edu/app/simpleapi/category/list.xml/XHM-HeLHaEis9NFhDn07UA";
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];//[NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSXMLParser * nsXmlParser = [[NSXMLParser alloc] initWithData:data];
        self->categoryParser = [[CategoryParser alloc] initCategoryParser];
        [nsXmlParser setDelegate:(id <NSXMLParserDelegate>)self->categoryParser];
        BOOL success = [nsXmlParser parse];
        
        NSString * link = nil;
        if (success) {
            NSMutableArray * categoryArray = [self->categoryParser categories];
            // NSLog(@"No errors - categories count : %lu", (unsigned long)[categories count]);
            if (categoryArray != nil) {
                for (int i=0; i < [categoryArray count]; i++) {
                    Category * cat = categoryArray[i];
                    if ( [[cat categoryName] rangeOfString:@"Channel Layouts"].location != NSNotFound )
                    {
                        link = [cat categoryID];
                    }
                }
                //link = [NSString stringWithFormat:@"%@", @"-ZAcTDGYQ0yj_x51P-3mlA"];
                
                // Create the video request
                if (link != nil)
                {
                    NSString * url2 = [NSString stringWithFormat:@"%@%@", @"https://mediaflo.txstate.edu/app/simpleapi/video/list.xml/?categoryID=", link];
                    NSURLSession * session2 = [NSURLSession sessionWithConfiguration:configuration];//[NSURLSession sharedSession];
                    NSURLSessionDataTask * dataTask2 = [session2 dataTaskWithURL:[NSURL URLWithString:url2] completionHandler:^(NSData *data2, NSURLResponse *response2, NSError *error2) {
                        
                        NSXMLParser * nsXmlParser2 = [[NSXMLParser alloc] initWithData:data2];
                        self->videoParser = [[VideoParser alloc] initVideoParser];
                        [nsXmlParser2 setDelegate:(id <NSXMLParserDelegate>)self->videoParser];
                        BOOL success = [nsXmlParser2 parse];
                        
                        NSMenu * newMenu = nil;
                        NSMenu * newMenu2 = nil;
                        if (success) {
                            NSMutableArray * videoArray = [self->videoParser videos];
                            // NSLog(@"No errors - videos count : %lu", (unsigned long)[videos count]);
                            if (videoArray != nil) {
                                for (int i = 0; i < [videoArray count]; i++) {
                                    Video * vid = videoArray[i];
                                    NSString * temp = [NSString stringWithFormat:@"%@", [vid videoTitle]];
                                    NSString * stringWithoutSpaces = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    NSString * file = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                    temp = [NSString stringWithFormat:@"%@", [vid categoryName]];
                                    stringWithoutSpaces = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    NSString * category = [vid categoryName];//[stringWithoutSpaces stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                    
                                    if ( i == 0 ) {
//                                      [self->dMenu setTitle:category];
                                        newMenu = [[NSMenu alloc] initWithTitle:@"boo"];
                                        newMenu2 = [[NSMenu alloc] initWithTitle:@"boo2"];
                                        
                                        NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle: category action:@selector(menuHandler)  keyEquivalent:@""];
//                                        NSMenuItem * menuItem2 = [[NSMenuItem alloc] initWithTitle: @"hoo2" action:@selector(menuHandler)  keyEquivalent:@""];
//                                        NSMenuItem * menuItem3 = [[NSMenuItem alloc] initWithTitle: @"hoo3" action:@selector(menuHandler)  keyEquivalent:@""];
                                        
//                                        [newMenu addItem: menuItem2];
//                                        [newMenu insertItem:menuItem3 atIndex:0];
                                        
                                        [self->dMenu addItem:menuItem];
                                        //[self->dMenu addItem:menuItem2];
                                        
                                        [menuItem setSubmenu:newMenu];
//                                        [menuItem setSubmenu:newMenu2];
                                        
//                                        [self->dMenuItem setSubmenu:newMenu];
                                       // [self->dMenu setSubmenu:newMenu forItem:menuItem];
                                    }
                                    
                                    NSMenuItem * newMenuItem = [[NSMenuItem alloc] initWithTitle: file action:@selector(menuHandler)  keyEquivalent:@""];
                                    [newMenuItem setEnabled:YES];
                                    [newMenuItem setTag:i];
                                    [newMenu addItem: newMenuItem];
                                }
                            }
                        } else {
                            NSLog(@"Error parsing videos!");
                        }
                        
                    }];
                    [dataTask2 resume];
                }

            }
        } else {
            NSLog(@"Error parsing playlists!");
        }
        
    }];
    [dataTask resume];
    */
 /*   if (error == nil)
    {
        NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:data];
        
        // create and init our delegate
//        XMLParser *parser = [[XMLParser alloc] initWithData:data];
        
        // set delegate
//        [nsXmlParser setDelegate:parser]; // here is the second warning
        
        // parsing...
        BOOL success = [nsXmlParser parse];
        
        // test the result
        if (success) {
            NSLog(@"No errors");// - user count : %i", [parser [users count]]);
            // get array of users here
            //  NSMutableArray *users = [parser users];
        } else {
            NSLog(@"Error parsing document!");
        }
    }*/

/*
    https://mediaflo.txstate.edu/api/playlists
    https://mediaflo.txstate.edu/api/content
    https://mediaflo.txstate.edu/api/sharedcontent
    https://mediaflo.txstate.edu/api/medialibrary
    https://mediaflo.txstate.edu/api/sharedlibrary
    https://mediaflo.txstate.edu/api/MediaWorkflows?FilterOn=LibraryID&FilterValue=fbb683e2-3efd-4069-a936-9994f2ee643d
    https://mediaflo.txstate.edu/api/MediaWorkflows?FilterOn=PlaylistID&FilterValue=WNoopQvGK02EUMHT7-4diA
    https://mediaflo.txstate.edu/app//assets/iTunesFeed.xml?DestinationID=XHM-HeLHaEis9NFhDn07UA
    https://mediaflo.txstate.edu/api/MediaWorkflows?FilterOn=PlaylistID&FilterValue=XHM-HeLHaEis9NFhDn07UA
    https://mediaflo.txstate.edu/app/simpleapi/video/list.xml/XHM-HeLHaEis9NFhDn07UA // main playlist
    https://mediaflo.txstate.edu/app/simpleapi/category/list.xml/XHM-HeLHaEis9NFhDn07UA // list of categories in main playlist
    https://mediaflo.txstate.edu/app/simpleapi/video/list.xml/?categoryID=-ZAcTDGYQ0yj_x51P-3mlA    // list of videos within a category
    https://mediaflo.txstate.edu/app/simpleapi/video/show.xml/eY5KiQgpyUut3e5JLAOHGg // videos within a category

//  __block NSString * test = @"";
    NSString * string = @"https://mediaflo.txstate.edu/Watch/a3YMw62B";
    NSURL * url = [NSURL URLWithString:string];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError * error)
    {
      if ( [data length] > 0 && error == nil )
      {
          NSString * web = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSRange start = [web rangeOfString:@"\"file\":"];
          NSRange end = [web rangeOfString:@".m3u8"];
          NSRange loc = NSMakeRange (start.location + 8, end.location - start.location - 3);
          NSString * hack = [web substringWithRange:loc];
//        test = [[NSString alloc] initWithString:hack];
          [self play:hack];
      } else {
          NSLog(@"error: isnull");
          [[NSApplication sharedApplication] terminate:(self)];//todo not very elegant
      }
    }];
    [task resume];
    
    
    
    

 NSURLRequest * res = [NSURLRequest requestWithURL:url];
 NSOperationQueue * que = [NSOperationQueue new];

    [NSURLConnection sendAsynchronousRequest:res queue:que completionHandler:^(NSURLResponse*rep,NSData*data,NSError*err)
    {
        if ( [data length] > 0 && err == nil )
        {
            NSString * rel = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange start = [rel rangeOfString:@"\"file\":"];
            NSRange end = [rel rangeOfString:@".m3u8"];
            NSRange loc = NSMakeRange (start.location + 8, end.location - start.location - 3);
            NSString * hack = [rel substringWithRange:loc];
            test = [[NSString alloc] initWithString:hack];
            NSLog(@"%@", rel);
        } else {
            NSLog(@"isnull");
        }
    }];

    
  NSString * test  = @"https://mediastream.its.txstate.edu/streaming/_definst_/mp4:TexasStateUniversity/SRS/MarkErickson-me02/TL-rJeFQDT_TEqipxxdgGr0Jg-TL.mp4/playlist.m3u8";
    if ( ! [self probe: test] ) { [[NSApplication sharedApplication] terminate:(self)]; }
    
    NSTask * task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: pathToFFplay];
    
    NSArray * arguments;
    if ( ! needsChannelMap )
        arguments = [NSArray arrayWithObjects: @"-autoexit", @"-hide_banner", @"-loglevel", @"panic", @"-i", test, nil];
    else
        arguments = [NSArray arrayWithObjects: @"-autoexit", @"-hide_banner", @"-loglevel", @"panic", @"-af", @"channelmap=0|1|2|3|6|7|4|5:7.1", test, nil];
    [task setArguments: arguments];
    
    [task launch];
    [task waitUntilExit];
    
    [[NSApplication sharedApplication] terminate:(self)];
 */
}

- (void)menuHandler:(id)sender
{
//  https://mediaflo.txstate.edu/app/content/permalink.aspx?ID=894a8e79-2908-4bc9-addd-ee492c03871a&type=1 aspx? does not work without logging in
    
    NSMenuItem * menu = sender;
    if (menu == nil ) return;

    NSString * videoKeywords = [menu accessibilityTitle];
    if (videoKeywords == nil ) return;
    
    NSString * path = [NSString stringWithFormat:@"https://mediaflo.txstate.edu/Watch/%@", videoKeywords];
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
                                               NSAlert * alert = [[NSAlert alloc] init];
                                               [alert setMessageText:@"Invalid web link."];
                                               [alert setInformativeText:@"This link does not point to a valid m3u8 file."];
                                               [alert addButtonWithTitle:@"Ok"];
                                               [alert runModal];
                                               
                                               [[NSApplication sharedApplication] terminate:(self)];
                                           }
                                           
                                           NSRange loc = NSMakeRange (start.location + 8, end.location - start.location - 3);
                                           NSString * hack = [web substringWithRange:loc];
                                           [self play:hack autoexit:NO];
                                       } else {
                                           NSLog(@"error: isnull");
                                           [[NSApplication sharedApplication] terminate:(self)];//todo not very elegant
                                       }
                                   }];
    [task resume];
}

- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls
{
    NSURL * url1 = urls[0];
    NSString * string = url1.absoluteString;
    NSRange loc = NSMakeRange (9, string.length-9);//remove 'm3u8_wrap' and replace with 'https'
    NSString * hack1 = [NSString stringWithFormat:@"%@%@", @"https", [string substringWithRange:loc]];
    
    NSURL * url = [NSURL URLWithString:hack1];
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
                                               NSAlert * alert = [[NSAlert alloc] init];
                                               [alert setMessageText:@"Invalid web link."];
                                               [alert setInformativeText:@"This link does not point to a valid m3u8 file."];
                                               [alert addButtonWithTitle:@"Ok"];
                                               [alert runModal];
                                               
                                               [[NSApplication sharedApplication] terminate:(self)];
                                           }

                                           NSRange loc = NSMakeRange (start.location + 8, end.location - start.location - 3);
                                           NSString * hack = [web substringWithRange:loc];
                                           [self play:hack autoexit:YES];
                                       } else {
                                           NSLog(@"error: isnull");
                                           [[NSApplication sharedApplication] terminate:(self)];//todo not very elegant
                                       }
                                   }];
    [task resume];
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)fileNames
{
    // moved to Document.m
    // never called
    //NSRect rect;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
    // moved to Document.m
    // never called
    
/*    if ( ! [self checkForFFMPEG] ) { return false; }
    
    NSURL * url = [NSURL URLWithString:filename];
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
               NSAlert * alert = [[NSAlert alloc] init];
               [alert setMessageText:@"Invalid web link."];
               [alert setInformativeText:@"This link does not point to a valid m3u8 file."];
               [alert addButtonWithTitle:@"Ok"];
               [alert runModal];
               
               [[NSApplication sharedApplication] terminate:(self)];
           }

           NSRange loc = NSMakeRange (start.location + 8, end.location - start.location - 3);
           NSString * hack = [web substringWithRange:loc];
           [self play:hack autoexit:YES];
       } else {
           NSLog(@"error: isnull");
           [[NSApplication sharedApplication] terminate:(self)];//todo not very elegant
       }
    }];
    [task resume];
*/
    return true;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)play:(NSString*)path autoexit:(BOOL)autoexit
{
    if ( ! [self probe: path] ) { [[NSApplication sharedApplication] terminate:(self)]; }
    
    NSTask * task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: pathToFFplay];
    
    NSArray * arguments;
    if ( ! needsChannelMap )
        arguments = [NSArray arrayWithObjects: @"-autoexit", @"-hide_banner", @"-loglevel", @"panic", @"-i", path, nil];
    else
        arguments = [NSArray arrayWithObjects: @"-autoexit", @"-hide_banner", @"-loglevel", @"panic", @"-af", @"channelmap=0|1|2|3|6|7|4|5:7.1", path, nil];
    [task setArguments: arguments];
    
    [task launch];
    [task waitUntilExit];
    
    if ( autoexit ) [[NSApplication sharedApplication] terminate:(self)];
}

- (BOOL)probe:(NSString*)path
{
    channels = 2;
    needsChannelMap = false;
    
    NSTask * task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: pathToFFprobe];

    NSArray * arguments;
    arguments = [NSArray arrayWithObjects: path, nil];
    [task setArguments: arguments];
    
    NSPipe * pipe;
    pipe = [NSPipe pipe];
    [task setStandardError: pipe];  //  [task setStandardOutput: pipe];
    
    NSFileHandle * file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    [task waitUntilExit];
    
    NSData * data = [file readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray<NSString*> * array = [string componentsSeparatedByString:@"\n"];
    
    long i = array.count - 1;
    while ( i > 0 )
    {
//      NSString * str = [NSString stringWithString:array[i]];
        if ( [array[i] rangeOfString:@"7.1"].location != NSNotFound ) { channels = 8; }
        if ( [array[i] rangeOfString:@"5.1"].location != NSNotFound ) { channels = 6; }
        if ( [array[i] rangeOfString:@"dts"].location != NSNotFound ) {
            if ( channels == 8 ) { needsChannelMap = true; }
            return true;
        }
        
        if ( [array[i] rangeOfString:@"ac3"].location  != NSNotFound ) { return true; }
        if ( [array[i] rangeOfString:@"mp4"].location  != NSNotFound ) { return true; }
        if ( [array[i] rangeOfString:@"flac"].location != NSNotFound ) { return true; }
        if ( [array[i] rangeOfString:@"aac"].location  != NSNotFound ) { return true; }
        if ( [array[i] rangeOfString:@"wav"].location  != NSNotFound ) { return true; }
        
        i = i - 1;
    }

    return false;
}

- (BOOL)checkForFFMPEG
{
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    if ( ! [fileManager fileExistsAtPath:  pathToFFplay] ) { return false; }
    if ( ! [fileManager fileExistsAtPath: pathToFFprobe] ) { return false; }

    return true;
}

/*
- (IBAction)handleTestFilesMenu:(id)sender
{
    NSString * filename;
    switch ( [sender tag] ) {
        
        case 1:     // 8ch DTS-HD
            filename = @"https://mediaflo.txstate.edu/Watch/a3YMw62B";
            break;
            
        case 2:   // 8ch AAC is not working
            break;
            
        case 4:     // 6ch DTS-HD
            filename = @"https://mediaflo.txstate.edu/Watch/Jo9x5XCm";
            break;
            
        case 5:     // 6ch DTS
            filename = @"https://mediaflo.txstate.edu/Watch/Lm7r9H3Q";
            break;
            
        case 6:     // 6ch E-AC3
            filename = @"https://mediaflo.txstate.edu/Watch/Gt7y4F2T";
            break;
            
        case 7:     // 6ch AC3
            filename = @"https://mediaflo.txstate.edu/Watch/a6XWx9r4";
            break;

        case 8:     // 6ch AAC
            filename = @"https://mediaflo.txstate.edu/Watch/k8SHm7r5";
            break;
            
        default:
            break;
    }
    
    NSURL * url = [NSURL URLWithString:filename];
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
                                               NSAlert * alert = [[NSAlert alloc] init];
                                               [alert setMessageText:@"Invalid web link."];
                                               [alert setInformativeText:@"This link does not point to a valid m3u8 file."];
                                               [alert addButtonWithTitle:@"Ok"];
                                               [alert runModal];
                                               
                                               [[NSApplication sharedApplication] terminate:(self)];
                                           }
                                           
                                           NSRange loc = NSMakeRange (start.location + 8, end.location - start.location - 3);
                                           NSString * hack = [web substringWithRange:loc];
                                           [self play:hack autoexit:NO];
                                       } else {
                                           NSLog(@"error: isnull");
                                           [[NSApplication sharedApplication] terminate:(self)];//todo not very elegant
                                       }
                                   }];
    [task resume];
}
*/
 
@end
