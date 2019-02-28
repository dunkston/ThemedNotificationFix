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
		UIImage* icons[] = {[[[%c(SBApplicationController) sharedInstance]
			applicationWithBundleIdentifier: bundleID] icon: nil
			imageWithFormat: 5]};
		return [NSArray arrayWithObjects: icons count: 1];
	}

	- (UIImage *)icon {
		return [[[%c(SBApplicationController) sharedInstance]
			applicationWithBundleIdentifier: bundleID] icon: nil
			imageWithFormat: 5];
	}

%end