---
title: "Splitting merged text files back into individual files"
slug: split-merged-text-files
date: 2022-02-27T21:25:54+01:00
categories: [sysadmin]
tags: [bash]
summary: How to split back with POSIX standard tools text files that were merged into one single file.
---

So I recently asked a customer to send me some log files from different hosts to investigate an issue, and what they did was something like this:

```bash
for h in host1 host2 host3
do
    echo $h
    ssh $h cat /var/log/application.log
done > log_bundle.txt
```

So the output was one single big log file with contents like:

```
[contents of the log file from host1]
Connection to host1 closed.
[contents of the log file from host2]
Connection to host2 closed.
[contents of the log file from host3]
Connection to host3 closed.
```

And so on for dozens of hosts.

Fortunately, each portion of the file coming from a different host was followed by the [`ssh`](https://www.unix.com/man-page/posix/1/ssh/) line "Connection to host<em>N</em> closed", which allowed knowing where every merged file ended.

That was still not practical because the issue I needed to investigate was affecting different components across several hosts and I needed to be able to [`grep`](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/grep.html) log files individually to see where the issue appeared and follow its track across different components and hosts and open their log files separately to cross the references.

So, in conclusion, I needed to _unmerge_ the log files that were merged into one single text file.

Fortunately, that line marking when the SSH connection was closed allowed me to use it as a marker to find where every merged file ended and I came up with this solution to unmerge the files using a simple Bash script:

```bash
#!/usr/bin/env bash

# This variable sets the line number in the original file where we
# will look for the merged file. We start at line 1
offset=1
# Search for the next line from $offset indicating an SSH connection
# was closed to find where the current merged file ends.
# This will return the matched line prepended with the line number.
# The `-m1` parameter is a GNU extension for `grep` indicating to
# stop at the first match.
# For a strictly POSIX alternative, you can remove
# `m1` and pipe it to `head -n1` instead:
# file_end=$(tail -n +$offset merged.log | grep -n "^Connection to .* closed.$" | head -n1)
file_end=$(tail -n +$offset merged.log | grep -nm1 "^Connection to .* closed.$")
# Start the loop that iterates over the file and splits the file until
# no more lines indicating the end of an SSH connection are found
while [ -n "$file_end" ]
do
    # From the output returned by grep, extract the line number
    # to a variable
    end_line=$(echo "$file_end" | cut -d : -f 1)
    # From the output returned by grep, extract the SSH hostname
    # to another variable
    hostname=$(echo "$file_end" | cut -d \  -f 3)
    # Extract the portion of the merged file betwen $offset and
    # $end_line to another file
    tail -n +$offset merged.log | head -n $((end_line-1)) > "$hostname.log"
    # Sum $end_line to $offset to advance to the next portion of
    # the merged log file
    offset=$((offset+end_line))
    # And get the next SSH connection line to continue with the loop
    file_end=$(tail -n +$offset merged.log | grep -nm1 "^Connection to .* closed.$")
done
```
