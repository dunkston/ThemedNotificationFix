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

static NSString *bundleID = nil;

%hook NCNotificationRequest

	- (NSString *)sectionIdentifier {
		bundleID = [NSString stringWithString: %orig];
		return bundleID;
	}

%end

%hook NCNotificationContent

	- (NSArray *)icons {
		NSArray *icons = %orig;
		if([icons count] == 0) return icons;
		UIImage *image = (UIImage *)icons[0];
		CGSize size = image.size;
		return @[[[[[%c(SBApplicationController) sharedInstance]
			applicationWithBundleIdentifier: bundleID] icon: nil
			imageWithFormat: 0] sbf_resizeImageToSize: size]];
	}

	- (UIImage *)icon {
		if(@available(iOS 12.0, *)) return %orig;
		return [[[%c(SBApplicationController) sharedInstance]
			applicationWithBundleIdentifier: bundleID] icon: nil
			imageWithFormat: 5];
}

%end