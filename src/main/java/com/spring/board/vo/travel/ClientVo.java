package com.spring.board.vo.travel;

import java.util.ArrayList;
import java.util.List;

public class ClientVo {
	private String seq;
	private String userName;
	private String userPhone;
	private Integer period;
	private String transport;
	private long expend;
	private String travelCity;
	private List<TravelInfoVo> travelInfos = new ArrayList<>();
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserPhone() {
		return userPhone;
	}
	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}
	public Integer getPeriod() {
		return period;
	}
	public void setPeriod(Integer period) {
		this.period = period;
	}
	public String getTransport() {
		return transport;
	}
	public void setTransport(String transport) {
		this.transport = transport;
	}
	public long getExpend() {
		return expend;
	}
	public void setExpend(long expend) {
		this.expend = expend;
	}
	public String getTravelCity() {
		return travelCity;
	}
	public void setTravelCity(String travelCity) {
		this.travelCity = travelCity;
	}
	public List<TravelInfoVo> getTravelInfos() {
		return this.travelInfos;
	}
	public void setTravelInfos(List<TravelInfoVo> travelInfos) {
		this.travelInfos = travelInfos;
	}
	public void addTravelInfo(TravelInfoVo travelInfo) {
		this.travelInfos.add(travelInfo);
	}
	public int getEstimatedExpenses() {
		int sum = 0;
		for (TravelInfoVo vo : this.travelInfos) {
			sum += vo.getTransportFee() + vo.getUseExpend(); 
		}
		if (this.transport.equals("R")) {
			int baseFee;
			switch (this.period) {
			case 1:
			case 2:
				baseFee = 100000;
				break;
			case 3:
			case 4:
				baseFee = 90000;
				break;
			case 5:
			case 6:
				baseFee = 80000;
				break;
			default:
				baseFee = 70000;
			}
			sum += baseFee * this.period;
		}
		return sum;
	}
	@Override
	public String toString() {
		return "ClientVo [seq=" + seq + ", userName=" + userName + ", userPhone=" + userPhone + ", period=" + period
				+ ", transport=" + transport + ", expend=" + expend + ", travelCity=" + travelCity + "]";
	}
}
