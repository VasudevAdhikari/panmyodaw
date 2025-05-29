package additional;

public class StringSimilarity {
	public static boolean isNinetyFivePercentSimilar(String str1, String str2) {
		int maxLen = Math.max(str1.length(), str2.length());
		int levenshteinDistance = calculateLevenshteinDistance(str1, str2);

		// Calculate similarity percentage
		double similarity = (1.0 - ((double) levenshteinDistance / maxLen)) * 100;

		return similarity >= 95.0;
	}

	public static boolean isEightyFivePercentSimilar(String str1, String str2) {
		int maxLen = Math.max(str1.length(), str2.length());
		int levenshteinDistance = calculateLevenshteinDistance(str1, str2);

		// Calculate similarity percentage
		double similarity = (1.0 - ((double) levenshteinDistance / maxLen)) * 100	;

		return similarity >= 85.0;
	}

	public static int calculateLevenshteinDistance(String str1, String str2) {
		int[][] dp = new int[str1.length() + 1][str2.length() + 1];

		for (int i = 0; i <= str1.length(); i++) {
			for (int j = 0; j <= str2.length(); j++) {
				if (i == 0) {
					dp[i][j] = j;
				} else if (j == 0) {
					dp[i][j] = i;
				} else if (str1.charAt(i - 1) == str2.charAt(j - 1)) {
					dp[i][j] = dp[i - 1][j - 1];
				} else {
					dp[i][j] = 1 + Math.min(dp[i - 1][j - 1], Math.min(dp[i - 1][j], dp[i][j - 1]));
				}
			}
		}

		return dp[str1.length()][str2.length()];
	}

	public static String normalizeAddress(String address) {
		// Convert to lowercase
		address = address.toLowerCase();

		// Replace common abbreviations (e.g., "st" for "street", "apt" for "apartment")
		address = address.replaceAll("\\bst\\b", "street");
		address = address.replaceAll("\\bapt\\b", "apartment");
		address = address.replaceAll("\\bil\\b", "illinois");
		address = address.replaceAll("\\busa\\b", "united states");

		// Remove all punctuation except for spaces
		address = address.replaceAll("[^a-z0-9\\s]", "");

		// Remove multiple spaces
		address = address.replaceAll("\\s+", " ");

		// Trim any leading or trailing spaces
		return address.trim();
	}
}
