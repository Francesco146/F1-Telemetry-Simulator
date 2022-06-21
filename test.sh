#!/bin/bash
for i in {1..6}; do
    if [ ! -f test/in_$i.txt ]; then
        echo "Skipping in_$i.txt"
    else
        printf "Processing in_$i.txt... ";
        bin/telemetry test/in_$i.txt test/out_$i.asm.txt;
        diff test/out_$i.txt test/out_$i.asm.txt >/dev/null;
        if [ $? -eq 0 ]; then
            echo "  ✔ Test passed!"
        else  
            echo "  ✘ Test failed!"
        fi
    fi
done