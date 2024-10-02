<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>달력 만들기</title>
<script type="text/javascript">
$j(document).ready(function() {
	$j("#downloadButton").on("click", function() {
		const year = $j("#yearSelection").val();
		const month = $j("#monthSelection").val();
		
		window.open("/calendar/downloadCalendar.do?year=" + year + "&month=" + month);
	});
});
</script>
</head>
<body>
	<table align="center">
		<tr>
			<td>
				<select id="yearSelection">
					<c:forEach var="year" begin="${yearFrom}" end="${yearTo}" step="1">
						<option value="${year}"
							<c:if test="${year == currentYear}">
								selected
							</c:if>
						>${year}</option>
					</c:forEach>
				</select>
			</td>
			<td>
				<select id="monthSelection">
					<c:forEach var="month" begin="1" end="12" step="1">
						<option value="${month}"
							<c:if test="${month == currentMonth}">
								selected
							</c:if>
						>${month}</option>
					</c:forEach>
				</select>
			</td>
			<td>
				<button id="downloadButton" type="button">달력 엑셀 출력</button>
			</td>
		</tr>
	</table>
</body>
</html>