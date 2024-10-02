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
		transportListCache.put("R", "��Ʈ");
		transportListCache.put("B", "���߱���");
		transportListCache.put("C", "����");
		
		TRANSPORT_LIST = Collections.unmodifiableMap(transportListCache);
		
		Map<String, List<String>> locationListCache = new HashMap<>();
		locationListCache.put("����", Arrays.asList("�����"));
		locationListCache.put("����", Arrays.asList("������"));
		locationListCache.put("��õ", Arrays.asList("��õ��"));
		locationListCache.put("�뱸", Arrays.asList("�뱸��"));
		locationListCache.put("�λ�", Arrays.asList("�λ��"));
		locationListCache.put("����", Arrays.asList("���ֽ�"));
		locationListCache.put("���", Arrays.asList("����"));
		locationListCache.put("���", Arrays.asList("������", "������", "��õ��", "�����ֽ�", "��õ��", "����õ��"));
		locationListCache.put("����", Arrays.asList("������", "������", "��õ��", "���ֽ�", "������", "ȭ����", "���ﱺ", "���ȱ�"));
		locationListCache.put("����", Arrays.asList("���ֽ�", "�ͻ��", "�����", "�ӽǱ�", "��â��", "���ֱ�", "���ȱ�", "���ֱ�"));
		locationListCache.put("�泲", Arrays.asList("õ�Ƚ�", "���ֽ�", "���ɽ�", "�ƻ��", "�����", "�ο���", "��õ��", "�¾ȱ�"));
		locationListCache.put("���", Arrays.asList("û�ֽ�", "���ֽ�", "������", "��õ��", "��õ��", "�ܾ籺"));
		locationListCache.put("����", Arrays.asList("���ֽ�", "��õ��", "������", "���ؽ�", "���ʽ�", "�¹��", "��â��", "������"));
		locationListCache.put("���ֵ�", Arrays.asList("���ֽ�", "��������"));
		
		LOCATION_LIST = Collections.unmodifiableMap(locationListCache);
		
		Map<String, String> travelTransportListCache = new HashMap<>();
		travelTransportListCache.put("W", "����");
		travelTransportListCache.put("B", "����");
		travelTransportListCache.put("S", "����ö");
		travelTransportListCache.put("T", "�ý�");
		travelTransportListCache.put("R", "��Ʈ");
		travelTransportListCache.put("C", "����");
		
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
