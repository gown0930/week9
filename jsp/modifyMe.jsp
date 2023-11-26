<!DOCTYPE html>
<html lang="en">
   <head>
      <meta charset="UTF-8"> 
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>내 정보 수정</title>
      <link rel="stylesheet" type="text/css" href="../css/modifyMe.css">
   </head>
   <body>
      <div id="header">Schedule Calendar</div>
         <div id="imformBox">
            <div id="title">내 정보 수정</div>
            <div id="id">ID: haeju0930</div>

            <div id="duplicateMessage" class="message"></div>
            <input type="password" name="password" class="signup" id="password" placeholder="비밀번호" oninput="checkPasswordMatch()">
            <input type="password" class="signup" id="confirmPassword" placeholder="비밀번호 확인" oninput="checkPasswordMatch()">
            <p id="passwordMatchMessage" class="message"></p>
            <span id="passwordErrorMessage" class="message"></span>

            <input type="text" name="name" class="signup" placeholder="이름">

            <input type="text" name="phone_num" id="phone" class="signup" placeholder="전화번호">
            <div class="selectBox">
               <div for="department">부서</div>
               <input type="radio" id="devDept" name="department" value="development">
               <label for="devDept">개발</label>
               <input type="radio" id="designDept" name="department" value="design">
               <label for="designDept">디자인</label>
           </div>
           
           <div class="selectBox">
               <div for="position">직급</div>
               <input type="radio" id="teamLead" name="position" value="teamLead">
               <label for="teamLead">팀장</label>
               <input type="radio" id="teamMember" name="position" value="teamMember">
               <label for="teamMember">팀원</label>
           </div>
            <div id="errorMessage" class="message"></div>
            <a href="Schedule.html">
               <input type="button" value="저장" id="submit" class="out">
            </a>

         </div>
         <script src="../js/modifyMe.js"></script>
   </body>
</html>