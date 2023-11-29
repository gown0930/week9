<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
String idx = (String) session.getAttribute("idx");

Connection connect = null;
PreparedStatement preparedStatement = null;
ResultSet resultSet = null;

String id = null;
String name = null;
String phoneNum = null;
String position = null;
String department = null;

// 리스트 선언
List<String> teamMembers = new ArrayList<>();

try {
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930");

    // 사용자 정보 가져오기
    String sqlUser = "SELECT id, name, phone_num, position, department FROM user WHERE idx = ?";
    preparedStatement = connect.prepareStatement(sqlUser);
    preparedStatement.setString(1, idx);
    resultSet = preparedStatement.executeQuery();

    if (resultSet.next()) {
        id = resultSet.getString("id");
        name = resultSet.getString("name");
        phoneNum = resultSet.getString("phone_num");
        position = resultSet.getString("position");
        department = resultSet.getString("department");

        // 해당 부서의 '팀원'인 사용자 정보 가져오기
        String sqlDepartment = "SELECT name FROM user WHERE department = ? AND position = ?";
        preparedStatement = connect.prepareStatement(sqlDepartment);
        preparedStatement.setString(1, department);
        preparedStatement.setString(2, "팀원");
        resultSet = preparedStatement.executeQuery();

        out.println("Team Members in the Department:<br>");
        while (resultSet.next()) {
            // 팀원 이름을 리스트에 추가
            teamMembers.add("\""+resultSet.getString("name")+"\"");
        }
    } else {
        out.println("사용자 정보를 찾을 수 없습니다.");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (resultSet != null) resultSet.close();
    if (preparedStatement != null) preparedStatement.close();
    if (connect != null) connect.close();
}

// 리스트를 세션에 저장
session.setAttribute("teamMembers", teamMembers);
%>
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
         <span id="currentDate"></span>
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
            ID: <%= id %><br>
            이름: <%= name %><br>
            전화번호: <%= phoneNum %><br>
            직급: <%= position %><br>
            부서: <%= department %><br>
        </div>
        <a href="modifyMe.jsp?idx=<%= session.getAttribute("idx") %>">
         <input type="button" class="modifybutton" value="내 정보 수정">
     </a>
   
         <div id="myInformTitle">팀원 일정 보기</div>
         <div id="memberList"></div>


   
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
      <div id="memberName"></div>
      <div id="myTableBox">
         <table id="myTable">
         </table>
      </div>



    </div>
    <script>

      var memberNames = <%=teamMembers%>;
      console.log(memberNames);

            // 멤버 리스트에 버튼 추가
            const memberListDiv = document.getElementById('memberList');

            memberNames.forEach(memberName => {
               const button = document.createElement('button');
               button.classList.add('member');
               button.textContent = memberName;
               button.onclick = function() {
                  updateCondition(memberName);
               };

               memberListDiv.appendChild(button);
            });

            const myScheduleButton = document.createElement('button');
            myScheduleButton.classList.add('member');
            myScheduleButton.textContent = '내 일정 보기';
            myScheduleButton.onclick = function() {
               updateCondition('내 일정 보기');
               // "내 일정 보기" 버튼이 클릭되면 selectedMember를 초기화
               selectedMember = null;
            };
            memberListDiv.appendChild(myScheduleButton);
            
            
            console.log("ID: <%= id %>");
            console.log("Name: <%= name %>");
            console.log("Phone Number: <%= phoneNum %>");
            console.log("Position: <%= position %>");
            console.log("Department: <%= department %>");

            var loginMessage = '<%= session.getAttribute("loginMessage") %>';
            var idx = '<%= session.getAttribute("idx") %>';

      if (loginMessage && loginMessage!== 'null') {
          alert(loginMessage);
          <% session.removeAttribute("loginMessage"); %>
      }
      
      if(idx&&idx!=='null'){
         console.log(idx);
         <% session.removeAttribute("idValue"); %>
      }
      var successMessage = '<%= session.getAttribute("successMessage") %>';
            if (successMessage && successMessage!== 'null') {
               alert(successMessage);
               <% session.removeAttribute("successMessage"); %>
            }

            function toggleMenu() {
   console.log('toggleMenu function called');
   var menuBox = document.getElementById('menuBox');
   var currentRight = parseInt(getComputedStyle(menuBox).right);

   // 메뉴의 현재 위치에 따라 다른 위치로 이동
   if (currentRight === 0) {
       menuBox.style.right = '-300px';
   } else {
       menuBox.style.right = '0';
   }
}
var month=null;
function getCurrentDate() {
   var currentDate = new Date();
   var year = currentDate.getFullYear();
   month = currentDate.getMonth() + 1; 
   var day = currentDate.getDate();
   return year + '-' + (month < 10 ? '0' + month : month) + '-' + (day < 10 ? '0' + day : day);
}

function setCurrentDate() {
   var currentDateElement = document.getElementById('currentDate');
   var yearElement = document.getElementById('year');

   var currentDate = getCurrentDate();
   var year = new Date().getFullYear(); // 현재 년도 가져오기

   // 엘리먼트의 내용 설정
   currentDateElement.textContent = currentDate;
   yearElement.textContent = year;
}

function changeYear(offset) {
   // 현재 연도를 가져오기
   var currentYear = parseInt(document.getElementById('year').innerText);

   // 새로운 연도 계산
   var newYear = currentYear + offset;

   // 연도 업데이트
   document.getElementById('year').innerText = newYear;
}

setCurrentDate();

function redrawTable() {
       // 기존의 표 내용을 모두 지움
       table.innerHTML = '';

       // 5행 반복
       var a = 1;
       var daysInMonth = getDaysInMonth(selectedMonth);
       var numRows = (daysInMonth <= 28) ? 4 : 5; // 28일 이하인 경우에는 4행, 그 이상일 경우에는 5행
       for (var i = 1; i <= numRows; i++) {
           // 새로운 행 생성
           var row = table.insertRow();

           for (var j = 1; j <= 7; j++) {
               var cell = row.insertCell();
               if (a <= daysInMonth) {
                   cell.textContent = a;
                   a++;
                   cell.style.fontFamily = 'EASTARJET-Medium';
                   var currentDate = new Date();
                   var day = currentDate.getDate()+1;
                   cell.style.backgroundColor = '#cddce8';
                   if (a === day) {
                       cell.style.backgroundColor = '#5caceb';
                   }
   
                   cell.addEventListener('click', function () {
                       if (selectedMonth) {
                           //alert('클릭한 셀: ' + this.textContent + ', 선택한 달: ' + selectedMonth);
                           showPopup();
                       }
                   });
               }
           }
       }
}

var selectedMember = null; 

function updateCondition(memberName) {
    selectedMember = memberName.trim();
    console.log(selectedMember);

    if (selectedMember !== '내 일정 보기') {
        document.getElementById('memberName').innerHTML = selectedMember + " 팀원의 일정";
    } else {
        console.log("야");
        document.getElementById('memberName').innerHTML = '';
    }
}

document.addEventListener('DOMContentLoaded', function () {
   function showPopup(day) {
        var url = "detail.jsp?year=" + new Date().getFullYear() + "&month=" + selectedMonth + "&day=" + day;
        window.open(url, "a", "width=400, height=400, left=100, top=50, scrollbars=yes");
    }




   var memberButtons = document.querySelectorAll('.member');
   var monthButtonContainer = document.getElementById('monthButtonBox');
   var table = document.getElementById('myTable');

   var selectedMonth = month;
   

   function redrawTable() {


       table.innerHTML = '';

       var a = 1;
       var daysInMonth = getDaysInMonth(selectedMonth);
       var numRows = (daysInMonth <= 28) ? 4 : 5; 
       // 28일 이하인 경우에는 4행, 그 이상일 경우에는 5행
       for (var i = 1; i <= numRows; i++) {
           var row = table.insertRow();

           for (var j = 1; j <= 7; j++) {
               var cell = row.insertCell();
               if (a <= daysInMonth) {
                   cell.textContent = a;
                   a++;
                   cell.style.fontFamily = 'EASTARJET-Medium';
                   var currentDate = new Date();
                   var day = currentDate.getDate()+1;
                   cell.style.backgroundColor = '#cddce8';
                   if (a === day) {
                       cell.style.backgroundColor = '#5caceb';
                   }
   
                   cell.addEventListener('click', function () {
                       if (selectedMonth) {
                           //alert('클릭한 셀: ' + this.textContent + ', 선택한 달: ' + selectedMonth);
                           if(selectedMember==null||selectedMember=='내 일정 보기'){
                              showPopup(this.textContent);
                           }
                           else {
                              var url = "detail_member.jsp?year=" + new Date().getFullYear() + "&month=" + selectedMonth + "&day=" + this.textContent;
                              window.open(url, "a", "width=400, height=400, left=100, top=50, scrollbars=yes");
                           }
                       }
                   });
               }
           }
       }
   }

   function getDaysInMonth(month) {
       // 1, 3, 5, 7, 8, 10, 12월은 31일까지
       if ([1, 3, 5, 7, 8, 10, 12].includes(month)) {
           return 31;
       }
       // 4, 6, 9, 11월은 30일까지
       else if ([4, 6, 9, 11].includes(month)) {
           return 30;
       } else {
           return 28;
       }
   }

   for (var i = 1; i <= 12; i++) {
       var button = document.createElement('button');
       button.textContent = i;
       button.id = 'button' + i;
       button.classList.add('monthButton');

       button.addEventListener('click', function () {
           // 모든 월 버튼에 대한 스타일 초기화
           var allButtons = document.querySelectorAll('.monthButton');
           allButtons.forEach(function (btn) {
               btn.classList.remove('selectedButton');
           });

           // 현재 클릭한 버튼에 스타일 추가
           this.classList.add('selectedButton');

           var clickedMonth = parseInt(this.textContent);
           console.log('클릭한 버튼:', clickedMonth);

           // 클릭한 버튼의 값을 전역 변수에 저장
           selectedMonth = clickedMonth;

           // 표를 다시 그리는 함수 호출
           redrawTable();
       });
       monthButtonContainer.appendChild(button);

            if (i === selectedMonth) {
               button.click();
            }
         }
         redrawTable();


      });      
    </script>

</body>
