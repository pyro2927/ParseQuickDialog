ParseQuickDialog
================

### Introduction
Simple app/library to view [Parse](https://parse.com/) classes/objects ([PFObjects](https://parse.com/docs/ios/api/Classes/PFObject.html) in iOS), leveraging the [QuickDialog](https://github.com/escoz/QuickDialog) framework.

#### Author

[Joe Pintozzi (pyro2927)](https://github.com/pyro2927)

#### Why?

Backends aren't always the easiest, hence why Parse was originally made.  Fetching/using data from PFObjects is easy, but administering that data isn't.  The goal of this framework is to make admin'ing Parse data as easy as Parse makes running a backend.

### Usage

ParseQuickDialog can be run as a standalone app to administer your data (after adding in your keys), or you can drop it into your app's admin section with a few lines of code.

#### Standalone App

Clone this repo and open up `ParseQuickDialog.xcworkspace`.  Open up `AppDelegate.h` and add in your `APP_ID` and `CLIENT_KEY`.  Take note to also remove the `<>`s.  Register your classes with

    [ParseQuickDialog addClasses:@[@"Class1", @"Class2", @"Class3"]];
    
Build/Run the app and you will see a list of your classes.  Tap into these to view existing objects.

#### Installation into Existing App

Install with [CocoaPods](http://cocoapods.org).  In your Podfile:

    pod 'QuickDialog', :podspec => "https://raw.github.com/pyro2927/QuickDialog/parse/QuickDialog.podspec"
    pod 'ParseQuickDialog', :git => "https://github.com/pyro2927/ParseQuickDialog.git"
    
You **HAVE** to use the `QuickDialog` with the specific podspec because I've had to slightly modify the way values are saved out of elements in order to work with Parse's SDK.  There also seems to be a [bug in `CocoaPods`](https://github.com/CocoaPods/Core/issues/24) where frameworks aren't linked to dependancies, so you may need to manually go in and link `Parse.framework` (found in Pods/Parse/) to Pod-ParseQuickDialog's build phase.

![](http://i.imgur.com/WtZF62q.png)

Setup the admin view controller with:

    [ParseQuickDialog setApplicationId:@"<APP_ID>" clientKey:@"<CLIENT_KEY>"];
    [ParseQuickDialog addClasses:@[@"Class1", @"Class2", @"Class3"]];
    ParseClassesViewController *mainAdminViewController = [ParseQuickDialog classesViewController];
    
Push `mainAdminViewController` onto a navigation stack, or present any way you like!

#### ViewControllers

##### ParseClassesViewController

This is the starting point for the admin page.  Shouldn't need to be modified or subclassed.

##### PFObjectListViewController

A listing of objects for a particular class.  If provided with a titleKey, this listing will the objects' values for that key, next to their objectId.  This is what is opened when you make a selection in the `ParseClassesViewController`.  You can also create one manually with

    [PFObjectListViewController objectListViewControllerForClassName:className titleKey:titleKey]
    
##### ParseObjectViewController

The meat of this project.  This class is in charge of presenting/updating/saving data for `PFObjects`.  By default, `ParseObjectViewController` will show the `objectId`, `createdAt`, `updatedAt` values, as well as values for any keys that do not have `undefined` values.  `PFObjects` are saved on `viewDidDisappear:`.

### Extending

You can extend `ParseObjectViewController` to change how a `PFObject` is displayed/edited.  For two minor examples, look at `BooleanElementsViewController.m` and `CapitalKeyParseObjectViewController.m`.

#### Elements

`PFObject` values are edited through `QElements`, elements which then generate the `UITableViewCells` in the dialog.  For a nice overview of the different available elements, check out the sample app in the [QuickDialog repo](https://github.com/escoz/QuickDialog).  Override

    + (QElement*)elementForObject:(PFObject*)parseObject key:(NSString*)attribute
    
to use different elements where you see fit.  `BooleanElementsViewController.m`, for example, uses `UISwitches` to set the `NSNumber` for a `PFObject`.

#### Über Admin

If you don't want to see the `objectId`, `createdAt`, or `updatedAt` values, subclass `ParseObjectViewController` and return `NO` to `+ (BOOL)showsImmutableValues`.
    
#### Keys

If you want to only see a subset of key/values for an object, override

    + (NSArray*)orderedKeysForObject:(PFObject*)parseObject

returning an ordered `NSArray` of the keys you would like to see.  By default `ParseObjectViewController` returns `[parseObject allKeys]`.

### Data Types

**TODO:** Fill out README with datatypes and how they are presented.

### Notes

#### Limitations

There are several limitations in the Parse API that translate into limitations with this framework.  They are outlined below.

###### Classes

Currently all Parse classes seem to be working except for the `User` class.

###### Keys

In the iOS SDK, `[pfObject allKeys]` only returns keys which do not have `undefined` values assigned to them.  If you are looking to change/set `undefined` values, you'll have to subclass `ParseObjectViewController` and override

    + (NSArray*)orderedKeysForObject:(PFObject*)parseObject
    
returning the ordered list of keys you would like access too.

##### Values

`PFObject` values boil down to several basic classes in iOS.  For example, an integer and boolean on an object will both appear as `NSNumbers` in the iOS SDK, so it is impossible to differentiate between the two without having some sort of context.  Hopefully this can be improved upon going forward, but at times the values will have to be set with basic inputs to account for the potential varying types of data.


### Screenshots

![](http://i.imgur.com/TXAP9k3.png)

![](http://i.imgur.com/PJaEpPf.png)

![](http://i.imgur.com/WHCZE6c.png)
