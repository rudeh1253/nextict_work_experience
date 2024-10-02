package com.spring.board.service.travel.impl;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.board.dao.travel.TravelDao;
import com.spring.board.service.travel.TravelService;
import com.spring.board.vo.travel.ClientVo;
import com.spring.board.vo.travel.TravelInfoVo;

@Service
public class TravelServiceImpl implements TravelService {
	
	@Autowired
	private TravelDao travelDao;

	@Override
	public List<ClientVo> getClients() throws Exception {
		List<ClientVo> clients = this.travelDao.selectClients();
		for (ClientVo client : clients) {
			List<TravelInfoVo> travelInfos = this.travelDao.selectTravelInfosByClientSeq(client.getSeq());
			client.setTravelInfos(travelInfos);
		}
		return clients;
	}
	
	@Override
	public ClientVo getClient(String userName, String userPhone) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("userName", userName);
		params.put("userPhone", userPhone);
		ClientVo client = this.travelDao.selectClient(params);
		if (client != null) {
			List<TravelInfoVo> travelInfos = this.travelDao.selectTravelInfosByClientSeq(client.getSeq());
			client.setTravelInfos(travelInfos);
		}
		return client;
	}
	
	@Override
	public List<TravelInfoVo> getTravelInfosOfUser(String userSeq) throws Exception {
		return this.travelDao.selectTravelInfosByClientSeq(userSeq);
	}
	
	@Override
	public List<TravelInfoVo> getTravelInfosOfClientAndDay(String clientSeq, int day) throws Exception {
		List<TravelInfoVo> ofClient = this.travelDao.selectTravelInfosByClientSeq(clientSeq);
		List<TravelInfoVo> ofDay = new ArrayList<>();
		for (TravelInfoVo travelInfo : ofClient) {
			if (travelInfo.getTravelDay() == day) {
				ofDay.add(travelInfo);
			}
		}
		return ofDay;
	}
	
	@Override
	public long getEstimateOfClient(String clientSeq) throws Exception {
		ClientVo client = this.travelDao.selectClientBySeq(clientSeq);
		List<TravelInfoVo> ofClient = this.travelDao.selectTravelInfosByClientSeq(clientSeq);
		client.setTravelInfos(ofClient);
		return client.getEstimatedExpenses();
	}

	@Override
	public int insertClientInfo(ClientVo clientVo) throws Exception {
		return this.travelDao.insertClientInfo(clientVo);
	}

	@Override
	public int updateTravelInfos(List<TravelInfoVo> travelInfos) throws Exception {
		TravelInfoVo firstItem = travelInfos.get(0);
		String seq = firstItem.getSeq();
		int travelDay = firstItem.getTravelDay();
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("seq", seq);
		paramMap.put("travelDay", travelDay);
		
		int rowsAffected = this.travelDao.deleteTravelInfoBySeqAndDay(paramMap);
		
		for (TravelInfoVo travelInfo : travelInfos) {
			int rows = this.travelDao.insertTravelInfo(generateParamMapFromVo(travelInfo));
			rowsAffected += rows;
		}
		return rowsAffected;
	}
	
	private Map<String, String> generateParamMapFromVo(Object vo) throws IllegalArgumentException, IllegalAccessException {
		Field[] fields = vo.getClass().getDeclaredFields();
		Map<String, String> paramMap = new HashMap<>();
		for (Field field : fields) {
			field.setAccessible(true);
			Object value = field.get(vo);
			paramMap.put(field.getName(),value == null ? null : String.valueOf(value));
		}
		return paramMap;
	}
	
	@Override
	public int updateTraveInfoRequests(List<Map<String, Object>> updateParams) throws Exception {
		int affectedRows = 0;
		for (Map<String, Object> updateParam : updateParams) {
			int row = this.travelDao.updateTravelInfoRequest(updateParam);
			affectedRows += row;
		}
		return affectedRows;
	}
	
	@Override
	public int deleteTravelInfosOfClientByDay(String clientSeq, int day) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("seq", clientSeq);
		paramMap.put("travelDay", day);
		return this.travelDao.deleteTravelInfoBySeqAndDay(paramMap);
	}
}
