package com.spring.shoppingmall.vo;

public class ProductPatternInfo {
	private Integer productPatternIdx;
	private Integer productGroupIdx;
	private String productPatternType;
	private int productPatternSort;
	private boolean productView;
	
	public Integer getProductPatternIdx() {
		return productPatternIdx;
	}
	
	public void setProductPatternIdx(Integer productIdx) {
		this.productPatternIdx = productIdx;
	}
	
	public Integer getProductGroupIdx() {
		return productGroupIdx;
	}
	
	public void setProductGroupIdx(Integer productGroupIdx) {
		this.productGroupIdx = productGroupIdx;
	}
	
	public String getProductPatternType() {
		return productPatternType;
	}
	
	public void setProductPatternType(String productPatternType) {
		this.productPatternType = productPatternType;
	}
	
	public int getProductPatternSort() {
		return productPatternSort;
	}
	
	public void setProductPatternSort(int productPatternSort) {
		this.productPatternSort = productPatternSort;
	}
	
	public boolean isProductView() {
		return productView;
	}
	
	public void setProductView(boolean productView) {
		this.productView = productView;
	}

	@Override
	public String toString() {
		return "ProductPatternInfo [productPatternIdx=" + productPatternIdx + ", productGroupIdx=" + productGroupIdx
				+ ", productPatternType=" + productPatternType + ", productPatternSort=" + productPatternSort
				+ ", productView=" + productView + "]";
	}
}
