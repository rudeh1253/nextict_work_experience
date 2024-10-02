package com.spring.board.controller;

import java.time.LocalDate;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.service.calendar.CalendarService;

@Controller
public class CalendarController {
	private static final int YEAR_FROM = 1950;
	private static final int YEAR_TO = 2050;
	private static final int CURRENT_YEAR = LocalDate.now().getYear();
	private static final int CURRENT_MONTH = LocalDate.now().getMonthValue();
	
	@Autowired
	private CalendarService calendarService;
	
	@RequestMapping(value = "/calendar/downloadCalendar.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadCalendar(@RequestParam("year") int year, @RequestParam("month") int month, HttpServletResponse response) throws Exception {
		Workbook workbook = this.calendarService.generateCalendarWorkbook(year, month);
		
		response.setHeader("Content-Disposition", "attachement; filename=\"new_calendar.xls\"");
		workbook.write(response.getOutputStream());
	}
	
	@RequestMapping(value = "/calendar/calendarSelectionView.do", method = RequestMethod.GET)
	public String calendarSelectionView(Model model) {
		model.addAttribute("yearFrom", YEAR_FROM);
		model.addAttribute("yearTo", YEAR_TO);
		model.addAttribute("currentYear", CURRENT_YEAR);
		model.addAttribute("currentMonth", CURRENT_MONTH);
		return "calendar/calendarSelectionView";
	}
}
