package com.spring.shoppingmall.vo;

public class ProductInfoVo {
	private Integer productIdx;
	private String productBrand;
	private String productCategory;
	private String productName;
	private int productPrice;
	private boolean productView;
	private String productImage;
	
	public Integer getProductIdx() {
		return productIdx;
	}
	
	public void setProductIdx(Integer productIdx) {
		this.productIdx = productIdx;
	}
	
	public String getProductBrand() {
		return productBrand;
	}
	
	public void setProductBrand(String productBrand) {
		this.productBrand = productBrand;
	}
	
	public String getProductCategory() {
		return productCategory;
	}
	
	public void setProductCategory(String productCategory) {
		this.productCategory = productCategory;
	}
	
	public String getProductName() {
		return productName;
	}
	
	public void setProductName(String productName) {
		this.productName = productName;
	}
	
	public int getProductPrice() {
		return productPrice;
	}
	
	public void setProductPrice(int productPrice) {
		this.productPrice = productPrice;
	}
	
	public boolean isProductView() {
		return productView;
	}
	
	public void setProductView(boolean productView) {
		this.productView = productView;
	}
	
	public String getProductImage() {
		return productImage;
	}
	
	public void setProductImage(String productImage) {
		this.productImage = productImage;
	}
	
	@Override
	public String toString() {
		return "ProductInfoVo [productIdx=" + productIdx + ", productBrand=" + productBrand + ", productCtGr="
				+ productCategory + ", productName=" + productName + ", productPrice=" + productPrice + ", productView="
				+ productView + ", productImage=" + productImage + "]";
	}
}
