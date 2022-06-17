#! /bin/bash
for i in {1..6};
do
    if [ ! -f in_$i.txt ]; then
        echo "Skipping in_$i.txt"
    else
        echo "Processing in_$i.txt";
        bin/telemetry in_$i.txt out_$i.asm.txt;
        diff out_$i.txt out_$i.asm.txt;
        if [ $? -eq 0 ]; then
            echo "  ✔ Test passed!"
        fi
    fi
done;