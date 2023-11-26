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