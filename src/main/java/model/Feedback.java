package model;

public class Feedback {

	int id, customer_id;
	String description, reply, feedback_date;

	public String getReply() {
		return reply;
	}

	public void setReply(String reply) {
		this.reply = reply;
	}

	public String getFeedback_date() {
		return feedback_date;
	}

	public void setFeedback_date(String feedback_date) {
		this.feedback_date = feedback_date;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCustomer_id() {
		return customer_id;
	}

	public void setCustomer_id(int customer_id) {
		this.customer_id = customer_id;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
}
