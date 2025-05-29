package additional;

public class MyDevice {

	public static String getDeviceInfo() {
		
		String osName = System.getProperty("os.name");
        // Get the operating system version
        String osVersion = System.getProperty("os.version");
        // Get the operating system architecture
        String osArch = System.getProperty("os.arch");
        
        String deviceInfo = osName + " Version" + osVersion + " Archi " + osArch;
        
        return deviceInfo;
	}
}