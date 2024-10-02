package com.spring.board.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.board.dao.BoardDao;
import com.spring.board.vo.BoardVo;

@Repository
public class BoardDaoImpl implements BoardDao{
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<BoardVo> selectQuestionsOfType(List<String> types) throws Exception {
		return this.sqlSession.selectList("mbti.selectQuestionsOfType", types);
	}
}
