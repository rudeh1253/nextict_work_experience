package com.spring.board.service.calendar.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Service;

import com.spring.board.service.calendar.CalendarService;
import com.spring.board.vo.calendar.CalendarCellDataVo;
import com.spring.board.vo.calendar.CalendarFormFrameVo;
import com.spring.board.vo.calendar.CalendarFormVo;

@Service
public class CalendarServiceImpl implements CalendarService {
	private static final String FILE_PATH = "C:\\Users\\pgd\\temp";
	private static final String FILENAME = "calendar_frame.xls";
	
	private final CalendarFormFrameVo basicCalendarFormFrame = new CalendarFormFrameVo();

	@Override
	public Workbook generateCalendarWorkbook(int year, int month) throws Exception {
		initFrameWorkbook();
		LocalDate firstDayOfMonth = LocalDate.of(year, month, 1);
		
		Workbook workbook = new HSSFWorkbook();
		
		List<Map<DayOfWeek, Integer>> dayOfMonthFrame = getDayOfMonthFrame(firstDayOfMonth);
		List<CalendarFormVo> calendarForms = generateCalendarForms(dayOfMonthFrame);
		Sheet sheet = generateSheet(firstDayOfMonth, workbook, this.basicCalendarFormFrame.getFormWidth());

		Font sundayFont = workbook.createFont();
		sundayFont.setColor(HSSFColor.RED.index);
		Font saturdayFont = workbook.createFont();
		saturdayFont.setColor(HSSFColor.AQUA.index);
		
		for (CalendarFormVo calendarForm : calendarForms) {
			List<CalendarCellDataVo<Integer>> cellDatum = calendarForm.getCalendarCellDatum();
			for (CalendarCellDataVo<Integer> cellData : cellDatum) {
				int rowIdx = cellData.getRowIdx();
				Row row = sheet.getRow(rowIdx);
				if (row == null) {
					row = sheet.createRow(rowIdx);
				}
				Cell cell = row.createCell(cellData.getColIdx());
				CellStyle newCellStyle = workbook.createCellStyle();
				newCellStyle.cloneStyleFrom(cellData.getCellStyle());
				
				if (cellData.getDayOfWeek() == DayOfWeek.SATURDAY) {
					newCellStyle.setFont(saturdayFont);
				}
				
				if (cellData.getDayOfWeek() == DayOfWeek.SUNDAY) {
					newCellStyle.setFont(sundayFont);
				}
				
				cell.setCellStyle(newCellStyle);
				Integer value = cellData.getValue();
				if (value != null) {
					cell.setCellValue(value);
				}
			}
		}
		
		return workbook;
	}
	
	private void initFrameWorkbook() throws Exception {
		HSSFWorkbook workbook = new HSSFWorkbook(
				new BufferedInputStream(new FileInputStream(new File(FILE_PATH, FILENAME)))
		);
		
		this.basicCalendarFormFrame.readFormStyle(workbook);
		
		DayOfWeek dw = DayOfWeek.SUNDAY;
		for (int i = 0; i < 7; i++) {
			System.out.println(dw);
			System.out.println(dw.getValue() % 7);
			dw = dw.plus(1);
		}
	}
	
	private List<Map<DayOfWeek, Integer>> getDayOfMonthFrame(LocalDate firstDayOfMonth) {
		List<Map<DayOfWeek, Integer>> dayOfMonthFrame = new ArrayList<>();
		LocalDate nextMonth = firstDayOfMonth.plus(1, ChronoUnit.MONTHS);
		LocalDate dateIndex = firstDayOfMonth;
		int rowIdx = -1;
		while (dateIndex.getMonth() != nextMonth.getMonth()) {
			if (dayOfMonthFrame.isEmpty() || dateIndex.getDayOfWeek() == DayOfWeek.MONDAY) {
				dayOfMonthFrame.add(new HashMap<>());
				rowIdx++;
			}
			Map<DayOfWeek, Integer> aWeek = dayOfMonthFrame.get(rowIdx);
			aWeek.put(dateIndex.getDayOfWeek(), dateIndex.getDayOfMonth());
			dateIndex = dateIndex.plus(1, ChronoUnit.DAYS);
		}
		return dayOfMonthFrame;
	}
	
	private List<CalendarFormVo> generateCalendarForms(List<Map<DayOfWeek, Integer>> dayOfMonthFrame) {
		final int startRow = 2;
		final int startCol = 0;
		
		List<CalendarFormVo> calendarForms = new ArrayList<>();
		int rowIdx = startRow;
		for (Map<DayOfWeek, Integer> singleFrame : dayOfMonthFrame) {
			int columnIdx = startCol;
			for (DayOfWeek dw : DayOfWeek.values()) {
				CalendarFormVo calendarForm = CalendarFormVo.createEmpty(rowIdx, columnIdx, this.basicCalendarFormFrame, dw);
				
				if (singleFrame.containsKey(dw)) {
					calendarForm.setDayOfMonth(singleFrame.get(dw));
				}
				
				calendarForms.add(calendarForm);
				
				columnIdx += this.basicCalendarFormFrame.getFormWidth();
			}
			rowIdx += this.basicCalendarFormFrame.getFormHeight();
		}
		
		return calendarForms;
	}
	
	private Sheet generateSheet(LocalDate date, Workbook workbook, int width) {
		Sheet newSheet = workbook.createSheet();
		Row firstRow = newSheet.createRow(0);
		
		Cell yearCell = firstRow.createCell(1);
		yearCell.setCellValue(date.getYear() + "년");
		
		Cell monthCell = firstRow.createCell(2);
		monthCell.setCellValue(date.getMonthValue() + "월");
		
		final String[] dayOfWeeksInKorean = {
				"월", "화", "수", "목", "금", "토", "일"
		};
		int colIdx = 0;
		
		Row dayOfWeekRow = newSheet.createRow(1);
		for (String dayOfWeekInKorean : dayOfWeeksInKorean) {
			int column = (colIdx + 1) * width - 1;
			Cell dayOfWeekCell = dayOfWeekRow.createCell(column);
			dayOfWeekCell.setCellValue(dayOfWeekInKorean);
			colIdx++;
		}
		
		return newSheet;
	}
}
