package com.spring.board.service;

import java.util.List;
import java.util.Map;

import com.spring.board.vo.BoardVo;
import com.spring.board.vo.MbtiResultVo;

public interface BoardService {

	public List<BoardVo> selectQuestionsOfType(List<String> questionTypes) throws Exception;
	
	public MbtiResultVo computeResult(Map<BoardVo, Integer> toComputer) throws Exception;
}
