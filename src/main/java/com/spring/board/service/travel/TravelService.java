package com.spring.board.service.travel;

import java.util.List;
import java.util.Map;

import com.spring.board.vo.travel.ClientVo;
import com.spring.board.vo.travel.TravelInfoVo;

public interface TravelService {

	public List<ClientVo> getClients() throws Exception;
	
	public ClientVo getClient(String userName, String userPhone) throws Exception;
	
	public List<TravelInfoVo> getTravelInfosOfUser(String userSeq) throws Exception;
	
	public List<TravelInfoVo> getTravelInfosOfClientAndDay(String clientSeq, int day) throws Exception;
	
	public long getEstimateOfClient(String clientSeq) throws Exception;
	
	public int insertClientInfo(ClientVo clientVo) throws Exception;
	
	public int updateTravelInfos(List<TravelInfoVo> travelInfos) throws Exception;
	
	public int updateTraveInfoRequests(List<Map<String, Object>> updateParams) throws Exception;
	
	public int deleteTravelInfosOfClientByDay(String clientSeq, int day) throws Exception;
}
