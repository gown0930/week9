<!DOCTYPE html>
<html lang="en">
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
         <input type="time" id="timeInput" name="timeInput">
         <input type="text" placeholder="일정을 입력하세요">
         <button class="detailButton" onclick="saveEdit(1)">저장</button>
     </div>
     
     <div class="schedule" data-id="2">
         <span>오후 01 : 00</span>
         <span>미팅</span>
         <button class="detailButton" onclick="showEditForm(2)">수정</button>
         <button class="detailButton" onclick="deleteSchedule(2)">삭제</button>
     </div>
     <div class="editForm" data-id="2" style="display: none;">
         <input type="time" id="timeInput" name="timeInput">
         <input type="text" placeholder="일정을 입력하세요">
         <button class="detailButton" onclick="saveEdit(2)">저장</button>
     </div>

     <div class="schedule" data-id="3">
         <span>오후 06 : 00</span>
         <span>퇴근</span>
         <button class="detailButton" onclick="showEditForm(3)">수정</button>
         <button class="detailButton" onclick="deleteSchedule(3)">삭제</button>
     </div>
     <div class="editForm" data-id="3" style="display: none;">
         <input type="time" id="timeInput" name="timeInput">
         <input type="text" placeholder="일정을 입력하세요">
         <button class="detailButton" onclick="saveEdit(3)">저장</button>
     </div>

   </div>
   <div id="add">
      <input type="time" id="timeInput" name="timeInput">
      <input type="text" placeholder="일정을 입력하세요">
      <button class="detailButton">일정 추가</button>
   </div>
   <script src="../js/detail.js"></script>
</body>
</html>