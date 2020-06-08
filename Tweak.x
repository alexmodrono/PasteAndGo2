// Hooks are from https://github.com/opa334/Choicy/blob/master/ChoicySB/TweakSB.x
// This code implements new features to https://github.com/lint/PasteAndGo/, so please make sure to go star their repo as well! ;)

#import "PasteAndGo2.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


%group iOS13Up

%hook SBIconView

%new
-(bool) isBrowser:(NSString *)bundleID { // hardcoded function because I'm tired and lazy
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

-(NSArray *) applicationShortcutItems {
	
	NSArray * orig = %orig;

	//MARK: App bundle and bundle IDs
	NSString * bundleID;
	NSBundle * tweakBundle = [NSBundle bundleWithPath:@"/Library/Application Support/PasteAndGo2.bundle"];

	if ([self respondsToSelector:@selector(applicationBundleIdentifier)]){
		bundleID = [self applicationBundleIdentifier];
	} else if ([self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)]){
		bundleID = [self applicationBundleIdentifierForShortcuts];
	}

	if(!bundleID){
		return orig;
	}

	if ([self isBrowser:bundleID]) {
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]) { // Item copied is an URL

				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = [tweakBundle localizedStringForKey:@"PASTEANDGO" value:@"" table:nil];
				pasteAndGoItem.localizedSubtitle = [NSString stringWithFormat: @"Go to: %@", [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy]]; // link without http:// and https://

				pasteAndGoItem.type = @"com.twickd.amodrono.pasteandgo2.item";

				return [orig arrayByAddingObject:pasteAndGoItem];

			} else { // Item copied is not an URL

				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = [tweakBundle localizedStringForKey:@"PASTEANDSEARCH" value:@"" table:nil];
				pasteAndGoItem.localizedSubtitle = [NSString stringWithFormat: @"Search \"%@\"", pbStr];

				pasteAndGoItem.type = @"com.twickd.amodrono.pasteandgo2.item";

				return [orig arrayByAddingObject:pasteAndGoItem];

			}
		}
	}

	return orig;
}

