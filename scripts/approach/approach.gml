
function approach(current, target, speed) {
    if (current < target) {
        current += speed;
        if (current > target) current = target;
    } else if (current > target) {
        current -= speed;
        if (current < target) current = target;
    }
    return current;
}
