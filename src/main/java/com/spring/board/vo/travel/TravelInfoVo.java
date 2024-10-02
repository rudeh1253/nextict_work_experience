package com.spring.board.vo.travel;

import java.util.Arrays;
import java.util.function.ToIntFunction;

import org.codehaus.jackson.annotate.JsonTypeInfo;

public class TravelInfoVo {
	private String travelSeq;
	private String seq;
	private int travelDay;
	private String travelTime;
	private String travelCity;
	private String travelCounty;
	private String travelLoc;
	private String travelTrans;
	private int transTime;
	private int useTime;
	private int useExpend;
	private String travelDetail;
	private String request;
	
	public String getTravelSeq() {
		return travelSeq;
	}
	public void setTravelSeq(String travelSeq) {
		this.travelSeq = travelSeq;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public int getTravelDay() {
		return travelDay;
	}
	public void setTravelDay(int travelDay) {
		this.travelDay = travelDay;
	}
	public String getTravelTime() {
		int[] parsedTravelTime = getParsedTravelTime();
		return (parsedTravelTime[0] >= 12 ? "오후 " : "오전 ") + formatTimeRep((parsedTravelTime[0] + 11) % 12 + 1) + ":" + formatTimeRep(parsedTravelTime[1]);
	}
	
	public String getTravelTimeIn24() {
		return this.travelTime;
	}
	
	private String formatTimeRep(int num) {
		return num >= 10 ? String.valueOf(num) : "0" + num;
	}
	
	public void setTravelTime(String travelTime) {
		this.travelTime = travelTime;
	}
	public String getTravelCity() {
		return travelCity;
	}
	public void setTravelCity(String travelCity) {
		this.travelCity = travelCity;
	}
	public String getTravelCounty() {
		return travelCounty;
	}
	public void setTravelCounty(String travelCounty) {
		this.travelCounty = travelCounty;
	}
	public String getTravelLoc() {
		return travelLoc;
	}
	public void setTravelLoc(String travelLoc) {
		this.travelLoc = travelLoc;
	}
	public String getTravelTrans() {
		return travelTrans;
	}
	public void setTravelTrans(String travelTrans) {
		this.travelTrans = travelTrans;
	}
	public int getTransTime() {
		return transTime;
	}
	public void setTransTime(int transTime) {
		this.transTime = transTime;
	}
	public int getUseTime() {
		return this.useTime;
	}
	public void setUseTime(int useTime) {
		this.useTime = useTime;
	}
	public int getUseExpend() {
		return useExpend;
	}
	public void setUseExpend(int useExpend) {
		this.useExpend = useExpend;
	}
	public String getTravelDetail() {
		return travelDetail;
	}
	public void setTravelDetail(String travelDetail) {
		this.travelDetail = travelDetail;
	}
	public String getRequest() {
		return request;
	}
	public void setRequest(String request) {
		this.request = request;
	}
	
	public int getTransportFee() {
		if (this.transTime == 0) {
			return 0;
		}
		
		int[] parsedTravelTime = getParsedTravelTime();
		int baseFee = 0;
		switch (this.travelTrans) {
		case "T":
			if (parsedTravelTime[0] >= 0 && parsedTravelTime[0] <= 4) {
				parsedTravelTime[0] += 24;
			}
			
			int travelTimeInMinutes = parsedTravelTime[0] * 60 + parsedTravelTime[1];
			int transTimePeriod = (this.transTime - 1) / 10;
			
			int additionalFee = 0;
			int timeCursor = travelTimeInMinutes + 1;
			for (int i = 0; i < transTimePeriod; i++) {
				timeCursor += 10;
				if (timeCursor > 28 * 60) {
					additionalFee += 0;
				} else if (timeCursor > 24 * 60) {
					additionalFee += 7000;
				} else if (timeCursor > 22 * 60) {
					additionalFee += 6000;
				} else {
					additionalFee += 5000;
				}
			}
			
			double baseFeeAdd;
			int baseFeeTime = travelTimeInMinutes;
			if (baseFeeTime > 24 * 60) {
				baseFeeAdd = 1.4;
			} else if (baseFeeTime > 22 * 60) {
				baseFeeAdd = 1.2;
			} else {
				baseFeeAdd = 1.0;
			}
			return ((int)(baseFeeAdd * 3800)) + additionalFee;
		case "B":
			baseFee = 1400;
		case "S":
			if (baseFee == 0) {
				baseFee = 1450;
			}
			return baseFee + 200 * (this.transTime / 20);
		case "C":
		case "R":
			// 렌트 비용은 여행 전체에 대해 한 번 부과되므로 연료비만 계산
			return (int)(Math.ceil((double)this.transTime / 10)) * 500;
		}
		return 0;
	}
	
	private int[] getParsedTravelTime() {
		String[] split = this.travelTime.split(":");
		return new int[] {
				Integer.parseInt(split[0]),
				Integer.parseInt(split[1])
		};
	}
	@Override
	public String toString() {
		return "TravelInfoVo [travelSeq=" + travelSeq + ", seq=" + seq + ", travelDay=" + travelDay + ", travelTime="
				+ travelTime + ", travelCity=" + travelCity + ", travelCounty=" + travelCounty + ", travelLoc="
				+ travelLoc + ", travelTrans=" + travelTrans + ", transTime=" + transTime + ", useTime=" + useTime
				+ ", useExpend=" + useExpend + ", travelDetail=" + travelDetail + ", request=" + request + "]";
	}
}
