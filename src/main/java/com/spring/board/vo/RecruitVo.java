package com.spring.board.vo;

import java.util.ArrayList;
import java.util.List;

public class RecruitVo {
	private String seq;
	private String name;
	private String birth;
	private String gender;
	private String phone;
	private String email;
	private String addr;
	private String location;
	private String workType;
	private String submit;
	
	private List<CertificateVo> certificates = new ArrayList<>();
	private List<EducationVo> educations = new ArrayList<>();
	private List<CareerVo> careers = new ArrayList<>();
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getWorkType() {
		return workType;
	}
	public void setWorkType(String workType) {
		this.workType = workType;
	}
	public String getSubmit() {
		return submit;
	}
	public void setSubmit(String submit) {
		this.submit = submit;
	}
	public List<CertificateVo> getCertificates() {
		return certificates;
	}
	public void setCertificates(List<CertificateVo> certificates) {
		this.certificates = certificates;
	}
	public List<EducationVo> getEducations() {
		return educations;
	}
	public void setEducations(List<EducationVo> educations) {
		this.educations = educations;
	}
	public List<CareerVo> getCareers() {
		return careers;
	}
	public void setCareers(List<CareerVo> careers) {
		this.careers = careers;
	}
	@Override
	public String toString() {
		return "RecruitVo [seq=" + seq + ", name=" + name + ", birth=" + birth + ", gender=" + gender + ", phone="
				+ phone + ", email=" + email + ", addr=" + addr + ", location=" + location + ", workType=" + workType
				+ ", submit=" + submit + ", certificates=" + certificates + ", educations=" + educations + ", careers="
				+ careers + "]";
	}
}
