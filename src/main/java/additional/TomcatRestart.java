package additional;
import java.io.IOException;

import java.io.IOException;

public class TomcatRestart {

    public static void restart() {
        try {
            // Stop the Tomcat server
            stopTomcat();
            
            // Sleep for a few seconds to allow Tomcat to shut down gracefully
            Thread.sleep(5000);

            // Start the Tomcat server
            startTomcat();

            System.out.println("Tomcat server restarted successfully.");

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            System.out.println("Failed to restart the Tomcat server.");
        }
    }

    public static void stopTomcat() throws IOException {
        String stopCommand;
        String osName = System.getProperty("os.name").toLowerCase();

        if (osName.contains("win")) {
            // Command to stop Tomcat on Windows
            stopCommand = "cmd /c C:\\Users\\ASUS\\Downloads\\apache-tomcat-9.0.90-windows-x64\\apache-tomcat-9.0.90\\bin\\catalina.bat stop";
        } else {
            // Command to stop Tomcat on Unix/Linux/Mac
            stopCommand = "/path/to/tomcat/bin/catalina.sh stop";
        }

        Process process = Runtime.getRuntime().exec(stopCommand);
        // Optionally wait for the process to complete
        try {
            process.waitFor();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Tomcat server stopped.");
    }

    public static void startTomcat() throws IOException {
        String startCommand;
        String osName = System.getProperty("os.name").toLowerCase();

        if (osName.contains("win")) {
            // Command to start Tomcat on Windows
            startCommand = "cmd /c C:\\Users\\ASUS\\Downloads\\apache-tomcat-9.0.90-windows-x64\\apache-tomcat-9.0.90\\bin\\catalina.bat start";
        } else {
            // Command to start Tomcat on Unix/Linux/Mac
            startCommand = "/path/to/tomcat/bin/catalina.sh start";
        }

        Process process = Runtime.getRuntime().exec(startCommand);
        // Optionally wait for the process to complete
        try {
            process.waitFor();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Tomcat server started.");
    }
}
