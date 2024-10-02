package com.spring.board.dao.impl;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.board.dao.ResumeDao;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.RecruitVo;

@Repository
public class ResumeDaoImpl implements ResumeDao {
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public int insertRecruit(RecruitVo recruitVo) throws Exception {
		return this.sqlSession.insert("recruit.insertRecruit", recruitVo);
	}

	@Override
	public int insertCertificate(CertificateVo certificateVo) throws Exception {
		return this.sqlSession.insert("certificate.insertCertificate", certificateVo);
	}

	@Override
	public int insertEducation(EducationVo educationVo) throws Exception {
		return this.sqlSession.insert("education.insertEducation", educationVo);
	}

	@Override
	public int insertCareer(CareerVo careerVo) throws Exception {
		return this.sqlSession.insert("career.insertCareer", careerVo);
	}

	@Override
	public int updateRecruit(RecruitVo recruitVo) throws Exception {
		return this.sqlSession.update("recruit.updateRecruit", recruitVo);
	}

	@Override
	public int deleteCertificate(String seq) throws Exception {
		return this.sqlSession.delete("certificate.deleteCertificate", seq);
	}

	@Override
	public int deleteEducation(String seq) throws Exception {
		return this.sqlSession.delete("education.deleteEducation", seq);
	}

	@Override
	public int deleteCareer(String seq) throws Exception {
		return this.sqlSession.delete("career.deleteCareer", seq);
	}

	@Override
	public RecruitVo selectRecruitVoByNameAndPhone(String name, String phone) {
		Map<String, Object> params = new HashMap<>();
		params.put("name", name);
		params.put("phone", phone);
		return this.sqlSession.selectOne("recruit.selectRecruit", params);
	}
}
