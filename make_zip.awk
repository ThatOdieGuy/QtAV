# After the build, a batch file is generated in build\debug\sdk_install.bat
# Go through the batch file replaceing all instances of "C:\\Qt\\5.9.9" with a temporary directory
# here hardcoded to build\rewrite
# the rewritten batch file will end up in build\debug alongside the original
# this script then runs the resulting batch file which will copy the content into out_dir

# call this script like: awk -f make_zip.awk build\debug\sdk_install.bat

BEGIN {
    out_dir = "build\\rewrite\\"  # has to exist before
    rewrite_bat = "build\\debug\\sdk_install_rewrite.bat"
    print ("Rewriting " rewrite_bat " to " rewrite_bat)
}
/C:\\Qt\\5.9.9\\/ {gsub (/C:\\Qt\\5.9.9\\/, out_dir); print > rewrite_bat }
END {
  print("Executing " rewrite_bat)
  system(shell_quote(rewrite_bat))
}


function shell_quote(s,             # parameter
    SINGLE, QSINGLE, i, X, n, ret)  # locals
{
    if (s == "")
        return "\"\""

    SINGLE = "\x27"  # single quote
    QSINGLE = "\"\x27\""
    n = split(s, X, SINGLE)

    ret = SINGLE X[1] SINGLE
    for (i = 2; i <= n; i++)
        ret = ret QSINGLE SINGLE X[i] SINGLE

    return ret
}