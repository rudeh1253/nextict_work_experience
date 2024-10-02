<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>여행견적 신청</title>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/utils.js"></script>
<script type="text/javascript">
const locationList = {
		<c:forEach var="locationEntry" items="${locationList}">
			${locationEntry.key}: [
					<c:forEach var="locations" items="${locationEntry.value}">
						"${locations}",
					</c:forEach>
				],
		</c:forEach>
}
const travelTransportList = {
		<c:forEach var="elem" items="${travelTransportList}">
			${elem.key}: "${elem.value}",
		</c:forEach>
}

const travelInfos = {};
<c:if test="${clientInfo != null}">
	<c:forEach var="travelInfo" items="${clientInfo.travelInfos}">
		if (!travelInfos[${travelInfo.travelDay}]) {
			travelInfos[${travelInfo.travelDay}] = [];
		}
		travelInfos[${travelInfo.travelDay}].push({
			travelSeq: "${travelInfo.travelSeq}",
			seq: "${travelInfo.seq}",
			travelDay: ${travelInfo.travelDay},
			travelTime: "${travelInfo.travelTime}",
			travelCity: "${travelInfo.travelCity}",
			travelCounty: "${travelInfo.travelCounty}",
			travelLoc: "${travelInfo.travelLoc}",
			travelTrans: "${travelInfo.travelTrans}",
			transTime: ${travelInfo.transTime},
			useTime: ${travelInfo.useTime},
			useExpend: ${travelInfo.useExpend},
			travelDetail: "${travelInfo.travelDetail}",
			transportFee: ${travelInfo.transportFee},
			request: "${travelInfo.request}",
			requestCache: false
		});
	</c:forEach>
</c:if>

console.log(travelInfos);

$j(document).ready(function() {
	if (!${hasLoggedIn}) {
		alert("로그인해 주세요!");
		window.location.href = "/travel/loginView.do";
	}
	
	$j("#period").on("keyup change", function(e) {
		if (e.target.value.length === 0) {
			return;
		}
		
		const intValue = parseInt(e.target.value);
		if (intValue < 1) {
			e.target.value = 1;
		}
		
		if (intValue > 30) {
			e.target.value = 30;
		}
	});
	
	$j("#expend").on("keyup change", function(e) {
		if (!new RegExp("^(\\d{1,3}(,\\d{3})*)?$").test(e.target.value)) {
			const val = e.target.value.replaceAll(new RegExp("[^0-9]", "g"), "");
			e.target.value = toFormattedMoneyRepresentation(val); // From /resources/js/firstparty/utils.js
		}
	});
	
	<c:if test="${clientInfo != null}">
		$j("#expend").val(toFormattedMoneyRepresentation(${clientInfo.expend}));
		$j("#expend").prop("disabled", "true");
	</c:if>
	
	$j("#submit").on("click", function(e) {
		if ($j("#period").val().length === 0) {
			alert("여행 기간을 입력해 주세요");
			$j("#period").trigger("focus");
			return;
		}
			
		if ($j("#expend").val().length === 0) {
			alert("예상 경비를 입력해 주세요");세
			$j("#expends").trigger("focus");
			return;
		}
		
		$j.ajax({
			url: "/travel/applyEstimate.do",
			type: "POST",
			dataType: "json",
			contentType: "application/json; charset=EUC-KR",
			data: JSON.stringify({
				userName: "${userName}",
				userPhone: "${userPhone}",
				period: parseInt($j("#period").val()),
				transport: $j("#transport").val(),
				expend: parseInt($j("#expend").val().replaceAll(",", "")),
				travelCity: $j("#travelCity").val()
			}),
			success: function(data, textStatus, jqXHR) {
				alert("성공적으로 저장되었습니다. message: " + data.message);
				window.location.href = "${pageContext.request.contextPath}/travel/loginView.do";
			},
			error: function(jqXHR, textStatus, errorThrown) {
				console.log(jqXHR);
				alert("실패");
			}
		});
	});
	
	$j("#logout").on("click", function() {
		$j.ajax({
			url: "${pageContext.request.contextPath}/travel/logoutAction.do",
			type: "POST",
			success: function(data, textStatus, jqXHR) {
				alert("로그아웃 완료");
				window.location.href = "${pageContext.request.contextPath}/travel/loginView.do";
			},
			error: function(jqXHR, textStatus, errorThrown) {
				console.error(textStatus);
				console.error(jqXHR);
				console.error(errorThrown);
				alert("실패");
			}
		});
	});
	
	$j("#backButton").on("click", function() {
		window.location.href = "${pageContext.request.contextPath}/travel/loginView.do";
	});
	
	<c:if test="${clientInfo != null}">
		const period = ${clientInfo.period};
		for (let i = 1; i <= period; i++) {
			const dayButton = $j(
					"<button type=\"button\">" + i + "</button>"
			);
			dayButton.on("click", function() {
				updateTable(i);
			});
			$j("#dayButtons").append(dayButton);
		}
	
		updateTable(1);
		
		function updateTable(day) {
			const table = $j("#travelInfoTable");
			table.children().remove();
			const tableContent = $j(
					"<tr>" +
						"<td></td>" +
						"<td>시간</td>" +
						"<td>지역</td>" +
						"<td>장소명</td>" +
						"<td>교통편</td>" +
						"<td>예상이동시간</td>" +
						"<td>이용요금(예상지출비용)</td>" +
						"<td>계획상세</td>" +
						"<td>교통비</td>" +
					"</tr>"
			);
			
			table.append($j(
					"<tr><td colspan=\"9\">" + day + "일차</td></tr>"
			));
			
			table.append(tableContent);
			
			const arr = travelInfos[day] ? travelInfos[day] : [];
			
			let idx = 0;
			for (let travelInfo of arr) {
				const row = $j(
						"<tr data-day=\"" + day + "\" data-idx=\"" + idx + "\">" +
							"<td><input class=\"requestCheckbox\" type=\"checkbox\" " +
									(travelInfo.request === "M" ? "disabled " : "") +
									(travelInfo.requestCache ? "checked" : "") +
									"></td>" +
							"<td><input type=\"text\" value=\"" + travelInfo.travelTime + "\" disabled></td>" +
							"<td><select disabled><option>" + travelInfo.travelCity + "</option></select>" +
									"<select disabled><option>" + travelInfo.travelCounty + "</option></select></td>" +
							"<td><input type=\"text\" value=\"" + travelInfo.travelLoc + "\" disabled></td>" +
							"<td><select disabled><option>" + travelTransportList[travelInfo.travelTrans] + "</option></select></td>" +
							"<td><input type=\"text\" value=\"" + travelInfo.transTime + "분\" disabled></td>" +
							"<td><input type=\"text\" value=\"" + toFormattedMoneyRepresentation(travelInfo.useExpend) + "\" disabled></td>" +
							"<td><input type=\"text\" value=\"" + travelInfo.travelDetail + "\" disabled></td>" +
							"<td><input type=\"text\" value=\"" + travelInfo.transportFee + "원\" disabled></td>" +
						"</tr>"
				);
				
				row.find(".requestCheckbox").on("change", function(e) {
					const je = $j(e.target);
					const tr = je.parent().parent();
					const day = tr.data("day");
					const idx = tr.data("idx");
					
					console.log(travelInfos[day][idx]);
					
					travelInfos[day][idx].requestCache = je.prop("checked");
				});
				
				table.append(row);
				
				idx++;
			}
			if (arr.length === 0) {
				table.append($j(`
						<tr>
							<td colspan="9">아무 스케줄도 입력돼 있지 않습니다.</td>
						</tr>
				`));
				$j("#requestButton").prop("disabled", true);
			} else {
				$j("#requestButton").prop("disabled", false);
			}
		}
		
		$j("#requestButton").on("click", function() {
			const requestBody = [];
			for (let key of Object.keys(travelInfos)) {
				for (let item of travelInfos[key]) {
					if (item.requestCache) {
						console.log("travelSeq=" + item.travelSeq);
						requestBody.push({
							travelSeq: item.travelSeq,
							request: "M"
						});
					}
				}
			}
			
			console.log(requestBody);
			
			if (requestBody.length === 0) {
				alert("수정을 요청할 스케줄을 하나 이상 체크해 주세요");
				return;
			}
			
			$j.ajax({
				url: "${pageContext.request.contextPath}/travel/updateTravelInfoRequests.do",
				type: "POST",
				dataType: "json",
				contentType: "application/json;charset=euc-kr",
				data: JSON.stringify(requestBody),
				success: function(data, textStatus, jqXHR) {
					console.log(textStatus);
					console.log(jqXHR);
					alert("성공! message: " + data.message);
					
					window.location.href = "${pageContext.request.contextPath}/travel/estimateView.do";
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.error(jqXHR);
					console.error(textStatus);
					console.error(errorThrown);
					alert("실패");
				}
			});
		});
	</c:if>
});
</script>
</head>
<body>
<c:if test="${clientInfo == null}">
	<button type="button" id="backButton">뒤로</button>
