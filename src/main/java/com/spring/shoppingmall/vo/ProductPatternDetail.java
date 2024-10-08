package com.spring.shoppingmall.vo;

public class ProductPatternDetail {
	private Integer ptDtailIdx;
	private Integer productGroupIdx;
	private Integer productPatternIdx;
	private String ptDetailType;
	private String ptDetailImg;
	private String ptDetailDesc;
	private String ptDetailMovie;
	private String productIdx;
	private boolean ptDetailView;
	
	public Integer getPtDtailIdx() {
		return ptDtailIdx;
	}
	
	public void setPtDtailIdx(Integer ptDtailIdx) {
		this.ptDtailIdx = ptDtailIdx;
	}
	
	public Integer getProductGroupIdx() {
		return productGroupIdx;
	}
	
	public void setProductGroupIdx(Integer productGroupIdx) {
		this.productGroupIdx = productGroupIdx;
	}
	
	public Integer getProductPatternIdx() {
		return productPatternIdx;
	}
	
	public void setProductPatternIdx(Integer productPatternIdx) {
		this.productPatternIdx = productPatternIdx;
	}
	
	public String getPtDetailType() {
		return ptDetailType;
	}
	
	public void setPtDetailType(String ptDetailType) {
		this.ptDetailType = ptDetailType;
	}
	
	public String getPtDetailImg() {
		return ptDetailImg;
	}
	
	public void setPtDetailImg(String ptDetailImg) {
		this.ptDetailImg = ptDetailImg;
	}
	
	public String getPtDetailDesc() {
		return ptDetailDesc;
	}
	
	public void setPtDetailDesc(String ptDetailDesc) {
		this.ptDetailDesc = ptDetailDesc;
	}
	
	public String getPtDetailMovie() {
		return ptDetailMovie;
	}
	
	public void setPtDetailMovie(String ptDetailMovie) {
		this.ptDetailMovie = ptDetailMovie;
	}
	
	public String getProductIdx() {
		return productIdx;
	}
	
	public void setProductIdx(String productIdx) {
		this.productIdx = productIdx;
	}
	
	public boolean getPtDetailView() {
		return ptDetailView;
	}
	
	public void setPtDetailView(boolean ptDetailView) {
		this.ptDetailView = ptDetailView;
	}

	@Override
	public String toString() {
		return "ProductPatternDetail [ptDtailIdx=" + ptDtailIdx + ", productGroupIdx=" + productGroupIdx
				+ ", productPatternIdx=" + productPatternIdx + ", ptDetailType=" + ptDetailType + ", ptDetailImg="
				+ ptDetailImg + ", ptDetailDesc=" + ptDetailDesc + ", ptDetailMovie=" + ptDetailMovie + ", productIdx="
				+ productIdx + ", ptDetailView=" + ptDetailView + "]";
	}
}
