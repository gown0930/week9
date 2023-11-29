<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" type="text/css" href="../css/Schedule.css">
   <title>캘린더</title>
</head>
<body>
    <div id="headerBox">
      <div class="header" id="logo">
         Schedule Calendar
      </div>
      <div class="header" id="today">
         today: <span id="currentDate"></span>
      </div>
      <div class="header" id="menu">
         <img src="../image/menu.png" id="menubutton" onclick="toggleMenu()">
      </div>
    </div>
    <div id="menuBox">
      <img src="../image/menu.png" id="menubutton" onclick="toggleMenu()">
      <span id="menuTitle">menu</span>

      <div id="informBox">
         <div id="myInformTitle">내 정보</div>
         <div id="myInform">
            ID: haeju0930<br>
            Password: hello0930!!<br>
            이름: 박해주<br>
            전화번호: 010-5247-4963<br>
            부서: 백엔드<br>
            직급: 팀원<br>
         </div>
         <a href="modifyMe.html">
            <input type="button" class="modifybutton"value="내 정보 수정">
         </a>
   
         <div id="bottomButton">
            <a href="../index.html">
               <button class="modifybutton">로그아웃</button>
            </a>
            <button class="modifybutton">회원 탈퇴</button>
         </div>
      </div>
   </div>
    <div id="calendarBox">
      <div id="yearBox">
         <img src="../image/left-arrow.png" class="yearbutton" onclick="changeYear(-1)">
         <span id="year"></span>
         <img src="../image/right-arrow.png" class="yearbutton" onclick="changeYear(1)">
     </div>
      <div id="monthButtonBox"></div>
      <div id="myTableBox">
         <table id="myTable">
         </table>
      </div>



    </div>
    <script src="../js/Schedule.js"></script>
</body>
