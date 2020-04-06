//Hooks are from https://github.com/opa334/Choicy/blob/master/ChoicySB/TweakSB.x
//This code implements new features to https://github.com/lint/PasteAndGo/, so please make sure to go star their repo as well! ;)

#import "PasteAndGo2.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


%group iOS13Up

%hook SBIconView

%new
<<<<<<< HEAD
-(bool) isBrowser:(NSString *)bundleID { //hardcoded function because I'm tired and lazy
	if ([bundleID isEqualToString:@"com.apple.mobilesafari"]
		|| [bundleID isEqualToString:@"org.mozilla.ios.Firefox"]
		|| [bundleID isEqualToString:@"org.mozilla.ios.Focus"]
		|| [bundleID isEqualToString:@"com.google.chrome.ios"]
		|| [bundleID isEqualToString:@"com.brave.ios.browser"]
		|| [bundleID isEqualToString:@"com.microsoft.msedge"]) {
			return true;
		}
=======
-(bool) isInArray:(NSArray *)array item:(NSString *)item {
	for (NSString * currentString in array) {

		if ([currentString isEqualToString:item]) {
			return true;
		}
		return false;

	}
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596

	return false;
}

-(NSArray *) applicationShortcutItems {
	
	NSArray * orig = %orig;

	//MARK: App bundle and bundle IDs
	NSString * bundleID;
	NSBundle * tweakBundle = [NSBundle bundleWithPath:@"/Library/Application Support/PasteAndGo2.bundle"];
<<<<<<< HEAD
	//NSArray * appBundleIDs = [[NSArray alloc] initWithObjects:@"com.apple.mobilesafari", @"org.mozilla.ios.Firefox", @"org.mozilla.ios.Focus", @"com.google.chrome.ios", @"com.brave.ios.browser", @"com.microsoft.msedge",nil];
=======
	NSArray * appBundleIDs = [[NSArray alloc] initWithObjects:@"com.apple.mobilesafari", @"org.mozilla.ios.Firefox", @"org.mozilla.ios.Focus", @"com.google.chrome.ios", @"com.brave.ios.browser", @"com.microsoft.msedge",nil];
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596

	if ([self respondsToSelector:@selector(applicationBundleIdentifier)]){
		bundleID = [self applicationBundleIdentifier];
	} else if ([self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)]){
		bundleID = [self applicationBundleIdentifierForShortcuts];
	}

	if(!bundleID){
		return orig;
	}

<<<<<<< HEAD
	if ([self isBrowser:bundleID]) {
=======
	if ([self isInArray:appBundleIDs item:bundleID]){
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]) { //Item copied is an URL

				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = [tweakBundle localizedStringForKey:@"PASTEANDGO" value:@"" table:nil];
				pasteAndGoItem.localizedSubtitle = [NSString stringWithFormat: @"Go to: %@", [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy]]; //link without http:// and https://
<<<<<<< HEAD
				pasteAndGoItem.type = @"com.twickd.amodrono.pasteandgo2.item";
=======
				pasteAndGoItem.type = @"com.amodrono.pasteandgo2.item";
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596

				return [orig arrayByAddingObject:pasteAndGoItem];

			} else { //Item copied is not an URL

				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = [tweakBundle localizedStringForKey:@"PASTEANDSEARCH" value:@"" table:nil];
				pasteAndGoItem.localizedSubtitle = [NSString stringWithFormat: @"Search \"%@\"", pbStr];
<<<<<<< HEAD
				pasteAndGoItem.type = @"com.twickd.amodrono.pasteandgo2.item";
=======
				pasteAndGoItem.type = @"com.amodrono.pasteandgo2.item";
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596

				return [orig arrayByAddingObject:pasteAndGoItem];

			}
		}
	}

	return orig;
}

