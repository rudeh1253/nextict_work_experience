package com.spring.board.dao;

import java.util.List;

import com.spring.board.vo.BoardVo;

public interface BoardDao {

	public List<BoardVo> selectQuestionsOfType(List<String> types) throws Exception;
}
