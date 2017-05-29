# CKBadgeView
A simple category for you to add a badge to any UIView.

![screenshot](Screenshots/example.png)

Just one line of code, then you can add a badge to any UIView.

```objc
[view addBadge];
```

and remote the badge with another line:

```objc
[view removeBadge];
```

## Installation

### Cocoapods

Add the following line to your `Podfile`

```ruby
pod 'CKBadgeView'
```

and run:

```sh
pod install
```

### Manually

Drag `UIView+Badge.h` and `UIView+Badge.m` to your xcode project

### Usage

Adding a badge to the UIView is super simple.

#### 1. include the header file

```objc
#import <CKBadgeView/UIView+Badge.h>
```

#### 2. call `addBadge` method to add a red badge

```objc
// Add a red badge with default values
[view addBadge];
```

The `Badge` category contains a set of `addBadge` methods for you to add badge with different requirement.

Add a __red__ badge without offset

```objc
- (void)addBadge;
```

Add a __red__ badge with given offset.

```objc
- (void)addBadgeWithOffset:(CGPoint)offset;
```

Add a badge to the UIView with given badge color.

```objc
- (void)addBadgeWithColor:(UIColor *)color;
```

Add a badge to the UIView with given content and color. (Default Setting: badge radius = 5, offset = CGPointZero)

```objc
- (void)addBadgeWithContent:(NSString *)content
                 badgeColor:(UIColor *)color;
```


Add a badge to the UIView with given content, color and offset. 
(Default Setting: badge radius = 10, content font = HelveticaNeue, font size = 12.0)
```objc
- (void)addBadgeWithContent:(NSString *)content
                 badgeColor:(UIColor *)color
                     offset:(CGPoint)offset;
```

Add a badge to the UIView with customized settings.
(Default Setting: content font = HelveticaNeue, content font size = 12.0, content color = [UIColor whiteColor])
```objc
- (void)addBadgeWithContent:(NSString * _Nullable)content
                 badgeColor:(UIColor * _Nullable)color
                     offset:(CGPoint)offset
                badgeRadius:(CGFloat)badgeRadius;
```


Add a badge to the UIView with customized settings.

```objc
- (void)addBadgeWithContent:(NSString * _Nullable)content
                contentFont:(UIFont * _Nullable)contentFont
               contentColor:(UIColor * _Nullable)contentColor
                 badgeColor:(UIColor * _Nullable)color
                     offset:(CGPoint)offset
                badgeRadius:(CGFloat)badgeRadius;
```

Remove the badge from the UIView
```objc
- (void)removeBadge;
```
