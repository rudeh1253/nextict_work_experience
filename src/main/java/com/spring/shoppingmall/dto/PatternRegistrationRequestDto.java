package com.spring.shoppingmall.dto;

import java.util.List;

public class PatternRegistrationRequestDto {
	private String productPatternType;
	private int productPatternSort;
	private boolean productView;
	private PatternDetailRequestDto[] patternDetails;
	
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
	
	public PatternDetailRequestDto[] getPatternDetails() {
		return patternDetails;
	}
	
	public void setPatternDetails(PatternDetailRequestDto[] patternDetails) {
		this.patternDetails = patternDetails;
	}
}
