set terminal png tiny size 800,800
set output "Efaecium_E745_vs_Aus0004.png"
set ytics ( \
 "contig_2" 1.0, \
 "*contig_11" 1415035.0, \
 "*contig_4" 1617300.0, \
 "contig_3" 1633302.0, \
 "*contig_1" 1671970.0, \
 "contig_5" 3034944.0, \
 "contig_7" 3038585.0, \
 "contig_9" 3065765.0, \
 "contig_12" 3080209.0, \
 "contig_8" 3099404.0, \
 "contig_10" 3110165.0, \
 "" 3142598 \
)
set size 1,1
set grid
unset key
set border 10
set tics scale 0
set xlabel "CP003351.2"
set ylabel "QRY"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set xrange [1:2952485]
set yrange [1:3142598]
set style line 1  lt 1 lw 3 pt 6 ps 1
set style line 2  lt 3 lw 3 pt 6 ps 1
set style line 3  lt 2 lw 3 pt 6 ps 1
plot \
 "Efaecium_E745_vs_Aus0004.fplot" title "FWD" w lp ls 1, \
 "Efaecium_E745_vs_Aus0004.rplot" title "REV" w lp ls 2
