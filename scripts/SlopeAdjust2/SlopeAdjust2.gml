
function SlopeAdjust2(){

if (place_meeting(x, y + 1, oSlope)) {
    while (place_meeting(x, y, oSlope)) {
        y -= 1;

    }
}


}
