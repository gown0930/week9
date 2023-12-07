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

    String scheduleSql = "SELECT * FROM schedule WHERE user_idx = ? AND date = ? ORDER BY time";
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

    const deleteForm = document.createElement('form'); // 삭제를 위한 폼 생성
    deleteForm.method = 'POST';
    deleteForm.action = '../action/detail_delete_action.jsp';

    const scheduleIdInput = document.createElement('input');
    scheduleIdInput.type = 'hidden';
    scheduleIdInput.name = 'scheduleId';
    scheduleIdInput.value = schedule.id;
    deleteForm.appendChild(scheduleIdInput);

    const userIndexInput = document.createElement('input');
    userIndexInput.type = 'hidden';
    userIndexInput.name = 'user_idx';
    userIndexInput.value = user_idx;
    deleteForm.appendChild(userIndexInput);

    const yearInput = document.createElement('input');
    yearInput.type = 'hidden';
    yearInput.name = 'year';
    yearInput.value = year;
    deleteForm.appendChild(yearInput);

    const monthInput = document.createElement('input');
    monthInput.type = 'hidden';
    monthInput.name = 'month';
    monthInput.value = month;
    deleteForm.appendChild(monthInput);

    const dayInput = document.createElement('input');
    dayInput.type = 'hidden';
    dayInput.name = 'day';
    dayInput.value = day;
    deleteForm.appendChild(dayInput);

    const deleteButton = document.createElement('button');
    deleteButton.classList.add('detailButton');
    deleteButton.textContent = '삭제';
    deleteButton.type = 'submit'; // 버튼을 submit으로 지정
    deleteForm.appendChild(deleteButton);

    scheduleDiv.appendChild(deleteForm); // 폼을 스케줄 div에 추가

    document.getElementById('mainBox').appendChild(scheduleDiv);
}

        function renderEditForm(scheduleId) {
            const editFormDiv = document.createElement('div');
            editFormDiv.classList.add('editForm');
            editFormDiv.setAttribute('data-id', scheduleId);
            editFormDiv.style.display = 'none';

            const form = document.createElement('form'); // 폼 생성
            form.method = 'POST';
            form.action = '../action/detail_edit_action.jsp';

            const IdxInput = document.createElement('input');
            IdxInput.type = 'hidden'; 
            IdxInput.name = 'scheduleId'; 
            IdxInput.value = scheduleId; 
            form.appendChild(IdxInput);

            const userIdxInput = document.createElement('input');
            userIdxInput.type = 'hidden'; 
            userIdxInput.name = 'user_idx';  // 수정: 'user_idx'로 변경
            userIdxInput.value = user_idx;   // 수정: user_idx의 값으로 변경
            form.appendChild(userIdxInput);


            const yearInput = document.createElement('input');
            yearInput.type = 'hidden'; 
            yearInput.name = 'year'; 
            yearInput.value = year;   
            form.appendChild(yearInput);

            const monthInput = document.createElement('input');
            monthInput.type = 'hidden'; 
            monthInput.name = 'month'; 
            monthInput.value = month; 
            form.appendChild(monthInput);

            const dayInput = document.createElement('input');
            dayInput.type = 'hidden'; 
            dayInput.name = 'day'; 
            dayInput.value = day;   
            form.appendChild(dayInput);

            const timeInput = document.createElement('input');
            timeInput.type = 'time';
            timeInput.id = 'editTimeInput' + scheduleId;
            timeInput.name = 'editTimeInput'; // 수정 폼의 시간 입력 필드의 이름
            timeInput.required = true; // 필수 입력 필드로 설정
            form.appendChild(timeInput);

            const eventInput = document.createElement('input');
            eventInput.type = 'text';
            eventInput.id = 'editEventInput' + scheduleId;
            eventInput.name = 'editEventInput'; // 수정 폼의 이벤트 입력 필드의 이름
            eventInput.placeholder = '일정을 입력하세요';
            eventInput.required = true; // 필수 입력 필드로 설정
            form.appendChild(eventInput);

            const saveButton = document.createElement('button');
            saveButton.type = 'submit'; // 버튼을 submit으로 지정
            saveButton.classList.add('detailButton');
            saveButton.textContent = '저장';
            editFormDiv.appendChild(form); // 폼을 수정 폼 div에 추가
            form.appendChild(saveButton); // 버튼을 폼에 추가

            document.getElementById('mainBox').appendChild(editFormDiv);
        }

        // 수정된 내용을 전송하는 함수
        function saveEdit(scheduleId) {

            const editedTime = document.getElementById('editTimeInput' + scheduleId).value;
            const editedEvent = document.getElementById('editEventInput' + scheduleId).value;

            // 예시: FormData를 사용하여 전송
            const formData = new FormData();
            formData.append('scheduleId', scheduleId);
            formData.append('editedTime', editedTime);
            formData.append('editedEvent', editedEvent);

            const user_idx = document.getElementById('user_idx').value;
            const year = document.getElementById('year').value;
            const month = document.getElementById('month').value;
            const day = document.getElementById('day').value;

            formData.append('user_idx', user_idx);
            formData.append('year', year);
            formData.append('month', month);
            formData.append('day', day);
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

            const confirmDelete = confirm('일정을 삭제하시겠습니까?');
            if (!confirmDelete) {
                return;
            }

            // FormData를 사용하여 삭제할 일정 정보를 서버로 전송
            const formData = new FormData();
            formData.append('scheduleId', scheduleId);
            formData.append('user_idx', user_idx);
            formData.append('year', year);
            formData.append('month', month);
            formData.append('day', day);

            fetch('../action/detail_delete_action.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                // 서버에서의 응답을 처리할 수 있는 로직을 추가할 수 있습니다.
                console.log(data);

                // 화면에서 삭제된 일정을 감추는 등의 작업 수행
                document.querySelector('.schedule[data-id="' + scheduleId + '"]').style.display = 'none';
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }

        function saveEdit(scheduleId) {
            alert('수정된 내용을 저장합니다.');
            // editForm 숨기도록 설정
            document.querySelector('.editForm[data-id="' + scheduleId + '"]').style.display = 'none';
            // schedule 보이도록 설정
            document.querySelector('.schedule[data-id="' + scheduleId + '"]').style.display = 'block';
        }


        window.onunload = function () {
            // 팝업이 닫힐 때 부모 창 새로고침
            window.opener.refreshParent();
        };



  </script>
</body>
