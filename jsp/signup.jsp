<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="../css/signup.css">
    <script src="../js/signup.js"></script>
</head>
<body>
    <div id="header">Schedule Calendar</div>
    <form action="../action/signup_action.jsp" method="post" onsubmit="return validateForm()">
        <div id="imformBox">
            <div id="title">회원가입</div>
            <!-- 아이디 입력 폼 -->
            <input type="text" name="id" id="idInput" class="signup" placeholder="아이디" oninput="validateId(); handleInputChange();" required>
            <div id="errorMessage" class="message"></div>
            <input type="button" id="idCheck" name="checkDuplicate" value="중복확인" onclick="idDuplicateEvent()">

            <!-- 비밀번호 입력 폼 -->
            <input type="password" name="password" class="signup" id="password" placeholder="비밀번호" oninput="checkPasswordMatch()" required>
            <input type="password" class="signup" id="confirmPassword" placeholder="비밀번호 확인" oninput="checkPasswordMatch()" required>
            <p id="passwordMatchMessage" class="message"></p>
            <span id="passwordErrorMessage" class="message"></span>

            <!-- 이름 입력 폼 -->
            <input type="text" name="name" class="signup" placeholder="이름" required>

            <!-- 전화번호 입력 폼 -->
            <input type="text" name="phone_num" id="phone" class="signup" placeholder="전화번호" oninput="formatPhoneNumber()" maxlength="13" required>
            <div id="phoneNumberErrorMessage" class="message"></div>
            <!-- 부서 선택 폼 -->
            <div class="selectBox">
               <div for="department">부서</div>
               <input type="radio" id="devDept" name="department" value="개발" required>
               <label for="devDept">개발</label>
               <input type="radio" id="designDept" name="department" value="디자인" required>
               <label for="designDept">디자인</label>
            </div>

            <!-- 직급 선택 폼 -->
            <div class="selectBox">
               <div for="position">직급</div>
               <input type="radio" id="teamLead" name="position" value="팀장" required>
               <label for="teamLead">팀장</label>
               <input type="radio" id="teamMember" name="position" value="팀원" required>
               <label for="teamMember">팀원</label>
            </div>

            <!-- 회원가입 버튼 -->
            <input type="submit" value="회원가입" name="signup" id="submit" class="out">
         </div>
    </form>


    <script>
      // JavaScript로 세션 메시지 확인 후 alert 표시
      var duplicateMessage = '<%= session.getAttribute("duplicateMessage") %>';
      var errorMessage = '<%= session.getAttribute("errorMessage") %>';
      var id="<%= session.getAttribute("idValue") %>";
      var name="<%= session.getAttribute("nameValue") %>";
      var phone_num="<%= session.getAttribute("phone_numValue") %>";
      var department="<%= session.getAttribute("departmentValue") %>";
      var position="<%= session.getAttribute("positionValue") %>";


      var passwordInput = document.getElementById("password");
      var confirmPasswordInput = document.getElementById("confirmPassword");
      var passwordMatchMessage = document.getElementById("passwordMatchMessage");
      var passwordErrorMessage = document.getElementById("passwordErrorMessage");

      console.log(duplicateMessage);
      console.log(errorMessage);
      console.log(id);
      console.log(name);
      console.log(phone_num);
      console.log(department);
      console.log(position);


   
      if (duplicateMessage && duplicateMessage !== 'null') {
          alert(duplicateMessage);
          
          <% session.removeAttribute("duplicateMessage"); %>
          if (duplicateMessage == "사용 가능한 아이디입니다.") {
        // 중복확인 버튼을 비활성화
        document.getElementById("idCheck").disabled = true;

         } else {
            // 중복확인 버튼을 활성화
            document.getElementById("idCheck").disabled = false;
         }
      }

      if (errorMessage && errorMessage!== 'null') {
          alert(errorMessage);
          <% session.removeAttribute("errorMessage"); %>
      }
      
      if(id&&id!=='null'){
         document.querySelector('.signup[name="id"]').value = id;
         <% session.removeAttribute("idValue"); %>
      }
      if(name&&name!=='null'){
         document.querySelector('.signup[name="name"]').value = name;
         <% session.removeAttribute("nameValue"); %>
      }
      if(phone_num&&phone_num!=='null'){
         document.querySelector('.signup[name="phone_num"]').value = phone_num;
         <% session.removeAttribute("phone_numValue"); %>
      }
      
      if (department && department !== 'null') {
         var departmentRadioButton = document.querySelector('input[name="department"][value="' + department + '"]');
         if (departmentRadioButton) {
            departmentRadioButton.checked = true;
         }
         <% session.removeAttribute("departmentValue"); %>
      }

      // position 값이 존재하면 해당 라디오 버튼을 찾아서 체크
      if (position && position !== 'null') {
         var positionRadioButton = document.querySelector('input[name="position"][value="' + position + '"]');
         if (positionRadioButton) {
            positionRadioButton.checked = true;
         }
         <% session.removeAttribute("positionValue"); %>
      }
      // 비밀번호 일치 여부 및 정규식
      function checkPasswordMatch() {
         var password = passwordInput.value;
         var confirmPassword = confirmPasswordInput.value;

         validatePasswordMatch(password, confirmPassword);
         validatePasswordRegex(password);
      }

      function validatePasswordMatch(password, confirmPassword) {
         if (password === confirmPassword) {
               passwordMatchMessage.textContent = "비밀번호가 일치합니다.";
               passwordMatchMessage.style.color = "green";
         } else {
               passwordMatchMessage.textContent = "비밀번호가 일치하지 않습니다.";
               passwordMatchMessage.style.color = "red";
         }
      }

      function validatePasswordRegex(password) {
      var passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
      if (!passwordRegex.test(password)) {
            passwordErrorMessage.textContent = "비밀번호는 대소문자, 숫자, 특수문자를 모두 포함하고 최소 8자 이상이어야 합니다.";
            passwordErrorMessage.style.color = "red";
      } else {
            passwordErrorMessage.textContent = '';
      }
      }

      function formatPhoneNumber() {
      var phoneNumber = document.getElementById('phone').value;

      // 정규식을 사용하여 형식에 맞게 변환
      phoneNumber = phoneNumber.replace(/[^0-9]/g, ''); // 숫자 이외의 문자 제거
      var formattedPhoneNumber = phoneNumber.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');

      // 변환된 전화번호를 다시 입력 폼에 설정
      document.getElementById('phone').value = formattedPhoneNumber;
      }



      // 아이디 유효성 검사 함수
      function validateId() {
         console.log("validateId 함수가 호출되었습니다.");

         var idInput = document.getElementsByName('id')[0];
         var idCheckButton = document.getElementById("idCheck");
         var idRegex = /^[a-z]+[a-z0-9]{6,19}$/;

         if (!idRegex.test(idInput.value)) {
            document.getElementById('duplicateMessage').innerHTML = '';
            document.getElementById('errorMessage').innerHTML = '사용 불가능한 아이디입니다.';
            document.getElementById('errorMessage').style.color = "red";
            idInput.classList.add('error');
            // 아이디가 형식에 맞지 않을 때 버튼 비활성화
            idCheckButton.disabled = true;
         } else {
            document.getElementById('errorMessage').innerHTML = '';
            idInput.classList.remove('error');
            // 아이디가 형식에 맞을 때 버튼 활성화
            idCheckButton.disabled = false;
         }
      }
            // JavaScript로 세션 메시지 확인 후 alert 표시
            var sessionMessage = '<%= session.getAttribute("duplicateMessage") %>';
            if (sessionMessage && sessionMessage !== 'null') {
                alert(sessionMessage);
                <% session.removeAttribute("duplicateMessage"); %>
            }
    

    
             // 비밀번호 일치 여부 및 정규식
             function checkPasswordMatch() {
                var password = passwordInput.value;
                var confirmPassword = confirmPasswordInput.value;
    
                validatePasswordMatch(password, confirmPassword);
                validatePasswordRegex(password);
             }
    
             function validatePasswordMatch(password, confirmPassword) {
                if (password === confirmPassword) {
                   passwordMatchMessage.textContent = "비밀번호가 일치합니다.";
                   passwordMatchMessage.style.color = "green";
                } else {
                   passwordMatchMessage.textContent = "비밀번호가 일치하지 않습니다.";
                   passwordMatchMessage.style.color = "red";
                }
             }
    
             function validatePasswordRegex(password) {
               var passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
               if (!passwordRegex.test(password)) {
                  document.getElementById('passwordErrorMessage').textContent = '비밀번호는 최소 8자 이상, 영문과 숫자를 조합해야 합니다.';
                  document.getElementById('passwordErrorMessage').style.color = "red";
               } else {
                  document.getElementById('passwordErrorMessage').textContent = '';
               }
            }

             //전화번호 정규식
             function formatPhoneNumber() {
                var phoneNumber = document.getElementById('phone').value;
    
                // 정규식을 사용하여 형식에 맞게 변환
                phoneNumber = phoneNumber.replace(/[^0-9]/g, ''); // 숫자 이외의 문자 제거
                if (phoneNumber.length <= 10) {
                  phoneNumberErrorMessage.textContent = '정확한 번호를 입력해주세요.';
                  phoneNumberErrorMessage.style.color = "red";
               }
                var formattedPhoneNumber = phoneNumber.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
   
                // 변환된 전화번호를 다시 입력 폼에 설정
                document.getElementById('phone').value = formattedPhoneNumber;
             }
    
             // id 중복 확인 버튼 클릭 시 실행되는 함수
             function idDuplicateEvent() {
                var id = document.getElementsByName('id')[0].value;
                window.location.href = "../action/signup_action.jsp?checkDuplicate=true&id=" + id;
             }
    
             // 아이디 유효성 검사 함수
             function validateId() {
                var idInput = document.getElementsByName('id')[0];
                var idRegex = /^[a-z]+[a-z0-9]{6,19}$/;
    
                if (!idRegex.test(idInput.value)) {
                   document.getElementById('duplicateMessage').innerHTML = '';
                   document.getElementById('errorMessage').innerHTML = '사용 불가능한 아이디입니다.';
                   document.getElementById('errorMessage').style.color = "red";
                   idInput.classList.add('error');
                } else {
                   document.getElementById('errorMessage').innerHTML = '';
                   idInput.classList.remove('error');
                }
             }
             
             //아이디 수정시 비활성화->활성화
             function handleInputChange() {
               var currentIdValue = document.getElementById("idInput").value;
               
               document.getElementById("idCheck").disabled = false;

            }
        

            function validateForm() {
               var idCheckButton = document.getElementById("idCheck");

               // 중복확인 버튼이 활성화되어 있다면
               if (!idCheckButton.disabled) {
                     // 알림창을 띄우고 제출을 막음
                     alert("아이디 중복확인을 해주세요.");
                     return false;
               }

               // 중복확인 버튼이 비활성화되어 있다면 제출을 허용
               return true;
            }
        </script>
    
</body>
</html>
