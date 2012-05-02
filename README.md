# ObjectiveTumblr

Tumblr API Client for Objective-C with minimal features, based on Tumblr API v2 (OAuth).

We use this library for our software. If you need a specific feature, you probably want to add it yourself and send me a pull request.

## Usage

1. Initialize Tumblr API

````
tumblr = [[IGObjectiveTumblr alloc] initWithConsumerKey:yourConsumerKey secret:yourSecret];
tumblr.delegate = self;
````

2. Login with xAuth

````
[tumblr authenticateWithUsername:userName password:password];
````
    
3. (Upon login finished) Request user info:

````    
[tumblr userInfo];
````

4. Create a post:

````  
IGTextPost* post = [[IGTextPost alloc] init];
post.markdown = YES;
post.title = @"Hello";
post.body  = @"**World**";
[tumblr createPostWithHostName:hostname post:post];
````

## License

ObjectiveTumblr are available under the [MIT license](http://www.opensource.org/licenses/mit-license.php).

## Contact

Francis Chong ([@siuying](http://twitter.com/siuying))
