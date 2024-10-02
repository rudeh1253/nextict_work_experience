package com.spring.board.service.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.board.dao.BoardDao;
import com.spring.board.service.BoardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.MbtiResultVo;

@Service
public class BoardServiceImpl implements BoardService{
	
	@Autowired
	BoardDao boardDao;

	@Override
	public List<BoardVo> selectQuestionsOfType(List<String> questionTypes) throws Exception {
		return this.boardDao.selectQuestionsOfType(questionTypes);
	}
	
	@Override
	public MbtiResultVo computeResult(Map<BoardVo, Integer> toComputer) throws Exception {
		Map<String, Integer> scoreSum = buildBaseScoreSumMap();
		
		for (Map.Entry<BoardVo, Integer> entry : toComputer.entrySet()) {
			addSingleScore(entry.getKey().getBoardType(), entry.getValue(), scoreSum);
		}
		
		System.out.println("scoreSum.size=" + scoreSum.size());
		for (Map.Entry<String, Integer> entry : scoreSum.entrySet()) {
			System.out.println(entry.getKey() + "=" + entry.getValue());
		}
		
		MbtiResultVo mbtiResultVo = new MbtiResultVo();
		mbtiResultVo.setMbti1(determineSingleMbti("IE", scoreSum));
		mbtiResultVo.setMbti2(determineSingleMbti("SN", scoreSum));
		mbtiResultVo.setMbti3(determineSingleMbti("TF", scoreSum));
		mbtiResultVo.setMbti4(determineSingleMbti("PJ", scoreSum));
		
		return mbtiResultVo;
	}
	
	private Map<String, Integer> buildBaseScoreSumMap() {
		Map<String, Integer> map = new HashMap<>();
		map.put("E", 0);
		map.put("I", 0);
		
		map.put("N", 0);
		map.put("S", 0);
		
		map.put("F", 0);
		map.put("T", 0);
		
		map.put("J", 0);
		map.put("P", 0);
		
		return map;
	}
	
	private void addSingleScore(String type, Integer score, Map<String, Integer> accumulator) throws Exception {
		checkIfAllowedType(type);
		
		String[] split = type.split("");
		
		String agreementSide = split[0];
		String disagreementSide = split[1];
		incrementScore(agreementSide, disagreementSide, score, accumulator);
	}
	
	private void incrementScore(String agreementSide, String disagreementSide, int score, Map<String, Integer> accumulator) {
		switch (score) {
		case 7: // 매우 동의
			accumulator.put(agreementSide, accumulator.get(agreementSide) + 3);
			break;
		case 6: // 동의
			accumulator.put(agreementSide, accumulator.get(agreementSide) + 2);
			break;
		case 5: // 약간 동의
			accumulator.put(agreementSide, accumulator.get(agreementSide) + 1);
			break;
		case 4: // 모르겠음
			// 둘 다 +0점 => 아무것도 할 필요 없음
		case 3: // 약간 비동의
			accumulator.put(disagreementSide, accumulator.get(disagreementSide) + 1);
			break;
		case 2: // 비동의
			accumulator.put(disagreementSide, accumulator.get(disagreementSide) + 2);
			break;
		case 1: // 매우 비동의
			accumulator.put(disagreementSide, accumulator.get(disagreementSide) + 3);
			break;
		default:
			break;
		}
	}
	
	private String determineSingleMbti(String type, Map<String, Integer> scoreSum) throws Exception {
		checkIfAllowedType(type);
		
		String[] split = type.split("");
		
		String type1 = split[0];
		String type2 = split[1];
		
		Integer type1Score = scoreSum.get(type1);
		Integer type2Score = scoreSum.get(type2);
		
		if (type1Score == type2Score) {
			String lexicographicallyPreceding = type1.compareTo(type2) < 0 ? type1 : type2;
			
			return lexicographicallyPreceding;
		}
		
		return type1Score >= type2Score ? type1 : type2;
	}
	
	private void checkIfAllowedType(String type) throws Exception {
		List<String> allowedTypes = Arrays.asList("EI", "IE", "NS", "SN", "TF", "FT", "PJ", "JP");
		if (!allowedTypes.contains(type)) {
			throw new Exception("허용되지 않는 타입: " + type);
		}
	}
}
