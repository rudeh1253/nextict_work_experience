<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>입사지원서 작성</title>

<script type="text/javascript">
	let seq = undefined;
	
	<c:if test="${recruitVo != null}">
		seq = "${recruitVo.seq}"
	</c:if>
	
	const elemPerType = {
			edu: `
					<tr class="eduRow">
						<td width="30">
							<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
						</td>
						<td width="200">
							<input class="datepicker" type="text" name="eduStartPeriod">
							~
							<input class="datepicker" type="text" name="eduEndPeriod">
						</td>
						<td width="100">
							<select name="division">
								<option value="ENROLLED_IN">재학</option>
								<option value="DROPPED_OUT">중퇴</option>
								<option value="GRADUATED">졸업</option>
							</select>
						</td>
						<td width="200">
							<input type="text" name="schoolName">
							<select name="eduLocation">
								<c:forEach var="entry" items="${locationSelections}">
									<option value="${entry.key}">${entry.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="200">
							<input type="text" name="major">
						</td>
						<td width="200">
							<input type="text" name="grade">
						</td>
					</tr>
			`,
			car: `
					<tr class="carRow">
						<td width="30">
							<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
						</td>
						<td width="300">
							<input class="datepicker" type="text" name="carStartPeriod">
							~
							<input class="datepicker" type="text" name="carEndPeriod">
						</td>
						<td width="200">
							<input type="text" name="compName">
						</td>
						<td width="200">
							<input type="text" name="task">
						</td>
						<td width="200">
							<select name="carLocation">
								<c:forEach var="entry" items="${locationSelections}">
									<option value="${entry.key}">${entry.value}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
			`,
			cert: `
					<tr class="certRow">
						<td width="30">
							<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
						</td>
						<td width="300">
							<input type="text" name="qualifiName">
						</td>
						<td width="300">
							<input class="datepicker" type="text" name="acquDate">
						</td>
						<td width="300">
							<input type="text" name="organizeName">
						</td>
					</tr>
			`
	};

	const idSequence = {
			edu: 2,
			car: 2,
			cert: 2
	};
	
	$j(document).ready(function() {
		$j("#birth").datepicker({
			changeMonth: true,
			changeYear: true,
			showButtonPanel: true,
			dateFormat: "yy.mm.dd",
			minDate: new Date(1900, 0, 1),
			maxDate: new Date(),
			monthNames: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
			monthNamesShort: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
			yearRange: "1900:" + new Date().getFullYear()
		});
		
		function setDatePickerForMonthAndYear(jElem) {
			jElem.datepicker({
				changeMonth: true,
		        changeYear: true,
				showButtonPanel: true,
				dateFormat: "yy.mm",
				onClose: function(dateText, inst) {
					/*const month = parseInt($j("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
					const year = $j("#ui-datepicker-div .ui-datepicker-year :selected").val();
					console.log(year + "." + (month < 10 ? "0" + month : month));
					$j(this).val(year + "." + (month < 10 ? "0" + month : month));*/
				},
	            beforeShow : function(input, inst) {
	            	formatDatepicker($j(this));
	            },
	            onChangeMonthYear: function(year, month, inst) {
	            	console.log(month);
	            	$j(this).val(year + "." + (month < 10 ? "0" + month : month));
	            },
	            minDate: new Date(1900, 0, 1),
	            maxDate: new Date(),
				monthNames: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
				monthNamesShort: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
				yearRange: "1900:" + new Date().getFullYear()
			});
			
			jElem.on("click focus", function() {
				const jThis = $j(this);
				
				$j(".ui-datepicker-calendar").hide();
				$j("#ui-datepicker-div").position({
					my: "center top",
					at: "center bottom",
					of: jThis
				});
				
				$j(".ui-datepicker-close").on("click", function() {
					const month = parseInt($j("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
					const year = $j("#ui-datepicker-div .ui-datepicker-year :selected").val();
					console.log(year + "." + (month < 10 ? "0" + month : month));
					jThis.val(year + "." + (month < 10 ? "0" + month : month));
				});
			});
		}
		
		setDatePickerForMonthAndYear($j(".datepicker"));
		
		<c:if test="${recruitVo != null}">
			if (${recruitVo.submit}) {
				$j("input").prop("disabled", true);
				$j("select").prop("disabled", true);
				$j("button").prop("disabled", true);
			}
		</c:if>
		
		$j(".addButton").on("click", function() {
			const type = $j(this).data("type");
			
			const jNewElem = $j(elemPerType[type]);
			
			jNewElem.find(".datepicker").each((idx, e) => {
				const je = $j(e);
				
				const prevStateHolder = {
						prevState: ""
				};
				
				je.on("keyup change", function(e) {
					formatPeriod(e, $j(this), prevStateHolder);
				});
				
				setDatePickerForMonthAndYear(je);
			});
			
			$j("#" + type + "Table").append(jNewElem);
		});
		
		$j(".deleteButton").on("click", function() {
			const type = $j(this).data("type");
			
			$j("." + type + "Row").filter((idx, e) => $j(e).find(".toDelete").is(":checked")).remove();
			
			if ($j("." + type + "Row").length === 0) {
				const jNewElem = $j(elemPerType[type]);
				
				jNewElem.find(".datepicker").each((idx, e) => {
					const je = $j(e);
					
					const prevStateHolder = {
							prevState: ""
					};
					
					je.on("keyup change", function(e) {
						formatPeriod(e, $j(this), prevStateHolder);
					});
					
					setDatePickerForMonthAndYear(je);
				});
				
				$j("#" + type + "Table").append(jNewElem);
			}
		});
		
		$j("#storeButton").on("click", function() {
			request("false");
		});
		
		$j("#submitButton").on("click", function() {
			request("true");
		});
		
		function request(isSubmit) {
			if (!validate()) {
				return;
			}
			
			const requestBody = {
					name: $j("input[name='name']").val(),
					birth: $j("input[name='birth']").val(),
					gender: $j("select[name='gender']").val(),
					phone: $j("input[name='phone']").val(),
					email: $j("input[name='email']").val(),
					addr: $j("input[name='addr']").val(),
					location: $j("select[name='desiredLocation']").val(),
					workType: $j("select[name='workType']").val(),
					certificates: [],
					educations: [],
					careers: [],
					submit: isSubmit
			};
			
			if (seq) {
				requestBody["seq"] = seq;
			}
			
			$j(".eduRow").each(function(idx, e) {
				const jRow = $j(e);
				
				requestBody.educations.push({
					schoolName: jRow.find("input[name='schoolName']").val(),
					division: jRow.find("select[name='division']").val(),
					startPeriod: jRow.find("input[name='eduStartPeriod']").val(),
					endPeriod: jRow.find("input[name='eduEndPeriod']").val(),
					major: jRow.find("input[name='major']").val(),
					grade: jRow.find("input[name='grade']").val(),
					location: jRow.find("select[name='eduLocation']").val()
				});
			});
			
			$j(".carRow").each(function(idx, e) {
				const jRow = $j(e);
				if (isAllInputEmpty(jRow)) {
					return;
				}
				
				requestBody.careers.push({
					compName: jRow.find("input[name='compName']").val(),
					location: jRow.find("select[name='carLocation']").val(),
					startPeriod: jRow.find("input[name='carStartPeriod']").val(),
					endPeriod: jRow.find("input[name='carEndPeriod']").val(),
					task: jRow.find("input[name='task']").val()
				});
			});
			
			$j(".certRow").each(function(idx, e) {
				const jRow = $j(e);
				if (isAllInputEmpty(jRow)) {
					return;
				}
				
				requestBody.certificates.push({
					qualifiName: jRow.find("input[name='qualifiName']").val(),
					acquDate: jRow.find("input[name='acquDate']").val(),
					organizeName: jRow.find("input[name='organizeName']").val()
				});
			});
			
			console.log(requestBody);
			
			const url =
				<c:if test="${recruitVo != null}">
					"/resume/updateRecruit.do"
				</c:if>
				<c:if test="${recruitVo == null}">
					"/resume/writeRecruit.do"
				</c:if>;
			
			$j.ajax({
				url: url,
				type: "POST",
				dataType: "json",
				contentType: "application/json",
				data: JSON.stringify(requestBody),
				success: function(data, textStatus, jqXHR) {
					console.log(jqXHR);
					console.log(data);
					
					alert(isSubmit === "true" ? "제출이 완료되었습니다." : "저장되었습니다.");
					window.location.href = "${pageContext.request.contextPath}/resume/loginView.do";
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.error("jqXHR", jqXHR);
					console.error("textStatus", textStatus);
					console.error("errorThrown", errorThrown);
				} 
			});
		}
		
		$j("input[name='name']").on("keyup change", function(e) {
			const regexForNotKorean = new RegExp("[^ㄱ-힝]", "g");
			
			const v = $j(this).val();
			if (regexForNotKorean.test(v)) {
				$j(this).val(v.replaceAll(regexForNotKorean, ""));
			}
		});
		
		$j("input[name='birth']").each((idx, e) => {
			const prevStateHolder = { prevState: $j(e).val() };
			$j(e).on("keyup change", function(e) {
				const id = $j(this).attr("id");
				
				const regex = new RegExp("[0-9]+(\\.[0-9]+)+");

				const v = $j(this).val();
				
				const regexToRemove = new RegExp("[^0-9\\.]");
				if (regexToRemove.test(v)) {
					$j(this).val(prevStateHolder.prevState);
					return;
				}
				let nVal = v;
				
				const digitNum = numOfDigits(v);
				
				if (digitNum > 6) {
					const reg = new RegExp("^[0-9]{4}\\.[0-9]{2}\\.[0-9]+$");
					
					if (!reg.test(v)) {
						const replaced = v.replaceAll(".", "");
						nVal = replaced.substring(0, 4) + "." + replaced.substring(4, 6) + "." + replaced.substring(6);
						$j(this).val(nVal);
					}
					
					if (v.length > 10) {
						nVal = nVal.substring(0, 10);
						$j(this).val(nVal);
					}
				} else if (digitNum > 4) {
					const reg = new RegExp("^[0-9]{4}\\.[0-9]+$");
					
					if (!reg.test(v)) {
						const replaced = v.replaceAll(".", "");
						nVal = replaced.substring(0, 4) + "." + replaced.substring(4);
						$j(this).val(nVal);
					}
				} else {
					nVal = v.replaceAll(".", "");
					$j(this).val(nVal);
				}
				
				const convertCondition2 = new RegExp("^[0-9]{4}\\.$");
				if (convertCondition2.test(v)) {
					nVal = v.substring(0, 4);
					$j(this).val(nVal);
				}
				
				prevStateHolder.prevState = nVal;
			});
		});
		
		$j("input[name='email']").each((idx, e) => {
			const prevStateHolder = { prevState: $j(e).val() };
			$j(e).on("keyup blur", function(e) {
				const v = $j(this).val();
				
				if (new RegExp("[^a-zA-Z0-9@\\.]").test(v)) {
					$j(this).val(prevStateHolder.prevState);
				} else {
					prevStateHolder.prevState = v;
				}
			});
		});
		
		$j("input[name='eduStartPeriod']").each((idx, e) => {
			const prevStateHolder = { prevState: "" };
			$j(e).on("keyup onchange", function(e) {
				formatPeriod(e, $j(this), prevStateHolder);
			});
		});
		
		$j("input[name='eduEndPeriod']").each((idx, e) => {
			const prevStateHolder = { prevState: "" };
			$j(e).on("keyup onchange", function(e) {
				formatPeriod(e, $j(this), prevStateHolder);
			});
		});
		
		$j("input[name='carStartPeriod']").each((idx, e) => {
			const prevStateHolder = { prevState: "" };
			$j(e).on("keyup onchange", function(e) {
				formatPeriod(e, $j(this), prevStateHolder);
			});
		});
		
		$j("input[name='carEndPeriod']").each((idx, e) => {
			const prevStateHolder = { prevState: "" };
			$j(e).on("keyup onchange", function(e) {
				formatPeriod(e, $j(this), prevStateHolder);
			});
		});
		
		$j("input[name='acquDate']").each((idx, e) => {
			const prevStateHolder = { prevState: "" };
			$j(e).on("keyup onchange", function(e) {
				formatPeriod(e, $j(this), prevStateHolder);
			});
		});
	});
	
	function formatPeriod(e, jThis, prevStateHolder) {
		formatDatepicker(jThis);
		formatNumberWithOneSeparation(e, jThis, prevStateHolder, 4, ".", true, 7);
	}
	
	function formatDatepicker(jThis) {
		// Datepicker 설정
		const dateRegex = new RegExp("[0-9]{4}\\.[0-9]{2}");
		const datestr = jThis.val();
		console.log(datestr);
        if (dateRegex.test(datestr)) {
        	console.log("format date");
        	var year = parseInt(datestr.substring(0, 4));
            var month = parseInt(datestr.substring(datestr.length - 2)) - 1
            jThis.datepicker('option', 'defaultDate', new Date(year, month, 1));
            jThis.datepicker('setDate', new Date(year, month, 1));
        }
	}
	
	function formatNumberWithOneSeparation(e, jThis, prevStateHolder, firstLen, separator, isRegexEscapeNeeded, maxLen) {
		// 허용되지 않은 문자 입력 시 문자 입력 이전 상태로 복구
		const v = jThis.val();
		const regexToRemove = new RegExp("[^0-9\\.]");
		if (regexToRemove.test(v)) {
			console.log("no");
			jThis.val(prevStateHolder.prevState);
			return;
		}
		
		// 자동으로 separator 삽입
		let nVal = v;
		
		const digitNum = numOfDigits(v);
		
		const separatorRegex = isRegexEscapeNeeded ? "\\" + separator : separator;
		
		if (digitNum > firstLen) { // separator를 삽입해야 하는 경우
			const reg = new RegExp("^[0-9]{" + firstLen + "}" + separatorRegex + "[0-9]+$");
			
			if (!reg.test(v)) {
				const replaced = v.replaceAll(separator, "");
				nVal = replaced.substring(0, firstLen) + separator + replaced.substring(firstLen);
				jThis.val(nVal);
			}
			
			// 최대 길이 제한
			if (maxLen && nVal.length > maxLen) {
				nVal = nVal.substring(0, maxLen);
				jThis.val(nVal);
			}
		} else {
			nVal = v.replaceAll(separator, "");
			jThis.val(nVal);
		}
		
		const convertCondition2 = new RegExp("^[0-9]{" + firstLen + "}" + separatorRegex + "$");
		if (convertCondition2.test(v)) {
			nVal = v.substring(0, firstLen);
			jThis.val(nVal);
		}
		
		prevStateHolder.prevState = nVal;
	}
	
	function numOfDigits(val) {
		let count = 0;
		for (let c of val) {
			if (!isNaN(parseInt(c))) {
				count++;
			}
		}
		return count;
	}
	
	function validate() {
		if (!validateName()
				|| !validateBirth()
				|| !validatePhone()
				|| !validateEmailFormat()
				|| !validateAddr()) {
			return false;
		}
		
		const eduRow = $j(".eduRow");
		
		if (eduRow.length === 0) {
			alert("하나 이상의 학력을 입력해 주세요");
			return false;
		}
		
		for (let i = 0; i < eduRow.length; i++) {
			const je = $j(eduRow[i]);
			if (!validateDoublePeriod(je.find("input[name='eduStartPeriod']"), "재학기간 시작 날짜", je.find("input[name='eduEndPeriod']"), "재학기간 종료 날짜")
					|| !validateNonEmpty(je.find("input[name='schoolName']"), "학교명")
					|| !validateNonEmpty(je.find("input[name='major']"), "전공")
					|| !validateGrade(je.find("input[name='grade']"))) {
				return false;
			}
		}
		
		return validateCareer() && validateCertificate() && validateDateRange();
	}
	
	function validateName() {
		const jElem = $j("input[name='name']");
		const name = jElem.val();
		
		if (!name || name.length === 0) {
			alert("이름을 입력해 주세요");
			jElem.trigger("focus");
			return false;
		}
		
		const regexForKor = new RegExp("^[가-힝]+$");
		if (!regexForKor.test(name)) {
			alert("이름 형식이 맞지 않습니다. (초성, 중성이 모두 입력된 한글 형식이어야 합니다)\n예시: 홍길동");
			jElem.trigger("focus");
			return false;
		}
		return true;
	}
	
	function validateBirth() {
		const jElem = $j("input[name='birth']");
		const birth = jElem.val();
		
		if (!birth || birth.length === 0) {
			alert("생년월일을 입력해 주세요")
			jElem.trigger("focus");
			return false;
		}
		
		const birthDate = new Date(birth);
		const birthRegex = new RegExp("[0-9]{4}\\.[0-9]{2}\\.[0-9]{2}");
		
		if (isNaN(birthDate) || !birthRegex.test(birth)) {
			alert("생년월일 형식이 맞지 않습니다. (yyyy.mm.dd 형식이어야 합니다)\n예시: 1997.09.01");
			jElem.trigger("focus");
			return false;
		}
		
		const now = new Date();
		if (now - birthDate < 0) {
			alert("현재보다 과거 날짜를 선택해 주세요 (현재: "
					+ now.getFullYear() + "-"
					+ (now.getMonth() + 1) + "-"
					+ now.getDate() + ")")
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	const allowedPhoneStarts = new Set();
	allowedPhoneStarts.add("010");
	allowedPhoneStarts.add("011");
	allowedPhoneStarts.add("016");
	allowedPhoneStarts.add("017");
	allowedPhoneStarts.add("019");
	
	function validatePhone() {
		const jElem = $j("input[name='phone']");
		const phone = jElem.val();
		
		if (!phone || phone.length === 0) {
			alert("연락처를 입력해 주세요.")
			jElem.trigger("focus");
			return false;
		}
		
		if ((phone.length !== 10
				&& phone.length !== 11)
				|| !allowedPhoneStarts.has(phone.substring(0, 3))) {
			alert("연락처 형식이 맞지 않습니다.\n"
					+ "(010/011/016/017/019로 시작하는 10자리 혹은 11자리 숫자여야 합니다.)\n예시: 01012341234");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateEmailFormat() {
		const jElem = $j("input[name='email']");
		const email = jElem.val();
		
		if (!email || email.length === 0) {
			alert("email을 입력해 주세요");
			jElem.trigger("focus");
			return false;
		}
		
		const emailRegex = new RegExp("^[a-zA-Z0-9]+@([a-zA-Z]+\\.[a-zA-Z]+)+$");
		
		if (!emailRegex.test(email)) {
			alert("이메일 형식이 맞지 않습니다.\n예시: test@gmail.com or test@khu.ac.kr");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateAddr() {
		const jElem = $j("input[name='addr']");
		const addr = jElem.val();
		
		if (!addr || addr.length === 0) {
			alert("주소를 입력해 주세요.");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateDoublePeriod(jElemBefore, beforeElemName, jElemAfter, afterElemName) {
		if (!validatePeriod(jElemBefore, beforeElemName)
				|| !validatePeriod(jElemAfter, afterElemName)) {
			return false;
		}
		
		const before = new Date(jElemBefore.val());
		const after = new Date(jElemAfter.val());
		
		if (after - before <= 0) {
			alert("시작 날짜가 종료 날짜보다 빠르게 해 주세요\n예시:\n2023.08 ~ 2023.09 o\n2023.08 ~ 2023.07 x\n2023.08 ~ 2023.08 x\n");
			jElemBefore.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validatePeriod(jElem, elemName) {
		const period = jElem.val();
		
		if (!period || period.length === 0) {
			alert(elemName + "을 입력해 주세요");
			jElem.trigger("focus");
			return false;
		}
		
		
		const periodFormat = new RegExp("^[0-9]{4}\\.[0-9]{2}$");
		
		if (!periodFormat.test(period)) {
			alert(elemName + " 형식이 맞지 않습니다. (yyyy.mm 형식을 따라주세요)\n 예시: 2018.01");
			jElem.trigger("focus");
			return false;
		}
		
		const [year, month] = period.split(".").map(function (e) { return parseInt(e) });
		
		if (year > new Date().getFullYear()) {
			alert(elemName + "의 연도의 범위를 확인해 주세요 (현재 시간보다 늦으면 안 됩니다)");
			jElem.trigger("focus");
			return false;
		}
		
		if (month < 1 || month > 12) {
			alert(elemName + "의 월 범위를 확인해 주세요 (1 ~ 12)");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateNonEmpty(jElem, elemName) {
		const v = jElem.val();
		
		if (!v || v.length === 0) {
			alert(elemName + "을 입력해 주세요");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateGrade(jElem) {
		const grade = jElem.val();
		
		if (!grade || grade.length === 0) {
			alert("학점을 입력해 주세요.");
			jElem.trigger("focus");
			return false;
		}
		
		const format = new RegExp("^[0-9]\\.[0-9]{1,2}$");
		
		if (!format.test(grade)) {
			alert("학점 형식이 맞지 않습니다. 소수점 한 자리 혹은 두 자리까지 입력해 주세요.\n"
					+ "범위는 0.0 ~ 4.5입니다.\n"
					+ "예시: 3.14, 4.5");
			jElem.trigger("focus");
			return false;
		}
		
		const gradeNum = parseFloat(grade);
		
		if (gradeNum < 0 || gradeNum > 4.5) {
			alert("학점의 범위를 확인해 주세요 (0 <= 학점 <= 4.5)");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateTask(jElem) {
		const task = jElem.val();
		
		if (!task || task.length === 0) {
			alert("부서/직급/직책을 입력해 주세요");
			jElem.trigger("focus");
			return false;
		}
		
		if (task.split("/").length !== 3) {
			alert("부서/직급/직책 형식에 맞게 입력해 주세요\n예시: 영업/팀장/영업본부장");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateCareer() {
		const carRow = $j(".carRow");
		
		for (let i = 0; i < carRow.length; i++) {
			const je = $j(carRow[i]);
			
			const shouldValidate = !isAllInputEmpty(je);
			console.log("shouldValidate=" + shouldValidate);
			
			if (shouldValidate
					&& (!validateDoublePeriod(je.find("input[name='carStartPeriod']"), "근무기간 시작 날짜", je.find("input[name='carEndPeriod']"), "근무기간 종료 날짜")
							|| !validateNonEmpty(je.find("input[name='compName']"), "회사명")
							|| !validateTask(je.find("input[name='task']")))) {
				return false;
			}
		}
		return true;
	}
	
	function validateCertificate() {
		const certRow = $j(".certRow");
		
		for (let i = 0; i < certRow.length; i++) {
			const je = $j(certRow[i]);
			
			const shouldValidate = !isAllInputEmpty(je);
			
			if (shouldValidate
					&& (!validateNonEmpty(je.find("input[name='qualifiName']"), "자격증명")
							|| !validatePeriod(je.find("input[name='acquDate']"), "취득일")
							|| !validateNonEmpty(je.find("input[name='organizeName']"), "발행처"))) {
				return false;
			}
		}
		return true;
	}
	
	function isAllInputEmpty(jElem) {
		const jInput = jElem.find("input[type='text']");
		for (let i = 0; i < jInput.length; i++) {
			const inputValue = $j(jInput[i]).val();
			console.log("inputValue=" + inputValue);
			if (inputValue.length !== 0) {
				console.log("allInputEmtpy = false");
				return false;
			}
		}
		console.log("allInputEmpty = true");
		return true;
	}
	
	function validateDateRange() {
		const birthDate = new Date($j("#birth").val());
		console.log("birthDate=" + birthDate);
		
		const periodCache = [];
		
		const eduRows = $j(".eduRow");
		for (let i = 0; i < eduRows.length; i++) {
			const je = $j(eduRows[i]);
			const startPeriod = new Date(je.find("input[name='eduStartPeriod']").val());
			const endPeriod = new Date(je.find("input[name='eduEndPeriod']").val());
			
			if (birthDate - startPeriod >= 0) {
				alert("재학기간이 생년월일보다 빠르지 않게 해 주세요");
				je.find("input[name='eduStartPeriod']").trigger("focus");
				return false;
			}
			
			for (let period of periodCache) {
				if (startPeriod - period.startPeriod >= 0 && period.endPeriod - startPeriod >= 0
						|| (period.startPeriod - startPeriod >= 0 && endPeriod - period.endPeriod >= 0)) {
					alert("재학기간이 겹치지 않게 해 주세요");
					je.find("input[name='eduStartPeriod']").trigger("focus");
					return false;
				}
				if (endPeriod - period.startPeriod >= 0 && period.endPeriod - endPeriod >= 0) {
					alert("재학기간이 겹치지 않게 해 주세요");
					je.find("input[name='eduEndPeriod']").trigger("focus");
					return false;
				}
			}
			periodCache.push({
				startPeriod: startPeriod,
				endPeriod: endPeriod,
				kind: "edu"
			});
		}
		
		const carRows = $j(".carRow");
		for (let i = 0; i < carRows.length; i++) {
			const je = $j(carRows[i]);
			const startPeriod = new Date(je.find("input[name='carStartPeriod']").val());
			const endPeriod = new Date(je.find("input[name='carEndPeriod']").val());
			
			if (birthDate - startPeriod > 0) {
				alert("근무기간이 생년월일보다 빠르지 않게 해 주세요");
				je.find("input[name='carStartPeriod']").trigger("focus");
				return false;
			}
			
			for (let period of periodCache) {
				const message = period.kind === "edu" ? "근무기간이 재학기간과 겹치지 않게 해 주세요" : "근무기간끼리 겹치지 않게 해 주세요";
				if (startPeriod - period.startPeriod >= 0 && period.endPeriod - startPeriod >= 0
						|| (period.startPeriod - startPeriod >= 0 && endPeriod - period.endPeriod >= 0)) {
					alert(message);
					je.find("input[name='carStartPeriod']").trigger("focus");
					return false;
				}
				if (endPeriod - period.startPeriod >= 0 && period.endPeriod - endPeriod >= 0) {
					alert(message);
					je.find("input[name='carEndPeriod']").trigger("focus");
					return false;
				}
			}
			periodCache.push({
				startPeriod: startPeriod,
				endPeriod: endPeriod,
				kind: "car"
			});
		}
		
		const certRows = $j(".certRow");
		for (let i = 0; i < certRows.length; i++) {
			const je = $j(certRows[i]);
			const acqueDate = new Date(je.find("input[name='acquDate']").val());
			
			if (birthDate - acqueDate > 0) {
				alert("자격증 취득일이 생년월일보다 빠르지 않게 해 주세요");
				je.find("input[name='acqueDate']").trigger("focus");
				return false;
			}
		}
		
		return true;
	}
</script>

</head>
<body>
	<table align="center">
		<tr align="center">
			<td>
				<h1>입사 지원서</h1>
			</td>
		</tr>
	</table>
	<table align="center" border="1">
		<tr>
			<td>
				<table align="center">
					<tr>
						<td>
							<table border ="1">
								<tr>
									<td width="120" align="center">
										이름
									</td>
									<td width="300">
										<input name="name" type="text" size="35" value="${name}" disabled>
									</td>
									<td width="120" align="center">
										생년월일
									</td>
									<td width="300">
										<input class="birth" id="birth" name="birth" type="text" size="35" value="${recruitVo.birth}" />
									</td>
								</tr>
								<tr>
									<td width="120" align="center">
										성별
									</td>
									<td width="300">
										<select name="gender">
											<option value="MALE" <c:if test="${recruitVo != null && recruitVo.gender == 'MALE'}">selected</c:if>>남자</option>
											<option value="FEMALE" <c:if test="${recruitVo != null && recruitVo.gender == 'FEMALE'}">selected</c:if>>여자</option>
										</select>
									</td>
									<td width="120" align="center">
										연락처
									</td>
									<td width="300">
										<input name="phone" type="text" size="35" value="${phone}" disabled>
									</td>
								</tr>
								<tr align="center">
									<td width="120" align="center">
										email
									</td>
									<td width="300" align="center">
										<input class="email" name="email" type="text" size="35" value="${recruitVo.email}">
									</td>
									<td width="120" align="center">
										주소
									</td>
									<td width="300" align="center">
										<input name="addr" type="text" size="35" value="${recruitVo.addr}">
									</td>
								</tr>
								<tr>
									<td width="120" align="center">
										희망근무지
									</td>
									<td>
										<select name="desiredLocation">
											<c:forEach var="entry" items="${locationSelections}">
												<option value="${entry.key}" <c:if test="recruitVo != null && recruitVo.location == entry.key">selected</c:if>>${entry.value}</option>
											</c:forEach>
										</select>
									</td>
									<td width="120" align="center">
										근무형태
									</td>
									<td width="300">
										<select name="workType">
											<option value="FULLTIME" <c:if test="${recruitVo.workType == 'FULLTIME'}">selected</c:if>>정규직</option>
											<option value="TEMPORARY" <c:if test="${recruitVo.workType == 'TEMPORARY'}">selected</c:if>>계약직</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				
				<c:if test="${additionalInfo != null}">
					<table border="1" align="center">
						<tr>
							<td>학력사항</td>
							<td>경력사항</td>
							<td>희망연봉</td>
							<td>희망근무지/근무형태</td>
						</tr>
						<tr>
							<td>${additionalInfo.educationInfo}</td>
							<td>${additionalInfo.careerInfo}</td>
							<td>${additionalInfo.desiredSalary}</td>
							<td>
								${locationSelections.get(additionalInfo.desiredLocation)}전체
								<br>
								<c:if test="${additionalInfo.workType == 'FULLTIME'}">
									정규직
								</c:if>
								<c:if test="${additionalInfo.workType} == 'TEMPORARY'">
									계약직
								</c:if>
							</td>
						</tr>
					</table>
				</c:if>
				
				<h1>학력</h1>
				<table align="center">
					<tr align="right">
						<td>
							<button type="button" class="addButton" data-type="edu">추가</button>
						</td>
						<td>
							<button type="button" class="deleteButton" data-type="edu">삭제</button>
						</td>
					</tr>
					<tr>
						<td>
							<table border="1" id="eduTable">
								<tr align="center">
									<td width="30">
									</td>
									<td width="200">
										재학기간
									</td>
									<td width="100">
										구분
									</td>
									<td width="200">
										학교명(소재지)
									</td>
									<td width="200">
										전공
									</td>
									<td width="200">
										학점
									</td>
								</tr>
								<c:if test="${recruitVo != null}">
									<c:forEach var="elem" items="${recruitVo.educations}">
										<tr class="eduRow">
											<td width="30">
												<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
											</td>
											<td width="200">
												<input class="datepicker" type="text" name="eduStartPeriod" value="${elem.startPeriod}">
												~
												<input class="datepicker" type="text" name="eduEndPeriod" value="${elem.endPeriod}">
											</td>
											<td width="100">
												<select name="division">
													<option value="ENROLLED_IN" <c:if test="${elem.division == 'ENROLLED_IN'}">selected</c:if>>재학</option>
													<option value="DROPPED_OUT" <c:if test="${elem.division == 'DROPPED_OUT'}">selected</c:if>>중퇴</option>
													<option value="GRADUATED" <c:if test="${elem.division == 'GRADUATED'}">selected</c:if>>졸업</option>
												</select>
											</td>
											<td width="200">
												<input type="text" name="schoolName" value="${elem.schoolName}">
												<select name="eduLocation">
													<c:forEach var="entry" items="${locationSelections}">
														<option value="${entry.key}" <c:if test="${elem.location == entry.key}">selected</c:if>>${entry.value}</option>
													</c:forEach>
												</select>
											</td>
											<td width="200">
												<input type="text" name="major" value="${elem.major}">
											</td>
											<td width="200">
												<input type="text" name="grade" value="${elem.grade}">
											</td>
										</tr>
									</c:forEach>
								</c:if>
								<c:if test="${recruitVo == null}">
									<tr class="eduRow">
										<td width="30">
											<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
										</td>
										<td width="200">
											<input class="datepicker" type="text" name="eduStartPeriod">
											~
											<input class="datepicker" type="text" name="eduEndPeriod">
										</td>
										<td width="100">
											<select name="division">
												<option value="ENROLLED_IN">재학</option>
												<option value="DROPPED_OUT">중퇴</option>
												<option value="GRADUATED">졸업</option>
											</select>
										</td>
										<td width="200">
											<input type="text" name="schoolName">
											<select name="eduLocation">
												<c:forEach var="entry" items="${locationSelections}">
													<option value="${entry.key}">${entry.value}</option>
												</c:forEach>
											</select>
										</td>
										<td width="200">
											<input type="text" name="major">
										</td>
										<td width="200">
											<input type="text" name="grade">
										</td>
									</tr>
								</c:if>
							</table>
						</td>
					</tr>
				</table>
				<h1>경력</h1>
				<table align="center">
					<tr align="right">
						<td>
							<button type="button" class="addButton" data-type="car">추가</button>
						</td>
						<td>
							<button type="button" class="deleteButton" data-type="car">삭제</button>
						</td>
					</tr>
					<tr>
						<td>
							<table border ="1" id="carTable">
								<tr align="center">
									<td width="30">
									</td>
									<td width="300">
										근무기간
									</td>
									<td width="200">
										회사명
									</td>
									<td width="200">
										부서/직급/직책
									</td>
									<td width="200">
										지역
									</td>
								</tr>
								<c:if test="${recruitVo != null && recruitVo.careers.size() > 0}">
									<c:forEach var="elem" items="${recruitVo.careers}">
										<tr class="carRow">
											<td width="30">
												<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
											</td>
											<td width="300">
												<input class="datepicker" type="text" name="carStartPeriod" value="${elem.startPeriod}">
												~
												<input class="datepicker" type="text" name="carEndPeriod" value="${elem.endPeriod}">
											</td>
											<td width="200">
												<input type="text" name="compName" value="${elem.compName}">
											</td>
											<td width="200">
												<input type="text" name="task" value="${elem.task}">
											</td>
											<td width="200">
												<select name="carLocation">
													<c:forEach var="entry" items="${locationSelections}">
														<option value="${entry.key}" <c:if test="${elem.location == entry.key}">selected</c:if>>${entry.value}</option>
													</c:forEach>
												</select>
											</td>
										</tr>
									</c:forEach>
								</c:if>
								<c:if test="${recruitVo == null || recruitVo.careers.size() == 0}">
									<tr class="carRow">
										<td width="30">
											<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
										</td>
										<td width="300">
											<input class="datepicker" type="text" name="carStartPeriod">
											~
											<input class="datepicker" type="text" name="carEndPeriod">
										</td>
										<td width="200">
											<input type="text" name="compName">
										</td>
										<td width="200">
											<input type="text" name="task">
										</td>
										<td width="200">
											<select name="carLocation">
												<c:forEach var="entry" items="${locationSelections}">
													<option value="${entry.key}">${entry.value}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
								</c:if>
							</table>
						</td>
					</tr>
				</table>
				<h1>자격증</h1>
				<table align="center">
					<tr align="right">
						<td>
							<button type="button" class="addButton" data-type="cert">추가</button>
						</td>
						<td>
							<button type="button" class="deleteButton" data-type="cert">삭제</button>
						</td>
					</tr>
					<tr>
						<td>
							<table border ="1" id="certTable">
								<tr align="center">
									<td width="30">
									</td>
									<td width="300">
										자격증명
									</td>
									<td width="300">
										취득일
									</td>
									<td width="300">
										발행처
									</td>
								</tr>
								<c:if test="${recruitVo != null && recruitVo.certificates.size() > 0}">
									<c:forEach var="elem" items="${recruitVo.certificates}">
										<tr class="certRow">
											<td width="30">
												<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
											</td>
											<td width="300">
												<input type="text" name="qualifiName" value="${elem.qualifiName}">
											</td>
											<td width="300">
												<input class="datepicker" type="text" name="acquDate" value="${elem.acquDate}">
											</td>
											<td width="300">
												<input type="text" name="organizeName" value="${elem.organizeName}">
											</td>
										</tr>
									</c:forEach>
								</c:if>
								<c:if test="${recruitVo == null || recruitVo.certificates.size() == 0}">
									<tr class="certRow">
										<td width="30">
											<input type="checkbox" class="toDelete" name="deleteEdu" value="1">
										</td>
										<td width="300">
											<input type="text" name="qualifiName">
										</td>
										<td width="300">
											<input class="datepicker" type="text" name="acquDate">
										</td>
										<td width="300">
											<input type="text" name="organizeName">
										</td>
									</tr>
								</c:if>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<table align="center">
		<tr align="center">
			<td>
				<button type="button" id="storeButton">저장</button>
			</td>
			<td>
				<button type="button" id="submitButton">제출</button>
			</td>
		</tr>
	</table>
</body>
</html>
