<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>상세 일정</title>
   <link rel="stylesheet" type="text/css" href="../css/detail.css">
</head>
<body>
   <div id="headerBox">
      상세 일정
   </div>
   <div id="mainBox">
      <div class="schedule" data-id="1">
         <span>오전 07 : 30</span>
         <span>출근</span>
     </div>
     
     <div class="schedule" data-id="2">
         <span>오후 01 : 00</span>
         <span>미팅</span>
     </div>

     <div class="schedule" data-id="3">
         <span>오후 06 : 00</span>
         <span>퇴근</span>
     </div>

   </div>
   <script>
      function getQueryParam(name) {
         const urlParams = new URLSearchParams(window.location.search);
         return urlParams.get(name);
      }

      // URL에서 년도, 달, 날짜 정보 추출
      var year = getQueryParam("year");
      var month = getQueryParam("month");
      var day = getQueryParam("day");

      // 추출한 정보를 사용하여 필요한 작업 수행
      console.log("년도:", year);
      console.log("달:", month);
      console.log("날짜:", day);
      function showEditForm(scheduleId) {
         document.querySelector('.editForm[data-id="' + scheduleId + '"]').style.display = 'block';
         document.querySelector('.schedule[data-id="' + scheduleId + '"]').style.display = 'none';
      }

      function deleteSchedule(scheduleId) {
         alert('스케줄을 삭제합니다.');
         document.querySelector('.schedule[data-id="' + scheduleId + '"]').style.display = 'none';
      }

      function saveEdit(scheduleId) {
         alert('수정된 내용을 저장합니다.');
         document.querySelector('.editForm[data-id="' + scheduleId + '"]').style.display = 'none';
         document.querySelector('.schedule[data-id="' + scheduleId + '"]').style.display = 'block';
      }
   </script>
</body>