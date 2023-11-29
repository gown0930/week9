<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>아이디 찾기</title>
   <link rel="stylesheet" type="text/css" href="../css/find_id.css">
</head>
<body>
   <div id="header">스케줄 캘린더</div>
   <div id="searchBox">
      <form action="../action/find_password_action.jsp" method="post">
         <div id="title">비밀번호 찾기</div>
         <input type="text" name="id" class="signup" placeholder="아이디" required>
         <input type="text" name="name" class="signup" placeholder="이름" required>
         <input type="text" name="phone_num" id="phone" class="signup" placeholder="전화번호" oninput="formatPhoneNumber()" maxlength="13" required>
         <input type="submit" value="비밀번호" id="submit" class="out">
      </form>
   </div>
   <script>
      var errorMessage = '<%= session.getAttribute("errorMessage") %>';
      console.log(errorMessage);
      if (errorMessage && errorMessage !== 'null') {
          alert(errorMessage);
          <% session.removeAttribute("errorMessage"); %>
      }

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
   </script>
</body>
</html>