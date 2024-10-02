package com.spring.board.controller;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.service.travel.TravelService;
import com.spring.board.vo.travel.ClientVo;
import com.spring.board.vo.travel.TravelInfoVo;
import com.spring.common.CommonUtil;

@Controller
public class TravelController {
	private static final Map<String, String> TRANSPORT_LIST;
	private static final Map<String, List<String>> LOCATION_LIST;
	private static final Map<String, String> TRAVEL_TRASPORT_LIST;
	
	static {
		Map<String, String> transportListCache = new HashMap<>();
		transportListCache.put("R", "렌트");
		transportListCache.put("B", "대중교통");
		transportListCache.put("C", "자차");
		
		TRANSPORT_LIST = Collections.unmodifiableMap(transportListCache);
		
		Map<String, List<String>> locationListCache = new HashMap<>();
		locationListCache.put("서울", Arrays.asList("서울시"));
		locationListCache.put("대전", Arrays.asList("대전시"));
		locationListCache.put("인천", Arrays.asList("인천시"));
		locationListCache.put("대구", Arrays.asList("대구시"));
		locationListCache.put("부산", Arrays.asList("부산시"));
		locationListCache.put("광주", Arrays.asList("광주시"));
		locationListCache.put("울산", Arrays.asList("울산시"));
		locationListCache.put("경기", Arrays.asList("성남시", "수원시", "과천시", "남양주시", "부천시", "동두천시"));
		locationListCache.put("전남", Arrays.asList("목포시", "여수시", "순천시", "나주시", "보성군", "화순군", "장흥군", "무안군"));
		locationListCache.put("전북", Arrays.asList("전주시", "익산시", "군산시", "임실군", "순창군", "무주군", "진안군", "완주군"));
		locationListCache.put("충남", Arrays.asList("천안시", "공주시", "보령시", "아산시", "서산시", "부여군", "서천군", "태안군"));
		locationListCache.put("충북", Arrays.asList("청주시", "충주시", "보은군", "온천군", "진천군", "단양군"));
		locationListCache.put("강원", Arrays.asList("원주시", "춘천시", "강릉시", "동해시", "속초시", "태백시", "평창군", "정선군"));
		locationListCache.put("제주도", Arrays.asList("제주시", "서귀포시"));
		
		LOCATION_LIST = Collections.unmodifiableMap(locationListCache);
		
		Map<String, String> travelTransportListCache = new HashMap<>();
		travelTransportListCache.put("W", "도보");
		travelTransportListCache.put("B", "버스");
		travelTransportListCache.put("S", "지하철");
		travelTransportListCache.put("T", "택시");
		travelTransportListCache.put("R", "렌트");
		travelTransportListCache.put("C", "자차");
		
		TRAVEL_TRASPORT_LIST = Collections.unmodifiableMap(travelTransportListCache);
	}
	
	@Autowired
	private TravelService travelService;

	@RequestMapping(value = "/travel/loginView.do", method = RequestMethod.GET)
	public String loginView() {
		return "travel/loginView";
	}
	
	@RequestMapping(value = "/travel/loginAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String loginAction(@RequestBody ClientVo clientVo, HttpSession session) throws Exception {
		session.setAttribute("loginClient", clientVo);
		
		Map<String, String> result = new HashMap<>();
		
		result.put("message", "success");
		
		System.out.println("loginClient from session = " + session.getAttribute("loginClient"));
		
		return CommonUtil.toJson(result);
	}
	
	@RequestMapping(value = "/travel/logoutAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String logoutAction(HttpSession session) {
		session.removeAttribute("loginClient");
		return "{\"message\": \"success\"}";
	}
	
	@RequestMapping(value = "/travel/estimateView.do", method = RequestMethod.GET)
	public String estimateView(Model model, HttpSession session) throws Exception {
		ClientVo loginClient = (ClientVo)session.getAttribute("loginClient");
		
		model.addAttribute("hasLoggedIn", loginClient != null);
		
		if (loginClient != null) {
			model.addAttribute("userName", loginClient.getUserName());
			model.addAttribute("userPhone", loginClient.getUserPhone());
			model.addAttribute("transportList", TRANSPORT_LIST);
			model.addAttribute("locationList", LOCATION_LIST);
			model.addAttribute("travelTransportList", TRAVEL_TRASPORT_LIST);
			model.addAttribute("clientInfo", this.travelService.getClient(loginClient.getUserName(), loginClient.getUserPhone()));
		}
		
		return "travel/estimateView";
	}
	
