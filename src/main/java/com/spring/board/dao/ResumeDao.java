package com.spring.board.dao;

import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.RecruitVo;

public interface ResumeDao {
	
	public int insertRecruit(RecruitVo recruitVo) throws Exception;

	public int insertCertificate(CertificateVo certificateVo) throws Exception;
	
	public int insertEducation(EducationVo educationVo) throws Exception;
	
	public int insertCareer(CareerVo careerVo) throws Exception;
	
	public int updateRecruit(RecruitVo recruitVo) throws Exception;
	
	public int deleteCertificate(String seq) throws Exception;
	
	public int deleteEducation(String seq) throws Exception;
	
	public int deleteCareer(String seq) throws Exception;
	
	public RecruitVo selectRecruitVoByNameAndPhone(String name, String phone);
}
