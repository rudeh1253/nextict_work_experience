package com.spring.board.service.impl;

import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.board.dao.ResumeDao;
import com.spring.board.service.ResumeService;
import com.spring.board.vo.AdditionalInfoVo;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.RecruitVo;

@Service
public class ResumeServiceImpl implements ResumeService {
	
	@Autowired
	private ResumeDao resumeDao;

	@Override
	public int insertRecruit(RecruitVo recruitVo) throws Exception {
		int recruitRow = this.resumeDao.insertRecruit(recruitVo);
		
		System.out.println("Generated SEQ:" + recruitVo.getSeq());
		
		int careerRow = insertCareers(recruitVo.getCareers(), recruitVo.getSeq());
		
		int certificateRow = insertCertificates(recruitVo.getCertificates(), recruitVo.getSeq());
		
		int educationRow = insertEducations(recruitVo.getEducations(), recruitVo.getSeq());
		
		return recruitRow + careerRow + certificateRow + educationRow;
	}

	@Override
	public RecruitVo selectRecruitByNameAndPhone(String name, String phone) throws Exception {
		return this.resumeDao.selectRecruitVoByNameAndPhone(name, phone);
	}

	@Override
	public int updateRecruit(RecruitVo recruitVo) throws Exception {
		int updatedRow = this.resumeDao.updateRecruit(recruitVo);
		
		this.resumeDao.deleteCertificate(recruitVo.getSeq());
		this.resumeDao.deleteCareer(recruitVo.getSeq());
		this.resumeDao.deleteEducation(recruitVo.getSeq());
		
		int certificateRow = insertCertificates(recruitVo.getCertificates(), recruitVo.getSeq());
		int educationRow = insertEducations(recruitVo.getEducations(), recruitVo.getSeq());
		int careerRow = insertCareers(recruitVo.getCareers(), recruitVo.getSeq());
		
		return updatedRow + certificateRow + educationRow + careerRow;
	}
	
	private int insertCertificates(Collection<CertificateVo> certificates, String seq) throws Exception {
		int certificateRow = 0;
		for (CertificateVo certVo : certificates) {
			certVo.setSeq(seq);
			int singleCertRow = this.resumeDao.insertCertificate(certVo);
			certificateRow += singleCertRow;
		}
		return certificateRow;
	}
	
	private int insertEducations(Collection<EducationVo> educations, String seq) throws Exception {
		int educationRow = 0;
		for (EducationVo eduVo : educations) {
			eduVo.setSeq(seq);
			int singleEduRow = this.resumeDao.insertEducation(eduVo);
			educationRow += singleEduRow;
		}
		return educationRow;
	}
	
	private int insertCareers(Collection<CareerVo> careers, String seq) throws Exception {
		int careerRow = 0;
		for (CareerVo careerVo : careers) {
			careerVo.setSeq(seq);
			int singleCareerRow = this.resumeDao.insertCareer(careerVo);
			careerRow += singleCareerRow;
		}
		return careerRow;
	}

	@Override
	public AdditionalInfoVo generateAdditionalInfo(RecruitVo recruitVo) throws Exception {
		AdditionalInfoVo additionalInfoVo = new AdditionalInfoVo();
		
		additionalInfoVo.setEducationInfo(getEducationInfo(recruitVo.getEducations()));
		additionalInfoVo.setCareerInfo(getCareerInfo(recruitVo.getCareers()));
		additionalInfoVo.setDesiredLocation(recruitVo.getLocation());
		additionalInfoVo.setWorkType(recruitVo.getWorkType());
		
		return additionalInfoVo;
	}
	
	private String getEducationInfo(List<EducationVo> educations) {
		if (educations.isEmpty()) {
			return "학력사항 없음";
		}
		
		EducationVo mostRecent = educations.get(0);
		for (int i = 1; i < educations.size(); i++) {
			EducationVo educationVo = educations.get(i);
			
			System.out.println(educationVo.getEndPeriod());
			System.out.println(mostRecent.getEndPeriod());
			
			if (Integer.parseInt(educationVo.getEndPeriod().split("\\.")[0]) > Integer.parseInt(mostRecent.getEndPeriod().split("\\.")[0])) {
				mostRecent = educationVo;
			}
		}
		
		String[] startPeriodSplit = mostRecent.getStartPeriod().split("\\.");
		String[] endPeriodSplit = mostRecent.getEndPeriod().split("\\.");
		
		int yearGap = Integer.parseInt(endPeriodSplit[0]) - Integer.parseInt(startPeriodSplit[0]);
		
		Map<String, String> codeToValue = new HashMap<>();
		codeToValue.put("ENROLLED_IN", "재학");
		codeToValue.put("DROPPED_OUT", "중퇴");
		codeToValue.put("GRADUATED", "졸업");
		
		String schoolName = mostRecent.getSchoolName();
		
		if (schoolName.endsWith("대학교") || schoolName.endsWith("대") || schoolName.endsWith("대학")) {
			return "대학교(" + yearGap + "년) " + codeToValue.get(mostRecent.getDivision());
		} else if (schoolName.endsWith("고") || schoolName.endsWith("고등학교")) {
			return "고등학교(" + yearGap + "년)" + codeToValue.get(mostRecent.getDivision());
		} else {
			return "학교(" + yearGap + "년)" + codeToValue.get(mostRecent.getDivision());
		}
	}
	
	private String getCareerInfo(List<CareerVo> careers) {
		int years = 0;
		int months = 0;
		
		for (CareerVo career : careers) {
			String[] startPeriodSplit = career.getStartPeriod().split("\\.");
			String[] endPeriodSplit = career.getEndPeriod().split("\\.");
			
			years += Integer.parseInt(endPeriodSplit[0]) - Integer.parseInt(startPeriodSplit[0]);
			months += Integer.parseInt(endPeriodSplit[1]) - Integer.parseInt(startPeriodSplit[1]) + 1;
		}
		
		years += (months < 0 ? -1 : months / 12);
		months = (months + 12) % 12;
		
		return "경력 " + years + "년 " + months + "개월";
	}
}
