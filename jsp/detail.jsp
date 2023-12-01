<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Time" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<% 
String user_idx = request.getParameter("user_idx");
String year = request.getParameter("year");
String month = request.getParameter("month");
String day = request.getParameter("day");
String inputDate = year + "-" + month + "-" + day;

request.setCharacterEncoding("UTF-8");

Connection connect = null;
PreparedStatement scheduleQuery = null;
ResultSet scheduleResult = null;

List<List<String>> scheduleList = new ArrayList<>();

try {
    // 연결 설정
    connect = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930");

    String scheduleSql = "SELECT * FROM schedule WHERE user_idx = ? AND date = ?";
    scheduleQuery = connect.prepareStatement(scheduleSql);

    scheduleQuery.setInt(1, Integer.parseInt(user_idx));
    scheduleQuery.setString(2, inputDate);

    scheduleResult = scheduleQuery.executeQuery();

    while (scheduleResult.next()) {
        int idx = scheduleResult.getInt("idx");
        String content = scheduleResult.getString("content");
        Time time = scheduleResult.getTime("time");

        // 각 일정의 정보를 리스트에 추가
        List<String> scheduleInfo = new ArrayList<>();
        scheduleInfo.add(String.valueOf(idx));
        scheduleInfo.add(time.toString());
        scheduleInfo.add(content);

        scheduleList.add(scheduleInfo);
    }
} catch (SQLException e) {
    e.printStackTrace();
}

%>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>상세 일정</title>
   <link rel="stylesheet" type="text/css" href="../css/detail.css">
</head>
<body>
   <div id="headerBox"></div>
   <div id="mainBox"></div>

   <form id="addForm" action="../action/detail_action.jsp" method="POST" >
        <input type="hidden" name="user_idx">
        <input type="hidden" name="year">
        <input type="hidden" name="month">
        <input type="hidden" name="day">
        <input type="time" id="addTimeInput" name="timeInput" required>
        <input type="text" id="addEventInput" name="eventInput" placeholder="일정을 입력하세요" required>
        <button type="submit" class="detailButton">일정 추가</button>
    </form>

   <script>

      function getQueryParam(name) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(name);
         }

         // URL에서 년도, 달, 날짜 정보 추출
         var year = getQueryParam("year");
         var month = getQueryParam("month");
         var day = getQueryParam("day");
         var user_idx = getQueryParam("user_idx");
         console.log(user_idx);

         document.querySelector('input[name="year"]').value = year;
        document.querySelector('input[name="month"]').value = month;
        document.querySelector('input[name="day"]').value = day;
        document.querySelector('input[name="user_idx"]').value = user_idx;

         var headerBox = document.getElementById('headerBox');
        headerBox.innerHTML = year + '-' + month + '-' + day + ' 상세 일정';

        var schedules = [
            <%
            for (int i = 0; i < scheduleList.size(); i++) {
            %>
                {
                    "id": "<%= scheduleList.get(i).get(0) %>",
                    "time": "<%= scheduleList.get(i).get(1) %>",
                    "event": "<%= scheduleList.get(i).get(2) %>"
                }<%= (i == scheduleList.size() - 1) ? "" : "," %>
            <%
            }
            %>
        ];

    console.log(schedules);

        function renderScheduleEvent(schedule) {
            const scheduleDiv = document.createElement('div');
            scheduleDiv.classList.add('schedule');
            scheduleDiv.setAttribute('data-id', schedule.id);

            const timeSpan = document.createElement('span');
            timeSpan.innerHTML = schedule.time.substring(0, 5);
            scheduleDiv.appendChild(timeSpan);

            const eventSpan = document.createElement('span');
            eventSpan.textContent = schedule.event;
            scheduleDiv.appendChild(eventSpan);

            const editButton = document.createElement('button');
            editButton.classList.add('detailButton');
            editButton.textContent = '수정';
            editButton.onclick = () => showEditForm(schedule.id);
            scheduleDiv.appendChild(editButton);

            const deleteButton = document.createElement('button');
            deleteButton.classList.add('detailButton');
            deleteButton.textContent = '삭제';
            deleteButton.onclick = () => deleteSchedule(schedule.id);
            scheduleDiv.appendChild(deleteButton);

            document.getElementById('mainBox').appendChild(scheduleDiv);
        }

        function renderEditForm(scheduleId) {
            const editFormDiv = document.createElement('div');
            editFormDiv.classList.add('editForm');
            editFormDiv.setAttribute('data-id', scheduleId);
            editFormDiv.style.display = 'none';

            const timeInput = document.createElement('input');
            timeInput.type = 'time';
            timeInput.id = 'editTimeInput' + scheduleId;
            timeInput.name = 'timeInput';
            editFormDiv.appendChild(timeInput);

            const eventInput = document.createElement('input');
            eventInput.type = 'text';
            eventInput.id = 'editEventInput' + scheduleId;
            eventInput.placeholder = '일정을 입력하세요';
            editFormDiv.appendChild(eventInput);

            const saveButton = document.createElement('button');
            saveButton.classList.add('detailButton');
            saveButton.textContent = '저장';
            saveButton.onclick = () => saveEdit(scheduleId);
            editFormDiv.appendChild(saveButton);

            document.getElementById('mainBox').appendChild(editFormDiv);
        }

        schedules.forEach(schedule => {
            renderScheduleEvent(schedule);
            renderEditForm(schedule.id);
        });

        function showEditForm(scheduleId) {
            // schedule 보이지 않도록 설정
            document.querySelector('.schedule[data-id="' + scheduleId + '"]').style.display = 'none';
            // editForm 보이도록 설정
            document.querySelector('.editForm[data-id="' + scheduleId + '"]').style.display = 'block';
        }

        function deleteSchedule(scheduleId) {
            alert('스케줄을 삭제합니다.');
            document.querySelector('.schedule[data-id="' + scheduleId + '"]').style.display = 'none';
        }

        function saveEdit(scheduleId) {
            alert('수정된 내용을 저장합니다.');
            // editForm 숨기도록 설정
            document.querySelector('.editForm[data-id="' + scheduleId + '"]').style.display = 'none';
            // schedule 보이도록 설정
            document.querySelector('.schedule[data-id="' + scheduleId + '"]').style.display = 'block';
        }

  </script>
</body>
