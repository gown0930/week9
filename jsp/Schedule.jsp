<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("utf-8");

String idx = null;

String member_idx = null;

String selectedMember =null;

Connection connect = null;
PreparedStatement preparedStatement = null;
PreparedStatement scheduleQuery = null;
ResultSet resultSet = null;

String id = null;
String name = null;
String phoneNum = null;
String position = null;
String department = null;

// 리스트 선언
List<String> teamMembers = new ArrayList<>();
List<String> teamMembersIdx = new ArrayList<>();

List<String> scheduleDates = new ArrayList<>();


try {
    idx = (String) session.getAttribute("idx");//try에 들어가기
    member_idx = request.getParameter("buttonId");
    selectedMember = request.getParameter("selectedMember");

    // JDBC 드라이버 로드
    Class.forName("com.mysql.cj.jdbc.Driver");

    // 데이터베이스 연결
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930");

    // 사용자 정보 가져오기
    String sqlUser = "SELECT id, name, phone_num, position, department FROM user WHERE idx = ?";
    preparedStatement = connect.prepareStatement(sqlUser);
    preparedStatement.setString(1, idx);
    resultSet = preparedStatement.executeQuery();
    //그냥 세션으로 보내주기....

    if (resultSet.next()) {
        id = resultSet.getString("id");
        name = resultSet.getString("name");
        phoneNum = resultSet.getString("phone_num");
        position = resultSet.getString("position");
        department = resultSet.getString("department");

        // 해당 부서의 '팀원'인 사용자 정보 가져오기
        // 팀장일 때만 실행되게 하기
        String sqlDepartment = "SELECT * FROM user WHERE department = ? AND position = ?";
        preparedStatement = connect.prepareStatement(sqlDepartment);
        preparedStatement.setString(1, department);
        preparedStatement.setString(2, "팀원");
        resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            // 팀원 이름을 리스트에 추가
            teamMembers.add("\"" + resultSet.getString("name") + "\"");
            teamMembersIdx.add("\"" + resultSet.getString("idx") + "\"");
        }

    } else {
        out.println("사용자 정보를 찾을 수 없습니다.");
    }

    //일정 수 가져오기
    if(member_idx==null){
        String scheduleSql = "SELECT date FROM schedule WHERE user_idx = ?";
        preparedStatement = connect.prepareStatement(scheduleSql);
        preparedStatement.setString(1, idx);
        resultSet = preparedStatement.executeQuery();
    }else{
        String scheduleSql = "SELECT date FROM schedule WHERE user_idx = ?";
        preparedStatement = connect.prepareStatement(scheduleSql);
        preparedStatement.setString(1, member_idx);
        resultSet = preparedStatement.executeQuery();
    }
    while (resultSet.next()){
        String date = resultSet.getString("date");
        scheduleDates.add("'" + date + "'");
    }

} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} 
//try 안에 넣어주기....
//월이랑 일 기준으로 넣어주기


%>


<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" type="text/css" href="../css/Schedule.css">
   <title>캘린더</title>
