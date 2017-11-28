/*
 * Copyright 2017 WalmartLabs
 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 
 * http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ViewController.h"
#import "RunnerConfig.h"
#import <ElectrodeContainer/ElectrodeContainer.h>
#import "AppDelegate.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    MoviesAPI* moviesApi = [[MoviesAPI alloc] init];
    [moviesApi.requests registerGetTopRatedMoviesRequestHandlerWithHandler:^(id  _Nullable data, ElectrodeBridgeResponseCompletionHandler  _Nonnull block) {
        NSMutableArray<Movie *> *movies = [[NSMutableArray alloc] init];
        
        [movies addObject:[self createMovie:@"1" title:@"The Shawshank Redemption" releaseYear:@1994 rating:@9.2 imageUrl:@"http://bit.ly/2xZm1Zr"]];
        [movies addObject:[self createMovie:@"2" title:@"The Godfather" releaseYear:@1972 rating:@9.2 imageUrl:@"http://bit.ly/2wK5TuA"]];
        [movies addObject:[self createMovie:@"3" title:@"The Godfather: Part II" releaseYear:@1974 rating:@9 imageUrl:@"http://bit.ly/2yysiIA"]];
        [movies addObject:[self createMovie:@"4" title:@"The Dark Knight" releaseYear:@2008 rating:@9 imageUrl:@"http://bit.ly/2iZPBqw"]];
        [movies addObject:[self createMovie:@"5" title:@"12 Angry Men" releaseYear:@1957 rating:@8.9 imageUrl:@"http://bit.ly/2xwkt7r"]];
        
        block(movies, nil);
    }];
    
    NavigationAPI *navigationAPI = [[NavigationAPI alloc] init];
    [navigationAPI.requests registerNavigateRequestHandlerWithHandler:^(id  _Nullable data, ElectrodeBridgeResponseCompletionHandler  _Nonnull block) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        NavigateData *navData = (NavigateData *)data;
        NSMutableDictionary *initialPapyload = [[NSMutableDictionary alloc]init];
        [initialPapyload setObject:navData.initialPayload forKey:@"payload"];

        UIViewController *viewController = [[ElectrodeReactNative sharedInstance] miniAppWithName:navData.miniAppName properties:initialPapyload];
        viewController.view.frame = [UIScreen mainScreen].bounds;
        [viewController setTitle:@"MovieDetails MiniApp"];


        UINavigationController *navController = (UINavigationController *) appDelegate.window.rootViewController;
        [navController pushViewController:viewController animated:NO];

        block(nil, nil);
    }];

    UIViewController *viewController =
    [[ElectrodeReactNative sharedInstance] miniAppWithName:MainMiniAppName properties:nil];
    [viewController setTitle:@"MovieList MiniApp"];
    viewController.view.frame = [UIScreen mainScreen].bounds;
    self.navigationBar.translucent = NO;
    [self pushViewController:viewController animated:NO];
}

- (Movie *) createMovie : (NSString*) movieId title: (NSString*) title releaseYear: (NSNumber*) releaseYear rating: (NSNumber*) rating imageUrl: (NSString*) imageUrl {
    
    NSMutableDictionary* movieDict = [[NSMutableDictionary alloc]init];
    [movieDict setObject:movieId forKey:@"id"];
    [movieDict setObject:title forKey:@"title"];
    [movieDict setObject:releaseYear forKey:@"releaseYear"];
    [movieDict setObject:imageUrl forKey:@"imageUrl"];
    
    Movie *movie =[[Movie alloc] initWithDictionary:movieDict];
    return movie;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
