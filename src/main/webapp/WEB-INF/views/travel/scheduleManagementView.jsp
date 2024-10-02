<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>여행 일정 관리</title>
<link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/clockpicker/0.0.7/bootstrap-clockpicker.css" type="text/css" />
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.min.js" /></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/clockpicker/0.0.7/jquery-clockpicker.min.js" /></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/utils.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/travel/scheduleManagementValidations.js"></script>
<script type="text/javascript">
const validationMessage = {
		travelTime: {
			1: "시간을 입력해 주세요",
			2: "시간 입력 형식이 잘못되었습니다.\n예시\n오전 12:30\n오후 01:20",
			3: "스케줄이 겹치지 않게 설정해 주세요\n시간뿐만 아니라 예상이동시간 또한 고려해 주세요",
			4: "시간은 오전 7시 ~ 다음날 오전 4시 사이로 설정해 주세요",
			5: "마지막 스케줄은 이동시간을 고려하여 오전 4시 이전에 마칠 수 있도록 해 주세요",
			6: "시간이 겹치지 않게 설정해 주세요"
		},
		travelLoc: {
			1: "장소명을 입력해 주세요"
		},
		travelDetail: {
			1: "계획상세를 입력해 주세요"
		}
}

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
		<c:forEach var="transportEntry" items="${travelTransportList}">
			${transportEntry.key}: "${transportEntry.value}",
		</c:forEach>
}

let currentSelectedDay;
let travelInfoPerDay = {};
let savedTravelInfoPerDay = {};
let currentSelectedClientSeq;

