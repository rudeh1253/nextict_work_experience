package com.spring.shoppingmall.vo;

public class ProductGroupProductVo {
	private Integer productGroupProductIdx;
	private Integer productGroupIdx;
	private Integer productIdx;
	private boolean productGroupProductView;
	
	public Integer getProductGroupProductIdx() {
		return productGroupProductIdx;
	}
	
	public void setProductGroupProductIdx(Integer productGroupProductIdx) {
		this.productGroupProductIdx = productGroupProductIdx;
	}
	
	public Integer getProductGroupIdx() {
		return productGroupIdx;
	}
	
	public void setProductGroupIdx(Integer productGroupIdx) {
		this.productGroupIdx = productGroupIdx;
	}
	
	public Integer getProductIdx() {
		return productIdx;
	}
	
	public void setProductIdx(Integer productIdx) {
		this.productIdx = productIdx;
	}
	
	public boolean isProductGroupProductView() {
		return productGroupProductView;
	}
	
	public void setProductGroupProductView(boolean productGroupProductView) {
		this.productGroupProductView = productGroupProductView;
	}
	
	@Override
	public String toString() {
		return "ProductGroupProductVo [productGroupProductIdx=" + productGroupProductIdx + ", productGroupIdx="
				+ productGroupIdx + ", productIdx=" + productIdx + ", productGroupProductView="
				+ productGroupProductView + "]";
	}
}
