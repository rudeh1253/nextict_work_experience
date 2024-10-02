package com.spring.board.vo;

public class MbtiResultVo {
	private String mbti1;
	private String mbti2;
	private String mbti3;
	private String mbti4;
	
	public String getMbti1() {
		return mbti1;
	}
	public void setMbti1(String mbti1) {
		this.mbti1 = mbti1;
	}
	public String getMbti2() {
		return mbti2;
	}
	public void setMbti2(String mbti2) {
		this.mbti2 = mbti2;
	}
	public String getMbti3() {
		return mbti3;
	}
	public void setMbti3(String mbti3) {
		this.mbti3 = mbti3;
	}
	public String getMbti4() {
		return mbti4;
	}
	public void setMbti4(String mbti4) {
		this.mbti4 = mbti4;
	}
	@Override
	public String toString() {
		return "MbtiResultVo [mbti1=" + mbti1 + ", mbti2=" + mbti2 + ", mbti3=" + mbti3 + ", mbti4=" + mbti4 + "]";
	}
}
