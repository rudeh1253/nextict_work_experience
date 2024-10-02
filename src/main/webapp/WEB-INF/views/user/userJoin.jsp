<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>memberJoin</title>
</head>
<script type="text/javascript">
	let isDuplicated = true;
	
	const regexForNotKorean = /[^ㄱ-힝]/;
	
	let lastUserIdInput = "";
	
	$j(document).ready(function() {
		
		$j("input[name='userId']").on("keyup blur", function(e) {
			isDuplicated = true;
			
			console.log(e);
			
			const regexForNotAlphabet = new RegExp("[^a-zA-Z0-9]+");
			
			const v = $j(this).val();
			console.log(v);
			if (regexForNotAlphabet.test(v)) {
				$j(this).val(v.replace(regexForNotAlphabet, ""));
			}
		});
		
		$j("input[name='userName']").on("keyup blur", function(e) {
			const v = $j(this).val();
			console.log(v);
			if (regexForNotKorean.test(v)) {
				$j(this).val(v.replace(regexForNotKorean, ""));
			}
		});
		
		const prevStateHolder = {
				prevValue: ""
		};
		
		$j("input[name='userAddr1']").on("keyup blur", function(e) {
			const regexToRemove = new RegExp("[^0-9]");
			if (e.originalEvent.key !== "Backspace"
					&& e.originalEvent.key !== "ArrowLeft"
					&& e.originalEvetn.key !== "ArrowRight"
					&& e.originalEvent.key !== "ArrowUp"
					&& e.originalEvent.key !== "ArrowDown"
					&& regexToRemove.test(e.originalEvent.key)) {
				$j(this).val(prevStateHolder.prevValue);
				console.log("here");
				return;
			}
			
			const v = $j(this).val();
			let nVal = v;
			
			const digitNum = numOfDigits(v);
			
			if (digitNum > 3) {
				console.log("numOfDigits is over 3");
				const reg = new RegExp("^[0-9]{3}\\-[0-9]+$");
				
				if (!reg.test(v)) {
					const replaced = v.replaceAll("-", "");
					nVal = replaced.substring(0, 3) + "-" + replaced.substring(3);
					$j(this).val(nVal);

					if (nVal.length > 7) {
						nVal = nVal.substring(0, 7)
						$j(this).val(nVal);
					}
				}
			} else {
				nVal = v.replaceAll("-", "");
				$j(this).val(nVal);
			}
			
			const convertCondition2 = new RegExp("^[0-9]{3}\\-$");
			if (convertCondition2.test(v)) {
				nVal = v.substring(0, 3);
				$j(this).val(nVal);
			}
			
			prevStateHolder.prevValue = nVal;
		});
		
		function numOfDigits(val) {
			let count = 0;
			for (let c of val) {
				if (!isNaN(parseInt(c))) {
					count++;
				}
			}
			return count;
		}
		
		$j("input[name='userPhone2']").on("keyup blur", function(e) {
			const maxLength = parseInt($j(this).attr("maxlength"));
			if (e.target.value.length > maxLength) {
				e.target.value = e.target.value.substring(0, maxLength);
			}
		});
		
		$j("input[name='userPhone3']").on("keyup blur", function(e) {
			const maxLength = parseInt($j(this).attr("maxlength"));
			if (e.target.value.length > maxLength) {
				e.target.value = e.target.value.substring(0, maxLength);
			}
		});
		
		$j("#checkDuplicateButton").on("click", function() {
			const userId = $j("input[name='userId']").val();
			
			if (userId === "") {
				alert("ID를 입력해 주세요");
				$j("input[name='userId']").trigger("focus");
				return;
			}
			
			$j.ajax({
				url: "/user/checkUserIdDuplicate.do",
				type: "GET",
				data: {
					userId: userId
				},
				success: function(data, textStatus, jqXHR) {
					console.log(data);
					console.log(typeof data.isDuplicate);
					console.log(typeof data.isDuplicate === true);
					if (data.isDuplicate) {
						alert("중복된 ID입니다.");
						$j("input[name='userId']").trigger("focus");
						isDuplicated = true;
					} else {
						alert("사용 가능한 ID입니다.");
						$j("input[name='userPw']").trigger("focus");
						isDuplicated = false;
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					alert("통신불량");
				}
			});
		});
		
		$j("#joinButton").on("click", () => {
			const success = validate();
			if (success) {
				$j.ajax({
					url: "/user/userJoinAction.do",
					type: "POST",
					dataType: "json",
					contentType: "application/json;euc-kr",
					data: JSON.stringify({
						userId: $j("input[name='userId']").val(),
						userPw: $j("input[name='userPw']").val(),
						userName: $j("input[name='userName']").val(),
						userPhone1: $j("select[name='userPhone1']").val(),
						userPhone2: $j("input[name='userPhone2']").val(),
						userPhone3: $j("input[name='userPhone3']").val(),
						userAddr1: $j("input[name='userAddr1']").val(),
						userAddr2: $j("input[name='userAddr2']").val(),
						userCompany: $j("input[name='userCompany']").val()
					}),
					success: function(data, textStatus, jqXHR) {
						alert("가입완료");
						alert("메세지: " + data.success);
						window.location.href = "/user/loginView.do";
					},
					error: function(jqXHR, textStatus, errorThrown) {
						alert("통신불량");
					}
				});
			} else {
				console.log("failed");
			}
		});
	});
	
	function validate() {
		return validateId()
				&& validatePassword()
				&& validateName()
				&& validatePhone()
				&& validatePostNo();
	}
	
	function validateId() {
		const jUserIdInput = $j("input[name='userId']");
		const idVal = jUserIdInput.val();
		
		if (idVal.length === 0) {
			alert("ID를 입력해 주세요");
			jUserIdInput.trigger("focus");
			return false;
		}
		
		if (isDuplicated) {
			alert("ID 중복확인해 주세요");
			$j("#checkDuplicateButton").trigger("focus");
			return false;
		}
		
		return true;
	}
	
	function validatePassword() {
		const jPwInput = $j("input[name='userPw']");
		const jPwCheckInput = $j("input[name='userPwCheck']");
		const pw = jPwInput.val();
		const pwCheck = jPwCheckInput.val();
		console.log("pw=" + pw);
		console.log("pwCheck=" + pwCheck);
		
		if (pw.length === 0) {
			alert("패스워드를 입력해 주세요");
			jPwInput.trigger("focus");
			return false;
		}
		
		if (pw.length < 6 || pw.length > 12) {
			alert("패스워드는 6자리 ~ 12자리로 입력해 주세요");
			jPwInput.trigger("focus");
			return false;
		}
		
		if (pwCheck.length === 0) {
			alert("pw check를 입력해 주세요");
			jPwCheckInput.trigger("focus");
			return false;
		}
		
		if (pw !== pwCheck) {
			alert("pw와 pw check가 일치하지 않습니다");
			jPwCheckInput.trigger("focus");
			return false;
		}
		return true;
	}
	
	function validateName() {
		const jNameInput = $j("input[name='userName']");
		const name = jNameInput.val();
		
		if (name.length === 0) {
			alert("이름을 입력해 주세요");
			jNameInput.trigger("focus");
			return false;
		}
		return true;
	}
	
	function validatePhone() {
		const secondNum = $j("input[name='userPhone2']").val();
		const thirdNum = $j("input[name='userPhone3']").val();
		
		if (secondNum.length === 0) {
			alert("두 번째 휴대전화번호를 입력해 주세요");
			$j("input[name='userPhone2']").trigger("focus");
			return false;
		}
		
		if (thirdNum.length === 0) {
			alert("세 번째 휴대전화번호를 입력해 주세요");
			$j("input[name='userPhone3']").trigger("focus");
			return false;
		}
		
		if (secondNum.length !== 4) {
			alert("휴대전화번호는 각각 4자리여야 합니다.");
			$j("input[name='userPhone2']").trigger("focus");
			return false;
		}
		
		if (thirdNum.length !== 4) {
			alert("휴대전화번호는 각각 4자리여야 합니다.");
			$j("input[name='userPhone3']").trigger("focus");
			return false;
		}
		return true;
	}
	
	function validatePostNo() {
		const jPostNoInput = $j("input[name='userAddr1']");
		const postNo = jPostNoInput.val();
		
		if (postNo.length === 0) {
			alert("postNo를 입력해 주세요");
			jPostNoInput.trigger("focus");
			return false;
		}
		
		const reg = new RegExp("[0-9]{3}\\-[0-9]{3}");
		if (reg.test(postNo)) {
			return true;
		}
		alert("postNo는 xxx-xxx 형식이어야 합니다.");
		jPostNoInput.trigger("focus");
		return false;
	}
</script>
<body>
	<table align="center">
		<tr>
			<td align="left">
				<a href="/board/boardList.do">List</a>
			</td>
		</tr>
		<form id="joinForm">
			<tr>
				<td>
					<table border ="1">
						<tr>
							<td width="120" align="center">
								id
							</td>
							<td width="300">
								<input name="userId" type="text" size="20" maxlength="14">
								<button type="button" id="checkDuplicateButton">중복확인</button>
							</td>
						</tr>
						<tr>
							<td width="120" align="center">
								pw
							</td>
							<td width="300">
								<input name="userPw" type="password" size="25">
							</td>
						</tr>
						<tr>
							<td width="120" align="center">
								pw check
							</td>
							<td width="300">
								<input name="userPwCheck" type="password" size="25">
							</td>
						</tr>
						<tr>
							<td width="120" align="center">
								name
							</td>
							<td width="300">
								<input name="userName" type="text" size="30" maxlength="5">
							</td>
						</tr>
						<tr>
							<td width="120" align="center">
								phone
							</td>
							<td width="300">
								<select name="userPhone1">
									<c:forEach var="item" items="${phoneFirstList}">
										<option value="${item.codeName}" label="${item.codeName}">
									</c:forEach>
								</select>
								-
								<input type="number" name="userPhone2" style="width: 4em" maxlength="4">
								-
								<input type="number" name="userPhone3" style="width: 4em" maxlength="4">
							</td>
						</tr>
						<tr>
							<td width="120" align="center">
								postNo
							</td>
							<td width="300">
								<input name="userAddr1" type="text" size="30" maxlength="7">
							</td>
						</tr>
						<tr>
							<td width="120" align="center">
								address
							</td>
							<td width="300">
								<input name="userAddr2" type="text" size="30" maxlength="50">
							</td>
						</tr>
						<tr>
							<td width="120" align="center">
								company
							</td>
							<td width="300">
								<input name="userCompany" type="text" size="30" maxlength="20">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="right">
					<button id="joinButton" type="button">join</button>
				</td>
			</tr>
		</form>
	</table>	
</body>
</html>