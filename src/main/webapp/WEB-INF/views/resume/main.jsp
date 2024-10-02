<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>�Ի������� �ۼ�</title>

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
								<option value="ENROLLED_IN">����</option>
								<option value="DROPPED_OUT">����</option>
								<option value="GRADUATED">����</option>
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
					
					alert(isSubmit === "true" ? "������ �Ϸ�Ǿ����ϴ�." : "����Ǿ����ϴ�.");
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
			const regexForNotKorean = new RegExp("[^��-��]", "g");
			
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
		// Datepicker ����
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
		// ������ ���� ���� �Է� �� ���� �Է� ���� ���·� ����
		const v = jThis.val();
		const regexToRemove = new RegExp("[^0-9\\.]");
		if (regexToRemove.test(v)) {
			console.log("no");
			jThis.val(prevStateHolder.prevState);
			return;
		}
		
		// �ڵ����� separator ����
		let nVal = v;
		
		const digitNum = numOfDigits(v);
		
		const separatorRegex = isRegexEscapeNeeded ? "\\" + separator : separator;
		
		if (digitNum > firstLen) { // separator�� �����ؾ� �ϴ� ���
			const reg = new RegExp("^[0-9]{" + firstLen + "}" + separatorRegex + "[0-9]+$");
			
			if (!reg.test(v)) {
				const replaced = v.replaceAll(separator, "");
				nVal = replaced.substring(0, firstLen) + separator + replaced.substring(firstLen);
				jThis.val(nVal);
			}
			
			// �ִ� ���� ����
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
			alert("�ϳ� �̻��� �з��� �Է��� �ּ���");
			return false;
		}
		
		for (let i = 0; i < eduRow.length; i++) {
			const je = $j(eduRow[i]);
			if (!validateDoublePeriod(je.find("input[name='eduStartPeriod']"), "���бⰣ ���� ��¥", je.find("input[name='eduEndPeriod']"), "���бⰣ ���� ��¥")
					|| !validateNonEmpty(je.find("input[name='schoolName']"), "�б���")
					|| !validateNonEmpty(je.find("input[name='major']"), "����")
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
			alert("�̸��� �Է��� �ּ���");
			jElem.trigger("focus");
			return false;
		}
		
		const regexForKor = new RegExp("^[��-��]+$");
		if (!regexForKor.test(name)) {
			alert("�̸� ������ ���� �ʽ��ϴ�. (�ʼ�, �߼��� ��� �Էµ� �ѱ� �����̾�� �մϴ�)\n����: ȫ�浿");
			jElem.trigger("focus");
			return false;
		}
		return true;
	}
	
	function validateBirth() {
		const jElem = $j("input[name='birth']");
		const birth = jElem.val();
		
		if (!birth || birth.length === 0) {
			alert("��������� �Է��� �ּ���")
			jElem.trigger("focus");
			return false;
		}
		
		const birthDate = new Date(birth);
		const birthRegex = new RegExp("[0-9]{4}\\.[0-9]{2}\\.[0-9]{2}");
		
		if (isNaN(birthDate) || !birthRegex.test(birth)) {
			alert("������� ������ ���� �ʽ��ϴ�. (yyyy.mm.dd �����̾�� �մϴ�)\n����: 1997.09.01");
			jElem.trigger("focus");
			return false;
		}
		
		const now = new Date();
		if (now - birthDate < 0) {
			alert("���纸�� ���� ��¥�� ������ �ּ��� (����: "
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
			alert("����ó�� �Է��� �ּ���.")
			jElem.trigger("focus");
			return false;
		}
		
		if ((phone.length !== 10
				&& phone.length !== 11)
				|| !allowedPhoneStarts.has(phone.substring(0, 3))) {
			alert("����ó ������ ���� �ʽ��ϴ�.\n"
					+ "(010/011/016/017/019�� �����ϴ� 10�ڸ� Ȥ�� 11�ڸ� ���ڿ��� �մϴ�.)\n����: 01012341234");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateEmailFormat() {
		const jElem = $j("input[name='email']");
		const email = jElem.val();
		
		if (!email || email.length === 0) {
			alert("email�� �Է��� �ּ���");
			jElem.trigger("focus");
			return false;
		}
		
		const emailRegex = new RegExp("^[a-zA-Z0-9]+@([a-zA-Z]+\\.[a-zA-Z]+)+$");
		
		if (!emailRegex.test(email)) {
			alert("�̸��� ������ ���� �ʽ��ϴ�.\n����: test@gmail.com or test@khu.ac.kr");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateAddr() {
		const jElem = $j("input[name='addr']");
		const addr = jElem.val();
		
		if (!addr || addr.length === 0) {
			alert("�ּҸ� �Է��� �ּ���.");
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
			alert("���� ��¥�� ���� ��¥���� ������ �� �ּ���\n����:\n2023.08 ~ 2023.09 o\n2023.08 ~ 2023.07 x\n2023.08 ~ 2023.08 x\n");
			jElemBefore.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validatePeriod(jElem, elemName) {
		const period = jElem.val();
		
		if (!period || period.length === 0) {
			alert(elemName + "�� �Է��� �ּ���");
			jElem.trigger("focus");
			return false;
		}
		
		
		const periodFormat = new RegExp("^[0-9]{4}\\.[0-9]{2}$");
		
		if (!periodFormat.test(period)) {
			alert(elemName + " ������ ���� �ʽ��ϴ�. (yyyy.mm ������ �����ּ���)\n ����: 2018.01");
			jElem.trigger("focus");
			return false;
		}
		
		const [year, month] = period.split(".").map(function (e) { return parseInt(e) });
		
		if (year > new Date().getFullYear()) {
			alert(elemName + "�� ������ ������ Ȯ���� �ּ��� (���� �ð����� ������ �� �˴ϴ�)");
			jElem.trigger("focus");
			return false;
		}
		
		if (month < 1 || month > 12) {
			alert(elemName + "�� �� ������ Ȯ���� �ּ��� (1 ~ 12)");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateNonEmpty(jElem, elemName) {
		const v = jElem.val();
		
		if (!v || v.length === 0) {
			alert(elemName + "�� �Է��� �ּ���");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateGrade(jElem) {
		const grade = jElem.val();
		
		if (!grade || grade.length === 0) {
			alert("������ �Է��� �ּ���.");
			jElem.trigger("focus");
			return false;
		}
		
		const format = new RegExp("^[0-9]\\.[0-9]{1,2}$");
		
		if (!format.test(grade)) {
			alert("���� ������ ���� �ʽ��ϴ�. �Ҽ��� �� �ڸ� Ȥ�� �� �ڸ����� �Է��� �ּ���.\n"
					+ "������ 0.0 ~ 4.5�Դϴ�.\n"
					+ "����: 3.14, 4.5");
			jElem.trigger("focus");
			return false;
		}
		
		const gradeNum = parseFloat(grade);
		
		if (gradeNum < 0 || gradeNum > 4.5) {
			alert("������ ������ Ȯ���� �ּ��� (0 <= ���� <= 4.5)");
			jElem.trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validateTask(jElem) {
		const task = jElem.val();
		
		if (!task || task.length === 0) {
			alert("�μ�/����/��å�� �Է��� �ּ���");
			jElem.trigger("focus");
			return false;
		}
		
		if (task.split("/").length !== 3) {
			alert("�μ�/����/��å ���Ŀ� �°� �Է��� �ּ���\n����: ����/����/����������");
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
					&& (!validateDoublePeriod(je.find("input[name='carStartPeriod']"), "�ٹ��Ⱓ ���� ��¥", je.find("input[name='carEndPeriod']"), "�ٹ��Ⱓ ���� ��¥")
							|| !validateNonEmpty(je.find("input[name='compName']"), "ȸ���")
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
					&& (!validateNonEmpty(je.find("input[name='qualifiName']"), "�ڰ�����")
							|| !validatePeriod(je.find("input[name='acquDate']"), "�����")
							|| !validateNonEmpty(je.find("input[name='organizeName']"), "����ó"))) {
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
				alert("���бⰣ�� ������Ϻ��� ������ �ʰ� �� �ּ���");
				je.find("input[name='eduStartPeriod']").trigger("focus");
				return false;
			}
			
			for (let period of periodCache) {
				if (startPeriod - period.startPeriod >= 0 && period.endPeriod - startPeriod >= 0
						|| (period.startPeriod - startPeriod >= 0 && endPeriod - period.endPeriod >= 0)) {
					alert("���бⰣ�� ��ġ�� �ʰ� �� �ּ���");
					je.find("input[name='eduStartPeriod']").trigger("focus");
					return false;
				}
				if (endPeriod - period.startPeriod >= 0 && period.endPeriod - endPeriod >= 0) {
					alert("���бⰣ�� ��ġ�� �ʰ� �� �ּ���");
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
				alert("�ٹ��Ⱓ�� ������Ϻ��� ������ �ʰ� �� �ּ���");
				je.find("input[name='carStartPeriod']").trigger("focus");
				return false;
			}
			
			for (let period of periodCache) {
				const message = period.kind === "edu" ? "�ٹ��Ⱓ�� ���бⰣ�� ��ġ�� �ʰ� �� �ּ���" : "�ٹ��Ⱓ���� ��ġ�� �ʰ� �� �ּ���";
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
				alert("�ڰ��� ������� ������Ϻ��� ������ �ʰ� �� �ּ���");
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
				<h1>�Ի� ������</h1>
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
										�̸�
									</td>
									<td width="300">
										<input name="name" type="text" size="35" value="${name}" disabled>
									</td>
									<td width="120" align="center">
										�������
									</td>
									<td width="300">
										<input class="birth" id="birth" name="birth" type="text" size="35" value="${recruitVo.birth}" />
									</td>
								</tr>
								<tr>
									<td width="120" align="center">
										����
									</td>
									<td width="300">
										<select name="gender">
											<option value="MALE" <c:if test="${recruitVo != null && recruitVo.gender == 'MALE'}">selected</c:if>>����</option>
											<option value="FEMALE" <c:if test="${recruitVo != null && recruitVo.gender == 'FEMALE'}">selected</c:if>>����</option>
										</select>
									</td>
									<td width="120" align="center">
										����ó
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
										�ּ�
									</td>
									<td width="300" align="center">
										<input name="addr" type="text" size="35" value="${recruitVo.addr}">
									</td>
								</tr>
								<tr>
									<td width="120" align="center">
										����ٹ���
									</td>
									<td>
										<select name="desiredLocation">
											<c:forEach var="entry" items="${locationSelections}">
												<option value="${entry.key}" <c:if test="recruitVo != null && recruitVo.location == entry.key">selected</c:if>>${entry.value}</option>
											</c:forEach>
										</select>
									</td>
									<td width="120" align="center">
										�ٹ�����
									</td>
									<td width="300">
										<select name="workType">
											<option value="FULLTIME" <c:if test="${recruitVo.workType == 'FULLTIME'}">selected</c:if>>������</option>
											<option value="TEMPORARY" <c:if test="${recruitVo.workType == 'TEMPORARY'}">selected</c:if>>�����</option>
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
							<td>�з»���</td>
							<td>��»���</td>
							<td>�������</td>
							<td>����ٹ���/�ٹ�����</td>
						</tr>
						<tr>
							<td>${additionalInfo.educationInfo}</td>
							<td>${additionalInfo.careerInfo}</td>
							<td>${additionalInfo.desiredSalary}</td>
							<td>
								${locationSelections.get(additionalInfo.desiredLocation)}��ü
								<br>
								<c:if test="${additionalInfo.workType == 'FULLTIME'}">
									������
								</c:if>
								<c:if test="${additionalInfo.workType} == 'TEMPORARY'">
									�����
								</c:if>
							</td>
						</tr>
					</table>
				</c:if>
				
				<h1>�з�</h1>
				<table align="center">
					<tr align="right">
						<td>
							<button type="button" class="addButton" data-type="edu">�߰�</button>
						</td>
						<td>
							<button type="button" class="deleteButton" data-type="edu">����</button>
						</td>
					</tr>
					<tr>
						<td>
							<table border="1" id="eduTable">
								<tr align="center">
									<td width="30">
									</td>
									<td width="200">
										���бⰣ
									</td>
									<td width="100">
										����
									</td>
									<td width="200">
										�б���(������)
									</td>
									<td width="200">
										����
									</td>
									<td width="200">
										����
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
													<option value="ENROLLED_IN" <c:if test="${elem.division == 'ENROLLED_IN'}">selected</c:if>>����</option>
													<option value="DROPPED_OUT" <c:if test="${elem.division == 'DROPPED_OUT'}">selected</c:if>>����</option>
													<option value="GRADUATED" <c:if test="${elem.division == 'GRADUATED'}">selected</c:if>>����</option>
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
												<option value="ENROLLED_IN">����</option>
												<option value="DROPPED_OUT">����</option>
												<option value="GRADUATED">����</option>
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
				<h1>���</h1>
				<table align="center">
					<tr align="right">
						<td>
							<button type="button" class="addButton" data-type="car">�߰�</button>
						</td>
						<td>
							<button type="button" class="deleteButton" data-type="car">����</button>
						</td>
					</tr>
					<tr>
						<td>
							<table border ="1" id="carTable">
								<tr align="center">
									<td width="30">
									</td>
									<td width="300">
										�ٹ��Ⱓ
									</td>
									<td width="200">
										ȸ���
									</td>
									<td width="200">
										�μ�/����/��å
									</td>
									<td width="200">
										����
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
				<h1>�ڰ���</h1>
				<table align="center">
					<tr align="right">
						<td>
							<button type="button" class="addButton" data-type="cert">�߰�</button>
						</td>
						<td>
							<button type="button" class="deleteButton" data-type="cert">����</button>
						</td>
					</tr>
					<tr>
						<td>
							<table border ="1" id="certTable">
								<tr align="center">
									<td width="30">
									</td>
									<td width="300">
										�ڰ�����
									</td>
									<td width="300">
										�����
									</td>
									<td width="300">
										����ó
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
				<button type="button" id="storeButton">����</button>
			</td>
			<td>
				<button type="button" id="submitButton">����</button>
			</td>
		</tr>
	</table>
</body>
</html>
