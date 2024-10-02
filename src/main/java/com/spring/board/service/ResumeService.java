package com.spring.board.service;

import com.spring.board.vo.AdditionalInfoVo;
import com.spring.board.vo.RecruitVo;

public interface ResumeService {
	
	public int insertRecruit(RecruitVo recruitVo) throws Exception;
	
	public RecruitVo selectRecruitByNameAndPhone(String name, String phone) throws Exception;
	
	public int updateRecruit(RecruitVo recruitVo) throws Exception;
	
	public AdditionalInfoVo generateAdditionalInfo(RecruitVo recruitVo) throws Exception;
}
