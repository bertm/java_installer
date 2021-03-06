/////////////////////////////////////////////////////////
// Bare Bones Browser Launch //
// Version 1.5 //
// December 10, 2005 //
// Supports: Mac OS X, GNU/Linux, Unix, Windows XP //
// Example Usage: // // String url = "http://www.centerkey.com/";
// BareBonesBrowserLaunch.openURL(url);
// Public Domain Software -- Free to Use as You Like //
/////////////////////////////////////////////////////////

import java.lang.reflect.Method;
import java.util.Arrays;

public class BareBonesBrowserLaunch {
	private static final String errMsg = "Error attempting to launch web browser";
	public static void main(String arg[]) {
		String url = arg[0];
		String osName = System.getProperty("os.name");
		try {
			if (osName.startsWith("Mac OS")) {
				Class fileMgr = Class.forName("com.apple.eio.FileManager");
				Method openURL = fileMgr.getDeclaredMethod("openURL", new Class[] { String.class });

				openURL.invoke(null, new Object[] { url });
			}
			else if (osName.startsWith("Windows")) Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + url);
			else {
				//assume Unix or Linux
				String[] browsers = {"firefox", "opera", "konqueror", "epiphany", "mozilla", "netscape", "seamonkey" };
				String browser = null;

				for (int count = 0; count < browsers.length && browser == null; count++)
					if (Runtime.getRuntime().exec( new String[] { "which", browsers[count]} ).waitFor() == 0)
						browser = browsers[count];
				if (browser == null)
					throw new Exception("Could not find web browser");
				else 
					Runtime.getRuntime().exec(new String[] { browser, url});
			}
		}
		catch (Exception e) {
			System.out.println("Unable to detect/startup your browser... please go to " + url + " for futher instructions");
		}
	}
}
