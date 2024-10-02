package com.spring.board.dao.travel.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.board.dao.travel.TravelDao;
import com.spring.board.vo.travel.ClientVo;
import com.spring.board.vo.travel.TravelInfoVo;

@Repository
public class TravelDaoImpl implements TravelDao {
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public int insertClientInfo(ClientVo clientVo) throws Exception {
		return this.sqlSession.insert("travel.insertClientInfo", clientVo);
	}

	@Override
	public List<ClientVo> selectClients() throws Exception {
		return this.sqlSession.selectList("travel.selectClients");
	}
	
	@Override
	public ClientVo selectClient(Map<String, Object> paramMap) throws Exception {
		return this.sqlSession.selectOne("travel.selectClient", paramMap);
	}

	@Override
	public ClientVo selectClientBySeq(String seq) throws Exception {
		return this.sqlSession.selectOne("travel.selectClientBySeq", seq);
	}

	@Override
	public List<TravelInfoVo> selectTravelInfosByClientSeq(String seq) throws Exception {
		return this.sqlSession.selectList("travel.selectTravelInfosByClientSeq", seq);
	}

	@Override
	public int insertTravelInfo(Map<String, String> insertParams) throws Exception {
		return this.sqlSession.insert("travel.insertTravelInfo", insertParams);
	}

	@Override
	public int deleteTravelInfo(String clientSeq) throws Exception {
		return this.sqlSession.delete("travel.deleteTravelInfosOfClient", clientSeq);
	}
	
	public int deleteTravelInfoBySeqAndDay(Map<String, Object> paramMap) throws Exception {
		return this.sqlSession.delete("travel.deleteTravelInfoBySeqAndDay", paramMap);
	}
	
	@Override
	public int updateTravelInfoRequest(Map<String, Object> updateParams) throws Exception {
		return this.sqlSession.update("travel.updateTravelInfoRequest", updateParams);
	}
}
