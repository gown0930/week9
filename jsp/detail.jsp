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
         <button class="detailButton" onclick="showEditForm(1)">수정</button>
         <button class="detailButton" onclick="deleteSchedule(1)">삭제</button>
     </div>
     <div class="editForm" data-id="1" style="display: none;">
         <input type="time" id="editTimeInput" name="timeInput">
         <input type="text" id="editEventInput" placeholder="일정을 입력하세요">
         <button class="detailButton" onclick="saveEdit(1)">저장</button>
     </div>
     
     <div class="schedule" data-id="2">
         <span>오후 01 : 00</span>
         <span>미팅</span>
         <button class="detailButton" onclick="showEditForm(2)">수정</button>
         <button class="detailButton" onclick="deleteSchedule(2)">삭제</button>
     </div>
     <div class="editForm" data-id="2" style="display: none;">
         <input type="time" id="editTimeInput" name="timeInput">
         <input type="text" id="editEventInput" placeholder="일정을 입력하세요">
         <button class="detailButton" onclick="saveEdit(2)">저장</button>
     </div>

     <div class="schedule" data-id="3">
         <span>오후 06 : 00</span>
         <span>퇴근</span>
         <button class="detailButton" onclick="showEditForm(3)">수정</button>
         <button class="detailButton" onclick="deleteSchedule(3)">삭제</button>
     </div>
     <div class="editForm" data-id="3" style="display: none;">
         <input type="time" id="editTimeInput" name="timeInput">
         <input type="text" id="editEventInput" placeholder="일정을 입력하세요">
         <button class="detailButton" onclick="saveEdit(3)">저장</button>
     </div>

   </div>
   <div id="add">
      <input type="time" id="addTimeInput" name="timeInput">
      <input type="text" id="addEventInput" placeholder="일정을 입력하세요">
      <button class="detailButton" onclick="addScheduleEvent()">일정 추가</button>
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
            const schedules = [
               { id: 4, time: '07:30', event: '출근' },
               // 추가적인 일정 데이터를 필요에 따라 여기에 추가할 수 있습니다.
            ];
  
      function renderScheduleEvent(schedule) {
          const scheduleDiv = document.createElement('div');
          scheduleDiv.classList.add('schedule');
          scheduleDiv.setAttribute('data-id', schedule.id);
  
          const timeSpan = document.createElement('span');
          timeSpan.innerHTML = schedule.time;
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
          renderSchedule(schedule);
          renderEditForm(schedule.id);
      });
  
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
