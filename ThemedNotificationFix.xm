@interface UIImage ()
	- (id)sbf_resizeImageToSize:(CGSize)arg1;
@end

@interface SBApplication
	- (id)icon:(id)arg1 imageWithFormat:(int)arg2;
@end

@interface SBApplicationController
	+ (id)sharedInstance;
	- (SBApplication *)applicationWithBundleIdentifier:(id)arg1;
@end

@interface NCNotificationRequest
	@property (nonatomic,copy,readonly) NSString * sectionIdentifier;
@end

@interface NCNotificationContent
	@property (assign, nonatomic) NSString * bundleIdentifier;
@end

%hook NCNotificationRequest

	- (NCNotificationContent *)content {
		NCNotificationContent *content = %orig;
		content.bundleIdentifier = self.sectionIdentifier;
		return content;
	}

%end

%hook NCNotificationContent

%property (assign, nonatomic) NSString * bundleIdentifier;

	- (NSArray *)icons {
		NSArray *icons = %orig;
		if([icons count] == 0) return icons;
		UIImage *image = (UIImage *)icons[0];
		CGSize size = image.size;
		return @[[[[[%c(SBApplicationController) sharedInstance]
			applicationWithBundleIdentifier: self.bundleIdentifier] icon: nil
			imageWithFormat: 0] sbf_resizeImageToSize: size]];
	}

	- (UIImage *)icon {
		if(@available(iOS 12.0, *)) return %orig;
		return [[[%c(SBApplicationController) sharedInstance]
			applicationWithBundleIdentifier: self.bundleIdentifier] icon: nil
			imageWithFormat: 5];
}

%end