</head>
<body>
    <header id="headerBox">
      <div class="header" id="logo">
        <a href="Schedule.jsp">Schedule Calendar</a>
      </div>
      <div class="header" id="today">
         <span id="currentDate"></span>
      </div>
      <div class="header" id="menu">
         <img src="../image/menu.png" id="menubutton" onclick="toggleMenu()">
      </div>
    </header>
    <nav id="menuBox">
      <img src="../image/menu.png" id="menubutton" onclick="toggleMenu()">
      <span id="menuTitle">menu</span>

      <div id="informBox">
         <div id="myInformtitle">내 정보</div>
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
   
         <div id="myInformTitle"></div>
         <div id="memberList"></div>


   
         <div id="bottomButton">
            <a href="../action/logout_action.jsp">
               <button class="modifybutton">로그아웃</button>
            </a>
            <button class="modifybutton">회원 탈퇴</button>
         </div>
      </div>
    </nav>
    <main id="calendarBox">
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



    </main>
    <script>

        

        var member_idx = <%=member_idx%>;
        console.log("멤버 id"+member_idx);

        var selectedMemberName = '<%= request.getParameter("selectedMember") %>';
        console.log("멤버 이름"+selectedMemberName);
        if (selectedMemberName != "내 일정 보기" && selectedMemberName != "null") {
            document.getElementById('memberName').innerHTML = selectedMemberName + " 팀원의 일정";
        }
        

        



        var teamMembersIdx = <%=teamMembersIdx%>;
      console.log(teamMembersIdx);
        
      var memberNames = <%=teamMembers%>;
      console.log(memberNames);

      var scheduleDates = <%=scheduleDates%>;
      console.log(scheduleDates);

      var dateCount = {};
      for (var i = 0; i < scheduleDates.length; i++) {
            var date = scheduleDates[i];
            if (!dateCount[date]) {
                dateCount[date] = 1;
            } else {
                dateCount[date]++;
            }
        }
        console.log(dateCount);

        var position ="<%= position %>";

        function createMemberButtons(memberNames) {
        const myInformTitleDiv = document.getElementById('myInformTitle');
        myInformTitleDiv.textContent = '팀원 일정 보기';

        const memberListDiv = document.getElementById('memberList');

        memberNames.forEach((memberName, i) => {
            const button = document.createElement('button');
            button.classList.add('member');
            button.textContent = memberName;

            // 버튼의 id를 teamMembersIdx로 설정
            button.id = teamMembersIdx[i];

            button.onclick = function () {
                updateCondition(memberName, this.id);
            };

            memberListDiv.appendChild(button);
        });

        const myScheduleButton = document.createElement('button');
        myScheduleButton.classList.add('member');
        myScheduleButton.textContent = '내 일정 보기';
        myScheduleButton.onclick = function () {
            updateCondition('내 일정 보기');
            // "내 일정 보기" 버튼이 클릭되면 selectedMember를 초기화
            selectedMember = null;
        };

        memberListDiv.appendChild(myScheduleButton);
    }
        // 팀장인 경우에만 실행
        if (position === '팀장') {
            createMemberButtons(memberNames);
        }
                //멤버 버튼 출력하는거
        function updateCondition(memberName, buttonId) {
            selectedMember = memberName.trim();
            console.log(selectedMember);

            if (selectedMember !== '내 일정 보기') {
                document.getElementById('memberName').innerHTML = selectedMember + " 팀원의 일정";

                // Create a form element
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'Schedule.jsp';  // schedule.jsp로 전달할 URL

                // Create an input element for the button ID
                var inputId = document.createElement('input');
                inputId.type = 'hidden';
                inputId.name = 'buttonId';  // 폼 데이터의 이름
                inputId.value = buttonId;  // 실제 버튼의 ID

                var inputName = document.createElement('input');
                inputName.type = 'hidden';
                inputName.name = 'selectedMember';  // 폼 데이터의 이름
                inputName.value = selectedMember; 

                form.appendChild(inputId);
                form.appendChild(inputName);

                // Append the form to the document body
                document.body.appendChild(form);

                // Submit the form
                form.submit();
            } else {
                document.getElementById('memberName').innerHTML = '';
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'Schedule.jsp';  // schedule.jsp로 전달할 URL

                // Create an input element for the button ID
                var inputId = document.createElement('input');
                inputId.type = 'hidden';
                inputId.name = 'buttonId';  // 폼 데이터의 이름
                inputId.value = <%=idx%>;  // 실제 버튼의 ID

                var inputName = document.createElement('input');
                inputName.type = 'hidden';
                inputName.name = 'selectedMember';  // 폼 데이터의 이름
                inputName.value = selectedMember;  // 실제 버튼의 ID

                form.appendChild(inputId);
                form.appendChild(inputName);

                // Append the form to the document body
                document.body.appendChild(form);

                // Submit the form
                form.submit();
                
            }
        }
            
            
            console.log("ID: <%= id %>");
            console.log("Name: <%= name %>");
            console.log("Phone Number: <%= phoneNum %>");
            console.log("Position: <%= position %>");
            console.log("Department: <%= department %>");
        

            var loginMessage = '<%= session.getAttribute("loginMessage") %>';
            var idx = '<%= session.getAttribute("idx") %>';
            var successMessage = '<%= session.getAttribute("successMessage") %>';

      if (loginMessage && loginMessage!== 'null') {
          alert(loginMessage);
          <% session.removeAttribute("loginMessage"); %>
      }
      
      if(idx&&idx!=='null'){
         console.log(idx);
         <% session.removeAttribute("idValue"); %>
      }
            
      if (successMessage && successMessage!== 'null') {
               alert(successMessage);
               <% session.removeAttribute("successMessage"); %>
            }

        function toggleMenu() {
            var idx = <%=idx%>;
            if(idx==null){
                alert("로그인 후 이용해주세요.");
                return;
            }
            

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
        
        var year =null;
        var month=null;
        var day = null;
        var selectedMember = null; 

        //오늘 날짜 갖고오기
        function getCurrentDate() {
        var currentDate = new Date();
        year = currentDate.getFullYear();
        month = currentDate.getMonth() + 1; 
        day = currentDate.getDate();
        return year + '-' + (month < 10 ? '0' + month : month) + '-' + (day < 10 ? '0' + day : day);
        }
        //헤더에 오늘 날짜 출력 + 처음에 현재 년도 출력
        function setCurrentDate() {
            var currentDateElement = document.getElementById('currentDate');
            var yearElement = document.getElementById('year');

            var currentDate = getCurrentDate();

            currentDateElement.textContent = currentDate;
            yearElement.textContent = year;
        }
        var newYear=null;
        //년도 바꾸는거
        function changeYear(offset) {
        // 현재 연도를 가져오기
        var currentYear = parseInt(document.getElementById('year').innerText);

        // 새로운 연도 계산
        newYear = currentYear + offset;

        // 연도 업데이트
        document.getElementById('year').innerText = newYear;
        redrawTable();
        }

        setCurrentDate();


   //상세 일정
   function showPopup(day) {
    var idx = '<%= idx %>';
    var url = "detail.jsp?year=" + new Date().getFullYear() + "&month=" + selectedMonth + "&day=" + day + "&user_idx=" + idx;
    var popup = window.open(url, "a", "width=400, height=400, left=100, top=50, scrollbars=yes");

}




   var memberButtons = document.querySelectorAll('.member');
   var monthButtonContainer = document.getElementById('monthButtonBox');
   var table = document.getElementById('myTable');

   //선택된 월
   var selectedMonth = month;
   
//달력 그리기
function redrawTable() {
    table.innerHTML = '';

    var a = 1;
    var daysInMonth = getDaysInMonth(selectedMonth);
    var numRows = (daysInMonth <= 28) ? 4 : 5;

    for (var i = 1; i <= numRows; i++) {
        var row = table.insertRow();

        for (var j = 1; j <= 7; j++) {
            var cell = row.insertCell();
            cell.style.backgroundColor = '#cddce8';
            if (a <= daysInMonth) {
                var paddedDay = a.toString().padStart(2, '0');

                var dayDiv = document.createElement('div');

                dayDiv.textContent = a;

                dayDiv.style.fontFamily = 'EASTARJET-Medium';
                cell.appendChild(dayDiv);

                var currentDate = new Date();
                var day = currentDate.getDate();
                var year = document.getElementById('year').innerText;
                dayDiv.style.backgroundColor = '#cddce8';
                if (dateCount.hasOwnProperty(year + '-' + ('0' + selectedMonth).slice(-2) + '-' + paddedDay) && dateCount[year + '-' + ('0' + selectedMonth).slice(-2) + '-' + paddedDay] > 0) {
                    console.log(dateCount[year + '-' + ('0' + selectedMonth).slice(-2) + '-' + paddedDay]);
                    var countDiv = document.createElement('div');
                    countDiv.textContent = dateCount[year + '-' + ('0' + selectedMonth).slice(-2) + '-' + paddedDay];
                    countDiv.style.color = 'red';
                    cell.appendChild(countDiv);
                }
                if (a === day && document.getElementById('year').innerText == year && selectedMonth == month) {
                    console.log(day);
                    console.log(year);
                    console.log(month);
                    dayDiv.style.backgroundColor = '#5caceb';
                }

                cell.addEventListener('click', (function (clickedDay) {
                    return function () {
                        if (selectedMonth) {
                            var idx = <%=idx%>;
                            if(idx==null){
                                alert("로그인 후 이용해주세요.");
                                return;
                            }
                            if (member_idx == null || selectedMemberName == null || selectedMemberName == '내 일정 보기') {
                                showPopup(clickedDay);
                            } else {
                                var url = "detail_member.jsp?year=" + new Date().getFullYear() + "&month=" + selectedMonth + "&day=" + clickedDay+ "&user_idx=" + member_idx;;
                                window.open(url, "a", "width=400, height=400, left=100, top=50, scrollbars=yes");
                            }
                        }
                    };
                })(a));


                a++;
            }
        }
    }
}


   //월별로 날짜 수
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

   //버튼 생성
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
  
    </script>

</body>
