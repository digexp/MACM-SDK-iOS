# MACM iOS SDK

CAASObjC is an API written in Objective-C to access a MACM (Mobile Application Content Manager) server and fetch content from it.

## Requirements

- iOS 8.0+
- XCode 7.x

##<a name="cocoaInstall"></a> Install CocoaPods

You need [CocoaPods](http://cocoapods.org) to install CAASObjC. To install CocoaPods, run the following command:
```
sudo gem install cocoapods 
```

## Running the sample

The repository comes with a sample, the CAASExample project. To run this sample, you need:

- clone the repository:
```
git clone https://github.com/digexp/MACM-SDK-iOS.git 
```
- Install the pods
```
pod install
```
- Specify the tenant in AppDelegate.swift line 41 (the sample won't compile without specifying the tenant):
```Swift
let tenant:String = "PUT YOUR TENANT ID HERE !!!!!"
```

## Using it for your own application

You need [CocoaPods](http://cocoapods.org) to install CAASObjC. See [Install CocoaPods](#cocoaInstall) section for details.

You then need to create a `Podfile` in the directory of your project file. Run the command:
```
pod init
```

To install CAASObjC add the following line to your Podfile:

```ruby
pod 'CAASObjC', :git => 'https://github.com/digexp/MACM-SDK-iOS.git'
```

If you want to use CAASObjC in a Swift application you must add the following line in your Podfile:

```ruby
use_frameworks!
```

A typical pod file looks like this:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

platform :ios, '8.0'

target 'TestCAAS' do
pod 'CAASObjC', :git => 'https://github.com/digexp/MACM-SDK-iOS.git'
end
```

## Usage

### Authentication

There are 2 ways to authenticate addressing two different use cases:

#### Authentication with the credentials of the application

- The username and password are hard-coded in the application: The following initializer should be used:

```objective-c
CAASService *caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:@"https://macm-rendering.saas.ibmcloud.com"] contextRoot:@"wps" tenant:@"myTenant" username:@"admin" password:@"foobar"];
```

#### Authentication with the credentials of the end user

- The users must sign in against a MACM server with their own credentials: The following initializer must be used:
```objective-c
CAASService *caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString::@"https://macm-rendering.saas.ibmcloud.com"] contextRoot:@"wps" tenant:@"myTenant"];
```
When the user provides its credentials, the following API checks these credentials against the MACM server:
```objective-c
[caasService signIn:username password:password completionHandler: ^(NSError *error, NSInteger httpStatusCode) {
    
    if (httpStatusCode == 204) {
        // Succesful
    } else {
        // Wrong credentials
    }
}];
```

### Retrieving contents

#### Querying a list of content items by path

```objective-c
CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithContentPath:@"Samples/Content Types/Book" completionBlock:^(CAASContentItemsResult *requestResult) {

    if (requestResult.httpStatusCode == 200) {
    }


}];

request.properties = @[CAASProperty.OID,CAASProperty.TITLE,CAASProperty.KEYWORDS];
request.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
[self.caasService executeRequest:request];
```

#### Querying a list of content items by id

```objective-c
CAASContentItemsRequest *request = [[CAASContentItemsRequest alloc] initWithOid:@"1892897e-6219-42a6-a8a8-28407c196b80" completionBlock:^(CAASContentItemsResult *requestResult) {

    if (requestResult.httpStatusCode == 200) {
    }

}];

[self.caasService executeRequest:request];

request.properties = @[CAASProperty.OID,CAASProperty.TITLE,CAASProperty.KEYWORDS];
request.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
[self.caasService executeRequest:request];
```

#### Querying a single content item by path

```objective-c
CAASContentItemRequest *request = [[CAASContentItemRequest alloc] initWithContentPath:@"Samples/some/content item path"completionBlock:^(CAASContentItemResult *requestResult) {


    if (requestResult.httpStatusCode == 200) {
    }


}];

request.properties = @[CAASProperty.OID,CAASProperty.TITLE,CAASProperty.KEYWORDS];
request.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
[caasService executeRequest:request];
```
It is necessary to specify the elements you want, by default you will not receive any element.

#### Querying a single content item by id


```objective-c
CAASContentItemRequest *request = [[CAASContentItemRequest alloc] initWithOid:@"903c2016-9d23-4893-a34a-14edfed19ead"completionBlock:^(CAASContentItemResult *requestResult) {

    if (requestResult.httpStatusCode == 200) {
    }


}];

request.properties = @[CAASProperty.OID,CAASProperty.TITLE,CAASProperty.KEYWORDS];
request.elements = @[@"author",@"cover",@"isbn",@"price",@"publish_date"];
[caasService executeRequest:request];
```

### Querying an asset (image) by its url

```objective-c
NSURL *url = [[NSURL alloc] initWithString:anURL relativeToURL:[NSURL URLWithString:CAASURL]];


CAASAssetRequest *request = [[CAASAssetRequest alloc] initWithAssetURL:url completionBlock:^(CAASAssetResult *requestResult) {

    if (requestResult.image != nil){
        UIImage *image = requestResult.image;
    } else {
        NSLog("Error %@",requestResult.error);
        NSLog("HTTP Status %@",@(requestResult.httpStatusCode));
    }


}];

[self.caasService executeRequest:request];
```

### Querying any kind of asset by its url

```objective-c
NSURL *url = [[NSURL alloc] initWithString:anURL relativeToURL:[NSURL URLWithString:CAASURL]];


CAASAssetRequest *request = [[CAASAssetRequest alloc] initWithAssetURL:url completionBlock:^(CAASAssetResult *requestResult) {

    if (requestResult.data != nil){
        NSData *data = requestResult.data;
    } else {
        NSLog("Error %@",requestResult.error);
    NSLog("HTTP Status %@",@(requestResult.httpStatusCode));
    }

}];

[self.caasService executeRequest:request];
```

## Miscellaneous
### Allowing untrusted certificates with HTTPS connections

By default, the SDK only allows trusted certificates whose certificate authority is known by iOS.
It is possible to disable this behavior,but only in DEBUG build, by setting the `allowUntrustedCertificates`
property to `true`. It allows to test with self-signed certificates.

```objective-c
// create the service that connects to the MACM instance
CAASService *caasService = [[CAASService alloc] initWithBaseURL:[NSURL URLWithString:@"https://macm-rendering.saas.ibmcloud.com"] contextRoot:@"wps" tenant:@"myTenant" username:@"admin" password:@"foobar"];

caasService.allowUntrustedCertificates = YES;


```

## Documentation references

* [IBM Mobile Application Content Manager Knowledge Center](http://www-01.ibm.com/support/knowledgecenter/SSYK7J_8.5.0/macm/macm_rm.dita)


