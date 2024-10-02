package com.spring.board.vo;

public class CareerVo {
	private String carSeq;
	private String seq;
	private String compName;
	private String location;
	private String startPeriod;
	private String endPeriod;
	private String task;
	private String salary;
	
	public String getCarSeq() {
		return carSeq;
	}
	public void setCarSeq(String carSeq) {
		this.carSeq = carSeq;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getCompName() {
		return compName;
	}
	public void setCompName(String compName) {
		this.compName = compName;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getStartPeriod() {
		return startPeriod;
	}
	public void setStartPeriod(String startPeriod) {
		this.startPeriod = startPeriod;
	}
	public String getEndPeriod() {
		return endPeriod;
	}
	public void setEndPeriod(String endPeriod) {
		this.endPeriod = endPeriod;
	}
	public String getTask() {
		return task;
	}
	public void setTask(String task) {
		this.task = task;
	}
	public String getSalary() {
		return salary;
	}
	public void setSalary(String salary) {
		this.salary = salary;
	}
	@Override
	public String toString() {
		return "CareerVo [carSeq=" + carSeq + ", seq=" + seq + ", compName=" + compName + ", location=" + location
				+ ", startPeriod=" + startPeriod + ", endPeriod=" + endPeriod + ", task=" + task + ", salary=" + salary
				+ "]";
	}
}
