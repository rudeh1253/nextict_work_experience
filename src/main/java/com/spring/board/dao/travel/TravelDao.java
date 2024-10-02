package com.spring.board.dao.travel;

import java.util.List;
import java.util.Map;

import com.spring.board.vo.travel.ClientVo;
import com.spring.board.vo.travel.TravelInfoVo;

public interface TravelDao {

	public int insertClientInfo(ClientVo clientVo) throws Exception;
	
	public List<ClientVo> selectClients() throws Exception;
	
	public ClientVo selectClient(Map<String, Object> paramMap) throws Exception;
	
	public ClientVo selectClientBySeq(String seq) throws Exception;
	
	public List<TravelInfoVo> selectTravelInfosByClientSeq(String seq) throws Exception;
	
	public int insertTravelInfo(Map<String, String> insertParams) throws Exception;
	
	public int deleteTravelInfo(String clientSeq) throws Exception;
	
	public int deleteTravelInfoBySeqAndDay(Map<String, Object> paramMap) throws Exception;
	
	public int updateTravelInfoRequest(Map<String, Object> updateParams) throws Exception;
}