$j(document).ready(function() {
	$j(".userName").on("click", function() {
		if (Object.keys(travelInfoPerDay).length > 0
				&& hasChanged(travelInfoPerDay[currentSelectedDay], savedTravelInfoPerDay[currentSelectedDay])
				&& wasAnyInputOccurred(travelInfoPerDay[currentSelectedDay])) {
			alert("변경사항을 저장해 주세요");
			return;
		}
		
		$j("#rowRelatedButtons").children().prop("hidden", false);
		$j("#saveButton").prop("hidden", false);
		$j("#clearButton").prop("hidden", false);
		
		currentSelectedDay = 1;
		$j("#dayButtons").children().remove();
		$j("#travelInfoTable").remove();
		
		currentSelectedClientSeq = $j(this).data("user-seq");
		
		const userSeq = $j(this).data("user-seq");
		const period = parseInt($j(this).data("period"));
		const currentClientTravelCity = $j(this).data("travel-city");
		const clientTransport = $j(this).data("transport");
		
		initTravelInfoPerDay();
		
		const dayButtons = $j("#dayButtons");
		for (let i of Object.keys(travelInfoPerDay)) {
			const dayButton = $j("<button type=\"button\">" + i + "</button>");
			dayButton.on("click", function() {
				if (hasChanged(travelInfoPerDay[currentSelectedDay], savedTravelInfoPerDay[currentSelectedDay])
						&& wasAnyInputOccurred(travelInfoPerDay[currentSelectedDay])) {
					alert("변경사항을 저장해 주세요");
					return;
				}
				updateTable(i);
				currentSelectedDay = i;
			});
			dayButtons.append(dayButton);
		}
		
		$j("#addButton").off("click");
		
		$j("#addButton").on("click", function() {
			insertRowLast();
		});
		
		$j("#insertButton").off("click");
		
		$j("#insertButton").on("click", function() {
			let maxIdx;
			$j("input[type='checkbox']:checked").each((idx, e) => {
				maxIdx = $j(e).parent().parent().data("idx");
				console.log(e);
				console.log(idx);
			});
			console.log(maxIdx);
			if (maxIdx !== undefined) {
				console.log("maxIdx=" + maxIdx);
				insertRow(maxIdx);
			}
		});
		
		$j("#delButton").off("click");
		
		$j("#delButton").on("click", function() {
			let deleted = 0;
			$j("input[type='checkbox']:checked").each((idx, e) => {
				$j(e).parent().parent().remove();
			});
			
			const newArr = [];
			
			$j(".travelInfoRow").each((idx, e) => {
				const je = $j(e);
				const newElem = {
						travelTime: je.find(".travelTime").val(),
						travelCity: je.find(".city").val(),
						travelCounty: je.find(".county").val(),
						travelLoc: je.find(".travelLoc").val(),
						travelTrans: je.find(".transports").val(),
						useExpend: parseInt(je.find(".expend").val().replace("," , "")),
						travelDetail: je.find(".travelDetail").val(),
						transTime: parseInt(je.find(".transTime").val().replaceAll("분", "")),
						request: je.data("request"),
						isModified: je.data("is-modified")
				};
				
				console.log(newElem);
				newElem.transportFee = getTransportFee(newElem, "오전", "오후");
				newArr.push(newElem);
			});
			
			travelInfoPerDay[currentSelectedDay] = newArr;
			
			console.log(travelInfoPerDay);
			
			updateTable(currentSelectedDay);
			if (travelInfoPerDay[currentSelectedDay].length === 0) {
				insertRowLast();
			}
		});
		
		function insertRowLast() {
			const day = currentSelectedDay;
			insertRow(travelInfoPerDay[day].length);
		}
		
		function insertRow(idx) {
			const day = currentSelectedDay;
			const newElem = getDefaultTravelInfoItem(day);
			
			travelInfoPerDay[day].splice(idx + 1, 0, newElem);
			updateTable(day);
		}
		
		function getDefaultTravelInfoItem(day) {
			const travelInfo = {
					request: "C",
					transportFee: 0,
					travelCity: currentClientTravelCity,
					travelCounty: locationList[currentClientTravelCity][0],
					travelDay: day,
					travelDetail: "",
					travelLoc: "",
					travelTime: "",
					travelTrans: clientTransport,
					useExpend: 0,
					transTime: 0,
					isModified: false
			};
			travelInfo.transportFee = getTransportFee(travelInfo, "오전", "오후");
			return travelInfo;
		}
		
		function initTravelInfoPerDay() {
			travelInfoPerDay = {};
			savedTravelInfoPerDay = {};
			for (let i = 1; i <= period; i++) {
				travelInfoPerDay[i] = [];
				savedTravelInfoPerDay[i] = [];
			}
		}
		
		function fetchSchedules(page) {
			$j.ajax({
				url: "/travel/getSchedules.do",
				type: "GET",
				dataType: "json",
				contentType: "application/json; charset=EUC-KR",
				data: {
					seq: userSeq
				},
				success: function(data, textStatus, jqXHR) {
					console.log(data);
					initTravelInfoPerDay();
					
					for (let d of data) {
						d.isModified = false;
						travelInfoPerDay[d.travelDay].push(d);
						savedTravelInfoPerDay[d.travelDay].push(JSON.parse(JSON.stringify(d)));
					}
					
					console.log(travelInfoPerDay);
					
					for (let day of Object.keys(travelInfoPerDay)) {
						if (travelInfoPerDay[day].length === 0) {
							const e = getDefaultTravelInfoItem(day);
							travelInfoPerDay[day].push(e);
							savedTravelInfoPerDay[day].push(JSON.parse(JSON.stringify(e)));
						}
						
						travelInfoPerDay[day].sort(getCompareFunctionForTravelInfoInTimeOrder("오전", "오후"));
						savedTravelInfoPerDay[day].sort(getCompareFunctionForTravelInfoInTimeOrder("오전", "오후"));
					}
					
					updateTable(page ? page : 1);
					
					console.log(travelInfoPerDay);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					alert("실패");
					console.log(jqXHR);
					console.log(textStatus);
					console.log(errorThrown);
				}
			});
		}
		
		fetchSchedules();
		
		function updateTable(day) {
			$j("#travelInfoTable").remove();
			const table = getTravelInfoTable(day);
			$j("#rowRelatedButtons").after(table);
		}
		
		function getTravelInfoTable(day) {
			const table = $j(`
					<table id="travelInfoTable" align="center" border="1">
						<tr>
							<td colspan="9" class="page"></td>
						</tr>
						<tr>
							<td></td>
							<td>시간</td>
							<td>지역</td>
							<td>장소명</td>
							<td>교통편</td>
							<td>예상이동시간(분)</td>
							<td>이용요금(예상지출비용)</td>
							<td>계획상세</td>
							<td>교통비</td>
							<td>수정요청</td>
						</tr>
					</table>
			`);
			table.find(".page").text(day + "일차");
			console.log(travelInfoPerDay);
			travelInfoPerDay[day].forEach((d, idx) => {
				console.log(d);
				const row = $j(
						"<tr class=\"travelInfoRow\" data-idx=\"" + idx + "\" data-request=\"" + d.request + "\" data-is-modified=\"" + d.isModified + "\">" +
							"<td><input type=\"checkbox\"></td>" +
							"<td><input class=\"travelTime\" type=\"text\" value=\"" + d.travelTime + "\"></td>" +
							
							"<td>" +
								"<select class=\"city\"></select>" +
								"<select class=\"county\"></select>" +
							"</td>" +
							"<td><input class=\"travelLoc\" type=\"text\" value=\"" + d.travelLoc + "\"></td>" +
							"<td><select class=\"transports\"></select></td>" +
							"<td><input class=\"transTime\" type=\"text\" value=\"" + d.transTime + "분\"></td>" +
							"<td><input class=\"expend\" type=\"text\" value=\"" + toFormattedMoneyRepresentation(d.useExpend) + "\"></td>" +
							"<td><input class=\"travelDetail\" type=\"text\" value=\"" + d.travelDetail + "\"></td>" +
							"<td class=\"transportFeeDat\">" + d.transportFee + "원</td>" +
							"<td>" + (d.request === "M" ? "O" : "") + "</td>" +
						"</tr>");
				row.find(".travelTime").clockpicker({
					donetext: "Done"
				});
				
				const travelTimePrevStateHolder = {
						prevState: d.travelTime
				};
				
				row.find(".travelTime").on("change", function(e) {
					if (new RegExp("^\\d{2}:\\d{2}$").test(e.target.value)) {
						let [hour, minute] = e.target.value.split(":").map((e) => parseInt(e));
						let val;
						if (hour >= 12) {
							hour = (hour + 11) % 12 + 1;
							val = "오후 " + (hour < 10 ? "0" + hour : hour) + ":" + (minute < 10 ? "0" + minute : minute);
						} else {
							hour = (hour + 11) % 12 + 1;
							val = "오전 " + (hour < 10 ? "0" + hour : hour) + ":" + (minute < 10 ? "0" + minute : minute);
						}
						const validationResult = validateAvailableTime(val, "오전", "오후");
						console.log(validationResult);
						if (Object.keys(validationResult).length > 0) {
							console.log("here");
							alert(validationMessage[validationResult.problem][validationResult.causeNum]);
							e.target.value = travelTimePrevStateHolder.prevState;
							$j(this).trigger("focus");
							return;
						}
						e.target.value = val;
						travelTimePrevStateHolder.prevState = val;
					}
					travelInfoPerDay[day][idx].travelTime = e.target.value;
					travelInfoPerDay[day][idx].transportFee = getTransportFee(isNaN(travelInfoPerDay[day][idx].transTime) ? { travelTime: travelInfoPerDay[day][idx].travelTime, travelTrans: travelInfoPerDay[day][idx].travelTrans, transTime: 0 } : travelInfoPerDay[day][idx], "오전", "오후");
					travelInfoPerDay[day][idx].isModified = true;
					$j(this).parent().siblings(".transportFeeDat").text(travelInfoPerDay[day][idx].transportFee + "원");
					
					//travelInfoPerDay[day].sort(getCompareFunctionForTravelInfoInTimeOrder("오전", "오후"));
					updateTable(day);
				});
				
				row.find(".travelLoc").on("keyup change", function(e) {
					travelInfoPerDay[day][idx].travelLoc = e.target.value;
					setModified($j(this));
				});
				
				row.find(".travelDetail").on("keyup change", function(e) {
					travelInfoPerDay[day][idx].travelDetail = e.target.value;
					setModified($j(this));
				});
				
				const cityElem = row.find(".city");
				
				const cityList = Object.keys(locationList);
				for (let city of cityList) {
					if (currentClientTravelCity === "제주도" && city === "제주도") {
						cityElem.append(
								"<option value=\"" + city + "\" " + (d.travelCity === city ? "selected" : "") +
								">" + city + "</option>"
								);
					} else if (currentClientTravelCity !== "제주도" && city !== "제주도") {
						cityElem.append(
								"<option value=\"" + city + "\" " + (d.travelCity === city ? "selected" : "") +
								">" + city + "</option>"
								);
					}
				}
				
				cityElem.on("change", function() {
					travelInfoPerDay[day][idx].travelCity = $j(this).val();
					setModified($j(this));
				});
				
				setCountySelection(d.travelCity, row.find(".county"), d.travelCounty);
				
				row.find(".county", function() {
					travelInfoPerDay[day][idx].travelCounty = $j(this).val();
					setModified($j(this));
				});
				
				cityElem.on("change", function() {
					const selectedCity = $j(this).val();
					setCountySelection(selectedCity, $j(this).siblings(".county"), "");
					travelInfoPerDay[day][idx].travelCounty = locationList[selectedCity][0];
					setModified($j(this));
				});
				
				const transportSelect = row.find(".transports");
				for (let transportKey of Object.keys(travelTransportList)) {
					if (clientTransport === "B" && (transportKey === "R" || transportKey === "C")
							|| clientTransport === "C" && (transportKey !== "C" && transportKey !== "W")
							|| clientTransport === "R" && (transportKey !== "R" && transportKey !== "W")) {
						continue;
					}
					
					const transportOption = $j(
							"<option value=\"" + transportKey + "\">" + travelTransportList[transportKey] + "</option>"
							);
					transportOption.prop("selected", transportKey === d.travelTrans);
					transportSelect.append(transportOption);
				}
				
				transportSelect.on("change", function() {
					travelInfoPerDay[day][idx].travelTrans = $j(this).val();
					travelInfoPerDay[day][idx].transportFee = getTransportFee(travelInfoPerDay[day][idx], "오전", "오후");
					setModified($j(this));
					$j(this).parent().siblings(".transportFeeDat").text(travelInfoPerDay[day][idx].transportFee + "원");
				});
				
				setInputFormatterForFormattedMoney(row.find(".expend"));
				
				row.find(".expend").on("change", function() {
					travelInfoPerDay[day][idx].useExpend = parseInt($j(this).val().replaceAll(",", ""));
					setModified($j(this));
				});
				
				const prevStateHolder = {
					prevState: d.transTime + "분"
				};
				
				row.find(".transTime").on("change", function(e) {
					if (!new RegExp("^\\d*분$").test(e.target.value)) {
						const val = e.target.value.replaceAll(new RegExp("[^0-9]", "g"), "");
						e.target.value = val + "분";
					}
				});
				
				row.find(".transTime").on("keyup change", function(e) {
					console.log(e.target.value);
					
					travelInfoPerDay[day][idx].transTime = parseInt(e.target.value.replaceAll(new RegExp("[^0-9]", "g"), ""));
					console.log("transTime=" + travelInfoPerDay[day][idx].transTime);
					travelInfoPerDay[day][idx].transportFee = getTransportFee(isNaN(travelInfoPerDay[day][idx].transTime) ? { travelTrans: travelInfoPerDay[day][idx].travelTrans, transTime: 0 } : travelInfoPerDay[day][idx], "오전", "오후");
					setModified($j(this));
					$j(this).parent().siblings(".transportFeeDat").text(travelInfoPerDay[day][idx].transportFee + "원");
					prevStateHolder.prevState = e.target.value;
				});
				
				table.append(row);
				
				function setModified(je) {
					travelInfoPerDay[day][idx].isModified = true;
					je.parent().parent().data("is-modified", "true");
				}
			});
			return table;
		}
		
		$j("#saveButton").off("click");
		
		$j("#saveButton").on("click", function(e) {
			console.log("currentSelectedDay=" + currentSelectedDay);
			const travelInfosOfSelectedDay = JSON.parse(JSON.stringify(travelInfoPerDay[currentSelectedDay]));
			const validationResult = validatePerDay(travelInfosOfSelectedDay, "오전", "오후");
			
			const rows = [];
			$j(".travelInfoRow").each((idx, e) => rows.push($j(e)));
			rows.map((e) => {
				const travelTime = e.find(".travelTime").val();
				e.travelTime = travelTime;
			});
			rows.sort(getCompareFunctionForTravelInfoInTimeOrder("오전", "오후"));
			
			if (Object.keys(validationResult).length !== 0) {
				const idx = validationResult.idx;
				const problem = validationResult.problem;
				const causeNum = validationResult.causeNum;
				
				alert(validationMessage[problem][causeNum]);
				
				//$j("tr[data-idx=" + idx + "]").find("." + problem).trigger("focus");
				rows[idx].find("." + problem).trigger("focus");
				return;
			}
			
			const requestBody = [];
			for (let travelItem of travelInfosOfSelectedDay) {
				const copiedTravelItem = JSON.parse(JSON.stringify(travelItem));
				copiedTravelItem.travelTime = to24Time(travelItem.travelTime, "오전", "오후");
				copiedTravelItem.seq = currentSelectedClientSeq;
				copiedTravelItem.travelDay = parseInt(currentSelectedDay);
				requestBody.push(copiedTravelItem);
			}
			
			console.log(requestBody);
			
			requestUpdate("/travel/updateSchedules.do", requestBody);
		});
		
		$j("#clearButton").off("click");
		
		$j("#clearButton").on("click", function() {
			requestUpdate("/travel/deleteTravelInfoByClientSeqAndDay.do?" + $j.param({
				seq: currentSelectedClientSeq,
				day: currentSelectedDay
			}));
		});
		
		function requestUpdate(url, data) {
			console.log(data);
			const requestProperty = {
					url: url,
					type: "POST",
					dataType: "json",
					contentType: "application/json;charset=euc-kr",
					success: function(data, textStatus, jqXHR) {
						alert("성공! 메시지: " + data.message);
						
						travelInfoPerDay[currentSelectedDay].sort(getCompareFunctionForTravelInfoInTimeOrder("오전", "오후"));
						savedTravelInfoPerDay = JSON.parse(JSON.stringify(travelInfoPerDay));
						updateTable(currentSelectedDay);
						
						const sum = calculateEstimatedExpense();
						const currentSelectedUserName = $j(".userName").filter((idx, e) => $j(e).data("user-seq") === userSeq);
						
						currentSelectedUserName.siblings(".clientEstimatedExpenses").text(toFormattedMoneyRepresentation(sum));
					},
					error: function(jqXHR, textStatus, errorThrown) {
						alert("실패");
						console.error(jqXHR);
						console.error(textStatus);
						console.error(errorThrown);
					}
			};
			if (data) {
				requestProperty.data = JSON.stringify(data);
			}
			console.log(requestProperty);
			$j.ajax(requestProperty);
		}
		
		function calculateEstimatedExpense() {
			console.log("applyNewEstimatedExpense");
			console.log(travelInfoPerDay);
			
			let sum = 0;
			for (let key of Object.keys(travelInfoPerDay)) {
				for (let travelInfoUnit of travelInfoPerDay[key]) {
					sum += travelInfoUnit.useExpend + getTransportFee(travelInfoUnit, "오전", "오후");
				}
			}
			
			if (clientTransport === "R") {
				let baseFee;
				switch (period) {
				case 1:
				case 2:
					baseFee += 100000;
					break;
				case 3:
				case 4:
					baseFee += 90000;
					break;
				case 5:
				case 6:
					baseFee += 80000;
					break;
				default:
					baseFee += 70000;
				}
				sum += baseFee * period;
			}
			return sum;
		}
	});
	
	$j("#loginViewButton").on("click", function() {
		if (hasChanged(travelInfoPerDay[currentSelectedDay], savedTravelInfoPerDay[currentSelectedDay])
				&& wasAnyInputOccurred(travelInfoPerDay[currentSelectedDay])) {
			alert("변경사항을 저장해 주세요");
		} else {
			window.location.href = "${pageContext.request.contextPath}/travel/loginView.do";
		}
	});
	
	$j(".clientEstimatedExpenses").each(function (idx, e) {
		const je = $j(e);
		je.text(toFormattedMoneyRepresentation(je.text()));
	});
	
	$j(".clientExpend").each(function (idx, e) {
		const je = $j(e);
		je.text(toFormattedMoneyRepresentation(je.text()));
	});
});

