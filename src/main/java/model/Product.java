package model;

public class Product {

	int id;
	double price, discount, profit;
	String theme_color;
	public String getTheme_color() {
		return theme_color;
	}

	public void setTheme_color(String theme_color) {
		this.theme_color = theme_color;
	}

	public double getProfit() {
		return profit;
	}

	public void setProfit(double profit) {
		this.profit = profit;
	}

	String name, profile_pic, product_description;
	boolean inStock;

	public String getProduct_description() {
		return product_description;
	}

	public void setProduct_description(String product_description) {
		this.product_description = product_description;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public double getDiscount() {
		return discount;
	}

	public void setDiscount(double discount) {
		this.discount = discount;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getProfile_pic() {
		return profile_pic;
	}

	public void setProfile_pic(String profile_pic) {
		this.profile_pic = profile_pic;
	}

	public boolean isInStock() {
		return inStock;
	}
	
	public boolean getInStock() {
		return isInStock();
	}

	public void setInStock(boolean inStock) {
		this.inStock = inStock;
	}
}
