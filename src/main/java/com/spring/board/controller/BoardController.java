package com.spring.board.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.board.HomeController;
import com.spring.board.service.BoardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.MbtiResultVo;
import com.spring.common.CommonUtil;

@Controller
public class BoardController {
	
	@Autowired 
	BoardService boardService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private static final String SELECTION_CACHE_SESSION_KEY = "selectionCache";
	
	@RequestMapping(value = "/mbti/questionList.do", method = RequestMethod.GET)
	public ModelAndView questionList(@RequestParam(value = "currentQuestionType", required = false) String currentQuestionType) throws Exception {
		System.out.println("currentQuestionType=" + currentQuestionType);
		List<String> questionTypes = getNextQuestionTypeSet(currentQuestionType != null ? currentQuestionType : "");
		List<BoardVo> nextQuestions = this.boardService.selectQuestionsOfType(questionTypes);
		
		System.out.println("nextQuestions=" + nextQuestions);
		
		ModelAndView mv = new ModelAndView("mbti/mbtiQuestionList");
		mv.addObject("questionTypes", questionTypes);
		mv.addObject("questions", nextQuestions);
		mv.addObject("isFinal", currentQuestionType != null
				&& (currentQuestionType.equals("TF") || currentQuestionType.equals("FT")));
		
		System.out.println("isFinal=" + mv.getModel().get("isFinal"));
		
		return mv;
	}
	
	private List<String> getNextQuestionTypeSet(String current) {
		switch (current) {
		case "IE":
		case "EI":
			return Arrays.asList("NS", "SN");
		case "NS":
		case "SN":
			return Arrays.asList("TF", "FT");
		case "TF":
		case "FT":
			return Arrays.asList("JP", "PJ");
		default:
			return Arrays.asList("IE", "EI");
		}
	}
	
	@RequestMapping(value = "/mbti/submitAnswerList.do", method = RequestMethod.POST)
	@ResponseBody
	public String submitAnswerList(HttpSession session, @RequestBody List<Map<String, Object>> requestBody) throws Exception {
		Map<BoardVo, Integer> selectionCache = (Map<BoardVo, Integer>)session.getAttribute(SELECTION_CACHE_SESSION_KEY);
		System.out.println("=========================");
		System.out.println("From session: ");
		printCurrentState(selectionCache);
		System.out.println("=========================");
		if (selectionCache == null) {
			selectionCache = new HashMap<>();
			session.setAttribute(SELECTION_CACHE_SESSION_KEY, selectionCache);
		}
		
		for (Map<String, Object> bodyUnit : requestBody) {
			BoardVo boardVo = new BoardVo();
			boardVo.setBoardType(bodyUnit.get("boardType").toString());
			boardVo.setBoardNum(Integer.parseInt(bodyUnit.get("boardNum").toString()));
			int score = Integer.parseInt(bodyUnit.get("score").toString());
			selectionCache.put(boardVo, score);
		}
		
		System.out.println("=========================");
		System.out.println("selectionCache: ");
		printCurrentState(selectionCache);
		System.out.println("=========================");
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		result.put("success", "Y");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	
	private void printCurrentState(Map<BoardVo, Integer> state) {
		if (state == null) {
			System.out.println("state is null");
			return;
		}
		System.out.println("size=" + state.size());
		for (Map.Entry<BoardVo, Integer> entry : state.entrySet()) {
			System.out.println("boardType=" + entry.getKey().getBoardType());
			System.out.println("boardNum=" + entry.getKey().getBoardNum());
			System.out.println("score=" + entry.getValue());
			System.out.println();
		}
	}
	
	@RequestMapping(value = "/mbti/mbtiResultView.do", method = RequestMethod.GET)
	public ModelAndView mbtiResultView(HttpSession session) throws Exception {
		ModelAndView mv = new ModelAndView("mbti/mbtiResultView");
		
		Map<BoardVo, Integer> result = (Map<BoardVo, Integer>)session.getAttribute(SELECTION_CACHE_SESSION_KEY);
		if (result == null) {
			mv.addObject("isCompleted", false);
			return mv;
		}
		
		MbtiResultVo mbtiResultVo = this.boardService.computeResult(result);
		
		mv.addObject("mbtiResultVo", mbtiResultVo);
		
		session.removeAttribute(SELECTION_CACHE_SESSION_KEY);
		
		System.out.println("mbti1=" + mbtiResultVo.getMbti1());
		System.out.println("mbti2=" + mbtiResultVo.getMbti2());
		System.out.println("mbti3=" + mbtiResultVo.getMbti3());
		System.out.println("mbti4=" + mbtiResultVo.getMbti4());
		
		mv.addObject("isCompleted", true);
		
		return mv;
	}
}
