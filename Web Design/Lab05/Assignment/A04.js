var hour = document.getElementById("hr");
var min = document.getElementById("mn");
var sec = document.getElementById("sc");
var digitalClock = document.getElementById("digitalClock");

function setClockTime() {
    const day = new Date();
    const hh = day.getHours();
    const mm = day.getMinutes();
    const ss = day.getSeconds();

    const hourDeg = (hh * 30) + (mm * 0.5);
    const minDeg = (mm * 6) + (ss * 0.1);
    const secDeg = (ss * 6);

    hour.style.transform = `rotateZ(${hourDeg}deg)`;
    min.style.transform = `rotateZ(${minDeg}deg)`;
    sec.style.transform = `rotateZ(${secDeg}deg)`;

    digitalClock.innerText = `${hh%12<10?'0':''}${hh % 12}:${mm<10?'0':''}${mm} ${hh>12?'PM':'AM'}`;
}

setClockTime();
setInterval(setClockTime, 1000);