function rClock() {
    clock();
    setInterval(clock, 1000);
}

function clock() {
    var date = new Date();
    var time = [date.getHours(), date.getMinutes(), date.getSeconds()];
    var ClockDivs = [document.getElementById("hour"),
                     document.getElementById("min"),
                     document.getElementById("sec")]

    var hour = time[1]/2+time[0]*30;

    ClockDivs[0].style.transform="rotate("+ hour +"deg)";
    ClockDivs[1].style.transform="rotate("+ time[1]*6 +"deg)";
    ClockDivs[2].style.transform="rotate("+ time[2]*6 +"deg)";
}