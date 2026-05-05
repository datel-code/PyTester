#target illustrator-30
// Check script - returns scripter.testerRunning value
// 1 = running, 0 = completed or error

app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;

try {
    if (typeof scripter !== 'undefined' && scripter !== null) {
        var running = scripter.testerRunning;
        $.writeln("CHECK: testerRunning = " + running);
        running;
    } else {
        $.writeln("CHECK: scripter not defined - assuming completed");
        0;
    }
} catch(err) {
    $.writeln("CHECK ERROR: " + err);
    0;
}
