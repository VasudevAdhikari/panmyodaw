package additional;

import java.util.Base64;

public class User 
{
	public String email, password, name, city,  profile_pic, role;
	public long phone;
	public User(String email, Long phone, String password, String name, String city, String profile_pic, String role) {
		this.email = email;
		this.phone = phone;
		this.password = password;
		this.name = name;
		this.city = city;
		this.profile_pic = "<img src='data:image/jpeg;base64," + profile_pic + "' alt='Profile Picture'>";
		this.role = role;
	}
	public User() {
		this(null, null, null, null, null, null, null);
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public long getPhone() {
		return phone;
	}
	public void setPhone(long phone) {
		this.phone = phone;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getProfile_pic() {
		return profile_pic;
	}
	public void setProfile_pic(byte[] profile_pic) {
		String image = (profile_pic != null) ? Base64.getEncoder().encodeToString(profile_pic) : "";
		this.profile_pic = (image.isEmpty()) ? "No image" : "<img src='data:image/jpeg;base64," + image + "' alt='Profile Picture'>";
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
}
