package model;

import java.sql.Timestamp;

public class Order {

	int id, customer_id, deliverer_id;
	Timestamp timestamp;
	String delivery_status;
	
	public Order() {
		this.deliverer_id = 1;
	}
	
	public int getDeliverer_id() {
		return deliverer_id;
	}

	public void setDeliverer_id(int deliverer_id) {
		this.deliverer_id = deliverer_id;
	}

	public Timestamp getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Timestamp timestamp) {
		this.timestamp = timestamp;
	}

	boolean is_paid;

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

	public String getDelivery_status() {
		return delivery_status;
	}

	public void setDelivery_status(String delivery_status) {
		this.delivery_status = delivery_status;
	}

	public boolean isIs_paid() {
		return is_paid;
	}

	public void setIs_paid(boolean is_paid) {
		this.is_paid = is_paid;
	}

}
