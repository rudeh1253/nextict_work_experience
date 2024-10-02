package com.spring.board.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.function.Consumer;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.service.ResumeService;
import com.spring.board.vo.AdditionalInfoVo;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.RecruitVo;
import com.spring.common.CommonUtil;

@Controller
public class ResumeController {
	private static final Map<String, String> LOCATION_MAP = new TreeMap<>();
	
	static {
		LOCATION_MAP.put("01_SEOUL", "서울");
		LOCATION_MAP.put("02_DAJEON", "대전");
		LOCATION_MAP.put("03_INCHEON", "인천");
		LOCATION_MAP.put("04_DAEGU", "대구");
		LOCATION_MAP.put("05_BUSAN", "부산");
		LOCATION_MAP.put("06_GWANGJU", "광주");
		LOCATION_MAP.put("07_ULSAN", "울산");
		LOCATION_MAP.put("08_GYEONGI", "경기");
		LOCATION_MAP.put("09_JEONNAM", "전남");
		LOCATION_MAP.put("10_JEONBUK", "전북");
		LOCATION_MAP.put("11_CHUNGNAM", "충남");
		LOCATION_MAP.put("12_CHUNGBUK", "충북");
		LOCATION_MAP.put("13_GYEONGNAM", "경남");
		LOCATION_MAP.put("14_GYEONGBUK", "경북");
		LOCATION_MAP.put("15_GANGWON", "강원");
		LOCATION_MAP.put("16_JEJU", "제주");
		LOCATION_MAP.put("17_ETC", "기타");
	}

	@Autowired
	private ResumeService resumeService;
	
	@RequestMapping(value = "/resume/loginView.do", method = RequestMethod.GET)
	public String loginView() throws Exception {
		return "resume/login";
	}
	
	@RequestMapping(value = "/resume/loginAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String loginAction(@RequestBody Map<String, String> loginInfo, HttpSession session) throws Exception {
		
		session.setAttribute("name", loginInfo.get("name"));
		session.setAttribute("phone", loginInfo.get("phone"));
		
		return "{\"success\":\"Y\"}";
	}
	
	@RequestMapping(value = "/resume/mainView.do", method = RequestMethod.GET)
	public String mainView(Model model, HttpSession session) throws Exception {
		String name = (String)session.getAttribute("name");
		String phone = (String)session.getAttribute("phone");
		
		if (name == null
				|| phone == null) {
			return "redirect:/resume/loginView.do";
		}
		
		RecruitVo recruitVo =
				this.resumeService.selectRecruitByNameAndPhone((String)session.getAttribute("name"), (String)session.getAttribute("phone"));
		
		model.addAttribute("recruitVo", recruitVo);
		model.addAttribute("name", name);
		model.addAttribute("phone", phone);
		model.addAttribute("locationSelections", LOCATION_MAP);
		
		if (recruitVo != null) {
			AdditionalInfoVo additionalInfo = this.resumeService.generateAdditionalInfo(recruitVo);
			model.addAttribute("additionalInfo", additionalInfo);
		}
		
		return "resume/main";
	}
	
	@RequestMapping(value = "/resume/writeRecruit.do", method = RequestMethod.POST)
	@ResponseBody
	public String writeRecruit(@RequestBody RecruitVo recruitVo) throws Exception {
		int resultCnt = this.resumeService.insertRecruit(recruitVo);
		
		Map<String, String> result = new HashMap<>();
		CommonUtil commonUtil = new CommonUtil();
		
		commonUtil.getJsonCallBackString(null, commonUtil);
		
		result.put("success", (resultCnt > 0) ? "Y" : "N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
		
		System.out.println("callbackMsg::" + callbackMsg);
		return callbackMsg;
	}
	
	@RequestMapping(value = "/resume/updateRecruit.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateRecruit(@RequestBody RecruitVo recruitVo) throws Exception {
		int resultCnt = this.resumeService.updateRecruit(recruitVo);
		
		Map<String, String> result = new HashMap<>();
		CommonUtil commonUtil = new CommonUtil();
		
		commonUtil.getJsonCallBackString(null, commonUtil);
		
		result.put("success", (resultCnt > 0) ? "Y" : "N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
		
		System.out.println("callbackMsg::" + callbackMsg);
		return callbackMsg;
	}
}
