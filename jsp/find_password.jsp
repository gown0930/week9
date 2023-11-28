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
         <input type="text" name="phone_num" class="signup" placeholder="전화번호" required>
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
   </script>
</body>
</html>