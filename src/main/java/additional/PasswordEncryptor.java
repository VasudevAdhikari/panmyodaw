package additional;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordEncryptor {

    private static final String ALGORITHM = "AES/CBC/PKCS5Padding";
    private static final int KEY_SIZE = 128; // 128-bit AES key
    private static final int IV_SIZE = 16; // 128-bit IV

    // Generates a new AES SecretKey
    private SecretKey generateKey() throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(KEY_SIZE); // Key size
        return keyGen.generateKey();
    }

    // Generates a random initialization vector (IV)
    private static IvParameterSpec generateIv() {
        byte[] iv = new byte[IV_SIZE];
        new SecureRandom().nextBytes(iv);
        return new IvParameterSpec(iv);
    }

    public String encrypt(String password) throws Exception {
        SecretKey secretKey = generateKey();
        IvParameterSpec ivParameterSpec = generateIv();

        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivParameterSpec);

        byte[] encryptedBytes = cipher.doFinal(password.getBytes(StandardCharsets.UTF_8));
        byte[] iv = ivParameterSpec.getIV();
        byte[] combined = new byte[secretKey.getEncoded().length + iv.length + encryptedBytes.length];

        System.arraycopy(secretKey.getEncoded(), 0, combined, 0, secretKey.getEncoded().length);
        System.arraycopy(iv, 0, combined, secretKey.getEncoded().length, iv.length);
        System.arraycopy(encryptedBytes, 0, combined, secretKey.getEncoded().length + iv.length, encryptedBytes.length);

        return Base64.getEncoder().encodeToString(combined);
    }

    public String decrypt(String encryptedPassword) throws Exception {
        byte[] combined = Base64.getDecoder().decode(encryptedPassword);
        byte[] secretKeyBytes = new byte[KEY_SIZE / 8];
        byte[] iv = new byte[IV_SIZE];
        byte[] encryptedBytes = new byte[combined.length - secretKeyBytes.length - iv.length];

        System.arraycopy(combined, 0, secretKeyBytes, 0, secretKeyBytes.length);
        System.arraycopy(combined, secretKeyBytes.length, iv, 0, iv.length);
        System.arraycopy(combined, secretKeyBytes.length + iv.length, encryptedBytes, 0, encryptedBytes.length);

        SecretKey secretKey = new SecretKeySpec(secretKeyBytes, "AES");
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, ivParameterSpec);

        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

        return new String(decryptedBytes, StandardCharsets.UTF_8);
    }
    public static void main(String[]args) throws Exception
    {
    	PasswordEncryptor encryptor = new PasswordEncryptor();    	System.out.println(encryptor.decrypt("GbhEoB+uRbYVy66nS9RDA+0zxKlVziWuhqid+hIDwf6K1hA2hnkSnBeS0+ydooWu"));
    }
}
