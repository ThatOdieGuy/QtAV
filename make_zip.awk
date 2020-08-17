# After the build, a batch file is generated in build\debug\sdk_install.bat
# Go through the batch file replaceing all instances of "C:\\Qt\\5.9.9" with a temporary directory
# here hardcoded to build\rewrite
# the rewritten batch file will end up in build\debug alongside the original
# run the resulting batch file and zip up the contents of the temporary folder build\rewrite
# saving it in the build folder
# call this script like: awk -f make_zip.awk build\debug\sdk_install.bat

BEGIN {
    out_dir = "build\\rewrite\\"
    rewrite_bat = "build\\debug\\sdk_install_rewrite.bat"
    tar_file = "build\\qtav.tar"
}
/C:\\Qt\\5.9.9\\/ {gsub (/C:\\Qt\\5.9.9\\/, out_dir); print >> rewrite_bat }
END {
  system(shell_quote(rewrite_bat))
  tar_command = ("tar -a -c "  "-f " shell_quote(tar_file) " " shell_quote(out_dir))
  print tar_command
  system(tar_command)
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