+(void) activateShortcut:(SBSApplicationShortcutItem*)item withBundleIdentifier:(NSString*)bundleID forIconView:(id)iconView{
	
<<<<<<< HEAD
	if ([[item type] isEqualToString:@"com.twickd.amodrono.pasteandgo2.item"]){
=======
	if ([[item type] isEqualToString:@"com.amodrono.pasteandgo2.item"]){
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
<<<<<<< HEAD
		if (pbStr) {

			NSString * urlScheme;

			if ([bundleID isEqualToString:@"org.mozilla.ios.Firefox"]) {
				urlScheme = @"firefox://open-url?url=";
			} else if ([bundleID isEqualToString:@"org.mozilla.ios.Focus"]) {
				urlScheme = @"firefox-focus://open-url?url=";
			} else if ([bundleID isEqualToString:@"com.google.chrome.ios"]) {
				urlScheme = @"googlechrome://";
			} else if ([bundleID isEqualToString:@"com.brave.ios.browser"]) {
				urlScheme = @"brave://open-url?url=";
			} else if ([bundleID isEqualToString:@"com.microsoft.msedge"]) {
				urlScheme = @"microsoft-edge-";
			} else {
				urlScheme = @"";
=======
		if (pbStr){

			NSString * urlScheme;
			NSArray * appBundleIDs = [[NSArray alloc] initWithObjects:@"com.apple.mobilesafari", @"org.mozilla.ios.Firefox", @"org.mozilla.ios.Focus", @"com.google.chrome.ios", @"com.brave.ios.browser", @"com.microsoft.msedge",nil];

			switch (([[appBundleIDs objectAtIndex:1] intValue])) {
				
				case 2:
					urlScheme = @"firefox://open-url?url=";
					break;

				case 3:
					urlScheme = @"firefox-focus://open-url?url=";
					break;

				case 4:
					pbStr = [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy];
					urlScheme = @"googlechrome://";
					break;

				case 5:
					urlScheme = @"brave://open-url?url=";
					break;

				case 6:
					urlScheme = @"microsoft-edge-";
					break;

				default:
					break;
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
			}

			NSURL * finalURL = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

<<<<<<< HEAD
			if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pbStr]]) {

				pbStr = [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy];
=======
			if ([[UIApplication sharedApplication] canOpenURL:finalURL]) {

>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
				finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlScheme, [pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];

			} else { //item is not an url, so we just need to search it.
				
				if ([bundleID isEqualToString:@"com.google.chrome.ios"]) {
<<<<<<< HEAD
					pbStr = [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy];
=======
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
					finalURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@www.google.com/search?q=%@", urlScheme, [[pbStr stringByReplacingOccurrencesOfString:@" " withString:@"+"] mutableCopy]]]; //convert to google link
				} else {
					finalURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@https://www.google.com/search?q=%@", urlScheme, [[pbStr stringByReplacingOccurrencesOfString:@" " withString:@"+"] mutableCopy]]]; //convert to google link
				}

			}
			
			[[UIApplication sharedApplication] openURL:finalURL];

		}
	}

	%orig;
}

%end

%end


%group iOS12OrDown

%hook SBUIAppIconForceTouchControllerDataProvider

<<<<<<< HEAD
%new
-(bool) isBrowser:(NSString *)bundleID { //hardcoded function because I'm tired and lazy
	if ([bundleID isEqualToString:@"com.apple.mobilesafari"]
		|| [bundleID isEqualToString:@"org.mozilla.ios.Firefox"]
		|| [bundleID isEqualToString:@"org.mozilla.ios.Focus"]
		|| [bundleID isEqualToString:@"com.google.chrome.ios"]
		|| [bundleID isEqualToString:@"com.brave.ios.browser"]
		|| [bundleID isEqualToString:@"com.microsoft.msedge"]) {
			return true;
		}

	return false;
}

=======
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
-(NSArray *) applicationShortcutItems {
	
	NSArray *orig = %orig;

	//MARK: App bundle and bundle IDs
	NSString * bundleID;
	NSBundle * tweakBundle = [NSBundle bundleWithPath:@"/Library/Application Support/PasteAndGo2.bundle"];
<<<<<<< HEAD
	//NSArray * appBundleIDs = [[NSArray alloc] initWithObjects:@"com.apple.mobilesafari", @"org.mozilla.ios.Firefox", @"org.mozilla.ios.Focus", @"com.google.chrome.ios", @"com.brave.ios.browser", @"com.microsoft.msedge",nil];
=======
	NSArray * appBundleIDs = [[NSArray alloc] initWithObjects:@"com.apple.mobilesafari", @"org.mozilla.ios.Firefox", @"org.mozilla.ios.Focus", @"com.google.chrome.ios", @"com.brave.ios.browser", @"com.microsoft.msedge",nil];
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596

	if (!bundleID){
		return orig;
	}
	
<<<<<<< HEAD
	if ([self isBrowser:bundleID]) {
=======
	if ([self isInArray:appBundleIDs item:bundleID]){
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]) {
				
				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = [tweakBundle localizedStringForKey:@"PASTEANDGO" value:@"" table:nil];
				pasteAndGoItem.localizedSubtitle = [NSString stringWithFormat: @"Go to: %@", [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy]]; //link without http:// and https://
<<<<<<< HEAD
				pasteAndGoItem.type = @"com.twickd.amodrono.pasteandgo2.item";
=======
				pasteAndGoItem.type = @"com.amodrono.pasteandgo2.item";
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596

				if (!orig){
					return @[pasteAndGoItem];
				} else {
					return [orig arrayByAddingObject:pasteAndGoItem];
				}

			} else { //Item copied is not an URL

				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = [tweakBundle localizedStringForKey:@"PASTEANDSEARCH" value:@"" table:nil];
				pasteAndGoItem.localizedSubtitle = [NSString stringWithFormat: @"Search \"%@\"", pbStr];
<<<<<<< HEAD
				pasteAndGoItem.type = @"com.twickd.amodrono.pasteandgo2.item";
=======
				pasteAndGoItem.type = @"com.amodrono.pasteandgo2.item";
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596

				if (!orig) {
					return @[pasteAndGoItem];
				} else {
					return [orig arrayByAddingObject:pasteAndGoItem];
				}

			}
		}
	}

	return orig;
}

