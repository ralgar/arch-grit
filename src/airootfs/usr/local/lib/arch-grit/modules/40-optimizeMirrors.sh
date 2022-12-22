# Optimize the pacman mirrors.  This module can fail on occasion but it does not need
#	to hold up the installation - so it has it's own smart output, with a custom error check
#	instead of using the "run" function in the main script
optimizeMirrors() {
    desc="Optimizing package mirrors"
    reflector \
        --latest 25 \
        --age 12 \
        --protocol https \
        --sort rate \
        --save /etc/pacman.d/mirrorlist &> /dev/null &
    run_pid=$!
    while [[ -d /proc/"$run_pid" ]] ; do
        printf "[      ]  $desc\r" ; sleep .75
        printf "[ .    ]  $desc\r" ; sleep .75
        printf "[ ..   ]  $desc\r" ; sleep .75
        printf "[ ...  ]  $desc\r" ; sleep .75
        printf "[ .... ]  $desc\r" ; sleep .75
    done
    if wait $run_pid ; then
        printf "[  ${bld}${grn}OK${off}  ]  $desc\n"
    else
        printf "[ ${bld}${yel}WARN${off} ]  Failed to optimize the mirrorlist. Attempting to continue anyway...\n"
    fi
}
