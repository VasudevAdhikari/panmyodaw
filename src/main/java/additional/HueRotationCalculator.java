package additional;
import java.awt.Color;

public class HueRotationCalculator {

    // Method to convert RGB to HSV
    private static float[] rgbToHSV(Color color) {
        float[] hsv = new float[3];
        Color.RGBtoHSB(color.getRed(), color.getGreen(), color.getBlue(), hsv);
        return hsv;
    }
    
    private static Color hexToColor(String hex) {
        // Remove hash if present
        if (hex.startsWith("#")) {
            hex = hex.substring(1);
        }

        // Parse the hex color string
        int r = Integer.parseInt(hex.substring(0, 2), 16);
        int g = Integer.parseInt(hex.substring(2, 4), 16);
        int b = Integer.parseInt(hex.substring(4, 6), 16);

        return new Color(r, g, b);
    }
    
    public static int getHueRotation(String startColor, String endColor) {
        Color start = hexToColor(startColor);
        Color end = hexToColor(endColor);

        return getHueRotation(start, end);
    }

    // Method to calculate hue rotation
    public static int getHueRotation(Color startColor, Color endColor) {
        float[] startHSV = rgbToHSV(startColor);
        float[] endHSV = rgbToHSV(endColor);

        // Extract hues
        float startHue = startHSV[0] * 360; // Convert from 0-1 range to 0-360 degrees
        float endHue = endHSV[0] * 360;

        // Calculate hue difference
        float hueDifference = endHue - startHue;

        // Normalize hue difference to be within -180° to 180°
        if (hueDifference > 180) {
            hueDifference -= 360;
        } else if (hueDifference < -180) {
            hueDifference += 360;
        }

        // Return hue difference as an integer
        return Math.round(hueDifference);
    }
}