+(void) activateShortcut:(SBSApplicationShortcutItem*)item withBundleIdentifier:(NSString*)bundleID forIconView:(id)iconView {
	
	if ([[item type] isEqualToString:@"com.twickd.amodrono.pasteandgo2.item"]){
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr) {

			pbStr = [pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString * urlScheme;
			BOOL needToEscapeURL = NO;
			BOOL needToRemoveSchema = NO;

			if ([bundleID isEqualToString:@"org.mozilla.ios.Firefox"]) {
				urlScheme = @"firefox://open-url?url=";
				needToEscapeURL = YES;
			} else if ([bundleID isEqualToString:@"org.mozilla.ios.Focus"]) {
				urlScheme = @"firefox-focus://open-url?url=";
				needToEscapeURL = YES;
			} else if ([bundleID isEqualToString:@"com.google.chrome.ios"]) {
				if ([pbStr hasPrefix:@"https://"])
					urlScheme = @"googlechromes://";
				else
					urlScheme = @"googlechrome://";
				needToRemoveSchema = YES;
			} else if ([bundleID isEqualToString:@"com.brave.ios.browser"]) {
				urlScheme = @"brave://open-url?url=";
				needToEscapeURL = YES;
			} else if ([bundleID isEqualToString:@"com.microsoft.msedge"]) {
				urlScheme = @"microsoft-edge-";
			} else {
				urlScheme = @"";
			}

			NSCharacterSet *customCharacterset = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]\\<>^`{|} "] invertedSet];
			if (needToRemoveSchema) {
				pbStr = [pbStr stringByReplacingOccurrencesOfString:@"http://" withString:@""];
				pbStr = [pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""];
			}
			NSURL * finalURL = [NSURL URLWithString:pbStr];

			if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pbStr]]) {

				if (needToEscapeURL) pbStr = [pbStr stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset];

				finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlScheme, pbStr]];

			} else { // item is not an url, so we need to search it
				
				if (needToEscapeURL) {
					pbStr = [pbStr stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset];
					pbStr = [pbStr stringByReplacingOccurrencesOfString:@"%" withString:@"%25"]; // second level escape is needed for the query
					pbStr = [NSString stringWithFormat:@"%@https://www.google.com/search%%3Fq%%3D%@", urlScheme, pbStr];
				} else {
					pbStr = [pbStr stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset];
					pbStr = [NSString stringWithFormat:@"%@%@www.google.com/search?q=%@", urlScheme, needToRemoveSchema?@"":@"https://", pbStr];
				}

				finalURL = [NSURL URLWithString: pbStr];

			}
			
			HBLogDebug(@"Final URL to open: %@", finalURL);
			[[UIApplication sharedApplication] openURL:finalURL];

		}
	}

	%orig;
}

%end

%end


%group iOS12OrDown

%hook SBUIAppIconForceTouchControllerDataProvider

%new
-(bool) isBrowser:(NSString *)bundleID {
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

-(NSArray *) applicationShortcutItems {
	
	NSArray *orig = %orig;

	//MARK: App bundle and bundle IDs
	NSString * bundleID;
	NSBundle * tweakBundle = [NSBundle bundleWithPath:@"/Library/Application Support/PasteAndGo2.bundle"];

	if (!bundleID){
		return orig;
	}
	
	if ([self isBrowser:bundleID]) {
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];
		
		if (pbStr){
			
			NSURL *url = [NSURL URLWithString:[pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
			
			if ([[UIApplication sharedApplication] canOpenURL:url]) { // Item copied is an URL
				
				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = [tweakBundle localizedStringForKey:@"PASTEANDGO" value:@"" table:nil];
				pasteAndGoItem.localizedSubtitle = [NSString stringWithFormat: @"Go to: %@", [[[pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""] mutableCopy]]; // link without http:// and https://

				pasteAndGoItem.type = @"com.twickd.amodrono.pasteandgo2.item";

				if (!orig){
					return @[pasteAndGoItem];
				} else {
					return [orig arrayByAddingObject:pasteAndGoItem];
				}

			} else { // Item copied is not an URL

				SBSApplicationShortcutItem* pasteAndGoItem = [[%c(SBSApplicationShortcutItem) alloc] init];
				pasteAndGoItem.localizedTitle = [tweakBundle localizedStringForKey:@"PASTEANDSEARCH" value:@"" table:nil];
				pasteAndGoItem.localizedSubtitle = [NSString stringWithFormat: @"Search \"%@\"", pbStr];

				pasteAndGoItem.type = @"com.twickd.amodrono.pasteandgo2.item";

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
	
	if ([[item type] isEqualToString:@"com.twickd.amodrono.pasteandgo2.item"]){
		
		UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; 
		NSString *pbStr = [pasteBoard string];

		NSString * bundleID;

		if (!bundleID) {
			return %orig;
		}
		
		if (pbStr) {

			pbStr = [pbStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString * urlScheme;
			BOOL needToEscapeURL = NO;
			BOOL needToRemoveSchema = NO;

			if ([bundleID isEqualToString:@"org.mozilla.ios.Firefox"]) {
				urlScheme = @"firefox://open-url?url=";
				needToEscapeURL = YES;
			} else if ([bundleID isEqualToString:@"org.mozilla.ios.Focus"]) {
				urlScheme = @"firefox-focus://open-url?url=";
				needToEscapeURL = YES;
			} else if ([bundleID isEqualToString:@"com.google.chrome.ios"]) {
				if ([pbStr hasPrefix:@"https://"])
					urlScheme = @"googlechromes://";
				else
					urlScheme = @"googlechrome://";
				needToRemoveSchema = YES;
			} else if ([bundleID isEqualToString:@"com.brave.ios.browser"]) {
				urlScheme = @"brave://open-url?url=";
				needToEscapeURL = YES;
			} else if ([bundleID isEqualToString:@"com.microsoft.msedge"]) {
				urlScheme = @"microsoft-edge-";
			} else {
				urlScheme = @"";
			}

			NSCharacterSet *customCharacterset = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]\\<>^`{|} "] invertedSet];
			if (needToRemoveSchema) {
				pbStr = [pbStr stringByReplacingOccurrencesOfString:@"http://" withString:@""];
				pbStr = [pbStr stringByReplacingOccurrencesOfString:@"https://" withString:@""];
			}
			NSURL * finalURL = [NSURL URLWithString:pbStr];

			if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pbStr]]) {

				if (needToEscapeURL) pbStr = [pbStr stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset];

				finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlScheme, pbStr]];

			} else { // item is not an url, so we need to search it
				
				if (needToEscapeURL) {
					pbStr = [pbStr stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset];
					pbStr = [pbStr stringByReplacingOccurrencesOfString:@"%" withString:@"%25"]; // second level escape is needed for the query
					pbStr = [NSString stringWithFormat:@"%@https://www.google.com/search%%3Fq%%3D%@", urlScheme, pbStr];
				} else {
					pbStr = [pbStr stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset];
					pbStr = [NSString stringWithFormat:@"%@%@www.google.com/search?q=%@", urlScheme, needToRemoveSchema?@"":@"https://", pbStr];
				}

				finalURL = [NSURL URLWithString: pbStr];

			}
			
			HBLogDebug(@"Final URL to open: %@", finalURL);
			[[UIApplication sharedApplication] openURL:finalURL];

		}
	}

	%orig;
}

%end

%end

%ctor {
	
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")){
		%init(iOS13Up);
	} else {
		%init(iOS12OrDown);
	}
}
