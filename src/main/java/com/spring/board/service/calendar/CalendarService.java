package com.spring.board.service.calendar;

import org.apache.poi.ss.usermodel.Workbook;

public interface CalendarService {

	public Workbook generateCalendarWorkbook(int year, int month) throws Exception;
}
