//
// Sample scripts are provided as-is with no warranty of fitness for a particular purpose.
// These scripts are solely intended to demonstrate techniques for accomplishing common tasks.
// Additional script logic and error-handling may need to be added to achieve the desired results in your specific environment.
//
// It is up to the user to verify that his intended use of the offered automation functionality is compliant with any third party license agreement and/or other restrictions applicable to any non-Esko products.
//


// script for Automated Esko Tester - checks if Barcode export is still running. Scripter object is re-used from the actually running process

#target Illustrator-29.064;
app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;

try
{
    $.writeln("Running? (1=yes): " + scripter.testerRunning);
    scripter.testerRunning;
}
catch(err)
{
    if (err.substring)
        alert("Error: " + err);
    else 
        alert("Error: " + (err.number & 0xFFFF) + ", " + err.description);
    app.quit();
    err;
}

