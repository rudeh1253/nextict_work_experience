package com.spring.board.vo;

public class AdditionalInfoVo {
	private String educationInfo;
	private String careerInfo;
	private String desiredSalary = "회사내규에 따름";
	private String desiredLocation;
	private String workType;
	
	public String getEducationInfo() {
		return educationInfo;
	}
	public void setEducationInfo(String educationInfo) {
		this.educationInfo = educationInfo;
	}
	public String getCareerInfo() {
		return careerInfo;
	}
	public void setCareerInfo(String careerInfo) {
		this.careerInfo = careerInfo;
	}
	public String getDesiredSalary() {
		return desiredSalary;
	}
	public void setDesiredSalary(String desiredSalary) {
		this.desiredSalary = desiredSalary;
	}
	public String getDesiredLocation() {
		return desiredLocation;
	}
	public void setDesiredLocation(String desiredLocation) {
		this.desiredLocation = desiredLocation;
	}
	public String getWorkType() {
		return workType;
	}
	public void setWorkType(String workType) {
		this.workType = workType;
	}
	@Override
	public String toString() {
		return "AdditionalInfoVo [educationInfo=" + educationInfo + ", careerInfo=" + careerInfo + ", desiredSalary="
				+ desiredSalary + "]";
	}
}
