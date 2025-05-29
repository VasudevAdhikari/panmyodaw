package additional;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

import javax.servlet.http.Part;
import javax.servlet.ServletContext;

public class ImageControl {

    // Directory where images will be saved
    private static String IMAGE_DIRECTORY;

    // Constructor to initialize IMAGE_DIRECTORY using ServletContext
    public ImageControl(ServletContext context) {
        // Get the absolute path to the userProfiles directory
        IMAGE_DIRECTORY = context.getRealPath("/userProfile");
        System.out.println("Image Directory: " + IMAGE_DIRECTORY);
    }

    /**
     * Saves the uploaded image file as email.image format in the project directory.
     *
     * @param name     The name used to generate the file name.
     * @param filePart The Part file from the form input.
     * @return The file name of the saved image.
     * @throws IOException If an I/O error occurs.
     */
    public String saveImage(String name, Part filePart) throws IOException {
        // Extract the original file name and determine the extension
        String originalFileName = getFileName(filePart);
        String extension = "";
        if (originalFileName != null) {
            extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }

        // Replace spaces with underscores in the provided name
        String sanitizedFileName = name.replaceAll("\\s+", "_");

        // Generate a unique identifier and construct a unique file name
        String uniqueID = UUID.randomUUID().toString();
        String newFileName = sanitizedFileName + "_" + uniqueID + extension;

        // Ensure the image directory exists
        File uploadDir = new File(IMAGE_DIRECTORY);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Save the file to the specified directory
        String filePath = IMAGE_DIRECTORY + File.separator + newFileName;
        System.out.println("Saving file to: " + filePath);

        try (InputStream fileContent = filePart.getInputStream();
             FileOutputStream outputStream = new FileOutputStream(filePath)) {

            int read;
            final byte[] bytes = new byte[1024];
            int totalBytes = 0;
            while ((read = fileContent.read(bytes)) != -1) {
                outputStream.write(bytes, 0, read);
                totalBytes += read;
            }
            System.out.println("Total bytes written: " + totalBytes);
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("An error occurred while saving the file: " + e.getMessage());
        }

        // Confirm the file exists
        File savedFile = new File(filePath);
        if (savedFile.exists()) {
            System.out.println("File saved successfully: " + filePath);
        } else {
            System.out.println("Failed to save the file: " + filePath);
        }

        return newFileName;
    }

    /**
     * Deletes the image file from the project directory.
     *
     * @param fileName The name of the file to be deleted.
     * @return true if the file was successfully deleted, false otherwise.
     */
    public boolean deleteImage(String fileName) {
        // Construct the full file path
        String filePath = IMAGE_DIRECTORY + File.separator + fileName;

        // Create a File object
        File file = new File(filePath);

        // Check if the file exists and delete it
        if (file.exists() && file.isFile()) {
            return file.delete(); // returns true if the file was deleted successfully
        } else {
            System.out.println("File not found or is not a file: " + filePath);
            return false;
        }
    }

    /**
     * Replaces an existing image with a new one.
     *
     * @param fileName The name of the file to be replaced.
     * @param filePart The new Part file from the form input.
     * @return The new file name of the replaced image.
     * @throws IOException If an I/O error occurs.
     */
    public String replaceImage(String fileName, Part filePart) throws IOException {
        this.deleteImage(fileName);
        return this.saveImage("modifiedPic", filePart);
    }

    /**
     * Helper method to extract the file name from the Part object.
     *
     * @param part The Part object representing the uploaded file.
     * @return The extracted file name.
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }
}
