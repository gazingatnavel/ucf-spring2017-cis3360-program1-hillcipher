#!/bin/bash

# Created by Mark Ackerman.
# Closely modeled on similar scripts provided by Dr. Sean Szumlanski for UCF Fall 2016 COP 3503.

# Variable '$?' is the exit status of a command

# Test for C or Java program.

if [ -a "hillcipher.c" ]; then
    isC=1
elif [ -a "hillcipher.java" ]; then
    isC=0
else 
    echo "Unable to find source file hillcipher.c or hillcipher.java"
    exit 1
fi

# Compile source into executable.
if [ $isC == 1 ]; then
    # Compile hillcipher.c file to hillcipher executable.
    echo "Compiling hillcipher.c"
    gcc hillcipher.c -o hillcipher 2> /dev/null
else
    # Compile hillcipher.java file to hillcipher.class executable.
    echo "Compiling hillcipher.java"
    javac hillcipher.java 2> /dev/null
fi

# Check that hillcipher.c (or hillcipher.java) compiled.
compile_val=$?
if [[ $compile_val != 0 ]]; then
    echo "fail (failed to compile)"
    exit 1
fi

# Loop for key files...
for i in `seq 1 4`;
do
    #Loop for text files...
    for j in `seq 1 4`;
    do
    
    # Have output file only for inkey4 and infile4, so skip other keys and
    # files.
    if [[ ($i == 4 || $j == 4) && $i != $j ]]; then
        continue
    fi

    # Provide some feedback.
    echo -n "Checking key$i file$j... "
    
    # Run the executable for the key and text file combination, placing
    # the output in a text file.
    
    if [ $isC == 1 ]; then
        ./hillcipher inkey$i.txt infile$j.txt > out-key$i-file$j.txt 2> /dev/null
    else
        java hillcipher inkey$i.txt infile$j.txt > out-key$i-file$j.txt 2> /dev/null
    fi
    
    # Check that hillcipher executed properly.
    execute_val=$?
    if [[ $execute_val != 0 ]]; then
        echo "fail (program crashed)"
        exit 1
    fi
    
    # Compare the computed output file to the exepected output file,
    # ignoring blank lines.
    diff -B out-key$i-file$j.txt output-key$i-file$j.txt > /dev/null

    # Print status, fail or pass.
    diff_val=$?
    if [[ $diff_val != 0 ]]; then
        echo "fail (output does not match)"
    else
        echo "PASS!"
    fi
    
    # Remove output file.
    rm out-key$i-file$j.txt

    done

done