/*
%new
-(bool) isInArray:(NSArray)array item:(NSString)item {
	for (NSString * currentString in array) {

		if ([currentString isEqualToString:item]) {
			return true;
		}
		return false;

	}
*/

%end


%hook SBUIAppIconForceTouchController

-(void) appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(SBSApplicationShortcutItem*)item {
	
<<<<<<< HEAD
	if ([[item type] isEqualToString:@"com.twickd.amodrono.pasteandgo2.item"]){
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];

		NSString * bundleID;

		if (!bundleID) {
			return %orig;
		}
		
		if (pbStr) {

			NSString * urlScheme;

			if ([bundleID isEqualToString:@"org.mozilla.ios.Firefox"]) {
				urlScheme = @"firefox://open-url?url=";
			} else if ([bundleID isEqualToString:@"org.mozilla.ios.Focus"]) {
				urlScheme = @"firefox-focus://open-url?url=";
			} else if ([bundleID isEqualToString:@"com.google.chrome.ios"]) {
				urlScheme = @"googlechrome://";
			} else if ([bundleID isEqualToString:@"com.brave.ios.browser"]) {
				urlScheme = @"brave://open-url?url=";
			} else if ([bundleID isEqualToString:@"com.microsoft.msedge"]) {
				urlScheme = @"microsoft-edge-";
			} else {
				urlScheme = @"";
			}

			NSURL * finalURL = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

			if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pbStr]]) {

				pbStr = [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy];
				finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlScheme, [pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];

			} else { //item is not an url, so we just need to search it.
				
				if ([bundleID isEqualToString:@"com.google.chrome.ios"]) {
					pbStr = [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy];
					finalURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@www.google.com/search?q=%@", urlScheme, [[pbStr stringByReplacingOccurrencesOfString:@" " withString:@"+"] mutableCopy]]]; //convert to google link
				} else {
					finalURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@https://www.google.com/search?q=%@", urlScheme, [[pbStr stringByReplacingOccurrencesOfString:@" " withString:@"+"] mutableCopy]]]; //convert to google link
				}

			}
			
			[[UIApplication sharedApplication] openURL:finalURL];

=======
	if ([item.type isEqualToString:@"com.amodrono.pasteandgo2.item"]){
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]) {

				[[UIApplication sharedApplication] openURL:url];

			} else { //item is not an URL, so we just need to search it.
				
				url = [NSURL URLWithString: [NSString stringWithFormat:@"https://www.google.com/search?q=%@", [[pbStr stringByReplacingOccurrencesOfString:@" " withString:@"+"] mutableCopy]]]; //convert to google link

				[[UIApplication sharedApplication] openURL:url];

			}
>>>>>>> 7cd4bfbcd0391701f3ab645052ad4875aeb90596
		}
	}

	%orig;
}

%end

%end

%ctor{
	
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")){
		%init(iOS13Up); //
	} else {
		%init(iOS12OrDown);
	}
}