function setCountySelection(city, jElem, selectedCounty) {
	jElem.children().remove();
	
	const counties = locationList[city];
	for (let county of counties) {
		jElem.append(
				"<option value=\"" + county + "\" " + (county === selectedCounty ? "selected" : "") + ">" +
				county + "</option>");
	}
}
</script>
</head>
<body>
<button id="loginViewButton" type="button">로그인</button>
<table align="center" border="1">
	<tr>
		<td>고객명</td>
		<td>휴대폰번호</td>
		<td>여행지</td>
		<td>여행 기간</td>
		<td>이동수단</td>
		<td>예상 경비</td>
		<td>견적 경비</td>
	</tr>
	<c:forEach var="client" items="${clients}">
		<tr>
			<td class="userName"
				data-user-seq="${client.seq}"
				data-period="${client.period}"
				data-travel-city="${client.travelCity}"
				data-transport="${client.transport}"
			>${client.userName}</td>
			<td>${client.userPhone}</td>
			<td>${client.travelCity}</td>
			<td>${client.period}</td>
			<td>${transportList.get(client.transport)}</td>
			<td class="clientExpend">${client.expend}</td>
			<td class="clientEstimatedExpenses"
				<c:if test="${client.estimatedExpenses gt client.expend}">
					style="color: red;"
				</c:if>
			>${client.estimatedExpenses}</td>
		</tr>
	</c:forEach>
</table>
<div id="tableInfos">
	<div id="dayButtons" style="display: flex;"></div>
	<div id="rowRelatedButtons" style="display: flex;">
		<button type="button" id="addButton" hidden>추가</button>
		<button type="button" id="insertButton" hidden>삽입</button>
		<button type="button" id="delButton" hidden>삭제</button>
	</div>
	<table align="center">
		<tr>
			<td>
				<button type="button" id="saveButton" hidden>저장</button>
				<button type="button" id="clearButton" hidden>스케줄 비우기</button>
			</td>
		</tr>
	</table>
</div>
</body>
</html>