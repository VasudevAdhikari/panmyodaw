package model;

import java.sql.Timestamp;

public class LoginFailure {

	int id, userId;
	String ipAddress, userType, reason;
	Timestamp failureTime, suspensionEndTime;
	
	public LoginFailure() {
		
	}
	
	public LoginFailure(int userId, String ipAddress, String userType, String reason) {
		this.userId = userId;
		this.ipAddress = ipAddress;
		this.userType = userType;
		this.reason = reason;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getIpAddress() {
		return ipAddress;
	}
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public Timestamp getFailureTime() {
		return failureTime;
	}
	public void setFailureTime(Timestamp failureTime) {
		this.failureTime = failureTime;
	}
	public Timestamp getSuspensionEndTime() {
		return suspensionEndTime;
	}
	public void setSuspensionEndTime(Timestamp suspensionEndTime) {
		this.suspensionEndTime = suspensionEndTime;
	}
}
