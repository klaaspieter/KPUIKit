/*
 * Jakefile
 * KPUIKit
 *
 * Created by You on March 16, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

var ENV = require("system").env,
    SYSTEM = require("system"),
    FILE = require("file"),
    JAKE = require("jake"),
    stream = require("narwhal/term").stream,
    task = JAKE.task,
    FileList = JAKE.FileList,
    app = require("cappuccino/jake").app,
    configuration = ENV["CONFIG"] || ENV["CONFIGURATION"] || ENV["c"] || "Debug",
    OS = require("os");

app ("KPUIKit", function(task)
{
    task.setBuildIntermediatesPath(FILE.join(ENV["CAPP_BUILD"], "KPUIKit.build", configuration));
    task.setBuildPath(FILE.join(ENV["CAPP_BUILD"], configuration));

    task.setProductName("KPUIKit");
    task.setIdentifier("com.madebysofa.KPUIKit");
    task.setVersion("1.0");
    task.setAuthor("Sofa BV");
    task.setEmail("klaaspieter@madebysofa.com");
    task.setSummary("KPUIKit");
    task.setSources((new FileList("*.j")).exclude(FILE.join("Build", "**")));
    task.setResources(new FileList("Resources/*"));
    task.setInfoPlistPath("Info.plist");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});

function printResults(configuration)
{
    print("----------------------------")
    print(configuration+" app built at path: "+FILE.join("Build", configuration, "KPUIKit"));
    print("----------------------------")
}

task ("default", ["KPUIKit"], function()
{
    printResults(configuration);
});

task ("build", ["default"]);

task ("install", ["debug", "release"])

task ("debug", function()
{
    ENV["CONFIGURATION"] = "Debug";
    JAKE.subjake(["."], "build", ENV);
});

task ("release", function()
{
    ENV["CONFIGURATION"] = "Release";
    JAKE.subjake(["."], "build", ENV);
});

task("test", function()
{
    var tests = new FileList('Tests/*Test.j');
    var cmd = ["ojtest"].concat(tests.items());
    var cmdString = cmd.map(OS.enquote).join(" ");

    var code = OS.system(cmdString);
    if (code !== 0)
        OS.exit(code);
});

executableExists = function(/*String*/ executableName)
{
    var paths = SYSTEM.env["PATH"].split(':');
    for (var i = 0; i < paths.length; i++) {
        var path = FILE.join(paths[i], executableName);
        if (FILE.exists(path))
            return path;
    }
    return null;
}

colorize = function(/* String */ message, /* String */ color)
{
    var matches = color.match(/(bold(?: |\+))?(.+)/);

    if (!matches)
        return;

    message = "\0" + matches[2] + "(" + message + "\0)";

    if (matches[1])
        message = "\0bold(" + message + "\0)";

    return message;
}

colorPrint = function(/* String */ message, /* String */ color)
{
    stream.print(colorize(message, color));
}


task ("docs", ["documentation"]);

task ("documentation", function()
{
    generateDocs(false);
});

task ("docs-no-frame", ["documentation-no-frame"]);

task ("documentation-no-frame", function()
{
    generateDocs(true);
});

function generateDocs(/* boolean */ noFrame)
{
    // try to find a doxygen executable in the PATH;
    var doxygen = executableExists("doxygen");

    // If the Doxygen application is installed on Mac OS X, use that
    if (!doxygen && executableExists("mdfind"))
    {
        var p = OS.popen(["mdfind", "kMDItemContentType == 'com.apple.application-bundle' && kMDItemCFBundleIdentifier == 'org.doxygen'"]);
        if (p.wait() === 0)
        {
            var doxygenApps = p.stdout.read().split("\n");
            if (doxygenApps[0])
                doxygen = FILE.join(doxygenApps[0], "Contents/Resources/doxygen");
        }
    }

    if (!doxygen || !FILE.exists(doxygen))
    {
        colorPrint("Doxygen not installed, skipping documentation generation.", "yellow");
        return;
    }

    colorPrint("Using " + doxygen + " for doxygen binary.", "green");
    colorPrint("Pre-processing source files...", "green");

    var documentationDir = FILE.canonical(FILE.join("Documentation")),
        processors = FILE.glob(FILE.join(documentationDir, "preprocess/*"));

    for (var i = 0; i < processors.length; ++i)
        if (OS.system([processors[i], documentationDir]))
            return;

    if (noFrame)
    {
        // Back up the default settings, turn off the treeview
        if (OS.system(["sed", "-i", ".bak", "s/GENERATE_TREEVIEW.*=.*YES/GENERATE_TREEVIEW = NO/", "KPUIKit.doxygen"]))
            return;
    }
    else if (FILE.exists("KPUIKit.doxygen.bak"))
        mv("KPUIKit.doxygen.bak", "KPUIKit.doxygen");

    var doxygenDidSucceed = !OS.system([doxygen, "KPUIKit.doxygen"]);

    // Restore the original doxygen settings
    if (FILE.exists("KPUIKit.doxygen.bak"))
        mv("KPUIKit.doxygen.bak", "KPUIKit.doxygen");

    colorPrint("Post-processing generated documentation...", "green");

    processors = FILE.glob(FILE.join(documentationDir, "postprocess/*"));

    for (var i = 0; i < processors.length; ++i)
        OS.system([processors[i], documentationDir, FILE.join("Documentation", "html")])

    if (doxygenDidSucceed)
    {
        // if (!FILE.isDirectory($BUILD_DIR))
        //     FILE.mkdirs($BUILD_DIR);
        // 
        // rm_rf($DOCUMENTATION_BUILD);
        // mv("debug.txt", FILE.join("Documentation", "debug.txt"));
        // mv("Documentation", $DOCUMENTATION_BUILD);
    }
}