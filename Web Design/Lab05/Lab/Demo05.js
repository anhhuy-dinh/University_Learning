function DisplayTime()
{
    var time = new Date();
    var hours = time.getHours();
    var minutes = time.getMinutes();
    var seconds = time.getSeconds();

    var hour = (hours > 12) ? hours - 12 : hours;
    var minute = ((minutes < 10) ? ":0" : ":") + minutes;
    var second = ((seconds < 10) ? ":0" : ":") + seconds;

    var display = " " + hour + minute + second + ((hours > 12) ? " PM" : " AM");

    document.ClockDiv.ClockText.value = display;
    id = setTimeout("DisplayTime()", 1000)
}