</c:if>
<table align="center">
	<tr>
		<td align="center">
			<table border="1"> 
				<tr>
					<td>고객명</td>
					<td>${userName}</td>
				</tr>
				<tr>
					<td>휴대폰번호</td>
					<td>${userPhone}</td>
				</tr>
				<tr>
					<td>여행 기간</td>
					<td><input type="number" id="period"
							<c:if test="${clientInfo != null}">
								value="${clientInfo.period}" disabled
							</c:if>
							<c:if test="${clientInfo == null}">value="1"</c:if>></td>
				</tr>
				<tr>
					<td>이동 수단</td>
					<td>
						<select id="transport" <c:if test="${clientInfo != null}">disabled</c:if>>
							<c:forEach var="elem" items="${transportList}">
								<option value="${elem.key}"
										<c:if test="${clientInfo != null && clientInfo.transport == elem.key}">
											selected disabled
										</c:if>>${elem.value}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td>예상 경비</td>
					<td><input type="text" id="expend"></td>
				</tr>
				<tr>
					<td>여행지</td>
					<td>
						<select id="travelCity" <c:if test="${clientInfo != null}">disabled</c:if>>
							<c:forEach var="elem" items="${locationList}">
								<option value="${elem.key}" <c:if test="${clientInfo != null && clientInfo.travelCity == elem.key}">selected</c:if>>${elem.key}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center">
			<c:if test="${clientInfo != null}">
				<button type="button" id="logout">로그아웃</button>
			</c:if>
			<c:if test="${clientInfo == null}">
				<button type="button" id="submit">신청</button>
			</c:if>
		</td>
	</tr>
</table>
<c:if test="${clientInfo != null}">
	<div id="dayButtons"></div>
	<button type="button" id="requestButton">수정요청</button>
	<table id="travelInfoTable" border="1" align="center">
		<tr>
			<td></td>
			<td>시간</td>
			<td>지역</td>
			<td>장소명</td>
			<td>교통편</td>
			<td>예상이동시간</td>
			<td>이용요금(예상지출비용)</td>
			<td>계획상세</td>
			<td>교통비</td>
		</tr>
	</table>
</c:if>
</body>
</html>