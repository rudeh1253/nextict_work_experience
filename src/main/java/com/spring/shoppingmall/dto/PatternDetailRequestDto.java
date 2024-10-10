package com.spring.shoppingmall.dto;

public class PatternDetailRequestDto {
	private String ptDetailType;
	private String ptDetailImageName;
	private String ptDetailImageDataInBase64;
	private String ptDetailDesc;
	private String ptDetailMovie;
	private boolean ptDetailView;
	
	public String getPtDetailType() {
		return ptDetailType;
	}
	
	public void setPtDetailType(String ptDetailType) {
		this.ptDetailType = ptDetailType;
	}
	
	public String getPtDetailImageName() {
		return ptDetailImageName;
	}
	
	public void setPtDetailImageName(String ptDetailImageName) {
		this.ptDetailImageName = ptDetailImageName;
	}
	
	public String getPtDetailImageDataInBase64() {
		return ptDetailImageDataInBase64;
	}
	
	public void setPtDetailImageDataInBase64(String ptDetailImageDataInBase64) {
		this.ptDetailImageDataInBase64 = ptDetailImageDataInBase64;
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
	
	public boolean isPtDetailView() {
		return ptDetailView;
	}
	
	public void setPtDetailView(boolean ptDetailView) {
		this.ptDetailView = ptDetailView;
	}
}