	@RequestMapping(value = "/travel/getEstimatedExpensesOfClient.do", method = RequestMethod.GET)
	@ResponseBody
	public String getEstimatedExpensesOfClient(@RequestParam("clientSeq") String clientSeq) throws Exception {
		long sum = this.travelService.getEstimateOfClient(clientSeq);
		
		Map<String, Object> result = new HashMap<>();
		result.put("estimateAmount", sum);
		return CommonUtil.toJson(result);
	}
	
	@RequestMapping(value = "/travel/applyEstimate.do", method = RequestMethod.POST)
	@ResponseBody
	public String applyEstimate(@RequestBody ClientVo clientVo) throws Exception {
		int rowImpacted = this.travelService.insertClientInfo(clientVo);
		
		Map<String, Object> result = new HashMap<>();
		result.put("message", String.format("Impacted rows: %d", rowImpacted));
		return CommonUtil.toJson(result);
	}
	
	@RequestMapping(value = "/travel/scheduleManagementView.do", method = RequestMethod.GET)
	public String scheduleManagementView(Model model) throws Exception {
		List<ClientVo> clients = this.travelService.getClients();
		
		model.addAttribute("clients", clients);
		model.addAttribute("transportList", TRANSPORT_LIST);
		model.addAttribute("locationList", LOCATION_LIST);
		model.addAttribute("travelTransportList", TRAVEL_TRASPORT_LIST);
		
		return "travel/scheduleManagementView";
	}
	
	@RequestMapping(value = "/travel/getSchedules.do", method = RequestMethod.GET)
	@ResponseBody
	public List<TravelInfoVo> getSchedules(
			@RequestParam("seq") String seq,
			@RequestParam(value = "travelDay", required = false) Integer travelDay
	) throws Exception {
		return travelDay == null
				? this.travelService.getTravelInfosOfUser(seq)
				: this.travelService.getTravelInfosOfClientAndDay(seq, travelDay);
	}
	
	@RequestMapping(value = "/travel/updateSchedules.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateSchedules(@RequestBody List<Map<String, Object>> requestBody) throws Exception {
		List<TravelInfoVo> travelInfos = new ArrayList<>();
		for (Map<String, Object> item : requestBody) {
			travelInfos.add(mapToVo(item));
		}
		
		int rowAffected = this.travelService.updateTravelInfos(travelInfos);
		
		Map<String, Object> result = new HashMap<>();
		result.put("message", String.format("Affected rows: %d", rowAffected));
		return CommonUtil.toJson(result);
	}
	
	private TravelInfoVo mapToVo(Map<String, Object> map) throws Exception {
		Field[] travelInfoVoFields = TravelInfoVo.class.getDeclaredFields();
		TravelInfoVo travelInfoVo = new TravelInfoVo();
		for (Field field : travelInfoVoFields) {
			field.setAccessible(true);
			
			String fieldName = field.getName();
			Object value = map.get(fieldName);
			
			if (value == null) {
				if (field.getType().isPrimitive() && field.getType() == Integer.TYPE) {
					value = 0;
				}
			} else {
				if (String.class.isAssignableFrom(field.getType())) {
					value = String.valueOf(value);
				}
			}
			
			field.set(travelInfoVo, value);
			
			field.setAccessible(false);
		}
		travelInfoVo.setRequest((boolean)map.get("isModified") ? "C" : (String)map.get("request"));
		return travelInfoVo;
	}
	
	@RequestMapping(value = "/travel/updateTravelInfoRequests.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateTravenInfoRequests(@RequestBody List<Map<String, Object>> requestBody) throws Exception {
		int rows = this.travelService.updateTraveInfoRequests(requestBody);
		
		Map<String, Object> result = new HashMap<>();
		result.put("message", String.format("Affected rows: %d", rows));
		return CommonUtil.toJson(result);
	}
	
	@RequestMapping(value = "/travel/deleteTravelInfoByClientSeqAndDay.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteTravelInfoByClientSeqAndDay(@RequestParam("seq") String seq, @RequestParam("day") int day) throws Exception {
		int row = this.travelService.deleteTravelInfosOfClientByDay(seq, day);
		
		Map<String, Object> result = new HashMap<>();
		result.put("message", "row=" + row);
		return CommonUtil.toJson(result);
	}
}
